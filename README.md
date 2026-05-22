# Conduent Child Support — DACSES Conversion POC

A proof-of-concept for converting **DACSES** (Delaware Automated Child Support Enforcement System) source data from a legacy SQL Server schema (`T*` tables) into a modern, normalized SQL Server 2022 schema (`V*` tables), using **Microsoft Fabric** as the transformation engine.

## High-level

| Layer | Technology | Role |
|---|---|---|
| Source | **SQL Server 2022** — `DACSES_POC_Source` | System of record on input. ~15 `T*` tables plus `t_reference` cross-walks. |
| Ingestion | Fabric **Data Factory pipeline** + Self-hosted IR | Snapshot copies SQL → `SourceLH` (Delta). |
| Simple transforms (~55%) | Fabric **Dataflow Gen2 (CI/CD)** | Direct copies, defaults, single-column cross-walks → `TargetLH.stg_*_Simple`. |
| Complex transforms (~45%) | Fabric **PySpark notebook** | Multi-table joins, parsing, windowing, FIPS logic, balance bucketing → `TargetLH.V*`. |
| Bulk load | Fabric pipeline **Copy activities** (FK-safe order) | `TargetLH.V*` → SQL Server target. |
| Target | **SQL Server 2022** — `DACSES_POC_Target` | System of record on output. 6 `V*` tables with foreign keys. |
| Audit | `v_conversion_audit` Delta table + pipeline `Validate_Row_Counts` script | Row-count reconciliation per run. |

The Lakehouse is a **durable staging tier**, not a final destination. SQL Server is the system of record on both ends.

---

## Repository layout

```
ConduentChildSupport/
├─ README.md                                    # ← you are here
├─ Transform Approach - DF and Notebooks.md     # Architecture & strategy doc
│
├─ SourceDB/
│  └─ DACESS_Source_DDL.sql                     # Legacy DACSES schema (T-series + reference)
├─ TargetDB/
│  └─ DACESS_Target_DDL.sql                     # New normalized schema (V-series with FKs)
│
├─ DACESS SQL DDL - Local.sql                   # Convenience: source + target DDL combined
├─ Load Dummy DACESS Data.sql                   # Seed script for the source POC database
│
├─ DACSES_Fabric_Transformations.ipynb          # Stand-alone PySpark notebook — does
│                                               # the WHOLE workload end-to-end (no DF stage)
│
├─ DataMapping/
│  ├─ POC Data Mapping Summary.xlsx             # Authoritative source→target column map
│  ├─ V*.docx                                   # Per-target-table mapping docs
│  └─ csv_export/                               # CSV export of the workbook
│
├─ scripts/
│  └─ fabric_notebook_metadata.py               # Stamps Fabric kernel/lakehouse/parameters
│                                               # metadata into the .ipynb files
│
└─ fabric-workspace/                            # Mirrors a Git-integrated Fabric workspace
   ├─ pl_DACSES_Convert.DataPipeline/           # Full orchestrator: SQL→LH→DF→NB→LH→SQL
   │  ├─ pipeline-content.json                  # 13 activities
   │  └─ .platform
   ├─ pl_DACSES_Ingest_Only.DataPipeline/       # Ingest-only: SQL Server → SourceLH (Delta)
   │  ├─ pipeline-content.json                  # Use with the stand-alone notebook
   │  └─ .platform
   ├─ df_StagingPassthrough.Dataflow/           # Dataflow Gen2 (CI/CD format)
   │  ├─ mashup.pq                              # M source — direct/default/crosswalk rules
   │  ├─ queryMetadata.json                     # formatVersion 202502
   │  └─ .platform
   ├─ nb_VHybrid_Transforms.Notebook/           # PySpark — complex rules only
   │  ├─ notebook-content.ipynb                 # Reads stg_* + raw T*; writes final V*
   │  └─ .platform
   ├─ SourceLH.Lakehouse/                       # Landing zone for ingested T-series
   │  └─ .platform
   ├─ TargetLH.Lakehouse/                       # stg_*_Simple + final V* (load-ready)
   │  └─ .platform
   ├─ vl_Environment.VariableLibrary/           # Per-environment overrides
   │  ├─ variables.json
   │  └─ .platform
   └─ README.md                                 # Fabric-workspace-specific notes
```

