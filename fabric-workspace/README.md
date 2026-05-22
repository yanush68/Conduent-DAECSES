# fabric-workspace

This folder mirrors what Microsoft Fabric serializes when you connect a workspace to GitHub via **Workspace settings → Git integration**. Every Fabric item lives in its own `<DisplayName>.<ItemType>/` directory and carries a `.platform` manifest (Git format Version 2). Pull this folder into a Fabric workspace and Fabric will materialize each item.

## Layout

```
fabric-workspace/
├─ pl_DACSES_Convert.DataPipeline/         # Orchestrator (Data Factory)
│  ├─ .platform
│  └─ pipeline-content.json
├─ df_StagingPassthrough.Dataflow/         # Dataflow Gen2 (CI/CD)
│  ├─ .platform
│  ├─ mashup.pq                            # M-language source
│  └─ queryMetadata.json                   # formatVersion 202502
├─ nb_VHybrid_Transforms.Notebook/         # PySpark – complex rules only
│  ├─ .platform
│  └─ notebook-content.ipynb
├─ SourceLH.Lakehouse/                     # Landing zone (T-series)
│  └─ .platform
├─ TargetLH.Lakehouse/                     # stg_*_Simple + final V-series
│  └─ .platform
└─ vl_Environment.VariableLibrary/         # Dev/Test/Prod overrides
   ├─ .platform
   └─ variables.json
```

## Runtime flow (`pl_DACSES_Convert`)

1. **Set_RunDate** – capture today's date into pipeline variable `RunDate`.
2. **Stage_Passthrough_Dataflow** – run `df_StagingPassthrough` to land `stg_VDEMO_Simple`, `stg_VCASE_Simple`, `stg_VCMEM_Simple`, `stg_VSORD_Simple` into `TargetLH`.
3. **Run_Hybrid_Notebook** – run `nb_VHybrid_Transforms` to enrich the staged tables and build `VOBLE` + `VLSUP` from scratch.
4. **Validate_Row_Counts** – read the `v_conversion_audit` table the notebook writes.
5. **On_Failure_Notify** – Outlook activity if any preceding step failed.

## How rules are split

| Rule type | Engine | Where |
|---|---|---|
| Direct (D) | Dataflow Gen2 | `mashup.pq` `Stg_*_Simple` queries |
| Default (DV) | Dataflow Gen2 | `Table.AddColumn` constants |
| Single-column Crosswalk (C) | Dataflow Gen2 | `Table.NestedJoin` against `Ref_*` queries |
| Multi-table joins | Notebook | sections 2-7 of `notebook-content.ipynb` |
| String parsing (NAM, HEIGHT) | Notebook | section 2 |
| Window / row_number | Notebook | section 6 (VOBLE) |
| Bucket aggregations (SS_TYP_CD, SUB_TYP_CD) | Notebook | section 7 (VLSUP) |
| Filter (skip DIRP) | Notebook | section 6 |
| Control flow / retry / notify | Pipeline | `pl_DACSES_Convert` |

## Importing into Fabric

1. Create an empty workspace.
2. **Workspace settings → Git integration → Connect** → point at this repo and the branch holding `fabric-workspace/`.
3. Click **Update all**. Fabric creates each item using the `logicalId` from `.platform`.
4. Open `vl_Environment` and pick the value-set (`Dev` / `Test` / `Prod`).
5. Open `pl_DACSES_Convert` and set the parameters (`StagingDataflowId`, `HybridNotebookId`, `TargetLakehouseId`) to the IDs Fabric assigned. *(In a deployment pipeline, bind these via a Variable Library reference instead of a literal default.)*
6. Run the pipeline.

## Stand-alone alternative

If you prefer code-only (no DF), use [`../DACSES_Fabric_Transformations.ipynb`](../DACSES_Fabric_Transformations.ipynb) — it produces all six V-series tables in a single notebook with no dependency on the Dataflow Gen2 staging layer.
