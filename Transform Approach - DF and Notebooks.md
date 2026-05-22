# Transformation Approach – Data Factory + Notebooks

**Project:** Conduent Child Support – DACSES Modernization POC
**Source system:** SQL Server 2022 (`DACSES_POC_Source`) – legacy DACSES T-series tables
**Compute platform:** Microsoft Fabric (Data Factory pipeline + Dataflow Gen2 + PySpark notebook + Lakehouse staging)
**Final target:** SQL Server 2022 (`DACSES_POC_Target`) – modern V-series tables (DDL: [TargetDB/DACESS_Target_DDL.sql](TargetDB/DACESS_Target_DDL.sql))
**Mapping artifact:** [DataMapping/POC Data Mapping Summary.xlsx](DataMapping/POC%20Data%20Mapping%20Summary.xlsx)

---

## 1. Goal

Decide *where* each transformation rule from the mapping spreadsheet should live so that:

- **Simple, declarative mappings** are easy for analysts to maintain (low-code).
- **Complex, conditional logic** is testable, version-controlled, and CI/CD-deployable.
- The pipeline can be re-run, monitored, and audited end-to-end.
- Everything can be **exported to source control** (GitHub) and re-imported into Fabric.

---

## 2. Fabric building blocks at a glance

| Component | Role | Source-control format | Best at |
|---|---|---|---|
| **Data Factory pipeline** | Orchestration / control flow | `pipeline-content.json` + `.platform` file | Triggers, parallel branches, parameter passing, lookups, error handling, calling notebooks/dataflows |
| **Dataflow Gen2 (CI/CD)** | Low-code data shaping (Power Query / M) | `mashup.pq` (M-language) + `queryMetadata.json` (formatVersion `202502`) + `.platform` | Direct column mapping, type casting, simple cross-walk joins, schema-on-read, GUI maintenance, DEs/analysts |
| **PySpark notebook** | Code-first transformation | `notebook-content.py` + `.platform` (Git format v2) | Multi-table joins, business rules, string parsing, window functions, calculated balances, custom UDFs |
| **Lakehouse** | Storage layer (Delta) | Schema only via `.platform` | Source landing zone + curated target tables |
| **Variable Library** | Per-environment parameters | JSON | Dev/Test/Prod swap of lakehouse names, dates, FIPS defaults |

All four item types **are first-class citizens of Fabric Git integration** (GitHub or Azure DevOps) and can be imported workspace-to-workspace through the Git connect / sync feature.

> **Important:** Dataflow Gen2 *with CI/CD* (the file-backed flavor) becomes mandatory in April 2026. Only this flavor serializes to Git; the legacy "Dataflow Gen2 (Standard)" does not.

---

## 3. Classifying the mapping rules

The mapping spreadsheet uses an `RType` column with three values: **D** (Direct), **DV** (Default value), **C** (Crosswalk), and many fields require **business rules** (multi-source joins, parsing, conditional calculation). Counting rule types across the six target-table tabs:

| Rule type | Count (approx.) | Where it fits best |
|---|---|---|
| Direct copy (D) | ~55 | Dataflow Gen2 |
| Default value (DV) | ~30 | Dataflow Gen2 |
| Simple crosswalk via `t_reference` (C, single column) | ~25 | Dataflow Gen2 (merge step) |
| Composite / conditional crosswalk (C with rules) | ~12 | Notebook |
| Multi-table joins (3+ tables) | ~15 | Notebook |
| String parsing (e.g. `NAM` → Last/First/Middle, `HEIGHT` `5 11 ` → `511`) | ~5 | Notebook |
| Aggregation / window (e.g. `OweTotPaa` from T1018 buckets) | ~9 | Notebook |
| Filter rule (e.g. *skip if `IVD_TYP_CD='DIRP'` for VOBLE*) | ~3 | Notebook (or pipeline `If` activity) |

**Conclusion:** roughly **55 % of the column-level work** is mechanical and a perfect fit for Dataflow Gen2; the remaining **45 %** needs full code expressivity.

---

## 4. Per-target recommendation