---

## Pipeline activity flow

`pl_DACSES_Convert.DataPipeline` orchestrates 13 activities:

```
                    ┌──────────── pipeline parameters ────────────┐
                    │ SourceLakehouse / TargetLakehouse / IDs     │
                    │ SqlServerSourceConn / SqlServerTargetConn   │
                    │ OnPremIRName / NotifyEmail / SourceTables[] │
                    └─────────────────────────────────────────────┘

  1. Set_RunDate                  → variable RunDate = utcNow()
  2. Ingest_Source_Tables         → ForEach (batch=6) over SourceTables
        └─ Copy: SQL Server source ─[Self-hosted IR]─▶ SourceLH (Delta, Overwrite)
  3. Stage_Passthrough_Dataflow   → df_StagingPassthrough writes
        TargetLH.stg_VDEMO_Simple / stg_VCASE_Simple / stg_VCMEM_Simple / stg_VSORD_Simple
  4. Run_Hybrid_Notebook          → nb_VHybrid_Transforms (PySpark)
        builds final TargetLH.V* (VDEMO, VCASE, VCMEM, VSORD, VOBLE, VLSUP)
        + v_conversion_audit; exits with JSON row-count payload
  5. Truncate_Target_Tables       → Script vs SQL Server target (reverse FK order)
        VLSUP → VOBLE → VSORD → VCMEM → VCASE → VDEMO
  6. Load_VDEMO          ┐         (parallel — no FK parents)
  7. Load_VCASE          ┘
  8. Load_VCMEM                    (FK → VCASE, VDEMO)
  9. Load_VSORD                    (FK → VCASE)
 10. Load_VOBLE                    (FK → VSORD)
 11. Load_VLSUP                    (FK → VOBLE)
        each Copy: TargetLH.V* ─[Self-hosted IR]─▶ SQL Server target
 12. Validate_Row_Counts          → SELECT COUNT(*) per V* in target
 13. On_Failure_Notify            → Office365Outlook on any failure
```

Foreign keys in the target DDL (`FK_VCMEM_VCASE`, `FK_VCMEM_VDEMO`, `FK_VSORD_VCASE`, `FK_VOBLE_VSORD`, `FK_VLSUP_VOBLE`) are **kept enabled** during load — order is enforced by the activity DAG.

---

## How transformation rules are split

| Rule type | Engine | Where |
|---|---|---|
| Direct (D) — pass-through column | Dataflow Gen2 | `mashup.pq` `Stg_*_Simple` queries |
| Default (DV) — constant value | Dataflow Gen2 | `Table.AddColumn` constants |
| Crosswalk (C) — single-column lookup | Dataflow Gen2 | `Table.NestedJoin` against `Ref_*` queries (uses `t_reference`) |
| Multi-table joins (3+ tables) | PySpark notebook | sections 2–7 of `notebook-content.ipynb` |
| String parsing (`NAM`, `HEIGHT`) | PySpark notebook | section 2 (VDEMO) |
| Windowing / `row_number` | PySpark notebook | section 6 (VOBLE) |
| Bucket aggregations (SS_TYP_CD, SUB_TYP_CD) | PySpark notebook | section 7 (VLSUP) |
| Filter (skip DIRP records) | PySpark notebook | section 6 |
| Control flow / retry / notify | Pipeline | `pl_DACSES_Convert` |
| Source ingestion (SQL → LH) | Pipeline Copy (ForEach) | activity 2 |
| Final delivery (LH → SQL) | Pipeline Copy (FK order) | activities 6–11 |

See [Transform Approach - DF and Notebooks.md](Transform%20Approach%20-%20DF%20and%20Notebooks.md) for the full rationale and decision matrix.

---

## Type alignment with the SQL Server target

The notebook's `conform()` helper casts key/amount columns to the exact precisions defined in [TargetDB/DACESS_Target_DDL.sql](TargetDB/DACESS_Target_DDL.sql) so the Copy activity's TDS bulk insert does not silently truncate or fail with arithmetic-overflow errors:

| Column | Target DDL type | Spark cast |
|---|---|---|
| `Case_IDNO` | `decimal(6,0)` | `DecimalType(6, 0)` |
| `MemberMci_IDNO` | `decimal(10,0)` | `DecimalType(10, 0)` |
| `INDIVIDUAL_IDNO` | `decimal(8,0)` | `DecimalType(8, 0)` |
| `MemberSsn_NUMB` | `decimal(9,0)` | `DecimalType(9, 0)` |
| `OrderSeq_NUMB`, `ObligationSeq_NUMB` | `decimal(2,0)` | `DecimalType(2, 0)` |
| `Order_IDNO` | `decimal(15,0)` | `DecimalType(15, 0)` |
| All `*_AMNT` columns | `decimal(11,2)` | `DecimalType(11, 2)` |
| `Update_DTTM` | `datetime2(7)` | `current_timestamp()` |

Fixed-width `char(n)` columns are written as Spark `StringType`; SQL Server pads on insert.

---

## Setup & installation

### 0. Prerequisites

| Requirement | Why |
|---|---|
| **SQL Server 2022** instance (or Azure SQL MI / Azure SQL DB) for source and target | Hosts `DACSES_POC_Source` + `DACSES_POC_Target`. Can be the same instance, separate databases. |
| **SSMS** or `sqlcmd` | Run the DDL and seed scripts. |
| **Microsoft Fabric** capacity (F-SKU, trial, or PPU) | Hosts the workspace, lakehouses, dataflow, notebook, pipeline. |
| **GitHub repository** | Source-control target for `fabric-workspace/`. |
| **Self-hosted Integration Runtime** (`shir-dacses`) | **Only if** SQL Server is on-prem or otherwise unreachable from Fabric's cloud runtime. **Not needed** for Azure VM SQL with a public IP, Azure VM SQL fronted by a Fabric Managed Private Endpoint (F64+), Azure SQL DB / MI, or any cloud-connectable endpoint. See [Set up connectivity](#3-set-up-connectivity). |
| **Azure Key Vault** (recommended) | Holds SQL credentials for the SHIR. |
| Python 3.10+ (local, optional) | Re-running `scripts/fabric_notebook_metadata.py`. |

### 1. Provision the source and target databases

```powershell
# from project root
sqlcmd -S <server> -d master -i "SourceDB\DACESS_Source_DDL.sql"
sqlcmd -S <server> -d master -i "TargetDB\DACESS_Target_DDL.sql"
sqlcmd -S <server> -d DACSES_POC_Source -i "Load Dummy DACESS Data.sql"
```

The source DDL also creates a stand-alone copy of the target `V*` tables for local-only experimentation; the *real* target lives in `DACSES_POC_Target` from the second script.

### 2. Create a Fabric workspace and lakehouses

