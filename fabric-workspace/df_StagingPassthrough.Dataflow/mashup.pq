// =============================================================================
//  df_StagingPassthrough.Dataflow  --  mashup.pq
//  Power Query (M-language) source for Fabric Dataflow Gen2 (CI/CD).
//  Handles Direct (D), Default (DV), and single-column Crosswalk (C) rules
//  for VDEMO, VCASE, VCMEM, VSORD. The output `stg_*_Simple` tables are
//  then enriched by nb_VHybrid_Transforms.Notebook.
// =============================================================================

section Section1;

// -----------------------------------------------------------------------------
// PARAMETERS
// -----------------------------------------------------------------------------
shared SourceLakehouseId =
    "00000000-0000-0000-0000-000000000000" meta [IsParameterQuery = true, Type = "Text"];

shared WorkspaceId =
    "00000000-0000-0000-0000-000000000000" meta [IsParameterQuery = true, Type = "Text"];

shared ConversionDate =
    #date(2026, 5, 6) meta [IsParameterQuery = true, Type = "Date"];

// -----------------------------------------------------------------------------
// SOURCE QUERIES  (queryGroup: Source)
// -----------------------------------------------------------------------------
shared Src_T1043_PART = let
    Source = Lakehouse.Contents([]),
    Ws     = Source{[workspaceId = WorkspaceId]}[Data],
    Lh     = Ws{[lakehouseId  = SourceLakehouseId]}[Data],
    Tbl    = Lh{[Id = "T1043_PART", ItemKind = "Table"]}[Data]
in
    Tbl;

shared Src_T1044_CASE = let
    Source = Lakehouse.Contents([]),
    Ws     = Source{[workspaceId = WorkspaceId]}[Data],
    Lh     = Ws{[lakehouseId  = SourceLakehouseId]}[Data],
    Tbl    = Lh{[Id = "T1044_CASE", ItemKind = "Table"]}[Data]
in
    Tbl;

shared Src_T1049_COURT_ORDER = let
    Source = Lakehouse.Contents([]),
    Ws     = Source{[workspaceId = WorkspaceId]}[Data],
    Lh     = Ws{[lakehouseId  = SourceLakehouseId]}[Data],
    Tbl    = Lh{[Id = "T1049_COURT_ORDER", ItemKind = "Table"]}[Data]
in
    Tbl;

shared Src_T1082_CASE_PART = let
    Source = Lakehouse.Contents([]),
    Ws     = Source{[workspaceId = WorkspaceId]}[Data],
    Lh     = Ws{[lakehouseId  = SourceLakehouseId]}[Data],
    Tbl    = Lh{[Id = "T1082_CASE_PART", ItemKind = "Table"]}[Data]
in
    Tbl;

shared Src_t_reference = let
    Source = Lakehouse.Contents([]),
    Ws     = Source{[workspaceId = WorkspaceId]}[Data],
    Lh     = Ws{[lakehouseId  = SourceLakehouseId]}[Data],
    Tbl    = Lh{[Id = "t_reference", ItemKind = "Table"]}[Data]
in
    Tbl;

// -----------------------------------------------------------------------------
// REFERENCE FILTERS  (queryGroup: Reference)
// One filtered subset per (view_nam, field_nam) combo we need to merge.
// -----------------------------------------------------------------------------
shared Ref_VCASE_StatusCase = let
    Source   = Src_t_reference,
    Filtered = Table.SelectRows(Source, each [view_nam] = "VCASE" and [field_nam] = "StatusCase_CODE"),
    Picked   = Table.SelectColumns(Filtered, {"old_code", "new_code"}),
    Renamed  = Table.RenameColumns(Picked, {{"new_code", "StatusCase_CODE"}})
in
    Renamed;

shared Ref_VCASE_TypeCase = let
    Source   = Src_t_reference,
    Filtered = Table.SelectRows(Source, each [view_nam] = "VCASE" and [field_nam] = "TypeCase_CODE"),
    Picked   = Table.SelectColumns(Filtered, {"old_code", "new_code"}),
    Renamed  = Table.RenameColumns(Picked, {{"new_code", "TypeCase_CODE"}})
in
    Renamed;

shared Ref_VDEMO_Race = let
    Source   = Src_t_reference,
    Filtered = Table.SelectRows(Source, each [view_nam] = "VDEMO" and [field_nam] = "Race_CODE"),
    Picked   = Table.SelectColumns(Filtered, {"old_code", "new_code"}),
    Renamed  = Table.RenameColumns(Picked, {{"new_code", "Race_CODE"}})
in
    Renamed;

shared Ref_VCMEM_Relationship = let
    Source   = Src_t_reference,
    Filtered = Table.SelectRows(Source, each [view_nam] = "VCMEM" and [field_nam] = "CaseRelationship_CODE"),
    Picked   = Table.SelectColumns(Filtered, {"old_code", "new_code"}),
    Renamed  = Table.RenameColumns(Picked, {{"new_code", "CaseRelationship_CODE"}})