| Target table | Complexity | Recommended engine | Rationale |
|---|---|---|---|
| **VDEMO** | High | **Notebook** | NAM parsing, height conversion, mailing-phone lookup, driver-license filter (`LIC_AGENCY_CD='DMV'` and `LIC_TYPE_CD in ('D','DRV')`), composite race crosswalk. |
| **VCASE** | High | **Notebook** | Composite `CaseCategory_CODE` rule, `RespondInit_CODE` derived from NCP MAIL address, `Intercept_CODE` from federal-tax sub-status, multiple event lookups (`UCNC`, `WPFA`/`UPFA`). |
| **VCMEM** | Medium | **Notebook** | Cross-walk + relationship-to-child rule depending on `SEX_CD` and family-violence flag (joined back to T1044). |
| **VSORD** | Medium | **Hybrid** – Dataflow for direct/default columns, Notebook for `IssuingOrderFips_CODE` (state→FIPS map) and `File_ID` cleansing. Single-engine notebook is also acceptable. |
| **VOBLE** | High | **Notebook** | Filter (skip DIRP), composite `Fips_CODE` (OSTATA URESA → MAIL FIPS → default), windowed `ObligationSeq_NUMB`, conditional `Periodic_AMNT`. |
| **VLSUP** | High | **Notebook** | Bucket aggregations on `SS_TYP_CD` and `SUB_TYP_CD`, joins back to VOBLE, period calculations. |
| **t_reference / lookups landing** | Low | **Dataflow Gen2** (or Copy Job) | Pure passthrough from source DB → Lakehouse. |
| **Source mirroring** | Low | **Mirroring / Copy Job** | Stream T-series tables into the source Lakehouse. |

---

## 5. Recommended end-to-end architecture

```
              ┌──────────────────────────────────────────────────────────────┐
              │   Data Factory pipeline  pl_DACSES_Convert                   │
              │                                                              │
   trigger ──▶│  1. Set_RunDate                  (variable)                  │
              │  2. Ingest_Source_Tables         (ForEach + Copy)            │
              │       SQL Server source ──Self-hosted IR──▶ SourceLH (Delta) │
              │  3. Stage_Passthrough_Dataflow   (Dataflow Gen2)             │
              │       SourceLH ───▶ TargetLH.stg_*_Simple                    │
              │  4. Run_Hybrid_Notebook          (PySpark)                   │
              │       TargetLH.stg_* + raw T-tables ───▶ TargetLH.V*         │
              │  5. Truncate_Target_Tables       (Script vs. SQL Server)     │
              │       VLSUP→VOBLE→VSORD→VCMEM→VCASE→VDEMO                    │
              │  6-11. Load_VDEMO / VCASE  (parallel)                        │
              │           └─▶ Load_VCMEM, Load_VSORD                         │
              │                       └─▶ Load_VOBLE ─▶ Load_VLSUP           │
              │       TargetLH.V*  ──Self-hosted IR──▶ SQL Server target     │
              │  12. Validate_Row_Counts         (SELECT COUNT(*) per V*)    │
              │  13. On_Failure_Notify           (Outlook)                   │
              └──────────────────────────────────────────────────────────────┘
```

**Why this layering wins:**

1. **Pipeline = orchestration only.** Easy to monitor, retry per activity, and parameterize via a Variable Library (`CONVERSION_DATE`, lakehouse names, FIPS defaults, SQL connections).
2. **Dataflow Gen2 handles the boring 55 %.** Analysts can change a column rename or a default value in the GUI without re-deploying code.
3. **Notebook handles the hard 45 %.** Full PySpark expressivity, unit-testable, version-controlled. The reference notebook is at [DACSES_Fabric_Transformations.ipynb](DACSES_Fabric_Transformations.ipynb).
4. **Lakehouse = checkpoint, not warehouse.** Both `SourceLH` (raw T-tables) and `TargetLH` (V* load-ready) persist between runs as Delta tables. SQL Server remains the system of record. Re-running just the load stage is a `TRUNCATE` + 6 Copy activities.
5. **Everything is in Git.** The pipeline JSON, Dataflow `mashup.pq`, and notebook `.ipynb` all serialize and round-trip.

---

## 5a. SQL Server 2022 as the final target

The transformation engine is Fabric, but the **system of record is SQL Server 2022** (`DACSES_POC_Target`, see [TargetDB/DACESS_Target_DDL.sql](TargetDB/DACESS_Target_DDL.sql)). Two implications:

### Source ingestion (SQL Server → Lakehouse)

We do **not** use Fabric Mirroring. Instead, the pipeline's first real activity is `Ingest_Source_Tables`, a **ForEach over the `SourceTables` parameter** that runs a parametrized **Copy activity** per T-table (and `t_reference`). Reasons:

- **Deterministic snapshot per run** – each pipeline execution sees a frozen view of the source.
- **Restartable** – if a downstream activity fails, the pipeline can be re-run from any step against the already-staged source data.
- **No CDC / replication infrastructure** – Mirroring would require enabling CDC on the legacy DB, which the source DBA team typically resists.
- **Self-hosted IR** handles on-prem connectivity through the existing data gateway with SQL auth (secret in Key Vault).

### Target loading (Lakehouse → SQL Server)

After the notebook produces final V* Delta tables in `TargetLH`, the pipeline loads them into SQL Server in **FK-safe order**:

```
Truncate (reverse FK order)
   │
   ├─▶ Load_VDEMO  ┐         (parallel, no FK parents)
   ├─▶ Load_VCASE  ┘
   │
   ├─▶ Load_VCMEM  (FK → VCASE, VDEMO)
   └─▶ Load_VSORD  (FK → VCASE)
         │
         └─▶ Load_VOBLE  (FK → VSORD)
               │
               └─▶ Load_VLSUP  (FK → VOBLE)
```

Each Copy activity uses `SqlServerSink` with `writeBehavior=insert`, `sqlWriterUseTableLock=true`, and `tableOption=none` so the table schema is preserved (no auto-create). FK constraints in the target DDL (`FK_VCMEM_VCASE`, `FK_VCMEM_VDEMO`, `FK_VSORD_VCASE`, `FK_VOBLE_VSORD`, `FK_VLSUP_VOBLE`) are honored by load order rather than disabled.

### Why keep the Lakehouse instead of writing Spark → JDBC directly?

| Concern | Lakehouse staging + Copy | Spark → JDBC direct |
|---|---|---|
| Bulk throughput | Bulk insert via TDS, 10-100× faster | Per-row JDBC, slow |
| Restart after FK failure | Re-run only `Load_*` activities | Re-run entire Spark job |
| Reconciliation history | Delta time-travel on `TargetLH.V*` | None unless logged separately |
| Network coupling | Spark cluster never touches on-prem SQL | Spark workers must reach SQL Server |
| Low-code edits | Dataflow Gen2 owns the simple rules | All in Spark |

**Conclusion:** the Lakehouse is a *durable staging tier*, not a temporary one. It earns its keep as a checkpoint and audit substrate.

### Type alignment with the target DDL

The notebooks now cast key keys/amounts to the exact precisions the DDL expects, to prevent silent truncation when the Copy activity's TDS bulk insert hits SQL Server:

| Column | DDL type | Spark cast |
|---|---|---|
| `Case_IDNO` | `decimal(6,0)` | `DecimalType(6,0)` |
| `MemberMci_IDNO` | `decimal(10,0)` | `DecimalType(10,0)` |
| `INDIVIDUAL_IDNO` | `decimal(8,0)` | `DecimalType(8,0)` |
| `MemberSsn_NUMB` | `decimal(9,0)` | `DecimalType(9,0)` |
| `OrderSeq_NUMB` / `ObligationSeq_NUMB` | `decimal(2,0)` | `DecimalType(2,0)` |
| `Order_IDNO` | `decimal(15,0)` | `DecimalType(15,0)` |
| All `*_AMNT` | `decimal(11,2)` | `DecimalType(11,2)` |
| `Update_DTTM` | `datetime2(7)` | `current_timestamp()` |

Fixed-width `char(n)` columns are written as Spark `StringType`; SQL Server pads on insert.

### Connection options

| Where SQL Server lives | Connector | IR type |
|---|---|---|
| On-prem | SQL Server | **Self-hosted IR** + on-prem data gateway (recommended for this POC) |
| Azure SQL Managed Instance | Azure SQL MI | Cloud (private endpoint) |
| Azure VM | SQL Server | Cloud (public endpoint) or self-hosted |
| Azure SQL Database | Azure SQL DB | Cloud |

Auth: **Managed Identity** for Azure-hosted; **SQL auth via Key Vault-stored secret** for on-prem (current default in the pipeline parameters).

---

## 6. Source-control layout (when imported into a Fabric workspace)

```
fabric-workspace/
├─ pl_DACSES_Convert.DataPipeline/
│  ├─ pipeline-content.json     (Copy + Dataflow + Notebook + Copy + Script)
│  └─ .platform
├─ df_StagingPassthrough.Dataflow/
│  ├─ mashup.pq
│  ├─ queryMetadata.json
│  └─ .platform
├─ nb_VHybrid_Transforms.Notebook/
│  ├─ notebook-content.ipynb
│  └─ .platform
├─ SourceLH.Lakehouse/           (mirrored T-tables)
│  └─ .platform
├─ TargetLH.Lakehouse/           (stg_*_Simple + final V*)
│  └─ .platform
└─ vl_Environment.VariableLibrary/
   ├─ variables.json
   └─ .platform
```

Each `.platform` file (Git format Version 2) declares:

```json
{
  "$schema": "https://developer.microsoft.com/json-schemas/fabric/gitIntegration/platformProperties/2.0.0/schema.json",
  "metadata": {
    "type": "Notebook",
    "displayName": "nb_VHybrid_Transforms",
    "description": "Applies high-complexity rules to staged tables and writes final V*."
  },
  "config": {
    "version": "2.0",
    "logicalId": "33333333-3333-3333-3333-333333333333"
  }
}
```