1. In Fabric, create a workspace (e.g. `Conduent_Dev`) on a capacity that supports Dataflow Gen2 CI/CD.
2. Create two lakehouses inside it: **`SourceLH`** and **`TargetLH`** (names must match — they're referenced by Delta-table FQNs in the notebook and dataflow).

### 3. Set up connectivity

The right connectivity option depends on **where the SQL Server lives and how Fabric can reach its network endpoint** — being in the same Azure subscription does *not* by itself grant connectivity.

| Scenario | Connector | Runtime | SHIR needed? |
|---|---|---|---|
| **Azure VM with a public IP**, port 1433 open to Fabric's outbound ranges | SQL Server | Cloud | **No** |
| **Azure VM, private IP only**, Fabric capacity **F64+** | SQL Server | Cloud + **Managed Private Endpoint** (recommended) | No |
| **Azure VM, private IP only**, smaller capacity | SQL Server | **VNet data gateway** | No (managed gateway, not SHIR) |
| **Azure SQL Database / Managed Instance** | Azure SQL DB / Azure SQL MI | Cloud (private endpoint preferred) | No |
| **On-prem SQL Server** | SQL Server | **Self-hosted IR** + on-prem data gateway | **Yes** (`shir-dacses`) |

**Auth:**
- **Managed Identity** preferred for Azure-hosted SQL (assign the Fabric workspace's managed identity to a SQL login with the right roles).
- **SQL auth via Key Vault secret** for on-prem.

**Azure VM specifics (this demo):**
- Verify the VM's NIC settings — does it have a public IP?
  - **Yes** → open NSG inbound 1433 to the `AzureCloud.<region>` service tag (or your Fabric region's published IP ranges), force TLS on the SQL Server endpoint, then create a cloud SQL Server connection in Fabric. Clear the `OnPremIRName` pipeline parameter.
  - **No** → use a Managed Private Endpoint (F64+) or a VNet data gateway. Same pipeline param treatment — leave `OnPremIRName` blank.
- Same Azure subscription as the Fabric capacity does **not** mean Fabric can reach the VM. Public IP + NSG rules, or private endpoint / VNet gateway, is what actually establishes the path.
- Do **not** expose port 1433 to the public Internet (`0.0.0.0/0`) — restrict to Fabric's service-tag IPs and require TLS.

**Pipeline parameters for cloud-only (no SHIR):**
- Set `OnPremIRName` to an empty string.
- Point `SqlServerSourceConn` / `SqlServerTargetConn` at the cloud connection IDs.
- The linked services will use Fabric's cloud runtime automatically when `connectVia` resolves to nothing.

**Pipeline parameters for on-prem (SHIR required):**
- Install a Self-hosted IR node, register it with the Fabric workspace, name it `shir-dacses` (or change the parameter).
- Create two connections via the SHIR:
  - `SqlServerSourceConn` → `DACSES_POC_Source`
  - `SqlServerTargetConn` → `DACSES_POC_Target`

### 4. Connect the workspace to GitHub

**GitHub-side prerequisites (one-time):**

1. The Fabric tenant admin must enable **Workspace settings → Git integration** at the tenant level.
2. The signed-in user connecting Fabric to GitHub must have **at least Write access** to the repo (https://github.com/jamesbas/Conduent-DACSES) and be authorized in any GitHub org SSO that gates it.
3. If the repo is in a GitHub organization, an org owner may need to **approve the Microsoft Fabric OAuth app** under *Settings → Third-party access*.
4. Configure **branch protection on `main`** (Settings → Branches → Add rule):
   - Require pull-request reviews before merge.
   - Require status checks (if you add CI later).
   - Block force-pushes and direct pushes to `main`.
   - This forces all Fabric edits to land via feature branches and PRs — see the deployment workflow below.

**In Fabric:**

1. **Workspace settings → Git integration → Connect** → choose **GitHub**, sign in, then select:
   - Organization / owner: `jamesbas`
   - Repository: `Conduent-DACSES`
   - Branch: `main`
   - Git folder: **`fabric-workspace/`**
2. Click **Connect and sync** → **Update all**. Fabric materializes:
   - `pl_DACSES_Convert` (DataPipeline) — full SQL→LH→DF→NB→LH→SQL flow
   - `pl_DACSES_Ingest_Only` (DataPipeline) — ingest-only variant
   - `df_StagingPassthrough` (Dataflow Gen2)
   - `nb_VHybrid_Transforms` (Notebook)
   - `SourceLH` / `TargetLH` (Lakehouse stubs — bind to the ones you created in step 2 if Fabric prompts)
   - `vl_Environment` (Variable Library)
3. Fabric assigns real GUIDs to each item on first sync. Update the placeholder defaults in `pl_DACSES_Convert` parameters (`SourceLakehouseId`, `TargetLakehouseId`, `StagingDataflowId`, `HybridNotebookId`) to match — or, better, bind them to `vl_Environment` variable references so each environment carries its own IDs.
4. From now on: edit in Fabric → commit via the **Source control** pane → PR in GitHub → merge to `main` → other environments pull.

> **Tip:** If you previously tried pasting `pipeline-content.json` into Fabric's *Edit JSON code* dialog and got *"Rename is not allowed from JSON editor"*, that's because the in-portal JSON editor only accepts the **inner properties object** (no outer `{ "properties": { … } }` wrapper) and won't let you rename the pipeline. Git integration sidesteps both problems — Fabric reads the full Git-format file directly.

### 5. Stamp Fabric metadata into the notebooks (only if regenerating)

The notebooks already carry the required metadata (`kernelspec=synapse_pyspark`, `dependencies.lakehouse`, `parameters` cell tag). If you ever rewrite or regenerate them, re-run:

```powershell
python scripts\fabric_notebook_metadata.py
```

### 6. Configure pipeline parameters

Open `pl_DACSES_Convert` and set defaults (or bind via `vl_Environment` variable references):

| Parameter | Example value |
|---|---|
| `SourceLakehouse` / `TargetLakehouse` | `SourceLH` / `TargetLH` |
| `SourceLakehouseId` / `TargetLakehouseId` | the GUIDs Fabric assigned to your lakehouses |
| `StagingDataflowId` | GUID of `df_StagingPassthrough` |
| `HybridNotebookId` | GUID of `nb_VHybrid_Transforms` |
| `SqlServerSourceConn` / `SqlServerTargetConn` | the connection IDs from step 3 |
| `OnPremIRName` | `shir-dacses` (or blank for cloud-only) |
| `NotifyEmail` | distribution list for failure alerts |
| `SourceTables` | leave the default array of 15 `T*` tables (+ `t_reference`) |

The `vl_Environment.VariableLibrary` lets you swap these per environment without editing the pipeline JSON.

### 7. Run

Trigger `pl_DACSES_Convert` manually for the first run. Watch:
- `Ingest_Source_Tables` populating `SourceLH` Delta tables.
- `Run_Hybrid_Notebook` exit value — JSON payload with row counts per `V*`.
- `Validate_Row_Counts` Script output — should match.

---

## Stand-alone notebook (no pipeline, no DF stage)

[DACSES_Fabric_Transformations.ipynb](DACSES_Fabric_Transformations.ipynb) at the project root does the **whole** workload end-to-end in PySpark — useful for:
- Quick exploration without standing up the dataflow.
- Local Spark / Synapse Spark runs.
- Testing rule changes before lifting them into the dataflow.

It writes V* tables into the lakehouse only; it does **not** push to SQL Server. Use it for transformation development, not production loads.

It also expects the raw T-series tables to already be in `SourceLH` — pair it with **`pl_DACSES_Ingest_Only`** (below) to land them.

## Ingest-only pipeline

[fabric-workspace/pl_DACSES_Ingest_Only.DataPipeline/](fabric-workspace/pl_DACSES_Ingest_Only.DataPipeline/) is a slimmed-down pipeline that only runs the SQL-Server-to-`SourceLH` ingestion step:

| Activity | Type |
|---|---|
| `Set_RunDate` | SetVariable |
| `Ingest_Source_Tables` | ForEach (parallel) → Copy SQL Server → Lakehouse Delta |
| `Validate_Source_Row_Counts` | ForEach (sequential) → Lookup `COUNT_BIG(*)` per table |
| `On_Failure_Notify` | Office365Outlook |

Use it when you want to:
- Pair with the stand-alone `DACSES_Fabric_Transformations.ipynb` notebook (which expects raw T-tables already in `SourceLH`).
- Refresh the source snapshot without re-running the dataflow / hybrid notebook / SQL load.
- Test SQL Server connectivity in isolation before wiring up the full pipeline.

It shares the same `SqlServerSourceConn`, `OnPremIRName`, `SourceLakehouseId`, and `SourceTables` parameters as the full pipeline, so a single Variable Library can drive both.

---

## Development & deployment workflow

1. **Develop** in `Conduent_Dev` workspace on a feature branch.
2. **Commit** through Fabric's *Source control* pane → GitHub. Pipelines, dataflow `mashup.pq`, notebook `.ipynb`, lakehouse stubs, and variables are all serialized as plain text/JSON.
3. **PR review** in GitHub — reviewers can read M code, Python, and pipeline JSON without opening Fabric.
4. **Merge** to `main`.
5. **Pull** into `Conduent_Test` workspace — Fabric resolves logical IDs and re-binds connections.
6. **Variable Library** swaps `SourceLH` / `TargetLH` names *and* `SqlServerSourceConn` / `SqlServerTargetConn` per environment.
7. **Promote** `main` → `Conduent_Prod` via a Fabric deployment pipeline.

---

## Repository security

This repo is the **source of truth** for the Fabric workspace. Treat it like infrastructure-as-code, not just notes — anything that lands here gets re-materialized inside Fabric on the next sync.

### What must NEVER be committed

- Real SQL Server **passwords**, connection strings with embedded passwords, or **API keys**.
- Tenant IDs, subscription IDs, or storage account keys for production environments.
- Personally identifiable information (PII) from real DACSES extracts. The `Load Dummy DACESS Data.sql` script seeds **synthetic** data only — keep it that way.
- Personal access tokens, service-principal secrets, certificates, `.pfx` files.
- Self-hosted IR registration keys.

The pipeline JSON intentionally uses **placeholder credentials** like `Password=<from-keyvault>` in `SqlServerSourceConn` / `SqlServerTargetConn` defaults. **Do not replace these with real passwords in the JSON.** Real values must come from one of:

1. **Fabric connection objects** (preferred) — store SQL credentials in a Fabric connection; the pipeline references the connection by ID, never by inline string.
2. **Azure Key Vault** referenced by the connection — Fabric can resolve secrets at runtime via Managed Identity.
3. **Variable Library overrides per environment** — `vl_Environment` can hold the connection IDs (not the secrets) per Dev / Test / Prod.

### Minimum GitHub controls

In **Settings** of `jamesbas/Conduent-DACSES`:

| Control | Where | Why |
|---|---|---|
| **Branch protection on `main`** | Settings → Branches | Forces PR review; prevents direct pushes that could leak secrets or break Fabric sync. |
| **Require pull-request reviews (≥1 approver)** | Branch protection rule | Two-person rule for any change Fabric will run. |
| **Dismiss stale approvals on new commits** | Branch protection rule | Re-review after rewrites. |
| **Require linear history** | Branch protection rule | Easier rollback / audit. |
| **Block force-pushes / deletions** | Branch protection rule | Prevents history rewrites that hide secret leaks. |
| **Secret scanning** + **push protection** | Settings → Code security | Blocks pushes that contain known credential patterns (SQL connection strings with passwords, Azure keys, GitHub tokens, etc.). Free for public repos; available with GHAS for private. |
| **Dependabot alerts** | Settings → Code security | Notifies on vulnerable Python deps in `scripts/`. |
| **CODEOWNERS** | `.github/CODEOWNERS` | Auto-request review from a known owner on PRs touching `fabric-workspace/`. |
| **Required signed commits** *(optional)* | Branch protection rule | Stronger provenance for production environments. |

### What is committed (and is safe)

- `fabric-workspace/**` — the Fabric Git-format files: pipeline JSON, dataflow `mashup.pq`, notebook `.ipynb`, lakehouse stubs, variable library. None of these carry runtime secrets when generated correctly.
- `SourceDB/` and `TargetDB/` DDL — schema only, no data.
- `Load Dummy DACESS Data.sql` — synthetic seed data only.
- `DataMapping/` — column-level mapping documents (no PII).
- `DACSES_Fabric_Transformations.ipynb` and `scripts/` — code, no credentials.

### `.gitignore` posture

The repo's [.gitignore](.gitignore) excludes:

- Python build artifacts (`__pycache__/`, `*.pyc`, `.venv/`).
- Notebook checkpoints (`.ipynb_checkpoints/`).
- Editor / OS junk (`.vscode/`, `.idea/`, `.DS_Store`, `Thumbs.db`).
- Anything matching `*.env`, `*.secrets`, `*-secrets.json`.

If you need to keep a local secrets file for ad-hoc testing, name it so it matches one of those globs (e.g. `local.secrets`).

### If a secret is accidentally committed

1. **Rotate the credential immediately** at the source (Key Vault, SQL login, GitHub token). The commit is in the repo's history forever — assume it is compromised.
2. Use `git filter-repo` (or BFG) to scrub history *only* if the repo has not been widely cloned; then force-push and notify everyone to re-clone.
3. Rotation is the real fix; history-rewrites are damage control.

---

## Key references

- [Transform Approach - DF and Notebooks.md](Transform%20Approach%20-%20DF%20and%20Notebooks.md) — full architecture rationale, decision matrix, trade-offs.
- [TargetDB/DACESS_Target_DDL.sql](TargetDB/DACESS_Target_DDL.sql) — authoritative target schema with FKs and decimal precisions.
- [DataMapping/POC Data Mapping Summary.xlsx](DataMapping/POC%20Data%20Mapping%20Summary.xlsx) — column-level source→target map (D / DV / C / complex tags).
- [fabric-workspace/README.md](fabric-workspace/README.md) — Fabric-workspace-specific notes.