in
    Renamed;

// -----------------------------------------------------------------------------
// STAGED OUTPUTS  (queryGroup: Staged)  --  loaded into TargetLH
// -----------------------------------------------------------------------------

// VDEMO simple subset:  D + DV + Race crosswalk only.
// Notebook layer adds parsed name parts, height, DL, mail-phone, paternity birth-state.
shared Stg_VDEMO_Simple = let
    Source     = Src_T1043_PART,
    AddOffset  = Table.AddColumn(Source, "MemberMci_IDNO",
                    each [MCI_NUM] + 1000000, Int64.Type),
    AddIndiv   = Table.AddColumn(AddOffset, "INDIVIDUAL_IDNO",
                    each [MCI_NUM] * 10, Int64.Type),
    SelectCols = Table.SelectColumns(AddIndiv,
                    { "MCI_NUM", "MemberMci_IDNO", "INDIVIDUAL_IDNO",
                      "NAM", "SEX_CD", "SOC_SEC_NUM", "BIRTH_DT", "ETHNIC_CD" }),
    Rename1    = Table.RenameColumns(SelectCols,
                    {{"NAM",         "FullDisplay_NAME"},
                     {"SEX_CD",      "MemberSex_CODE"},
                     {"SOC_SEC_NUM", "MemberSsn_NUMB"},
                     {"BIRTH_DT",    "Birth_DATE"}}),
    // Single-column crosswalk via merge
    Merge      = Table.NestedJoin(Rename1, {"ETHNIC_CD"},
                                  Ref_VDEMO_Race, {"old_code"},
                                  "_race", JoinKind.LeftOuter),
    Expand     = Table.ExpandTableColumn(Merge, "_race", {"Race_CODE"}, {"Race_CODE"}),
    FillRace   = Table.ReplaceValue(Expand, null, "U",
                    Replacer.ReplaceValue, {"Race_CODE"}),
    AddDefs    = Table.AddColumn(FillRace, "Language_CODE",     each "ENG", type text),
    AddDefs2   = Table.AddColumn(AddDefs,  "BirthCountry_CODE", each "US",  type text),
    AddDefs3   = Table.AddColumn(AddDefs2, "BeginValidity_DATE", each ConversionDate, type date),
    AddDefs4   = Table.AddColumn(AddDefs3, "WorkerUpdate_ID",   each "CONV", type text)
in
    AddDefs4;

// VCASE simple subset:  D + DV + Status/Type crosswalks.
// Notebook layer adds Intercept/RespondInit/CaseCategory/Event-derived dates.
shared Stg_VCASE_Simple = let
    Source     = Src_T1044_CASE,
    Pick       = Table.SelectColumns(Source,
                    { "CASE_NUM", "STATUS_CD", "IVD_TYP_CD", "CLOSING_CD",
                      "STATUS_EFF_DT", "PROC_STS_EFF_DT",
                      "COUNTY_CD", "MED_SUP_ONLY_IND",
                      "APPL_REQ_DT", "APPL_RETURN_DT",
                      "RESP_WORKER_ID", "GOOD_CAUSE_RSN_CD" }),
    Rename     = Table.RenameColumns(Pick,
                    {{"CASE_NUM",          "Case_IDNO"},
                     {"STATUS_EFF_DT",     "Opened_DATE"},
                     {"PROC_STS_EFF_DT",   "StatusCurrent_DATE"},
                     {"MED_SUP_ONLY_IND",  "MedicalOnly_INDC"},
                     {"APPL_REQ_DT",       "AppReq_DATE"},
                     {"APPL_RETURN_DT",    "AppRetd_DATE"},
                     {"RESP_WORKER_ID",    "Worker_ID"}}),
    AddCounty  = Table.AddColumn(Rename, "County_IDNO",
                    each Int32.From([COUNTY_CD]), Int32.Type),
    AddFips    = Table.AddColumn(AddCounty, "AssignedFips_CODE",
                    each Text.PadStart(Text.From([COUNTY_CD]), 7, "0"), type text),
    AddGoodC   = Table.AddColumn(AddFips, "GoodCause_CODE",
                    each if [GOOD_CAUSE_RSN_CD] <> null then "Y" else "N", type text),
    // Status crosswalk
    M1         = Table.NestedJoin(AddGoodC, {"STATUS_CD"},
                                  Ref_VCASE_StatusCase, {"old_code"},
                                  "_s", JoinKind.LeftOuter),
    E1         = Table.ExpandTableColumn(M1, "_s", {"StatusCase_CODE"}, {"StatusCase_CODE"}),
    F1         = Table.ReplaceValue(E1, null, "O", Replacer.ReplaceValue, {"StatusCase_CODE"}),
    // Type crosswalk
    M2         = Table.NestedJoin(F1, {"IVD_TYP_CD"},
                                  Ref_VCASE_TypeCase, {"old_code"},
                                  "_t", JoinKind.LeftOuter),
    E2         = Table.ExpandTableColumn(M2, "_t", {"TypeCase_CODE"}, {"TypeCase_CODE"}),
    F2         = Table.ReplaceValue(E2, null, "N", Replacer.ReplaceValue, {"TypeCase_CODE"}),
    // Defaults
    Add1       = Table.AddColumn(F2, "SourceRfrl_CODE",      each "APP", type text),
    Add2       = Table.AddColumn(Add1, "Restricted_INDC",    each "N",   type text),
    Add3       = Table.AddColumn(Add2, "Jurisdiction_INDC",  each "Y",   type text),
    Add4       = Table.AddColumn(Add3, "IvdApplicant_CODE",  each "APP", type text),
    Add5       = Table.AddColumn(Add4, "ServiceRequested_CODE", each "F", type text),
    Add6       = Table.AddColumn(Add5, "BeginValidity_DATE", each ConversionDate, type date),
    Add7       = Table.AddColumn(Add6, "WorkerUpdate_ID",    each [Worker_ID], type text)