---

## 7. Decision matrix – when to choose which

| Question | If YES → | If NO → |
|---|---|---|
| Is the rule a 1:1 column copy or simple cast? | Dataflow Gen2 | – |
| Is the rule a single-column lookup against `t_reference`? | Dataflow Gen2 (Merge step) | – |
| Does it require joining 3+ source tables? | Notebook | Dataflow Gen2 |
| Does it need string parsing, regex, or split? | Notebook | Dataflow Gen2 |
| Does it use windowing / row_number / running totals? | Notebook | Dataflow Gen2 |
| Does it depend on the *result* of another transform? | Notebook (chain DFs) | Either |
| Do business analysts need to edit it without code? | Dataflow Gen2 | Notebook |
| Is it a control-flow concern (skip, branch, retry)? | Pipeline activity | – |
| Is it source ingestion (SQL Server → Lakehouse)? | Pipeline Copy activity (ForEach) | – |
| Is it final delivery (Lakehouse → SQL Server)? | Pipeline Copy activity (FK order) | – |

---

## 8. Migration & deployment workflow

1. **Develop in feature workspace** (`Conduent_Dev`) connected to a feature branch.
2. **Commit** through the Fabric *Source control* pane → GitHub. Pipelines, dataflows, notebooks, and lakehouse stubs are all serialized.
3. **PR review** in GitHub – reviewers can read M code, Python, and pipeline JSON as plain text.
4. **Merge to `main`**.
5. **Pull** into `Conduent_Test` workspace → Fabric resolves logical IDs and re-binds connections.
6. **Variable Library** swaps `SourceLH`/`TargetLH` names *and* `SqlServerSourceConn`/`SqlServerTargetConn` per environment.
7. **Promote** `main` → `Conduent_Prod` workspace via deployment pipeline.

---

## 9. Trade-offs & caveats

- **Dataflow Gen2 (CI/CD)** is GA but evolving; some legacy connectors are not yet supported. Validate connectors used by the staging dataflow against the [supported list](https://learn.microsoft.com/fabric/data-factory/dataflow-gen2-cicd-and-git-integration).
- **Notebook cold-start** (~30-60 s for a fresh Spark session) dominates the small-volume runtime. For the POC we accept this; for production the pipeline can use a **session pool** to share warm sessions.
- **Cross-engine schema drift**: column names emitted by the Dataflow stage must match what the notebooks expect, and the V* tables must match the SQL Server target DDL exactly. Capture the contract in a validation notebook.
- **Logical IDs in `.platform`** must be unique per item; copying folders manually requires generating a new GUID.
- **On-prem connectivity**: the Self-hosted IR (`shir-dacses` in the pipeline parameters) needs network line-of-sight to *both* SQL Servers (source and target) and outbound HTTPS to Fabric. Plan for HA by registering a second IR node.
- **TRUNCATE permissions**: the `etl_writer` SQL login needs `ALTER` on each V* table for `TRUNCATE TABLE` to succeed. If the security team blocks this, switch the `Truncate_Target_Tables` activity to `DELETE FROM …` (slower, fully logged).
- **FK enforcement**: bulk loads run against tables with FKs *enabled*. If a notebook bug emits an orphan, the Copy activity fails fast – which is desirable. For initial backfills you can wrap the load in `ALTER TABLE … NOCHECK CONSTRAINT ALL` / `WITH CHECK CHECK CONSTRAINT ALL` for throughput, at the cost of trusting the source data.

---

## 10. Bottom line

> A **Data-Factory-orchestrated, Dataflow-+-Notebook** pipeline that bookends the Lakehouse with **SQL-Server Copy activities** delivers the best of both worlds: legacy DACSES (`DACSES_POC_Source`) is the system of record on input, SQL Server 2022 (`DACSES_POC_Target`) is the system of record on output, and Fabric is the stateless transformation engine in between. Dataflow Gen2 absorbs the mechanical 55 % (Direct, Default, single-column Crosswalk); the PySpark notebook handles the hard 45 % (multi-table joins, parsing, conditional FIPS/relationship logic, balance bucketing). Everything ships through Git, satisfying the GitHub import requirement.

The reference PySpark implementation – which does the **whole** workload end-to-end so the team can run it standalone (Lakehouse-only, no SQL writes) – is at [DACSES_Fabric_Transformations.ipynb](DACSES_Fabric_Transformations.ipynb). The trimmed hybrid version that the pipeline calls is at [fabric-workspace/nb_VHybrid_Transforms.Notebook/notebook-content.ipynb](fabric-workspace/nb_VHybrid_Transforms.Notebook/notebook-content.ipynb).