in
    Add7;

// VCMEM simple subset:  D + DV + Relationship crosswalk only.
// Notebook layer adds CpRelationshipToChild/Ncp logic and FAMILYVIOLENCE_INDC.
shared Stg_VCMEM_Simple = let
    Source = Src_T1082_CASE_PART,
    Pick   = Table.SelectColumns(Source,
                { "CASE_NUM", "MCI_NUM", "TYP_CD", "STATUS_CD" }),
    Rename = Table.RenameColumns(Pick,
                {{"CASE_NUM",  "Case_IDNO"},
                 {"STATUS_CD", "CaseMemberStatus_CODE"}}),
    AddOff = Table.AddColumn(Rename, "MemberMci_IDNO",
                each [MCI_NUM] + 1000000, Int64.Type),
    M1     = Table.NestedJoin(AddOff, {"TYP_CD"},
                              Ref_VCMEM_Relationship, {"old_code"},
                              "_r", JoinKind.LeftOuter),
    E1     = Table.ExpandTableColumn(M1, "_r", {"CaseRelationship_CODE"}, {"CaseRelationship_CODE"}),
    F1     = Table.ReplaceValue(E1, null, "O",
                Replacer.ReplaceValue, {"CaseRelationship_CODE"}),
    Add1   = Table.AddColumn(F1, "BenchWarrant_INDC",   each "N",  type text),
    Add2   = Table.AddColumn(Add1, "Applicant_CODE",
                each if [TYP_CD] = "CP  " then "Y" else "N", type text),
    Add3   = Table.AddColumn(Add2, "BeginValidity_DATE", each ConversionDate, type date),
    Add4   = Table.AddColumn(Add3, "WorkerUpdate_ID",    each "CONV", type text)
in
    Add4;

// VSORD simple subset:  D + DV only.
// Notebook layer adds File_ID cleansing, FIPS map, DirectPay flag.
shared Stg_VSORD_Simple = let
    Source = Src_T1049_COURT_ORDER,
    Pick   = Table.SelectColumns(Source,
                { "CASE_NUM", "BLIND_KEY",
                  "COURT_DT", "ORDER_START_DT", "ORDER_END_DT",
                  "INS_ORDERED_IND", "MELSON_DEV_IND",
                  "MOD_TYP_CD", "CREATE_WORKER_ID", "CREATE_DT",
                  "ORIGINATING_ST_CD" }),
    Rename = Table.RenameColumns(Pick,
                {{"CASE_NUM",         "Case_IDNO"},
                 {"BLIND_KEY",        "OrderSeq_NUMB"},
                 {"COURT_DT",         "OrderEnt_DATE"},
                 {"ORDER_START_DT",   "OrderEffective_DATE"},
                 {"ORDER_END_DT",     "OrderEnd_DATE"},
                 {"INS_ORDERED_IND",  "InsOrdered_CODE"},
                 {"MELSON_DEV_IND",   "GuidelinesFollowed_INDC"},
                 {"CREATE_WORKER_ID", "WorkerUpdate_ID"},
                 {"CREATE_DT",        "BeginValidity_DATE"}}),
    AddIs  = Table.AddColumn(Rename, "OrderIssued_DATE",
                each [OrderEnt_DATE], type date),
    Add1   = Table.AddColumn(AddIs, "StatusOrder_CODE",  each "A", type text),
    Add2   = Table.AddColumn(Add1,  "MedicalOnly_INDC",  each "N", type text),
    Add3   = Table.AddColumn(Add2,  "SourceOrdered_CODE",each "C", type text),
    Add4   = Table.AddColumn(Add3,  "TypeOrder_CODE",
                each if [MOD_TYP_CD] = "MOD " then "M" else "O", type text)
in
    Add4;
