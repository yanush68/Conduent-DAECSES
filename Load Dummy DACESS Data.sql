/*
  Load Dummy DACSES Data
  ----------------------
  Populates all source tables with representative demo data.
  Insert order respects foreign key dependencies.

  Participants (T1043_PART):
    1000001 - John Smith      (NCP, Male)
    1000002 - Jane Doe        (CP, Female)
    1000003 - Tommy Smith     (Child, Male)
    1000004 - Sarah Smith     (Child, Female)
    1000005 - Robert Jones    (NCP, Male)
    1000006 - Maria Garcia    (CP, Female)
    1000007 - Carlos Jones    (Child, Male)
    1000008 - William Brown   (NCP, Male)  - DIRP case
    1000009 - Linda Brown     (CP, Female) - DIRP case
    1000010 - Emily Brown     (Child, Female) - DIRP case
    1000011 - Frank Adams     (Guardian, Male) - OTHR/GUAR on case 100002

  Cases (T1044_CASE):
    100001 - Smith/Doe family     (Active, NFAF)
    100002 - Jones/Garcia family  (Active, AFDC, PFA, with guardian)
    100003 - Closed case          (Smith/Doe prior, NFAF)
    100004 - Brown/Brown family   (Active, DIRP - direct pay)
    100005 - Jones/Garcia MAO     (Active, MAO, UCNC unworkable)

  V-Series (target-format tables):
    VDEMO  MemberMci_IDNO 2000001-2000011
    VCASE  Case_IDNO      200001-200005
*/

USE [DACSES_POC_Source]
GO

SET NOCOUNT ON;
GO

-- ============================================================
-- DELETE existing data (child tables first, then parents)
-- ============================================================
DELETE FROM [dbo].[t_compare_fields];
DELETE FROM [dbo].[t_compare_report];
DELETE FROM [dbo].[t_reference];
DELETE FROM [dbo].[VLSUP];
DELETE FROM [dbo].[VOBLE];
DELETE FROM [dbo].[VSORD];
DELETE FROM [dbo].[VCMEM];
DELETE FROM [dbo].[VCASE];
DELETE FROM [dbo].[VDEMO];
DELETE FROM [dbo].[T1050_ORD_SUB_ACCT];
DELETE FROM [dbo].[T1052_ORD_CHLD_INC];
DELETE FROM [dbo].[T1049_COURT_ORDER];
DELETE FROM [dbo].[T1018_SS_DEBT];
DELETE FROM [dbo].[T1038_FTIN_ELIG];
DELETE FROM [dbo].[T1048_SUB_ACCT];
DELETE FROM [dbo].[T1074_EVENT];
DELETE FROM [dbo].[T1082_CASE_PART];
DELETE FROM [dbo].[T1005_LS_LIC_MATCH];
DELETE FROM [dbo].[T1045_AP_EXT];
DELETE FROM [dbo].[T1051_PART_ADDRESS];
DELETE FROM [dbo].[T1096_PATERNITY];
DELETE FROM [dbo].[T1044_CASE];
DELETE FROM [dbo].[T1043_PART];
GO

PRINT 'Existing data cleared.';
GO

-- ============================================================
-- 1. T1043_PART  (Participants - no FK dependencies)
-- ============================================================
INSERT INTO [dbo].[T1043_PART]
  ([MCI_NUM],[DCIS1_CASE_NUM],[DCIS1_SUFFIX_CD],[NAM],[BIRTH_DT],[SEX_CD],[ETHNIC_CD],
   [EFT_ACCT_NUM],[PAT_ESTB_DT],[MMCB_IND],[AP_WAGE_SUPP_IND],[PAT_ESTB_CD],
   [DCIS2_CASE_NUM],[DCIS2_CASE_STS_CD],[DCIS2_PGM_CD],[DCIS2_SUB_PGM_CD],
   [DCIS2_AG_SEQ_NUM],[PAT_EFF_DT],[TFM_TRACK_CD],[SOC_SEC_NUM],[PART_ACCT_NUM],[SSN_VER_CD])
VALUES
  ('1000001','100001','01','SMITH, JOHN A','1980-03-15','M','WH',NULL,NULL,'N','N',NULL,
   '0000100001','ACTV','IVD','A','00001',NULL,'Y','100010001','100001','VALD'),

  ('1000002','100001','02','DOE, JANE M','1982-07-22','F','WH',NULL,NULL,'N','N',NULL,
   '0000100002','ACTV','IVD','A','00002',NULL,'N','100020002','100002','VALD'),

  ('1000003','100001','03','SMITH, TOMMY L','2010-11-05','M','WH',NULL,'2010-11-05','N','N','H',
   '0000100003','ACTV','IVD','A','00003','2010-11-05','N',NULL,NULL,NULL),

  ('1000004','100001','04','SMITH, SARAH K','2013-02-18','F','WH',NULL,'2013-02-18','N','N','H',
   '0000100004','ACTV','IVD','A','00004','2013-02-18','N',NULL,NULL,NULL),

  ('1000005','100002','01','JONES, ROBERT D','1975-09-10','M','BL',NULL,NULL,'N','Y',NULL,
   '0000100005','ACTV','IVD','A','00005',NULL,'Y','100050005','100005','VALD'),

  ('1000006','100002','02','GARCIA, MARIA T','1978-12-01','F','HI',NULL,NULL,'N','N',NULL,
   '0000100006','ACTV','IVD','A','00006',NULL,'N','100060006','100006','VALD'),

  ('1000007','100002','03','JONES, CARLOS R','2015-06-30','M','HI',NULL,'2015-06-30','N','N','V',
   '0000100007','ACTV','IVD','A','00007','2015-06-30','N',NULL,NULL,NULL),

  ('1000008','100004','01','BROWN, WILLIAM T','1972-05-20','M','WH',NULL,NULL,'N','N',NULL,
   '0000100008','ACTV','IVD','A','00008',NULL,'Y','100080008','100008','VALD'),

  ('1000009','100004','02','BROWN, LINDA R','1974-11-03','F','WH',NULL,NULL,'N','N',NULL,
   '0000100009','ACTV','IVD','A','00009',NULL,'N','100090009','100009','VALD'),

  ('1000010','100004','03','BROWN, EMILY J','2012-08-14','F','WH',NULL,'2012-08-14','N','N','H',
   '0000100010','ACTV','IVD','A','00010','2012-08-14','N',NULL,NULL,NULL),

  ('1000011','100002','04','ADAMS, FRANK G','1955-01-28','M','BL',NULL,NULL,'N','N',NULL,
   '0000100011','ACTV','IVD','A','00011',NULL,'N','100110011','100011','VALD');
GO

-- ============================================================
-- 2. T1044_CASE  (Cases - no FK dependencies)
-- ============================================================
INSERT INTO [dbo].[T1044_CASE]
  ([CASE_NUM],[STATUS_CD],[STATUS_EFF_DT],[CLOSING_CD],[PROCESSING_CD],[PROC_STS_EFF_DT],
   [CONTACT_WORKER_ID],[UNWORK_RSN_CD],[UNWORK_RSN_EFF_DT],[IVD_TYP_CD],[IVD_TYP_EFF_DT],
   [PREV_IVD_TYP_CD],[PREV_IVD_TYP_EF_DT],[COUNTY_CD],[FAM_COURT_FILE],[LAST_PMT_DT],
   [CREDIT_BUR_CD],[URESA_TYP_CD],[RESP_WORKER_ID],[PMT_TYP_CD],[PAY_OVERRIDE_IND],
   [NEXT_CHARGE_DT],[CHARGE_FREQ_CD],[AUDIT_DT],[EMAN_STS_IND],[MED_SUP_ONLY_IND],
   [INIT_RESP_ST_CD],[LAST_CHRG_DT],[APPL_REQ_DT],[APPL_PROVIDED_DT],[APPL_RETURN_DT],
   [LAST_DLQ_DT],[INS_AVAIL_IND],[FCR_RPT_IND],[INTACT_FAM_IND],[AFDC_GRANT_AMT],
   [GOOD_CAUSE_RSN_CD],[UNWORK_OVERRIDE_CD],[PFA_IND],[WAGE_OVERRIDE_IND],[TAX_EXCL_IND],
   [WAGE_SUPPRESS_IND],[BILLING_IND],[LEGAL_FILE_ID],[LAST_PMT_RCP_TYP],[DRA_FEE_ELIG_IND])
VALUES
  ('100001','OPEN','2018-01-15',NULL,'WRKD','2018-01-15',
   'W001',NULL,NULL,'NFAF','2018-01-15',NULL,NULL,'003','FC2018-0042','2026-03-01',
   NULL,NULL,'W001','WAGE','N','2026-04-01','MNTH','2025-12-15','N','N','I','2026-03-01',
   '2017-12-01','2017-12-10','2018-01-05','2025-06-15','Y','Y','N',0.00,NULL,NULL,'N','N','N','N','Y','LF001','CP  ','Y'),

  ('100002','OPEN','2019-06-10',NULL,'WRKD','2019-06-10',
   'W002',NULL,NULL,'AFDC','2019-06-10',NULL,NULL,'001','FC2019-0118','2026-02-15',
   NULL,NULL,'W002','WAGE','N','2026-04-01','MNTH','2025-11-20','N','N','I','2026-02-15',
   '2019-05-01','2019-05-15','2019-06-01',NULL,'N','Y','N',350.00,NULL,NULL,'N','N','N','N','Y','LF002','CP  ','N'),

  ('100003','CLSD','2022-08-30','EMCP','CLSD','2022-08-30',
   'W001',NULL,NULL,'NFAF','2020-03-01','AFDC','2018-01-15','003','FC2020-0201',NULL,
   NULL,NULL,'W001',NULL,'N',NULL,NULL,'2022-08-30','Y','N','I',NULL,
   '2020-02-01','2020-02-15','2020-03-01',NULL,'N','Y','N',0.00,NULL,NULL,'N','N','N','N','N','LF003',NULL,'N'),

  -- DIRP case: Direct Pay, no VOBLE should be created per mapping rules
  ('100004','OPEN','2021-04-01',NULL,'WRKD','2021-04-01',
   'W003',NULL,NULL,'DIRP','2021-04-01',NULL,NULL,'003','FC2021-0055','2026-01-15',
   NULL,NULL,'W003','WAGE','N','2026-04-01','MNTH','2025-10-01','N','N','I','2026-01-15',
   '2021-03-01','2021-03-15','2021-04-01',NULL,'Y','Y','N',0.00,NULL,NULL,'N','N','N','N','Y','LF004','CP  ','N'),

  -- MAO case with UCNC unworkable reason + PFA (exercises NonCoop, FamilyViolence, CaseCategory rules)
  ('100005','OPEN','2020-09-15',NULL,'UNWK','2023-05-01',
   'W002','UCNC','2023-05-01','MAO ','2020-09-15',NULL,NULL,'001','FC2020-0330','2025-11-01',
   NULL,NULL,'W002','WAGE','N','2026-04-01','MNTH','2025-08-10','N','Y','R','2025-11-01',
   '2020-08-01','2020-08-15','2020-09-01',NULL,'N','Y','N',275.00,'WPFA',NULL,'Y','N','N','Y','Y','LF005','CP  ','N');
GO

-- ============================================================
-- 3. T1005_LS_LIC_MATCH  (FK → T1043)
-- ============================================================
INSERT INTO [dbo].[T1005_LS_LIC_MATCH]
  ([NCP_MCI_NUM],[LIC_AGENCY_CD],[LIC_TYPE_CD],[LIC_NUM],[FIRST_MATCH_DT],[WKR_ID],[CREATE_DT],[UPDATE_DT],[LIC_EXPIRE_DT])
VALUES
  ('1000001','DMV','DRV','DE-12345678 ','2019-04-10','W001','2019-04-10','2024-06-01','2027-03-15'),
  ('1000005','DMV','DRV','DE-87654321 ','2020-01-20','W002','2020-01-20','2023-09-15','2026-09-10'),
  ('1000005','PLC','PRF','PL-00099887 ','2021-05-05','W002','2021-05-05',NULL,'2025-12-31'),
  ('1000008','DMV','DRV','DE-55566677 ','2022-02-10','W003','2022-02-10',NULL,'2028-05-20');
GO

-- ============================================================
-- 4. T1018_SS_DEBT  (FK → T1044)
-- ============================================================
INSERT INTO [dbo].[T1018_SS_DEBT]
  ([CASE_NUM],[SUB_TYP_CD],[SS_TYP_CD],[BAL_DUE],[CREDIT_TO_DT],[DEBIT_TO_DT])
VALUES
  ('100001','CSCHLD','CURR  ',250.00,12500.00,14750.00),
  ('100001','ARREAR','ARRS  ',3200.00,800.00,4000.00),
  ('100001','ARREAR','PERMAN',1500.00,500.00,2000.00),   -- Maps to VLSUP.OweTotPaa_AMNT
  ('100001','ARREAR','UNASSD',750.00,0.00,750.00),        -- Maps to VLSUP.OweTotUda_AMNT
  ('100002','CSCHLD','CURR  ',400.00,8000.00,10400.00),
  ('100004','CSCHLD','CURR  ',300.00,3600.00,3900.00),
  ('100005','CSCHLD','CURR  ',275.00,4125.00,4400.00);
GO

-- ============================================================
-- 5. T1038_FTIN_ELIG  (FK → T1044)
-- ============================================================
INSERT INTO [dbo].[T1038_FTIN_ELIG]
  ([CASE_NUM],[BLIND_KEY],[MCI_NUM],[CASE_TYP_CD],[AFDC_ARREARS_AMT],[NPA_ARREARS_AMT],
   [STAX_ARREARS_AMT],[TAX_INT_STS_CD],[TAX_INT_STS_DT],[PREV_INT_STS_CD],
   [AFDC_ELIG_IND],[NPA_ELIG_IND],[STX_LOT_ELIG_IND],[NOTICE_SENT_DT],
   [CREATE_DT],[ARCHIVE_DT],[LAST_UPD_DT],[LAST_WKR_ID])
VALUES
  ('100001','0000000000000001','1000001','NFAF',0,3200,3200,'ELIG','2025-10-01',NULL,
   'N','Y','Y','2025-10-15','2025-10-01',NULL,'2025-10-15','W001'),
  ('100002','0000000000000001','1000005','AFDC',2400,0,2400,'ELIG','2025-11-01',NULL,
   'Y','N','Y','2025-11-15','2025-11-01',NULL,'2025-11-15','W002'),
  -- T1038 with SUBM status (submitted) to test VCASE.Intercept_CODE = 'I' path
  ('100005','0000000000000001','1000005','MAO ',0,1800,1800,'SUBM','2025-09-01',NULL,
   'N','Y','Y','2025-09-15','2025-09-01',NULL,'2025-09-15','W002');
GO

-- ============================================================
-- 6. T1045_AP_EXT  (FK → T1043, NCPs only)
-- ============================================================
INSERT INTO [dbo].[T1045_AP_EXT]
  ([MCI_NUM],[EYE_COLOR],[HAIR_COLOR],[HEIGHT],[WEIGHT],[IDENT_MARKS],
   [LICENSE_STATE],[LICENSE_NUM],[LAST_SEEN_DT],[MILITARY],[MILITARY_ST_DT],[MILITARY_EN_DT],
   [BIRTH_CITY],[BIRTH_STATE],[NOTE1],[NOTE2],[NOTE3])
VALUES
  ('1000001','BRN  ','BLK  ','5 11 ','185',NULL,'DE','DE-12345678 ','2025-12-01',NULL,NULL,NULL,
   'WILMINGTON      ','DE','Employed at ABC Manufacturing',NULL,NULL),
  ('1000005','BLU  ','BRN  ','6 01 ','210','SCAR LEFT ARM     ','DE','DE-87654321 ','2026-01-10','ARMY     ','2000-06-01','2004-06-30',
   'DOVER           ','DE','Veteran - Army','Licensed plumber',NULL),
  ('1000008','GRN  ','BLK  ','5 09 ','175',NULL,'DE','DE-55566677 ','2026-02-01',NULL,NULL,NULL,
   'WILMINGTON      ','DE','Self-employed contractor',NULL,NULL);
GO

-- ============================================================
-- 7. T1048_SUB_ACCT  (FK → T1044)
-- ============================================================
INSERT INTO [dbo].[T1048_SUB_ACCT]
  ([CASE_NUM],[SUB_TYP_CD],[BALANCE],[STATUS_CD],[PAYEE_ACCT_NUM],[URESA_CD],
   [DEBIT_TO_DT_AMT],[CREDIT_TO_DT_AMT],[FREQ_AMT],[PERIOD_AMT])
VALUES
  ('100001','CSCHLD','250.00','ACTV','100002',NULL,14750.00,12500.00,500.00,500.00),
  ('100001','ARREAR','3200.00','ACTV','100002',NULL,4000.00,800.00,50.00,50.00),
  ('100001','FCAREA','800.00','ACTV','100002',NULL,1200.00,400.00,0.00,0.00),    -- Maps to VLSUP.OweTotIvef_AMNT
  ('100001','MEDA  ','150.00','ACTV','100002',NULL,300.00,150.00,0.00,0.00),      -- Maps to VLSUP.OweTotMedi_AMNT
  ('100002','CSCHLD','400.00','ACTV','100006',NULL,10400.00,8000.00,600.00,600.00),
  ('100002','ARREAR','0.00','ACTV','100006',NULL,0.00,0.00,0.00,0.00),
  ('100002','OSTATA','0.00','ACTV','100006',420000,0.00,0.00,0.00,0.00),          -- Out-of-state; URESA_CD used for VOBLE.Fips_CODE
  ('100004','CSCHLD','300.00','ACTV','100009',NULL,3900.00,3600.00,350.00,350.00),
  ('100005','CSCHLD','275.00','ACTV','100006',NULL,4400.00,4125.00,275.00,275.00),
  ('100005','MEDSUP','0.00','ACTV','100006',NULL,0.00,0.00,0.00,0.00);            -- Medical support sub-account
GO

-- ============================================================
-- 8. T1049_COURT_ORDER  (FK → T1044)
-- ============================================================
INSERT INTO [dbo].[T1049_COURT_ORDER]
  ([CASE_NUM],[BLIND_KEY],[COURT_OFF_NAM],[COURT_DT],[CREATE_WORKER_ID],[CHRG_FREQ_CD],
   [MOD_TYP_CD],[ORDER_START_DT],[ORDER_END_DT],[ORDER_METHOD_CD],[ORIGINATING_ST_CD],
   [INS_ORDERED_IND],[INS_PROV_BY_CD],[CREATE_DT],[PFA_IND],[NEW_ORD_ENTRY_IND],
   [MELSON_DEV_IND],[MAILED_DT],[NOTE_TXT])
VALUES
  ('100001',1,'JUDGE TAYLOR            ','2018-03-20','W001','MNTH',NULL,'2018-04-01',NULL,'CT','DE',
   'Y','NCP ','2018-03-20','N','Y','Y','2018-03-25','Initial support order for Smith/Doe'),
  ('100001',2,'JUDGE TAYLOR            ','2022-01-15','W001','MNTH','MOD ','2022-02-01',NULL,'CT','DE',
   'Y','NCP ','2022-01-15','N','N','Y','2022-01-20','Modification - increased support amount'),
  ('100002',1,'JUDGE MARTINEZ          ','2019-08-05','W002','MNTH',NULL,'2019-09-01',NULL,'CT','DE',
   'N',NULL,'2019-08-05','N','Y','Y','2019-08-10','Initial support order for Jones/Garcia'),
  -- DIRP case court order
  ('100004',1,'JUDGE WILSON            ','2021-06-10','W003','MNTH',NULL,'2021-07-01',NULL,'CT','DE',
   'Y','NCP ','2021-06-10','N','Y','Y','2021-06-15','Direct pay order for Brown family'),
  -- MAO case order with PFA and out-of-state origin
  ('100005',1,'JUDGE MARTINEZ          ','2020-11-20','W002','MNTH',NULL,'2020-12-01',NULL,'CT','PA',
   'N',NULL,'2020-11-20','Y','Y','N','2020-11-25','MAO case - PA originating order'),
  -- No-charge court order (exercises VOBLE NO-C frequency rule)
  ('100005',2,'JUDGE MARTINEZ          ','2023-06-01','W002','NO-C',NULL,'2023-07-01','2024-12-31','CT','PA',
   'N',NULL,'2023-06-01','N','N','N',NULL,'No-charge modification');
GO

-- ============================================================
-- 9. T1050_ORD_SUB_ACCT  (FK → T1049)
-- ============================================================
INSERT INTO [dbo].[T1050_ORD_SUB_ACCT]
  ([CASE_NUM],[BLIND_KEY],[SUB_TYP_CD],[FREQ_AMT],[ORDERED_ARR_AMT],[ARR_ADJ_AMT])
VALUES
  ('100001',1,'CSCHLD',400.00,NULL,NULL),
  ('100001',2,'CSCHLD',500.00,NULL,NULL),
  ('100001',2,'ARREAR',50.00,3200.00,0.00),
  ('100002',1,'CSCHLD',600.00,NULL,NULL),
  -- DIRP case ordered amounts
  ('100004',1,'CSCHLD',350.00,NULL,NULL),
  -- MAO case ordered amounts (CURSUP + MEDSUP + SPLSUP varieties for Periodic_AMNT rule)
  ('100005',1,'CURSUP',275.00,NULL,NULL),
  ('100005',1,'MEDSUP',0.00,NULL,NULL),
  ('100005',1,'CUSTA1',25.00,500.00,0.00);  -- Arrears aligned with CURSUP
GO

-- ============================================================
-- 10. T1051_PART_ADDRESS  (FK → T1043)
-- ============================================================
INSERT INTO [dbo].[T1051_PART_ADDRESS]
  ([MCI_NUM],[BLIND_KEY],[STREET_1_ADR],[EFFECTIVE_DT],[HSE_PHONE_NUM],[ADD_TYP_CD],
   [ADD_VER_CD],[APARTMENT_ADR],[STREET_2_ADR],[CITY_ADR],[STATE_ADR],[ZIP_ADR],
   [ZIP_SFX_ADR],[CORR_FIPS_CD],[UPDATE_WORKER_ID],[PAYMENT_FIPS_CD],
   [LAST_KNOWN_CA_IND],[UPDATE_DT],[NOTE_TXT])
VALUES
  ('1000001','0000000000000001','123 MAIN STREET            ','2020-06-01','3025551234','HOME','CONF',NULL,NULL,
   'WILMINGTON      ','DE','19801','1234','100030000','W001','100030000','Y','2024-01-15',NULL),
  ('1000001','0000000000000002','456 INDUSTRIAL BLVD        ','2020-06-01','3025555678','WORK','CONF',NULL,'SUITE 200                      ',
   'NEWARK          ','DE','19711','5678','100030000','W001','100030000','N','2024-01-15','Employer: ABC Manufacturing'),
  -- MAIL address for NCP (Smith) - used by RespondInit_CODE, HomePhone, VOBLE Fips rules
  ('1000001','0000000000000003','123 MAIN STREET            ','2020-06-01','3025551234','MAIL','CONF',NULL,NULL,
   'WILMINGTON      ','DE','19801','1234','100030000','W001','100030000','N','2024-01-15',NULL),
  ('1000002','0000000000000001','789 OAK AVENUE             ','2019-02-10','3025559012','HOME','CONF','APT 4',NULL,
   'WILMINGTON      ','DE','19802','9012','100030000','W001','100030000','Y','2023-08-20',NULL),
  -- MAIL address for CP (Doe)
  ('1000002','0000000000000002','789 OAK AVENUE             ','2019-02-10','3025559012','MAIL','CONF','APT 4',NULL,
   'WILMINGTON      ','DE','19802','9012','100030000','W001','100030000','N','2023-08-20',NULL),
  ('1000005','0000000000000001','321 ELM STREET             ','2021-03-15','3025553456','HOME','CONF',NULL,NULL,
   'DOVER           ','DE','19901','3456','100010000','W002','100010000','Y','2025-05-10',NULL),
  -- MAIL address for NCP (Jones)
  ('1000005','0000000000000002','321 ELM STREET             ','2021-03-15','3025553456','MAIL','CONF',NULL,NULL,
   'DOVER           ','DE','19901','3456','100010000','W002','100010000','N','2025-05-10',NULL),
  ('1000006','0000000000000001','654 PINE ROAD              ','2020-11-01','3025557890','HOME','CONF',NULL,NULL,
   'DOVER           ','DE','19901','7890','100010000','W002','100010000','Y','2024-09-22',NULL),
  -- MAIL address for CP (Garcia)
  ('1000006','0000000000000002','654 PINE ROAD              ','2020-11-01','3025557890','MAIL','CONF',NULL,NULL,
   'DOVER           ','DE','19901','7890','100010000','W002','100010000','N','2024-09-22',NULL),
  ('1000003','0000000000000001','789 OAK AVENUE             ','2019-02-10','3025559012','HOME','CONF','APT 4',NULL,
   'WILMINGTON      ','DE','19802','9012','100030000','W001','100030000','Y','2023-08-20','Same as CP (Jane Doe)'),
  ('1000007','0000000000000001','654 PINE ROAD              ','2020-11-01','3025557890','HOME','CONF',NULL,NULL,
   'DOVER           ','DE','19901','7890','100010000','W002','100010000','Y','2024-09-22','Same as CP (Maria Garcia)'),
  -- DIRP NCP (Brown) addresses
  ('1000008','0000000000000001','900 MARKET STREET          ','2021-04-01','3025556789','HOME','CONF',NULL,NULL,
   'WILMINGTON      ','DE','19801','6789','100030000','W003','100030000','Y','2025-01-10',NULL),
  ('1000008','0000000000000002','900 MARKET STREET          ','2021-04-01','3025556789','MAIL','CONF',NULL,NULL,
   'WILMINGTON      ','DE','19801','6789','100030000','W003','100030000','N','2025-01-10',NULL),
  -- DIRP CP (Linda Brown)
  ('1000009','0000000000000001','222 WALNUT LANE            ','2021-04-01','3025554321','HOME','CONF',NULL,NULL,
   'WILMINGTON      ','DE','19802','4321','100030000','W003','100030000','Y','2025-01-10',NULL),
  ('1000009','0000000000000002','222 WALNUT LANE            ','2021-04-01','3025554321','MAIL','CONF',NULL,NULL,
   'WILMINGTON      ','DE','19802','4321','100030000','W003','100030000','N','2025-01-10',NULL),
  -- Guardian (Adams)
  ('1000011','0000000000000001','100 SENIOR BLVD            ','2019-06-10','3025558888','HOME','CONF',NULL,NULL,
   'DOVER           ','DE','19901','8888','100010000','W002','100010000','Y','2024-09-22',NULL);
GO

-- ============================================================
-- 11. T1052_ORD_CHLD_INC  (FK → T1049)
-- ============================================================
INSERT INTO [dbo].[T1052_ORD_CHLD_INC]
  ([CASE_NUM],[BLIND_KEY],[MCI_NUM])
VALUES
  ('100001',1,'1000003'),
  ('100001',1,'1000004'),
  ('100001',2,'1000003'),
  ('100001',2,'1000004'),
  ('100002',1,'1000007'),
  ('100004',1,'1000010'),
  ('100005',1,'1000007');
GO

-- ============================================================
-- 12. T1074_EVENT  (FK → T1044)
-- ============================================================
INSERT INTO [dbo].[T1074_EVENT]
  ([CASE_NUM],[BLIND_KEY],[CREATE_DT],[CREATE_TM],[TYP_CD],[DISPOSITION_CD],
   [DISP_WORKER_ID],[COUNTY_CD],[CREATE_WORKER_ID],[INIT_EVNT_TYP_CD],
   [DESC_TXT],[UPDATE_WORKER_ID],[UPDATE_DT],[DISP_DT],[RESP_WORKER_ID])
VALUES
  ('100001','0000000000000001','2018-01-15','08:30:00','OPEN',NULL,NULL,'003','W001','OPEN',
   'Case opened - referral from TANF','W001','2018-01-15',NULL,'W001'),
  ('100001','0000000000000002','2018-03-20','10:15:00','CORD','COMP','W001','003','W001','CORD',
   'Court order established','W001','2018-03-20','2018-03-20','W001'),
  ('100001','0000000000000003','2022-01-15','14:00:00','CMOD','COMP','W001','003','W001','CMOD',
   'Order modification hearing completed','W001','2022-01-15','2022-01-15','W001'),
  ('100001','0000000000000004','2025-10-01','09:00:00','FTIX','PEND',NULL,'003','W001','FTIX',
   'Federal tax intercept submitted','W001','2025-10-15',NULL,'W001'),
  ('100002','0000000000000001','2019-06-10','11:00:00','OPEN',NULL,NULL,'001','W002','OPEN',
   'Case opened - CP application','W002','2019-06-10',NULL,'W002'),
  ('100002','0000000000000002','2019-08-05','13:30:00','CORD','COMP','W002','001','W002','CORD',
   'Court order established','W002','2019-08-05','2019-08-05','W002'),
  ('100002','0000000000000003','2026-02-15','10:00:00','PYMT',NULL,NULL,'001','W002','PYMT',
   'Wage withholding payment received','W002','2026-02-15',NULL,'W002'),
  ('100003','0000000000000001','2020-03-01','09:30:00','OPEN',NULL,NULL,'003','W001','OPEN',
   'Case opened','W001','2020-03-01',NULL,'W001'),
  ('100003','0000000000000002','2022-08-30','16:00:00','CLOS','COMP','W001','003','W001','CLOS',
   'Case closed - child emancipated','W001','2022-08-30','2022-08-30','W001'),
  -- DIRP case events
  ('100004','0000000000000001','2021-04-01','10:00:00','OPEN',NULL,NULL,'003','W003','OPEN',
   'Case opened - direct pay','W003','2021-04-01',NULL,'W003'),
  ('100004','0000000000000002','2021-06-10','11:30:00','CORD','COMP','W003','003','W003','CORD',
   'Court order established','W003','2021-06-10','2021-06-10','W003'),
  -- MAO case events (good cause / non-coop events)
  ('100005','0000000000000001','2020-09-15','09:00:00','OPEN',NULL,NULL,'001','W002','OPEN',
   'Case opened - MAO referral','W002','2020-09-15',NULL,'W002'),
  ('100005','0000000000000002','2020-11-20','14:00:00','CORD','COMP','W002','001','W002','CORD',
   'Court order established','W002','2020-11-20','2020-11-20','W002'),
  ('100005','0000000000000003','2023-05-01','10:30:00','WPFA','PEND',NULL,'001','W002','WPFA',
   'PFA - family violence reported','W002','2023-05-01',NULL,'W002'),
  ('100005','0000000000000004','2023-05-01','10:35:00','UCNC','PEND',NULL,'001','W002','UCNC',
   'Non-cooperation - unworkable','W002','2023-05-01',NULL,'W002');
GO

-- ============================================================
-- 13. T1082_CASE_PART  (FK → T1043, T1044)
-- ============================================================
INSERT INTO [dbo].[T1082_CASE_PART]
  ([CASE_NUM],[MCI_NUM],[TYP_CD],[STATUS_CD],[RELATION_CD],[FCR_RPTD_CD],[MMAP_IND])
VALUES
  ('100001','1000001','AP  ','A','NCP ','Y','N'),   -- NCP (John Smith)
  ('100001','1000002','CP  ','A','CP  ','Y','N'),   -- CP  (Jane Doe)
  ('100001','1000003','DEP ','A','CHLD','Y','N'),   -- Child (Tommy Smith)
  ('100001','1000004','DEP ','A','CHLD','Y','N'),   -- Child (Sarah Smith)
  ('100002','1000005','AP  ','A','NCP ','Y','N'),   -- NCP (Robert Jones)
  ('100002','1000006','CP  ','A','CP  ','Y','N'),   -- CP  (Maria Garcia)
  ('100002','1000007','DEP ','A','CHLD','Y','N'),   -- Child (Carlos Jones)
  ('100002','1000011','OTHR','A','GUAR','N','N'),   -- Guardian (Frank Adams) - exercises OTHR/GUAR rule
  ('100003','1000001','AP  ','I','NCP ','Y','N'),   -- Closed case - same NCP
  ('100003','1000002','CP  ','I','CP  ','Y','N'),   -- Closed case - same CP
  -- DIRP case members
  ('100004','1000008','AP  ','A','NCP ','Y','N'),   -- NCP (William Brown)
  ('100004','1000009','CP  ','A','CP  ','Y','N'),   -- CP  (Linda Brown)
  ('100004','1000010','DEP ','A','CHLD','Y','N'),   -- Child (Emily Brown)
  -- MAO case members (with FATH relation on OTHR for BTEX rule)
  ('100005','1000005','AP  ','A','FATH','Y','N'),   -- NCP (Robert Jones)
  ('100005','1000006','CP  ','A','MOTH','Y','N'),   -- CP  (Maria Garcia)
  ('100005','1000007','DEP ','A','CHLD','Y','N'),   -- Child (Carlos Jones)
  ('100005','1000011','OTHR','I','BTEX','N','N');   -- BTEX relation (Adams) - exercises CaseMemberStatus=I, REASONMEMBERSTATUS=X
GO

-- ============================================================
-- 14. T1096_PATERNITY  (FK → T1043)
-- ============================================================
INSERT INTO [dbo].[T1096_PATERNITY]
  ([CHILD_MCI_NUM],[CHILD_BIM],[PAT_ESTB],[PAT_ESTB_BY],[PAT_ESTB_DT],[PAT_ESTB_LOC],
   [ADOPT_DT],[BIRTH_ST],[CONCV_ST],[PAT_EFF_DT],[ADOPT_LOC],[ADOPT_IND],
   [UPDT_WKR_ID],[UPDT_DT])
VALUES
  ('1000003','Y','Y','HOSP','2010-11-05','DE',NULL,'DE','DE','2010-11-05',NULL,'N','W001','2018-01-20'),
  ('1000004','Y','Y','HOSP','2013-02-18','DE',NULL,'DE','DE','2013-02-18',NULL,'N','W001','2018-01-20'),
  ('1000007','Y','Y','CORT','2016-01-10','DE',NULL,'DE','DE','2016-01-10',NULL,'N','W002','2019-07-01'),
  ('1000010','Y','Y','HOSP','2012-08-14','DE',NULL,'DE','DE','2012-08-14',NULL,'N','W003','2021-04-15');
GO

-- ============================================================
-- 15. t_reference  (Code translation lookup)
-- ============================================================
INSERT INTO [dbo].[t_reference]
  ([view_nam],[field_nam],[old_code],[new_code],[description])
VALUES
  ('VCASE','StatusCase_CODE','OPEN','O','Open/Active case'),
  ('VCASE','StatusCase_CODE','CLSD','C','Closed case'),
  ('VCASE','TypeCase_CODE','NFAF','N','Non-AFDC/Non-IV-A Foster Care'),
  ('VCASE','TypeCase_CODE','AFDC','A','AFDC/TANF'),
  ('VCMEM','CaseRelationship_CODE','AP  ','N','Non-Custodial Parent'),
  ('VCMEM','CaseRelationship_CODE','CP  ','C','Custodial Parent'),
  ('VCMEM','CaseRelationship_CODE','DEP ','D','Dependent Child'),
  ('VDEMO','MemberSex_CODE','M','M','Male'),
  ('VDEMO','MemberSex_CODE','F','F','Female'),
  ('VDEMO','Race_CODE','WH','W','White'),
  ('VDEMO','Race_CODE','BL','B','Black'),
  ('VDEMO','Race_CODE','HI','H','Hispanic'),
  -- IVD type crosswalk
  ('VCASE','TypeCase_CODE','DIRP','D','Direct Pay'),
  ('VCASE','TypeCase_CODE','MAO ','M','Medical Assistance Only'),
  ('VCASE','TypeCase_CODE','COLL','C','Collection'),
  ('VCASE','TypeCase_CODE','FC  ','F','Foster Care'),
  -- Closing reason crosswalk
  ('VCASE','RsnStatusCase_CODE','EMCP','EM','Emancipated'),
  ('VCASE','RsnStatusCase_CODE','OPEN','OP','Opened/Active'),
  -- Debt type crosswalk (T1050.SUB_TYP_CD → VOBLE.TypeDebt_CODE)
  ('VOBLE','TypeDebt_CODE','CSCHLD','CS','Current Child Support'),
  ('VOBLE','TypeDebt_CODE','ARREAR','AR','Arrears'),
  ('VOBLE','TypeDebt_CODE','CURSUP','CS','Current Support'),
  ('VOBLE','TypeDebt_CODE','MEDSUP','MS','Medical Support'),
  ('VOBLE','TypeDebt_CODE','SPLSUP','SS','Spousal Support'),
  ('VOBLE','TypeDebt_CODE','CUSTA1','AA','Arrears Aligned - CurSup'),
  ('VOBLE','TypeDebt_CODE','CUSTM1','MA','Arrears Aligned - MedSup'),
  ('VOBLE','TypeDebt_CODE','APFEES','GT','Genetic Testing'),
  ('VOBLE','TypeDebt_CODE','OSTATA','IS','Interstate'),
  ('VOBLE','TypeDebt_CODE','MEDA  ','MD','Medical Arrears'),
  -- VCMEM TYP_CD crosswalk for OTHR rows
  ('VCMEM','CaseRelationship_CODE','OTHR','O','Other Participant'),
  -- Frequency crosswalk
  ('VOBLE','FreqPeriodic_CODE','MNTH','M','Monthly'),
  ('VOBLE','FreqPeriodic_CODE','SEMI','S','Semi-Monthly'),
  ('VOBLE','FreqPeriodic_CODE','NO-C','N','No Charge'),
  ('VOBLE','FreqPeriodic_CODE','BWKL','B','Bi-Weekly'),
  ('VOBLE','FreqPeriodic_CODE','WKLY','W','Weekly');
GO

-- ============================================================
-- 16. VDEMO  (Target demographics)
-- ============================================================
INSERT INTO [dbo].[VDEMO]
  ([MemberMci_IDNO],[INDIVIDUAL_IDNO],[Last_NAME],[First_NAME],[Middle_NAME],[Suffix_NAME],
   [Title_NAME],[FullDisplay_NAME],[MemberSex_CODE],[MemberSsn_NUMB],[Birth_DATE],
   [BirthCity_NAME],[BirthState_CODE],[BirthCountry_CODE],
   [DescriptionHeight_TEXT],[DescriptionWeightLbs_TEXT],[Race_CODE],
   [ColorHair_CODE],[ColorEyes_CODE],[Language_CODE],
   [HomePhone_NUMB],[WorkPhone_NUMB],[CellPhone_NUMB],
   [CONTACT_EML],[BeginValidity_DATE],[WorkerUpdate_ID],
   [TransactionEventSeq_NUMB],[Update_DTTM])
VALUES
  (2000001,10000001,'SMITH               ','JOHN            ','ANDREW              ',NULL,
   'MR      ','SMITH, JOHN ANDREW                                          ','M',100010001,'1980-03-15',
   'WILMINGTON                  ','DE','US','511','185','W','BLK','BRN','ENG',
   3025551234,3025555678,3025551111,
   'john.smith@example.com                                                                              ',
   '2018-01-15','W001',1001,'2024-01-15T10:30:00'),

  (2000002,10000002,'DOE                 ','JANE            ','MARIE               ',NULL,
   'MS      ','DOE, JANE MARIE                                             ','F',100020002,'1982-07-22',
   'DOVER                       ','DE','US','505','140','W','BRN','GRN','ENG',
   3025559012,NULL,3025552222,
   'jane.doe@example.com                                                                                ',
   '2018-01-15','W001',1002,'2023-08-20T14:00:00'),

  (2000003,10000003,'SMITH               ','TOMMY           ','LEE                 ',NULL,
   NULL    ,'SMITH, TOMMY LEE                                              ','M',NULL,'2010-11-05',
   'WILMINGTON                  ','DE','US',NULL,NULL,'W','BLK','BRN','ENG',
   NULL,NULL,NULL,NULL,
   '2018-01-15','W001',1003,'2023-08-20T14:00:00'),

  (2000004,10000004,'SMITH               ','SARAH           ','KAY                 ',NULL,
   NULL    ,'SMITH, SARAH KAY                                              ','F',NULL,'2013-02-18',
   'WILMINGTON                  ','DE','US',NULL,NULL,'W','BRN','BLU','ENG',
   NULL,NULL,NULL,NULL,
   '2018-01-15','W001',1004,'2023-08-20T14:00:00'),

  (2000005,10000005,'JONES               ','ROBERT          ','DAVID               ',NULL,
   'MR      ','JONES, ROBERT DAVID                                         ','M',100050005,'1975-09-10',
   'DOVER                       ','DE','US','601','210','B','BRN','BLU','ENG',
   3025553456,3025554567,3025553333,
   'robert.jones@example.com                                                                            ',
   '2019-06-10','W002',1005,'2025-05-10T09:15:00'),

  (2000006,10000006,'GARCIA              ','MARIA           ','TERESA              ',NULL,
   'MS      ','GARCIA, MARIA TERESA                                        ','F',100060006,'1978-12-01',
   'NEWARK                      ','DE','US','504','130','H','BLK','BRN','SPA',
   3025557890,NULL,3025554444,
   'maria.garcia@example.com                                                                            ',
   '2019-06-10','W002',1006,'2024-09-22T11:45:00'),

  (2000007,10000007,'JONES               ','CARLOS          ','RAFAEL              ',NULL,
   NULL    ,'JONES, CARLOS RAFAEL                                          ','M',NULL,'2015-06-30',
   'DOVER                       ','DE','US',NULL,NULL,'H','BLK','BRN','SPA',
   NULL,NULL,NULL,NULL,
   '2019-06-10','W002',1007,'2024-09-22T11:45:00'),

  (2000008,10000008,'BROWN               ','WILLIAM         ','THOMAS              ',NULL,
   'MR      ','BROWN, WILLIAM THOMAS                                       ','M',100080008,'1972-05-20',
   'WILMINGTON                  ','DE','US','509','175','W','BLK','GRN','ENG',
   3025556789,NULL,NULL,NULL,
   '2021-04-01','W003',1008,'2025-01-10T09:00:00'),

  (2000009,10000009,'BROWN               ','LINDA           ','RAE                 ',NULL,
   'MS      ','BROWN, LINDA RAE                                            ','F',100090009,'1974-11-03',
   'WILMINGTON                  ','DE','US','505','135','W','BRN','BLU','ENG',
   3025554321,NULL,NULL,NULL,
   '2021-04-01','W003',1009,'2025-01-10T09:00:00'),

  (2000010,10000010,'BROWN               ','EMILY           ','JANE                ',NULL,
   NULL    ,'BROWN, EMILY JANE                                             ','F',NULL,'2012-08-14',
   'WILMINGTON                  ','DE','US',NULL,NULL,'W','BRN','GRN','ENG',
   NULL,NULL,NULL,NULL,
   '2021-04-01','W003',1010,'2025-01-10T09:00:00'),

  (2000011,10000011,'ADAMS               ','FRANK           ','GEORGE              ',NULL,
   'MR      ','ADAMS, FRANK GEORGE                                         ','M',100110011,'1955-01-28',
   'DOVER                       ','DE','US',NULL,NULL,'B','GRY','BRN','ENG',
   3025558888,NULL,NULL,NULL,
   '2019-06-10','W002',1011,'2024-09-22T11:45:00');
GO

-- ============================================================
-- 17. VCASE  (Target cases)
-- ============================================================
INSERT INTO [dbo].[VCASE]
  ([Case_IDNO],[StatusCase_CODE],[TypeCase_CODE],[RsnStatusCase_CODE],[RespondInit_CODE],
   [SourceRfrl_CODE],[Opened_DATE],[StatusCurrent_DATE],[County_IDNO],[Office_IDNO],
   [AssignedFips_CODE],[GoodCause_CODE],[Restricted_INDC],[Intercept_CODE],
   [MedicalOnly_INDC],[Jurisdiction_INDC],[IvdApplicant_CODE],
   [AppReq_DATE],[AppRetd_DATE],[CpRelationshipToNcp_CODE],[Worker_ID],
   [BeginValidity_DATE],[WorkerUpdate_ID],[TransactionEventSeq_NUMB],[Update_DTTM],
   [CaseCategory_CODE],[ServiceRequested_CODE],[StatusEnforce_CODE])
VALUES
  (200001,'O','N','OP','I','TAN','2018-01-15','2018-01-15',3,3,'1000300',
   'N','N','Y','N','Y','TAN','2017-12-01','2018-01-05','SPO','W001                          ',
   '2018-01-15','W001                          ',2001,'2024-01-15T10:30:00',
   'IV','F','ACTV'),

  (200002,'O','A','OP','I','APP','2019-06-10','2019-06-10',1,1,'1000100',
   'N','N','Y','N','Y','APP','2019-05-01','2019-06-01','SPO','W002                          ',
   '2019-06-10','W002                          ',2002,'2025-05-10T09:15:00',
   'IV','F','ACTV'),

  (200003,'C','N','EM',NULL,'TAN','2020-03-01','2022-08-30',3,3,'1000300',
   'N','N','N','N','Y','TAN','2020-02-01','2020-03-01','SPO','W001                          ',
   '2020-03-01','W001                          ',2003,'2022-08-30T16:00:00',
   'IV','F','CLSD'),

  (200004,'O','D','OP','I','APP','2021-04-01','2021-04-01',3,3,'1000300',
   'N','N','N','N','Y','APP','2021-03-01','2021-04-01','SPO','W003                          ',
   '2021-04-01','W003                          ',2004,'2025-01-10T09:00:00',
   'DP','F','ACTV'),

  (200005,'O','M','OP','R','APP','2020-09-15','2020-09-15',1,1,'1000100',
   'Y','Y','I','Y','Y','APP','2020-08-01','2020-09-01','SPO','W002                          ',
   '2020-09-15','W002                          ',2005,'2025-08-10T10:30:00',
   'MO','F','ACTV');
GO

-- ============================================================
-- 18. VCMEM  (Target case members)
-- ============================================================
INSERT INTO [dbo].[VCMEM]
  ([Case_IDNO],[MemberMci_IDNO],[CaseRelationship_CODE],[CaseMemberStatus_CODE],
   [CpRelationshipToChild_CODE],[NcpRelationshipToChild_CODE],[BenchWarrant_INDC],
   [Applicant_CODE],[BeginValidity_DATE],[WorkerUpdate_ID],
   [TransactionEventSeq_NUMB],[Update_DTTM],[FAMILYVIOLENCE_INDC])
VALUES
  (200001,2000001,'N','A',NULL,'FAT','N','N','2018-01-15','W001                          ',3001,'2024-01-15T10:30:00','N'),
  (200001,2000002,'C','A','MOT',NULL,'N','Y','2018-01-15','W001                          ',3002,'2023-08-20T14:00:00','N'),
  (200001,2000003,'D','A','MOT','FAT','N','N','2018-01-15','W001                          ',3003,'2023-08-20T14:00:00','N'),
  (200001,2000004,'D','A','MOT','FAT','N','N','2018-01-15','W001                          ',3004,'2023-08-20T14:00:00','N'),
  (200002,2000005,'N','A',NULL,'FAT','N','N','2019-06-10','W002                          ',3005,'2025-05-10T09:15:00','N'),
  (200002,2000006,'C','A','MOT',NULL,'N','Y','2019-06-10','W002                          ',3006,'2024-09-22T11:45:00','N'),
  (200002,2000007,'D','A','MOT','FAT','N','N','2019-06-10','W002                          ',3007,'2024-09-22T11:45:00','N'),
  (200003,2000001,'N','I',NULL,'FAT','N','N','2020-03-01','W001                          ',3008,'2022-08-30T16:00:00','N'),
  (200003,2000002,'C','I','MOT',NULL,'N','Y','2020-03-01','W001                          ',3009,'2022-08-30T16:00:00','N'),
  -- DIRP case members
  (200004,2000008,'N','A',NULL,'FAT','N','N','2021-04-01','W003                          ',3010,'2025-01-10T09:00:00','N'),
  (200004,2000009,'C','A','MOT',NULL,'N','Y','2021-04-01','W003                          ',3011,'2025-01-10T09:00:00','N'),
  (200004,2000010,'D','A','MOT','FAT','N','N','2021-04-01','W003                          ',3012,'2025-01-10T09:00:00','N'),
  -- MAO case members (with guardian, family violence)
  (200005,2000005,'N','A',NULL,'FAT','N','N','2020-09-15','W002                          ',3013,'2025-08-10T10:30:00','Y'),
  (200005,2000006,'C','A','MOT',NULL,'N','Y','2020-09-15','W002                          ',3014,'2025-08-10T10:30:00','Y'),
  (200005,2000007,'D','A','MOT','FAT','N','N','2020-09-15','W002                          ',3015,'2025-08-10T10:30:00','N'),
  (200005,2000011,'O','A',NULL,'GUA','N','N','2020-09-15','W002                          ',3016,'2025-08-10T10:30:00','N');
GO

-- ============================================================
-- 19. VSORD  (Target support orders)
-- ============================================================
INSERT INTO [dbo].[VSORD]
  ([Case_IDNO],[OrderSeq_NUMB],[Order_IDNO],[File_ID],[OrderEnt_DATE],[OrderIssued_DATE],
   [OrderEffective_DATE],[OrderEnd_DATE],[StatusOrder_CODE],[StatusOrder_DATE],
   [InsOrdered_CODE],[MedicalOnly_INDC],[GuidelinesFollowed_INDC],
   [IssuingOrderFips_CODE],[WorkerUpdate_ID],[BeginValidity_DATE],
   [TypeOrder_CODE],[DirectPay_INDC],[SourceOrdered_CODE])
VALUES
  (200001,1,900000000000001,'FC20180042','2018-03-20','2018-03-20','2018-04-01',NULL,
   'A','2018-03-20','Y','N','Y','1000300','W001                          ','2018-03-20','O','N','C'),
  (200001,2,900000000000002,'FC20180042','2022-01-15','2022-01-15','2022-02-01',NULL,
   'A','2022-01-15','Y','N','Y','1000300','W001                          ','2022-01-15','M','N','C'),
  (200002,1,900000000000003,'FC20190118','2019-08-05','2019-08-05','2019-09-01',NULL,
   'A','2019-08-05','N','N','Y','1000100','W002                          ','2019-08-05','O','N','C'),
  -- DIRP case order
  (200004,1,900000000000004,'FC20210055','2021-06-10','2021-06-10','2021-07-01',NULL,
   'A','2021-06-10','Y','N','Y','1000300','W003                          ','2021-06-10','O','Y','C'),
  -- MAO case orders (PA originating, plus no-charge modification)
  (200005,1,900000000000005,'FC20200330','2020-11-20','2020-11-20','2020-12-01',NULL,
   'A','2020-11-20','N','Y','N','4200000','W002                          ','2020-11-20','O','N','C'),
  (200005,2,900000000000006,'FC20200330','2023-06-01','2023-06-01','2023-07-01','2024-12-31',
   'A','2023-06-01','N','N','N','4200000','W002                          ','2023-06-01','M','N','C');
GO

-- ============================================================
-- 20. VOBLE  (Target obligations)
-- ============================================================
INSERT INTO [dbo].[VOBLE]
  ([Case_IDNO],[OrderSeq_NUMB],[ObligationSeq_NUMB],[MemberMci_IDNO],[TypeDebt_CODE],
   [Fips_CODE],[FreqPeriodic_CODE],[Periodic_AMNT],[ExpectToPay_AMNT],[ExpectToPay_CODE],
   [BeginObligation_DATE],[EndObligation_DATE],[AccrualLast_DATE],[AccrualNext_DATE],
   [BeginValidity_DATE])
VALUES
  (200001,1,1,2000001,'CS','1000300','M',400.00,400.00,'F','2018-04-01',NULL,'2026-03-01','2026-04-01','2018-04-01'),
  (200001,2,1,2000001,'CS','1000300','M',500.00,500.00,'F','2022-02-01',NULL,'2026-03-01','2026-04-01','2022-02-01'),
  (200001,2,2,2000001,'AR','1000300','M',50.00,50.00,'F','2022-02-01',NULL,'2026-03-01','2026-04-01','2022-02-01'),
  (200002,1,1,2000005,'CS','1000100','M',600.00,600.00,'F','2019-09-01',NULL,'2026-02-15','2026-03-15','2019-09-01'),
  -- MAO case obligations (CURSUP + MEDSUP debt types, out-of-state FIPS)
  (200005,1,1,2000005,'CS','4200000','M',275.00,275.00,'C','2020-12-01',NULL,'2025-11-01','2026-04-01','2020-12-01'),
  (200005,1,2,2000005,'MS','4200000','M',0.00,0.00,'C','2020-12-01',NULL,'2025-11-01','2026-04-01','2020-12-01'),
  -- No-charge obligation (FreqPeriodic_CODE = 'N')
  (200005,2,1,2000005,'CS','4200000','N',0.00,0.00,'C','2023-07-01','2024-12-31',NULL,NULL,'2023-07-01');
GO

-- ============================================================
-- 21. VLSUP  (Target ledger / support history)
-- ============================================================
INSERT INTO [dbo].[VLSUP]
  ([Case_IDNO],[OrderSeq_NUMB],[ObligationSeq_NUMB],[SupportYearMonth_NUMB],
   [TypeWelfare_CODE],[TransactionCurSup_AMNT],[OweTotCurSup_AMNT],[AppTotCurSup_AMNT],
   [MtdCurSupOwed_AMNT],[Batch_DATE],[SourceBatch_CODE],[Receipt_DATE],[Distribute_DATE],
   [EventGlobalSeq_NUMB],[TYPERECORD_CODE])
VALUES
  (200001,1,1,202603,'N',400.00,19200.00,18800.00,400.00,
   '2026-03-01','WGE','2026-03-01','2026-03-05',5001,'D'),
  (200001,2,1,202603,'N',500.00,24500.00,22250.00,500.00,
   '2026-03-01','WGE','2026-03-01','2026-03-05',5002,'D'),
  (200001,2,2,202603,'N',50.00,4000.00,800.00,50.00,
   '2026-03-01','WGE','2026-03-01','2026-03-05',5003,'D'),
  (200002,1,1,202602,'A',600.00,46800.00,44400.00,600.00,
   '2026-02-15','WGE','2026-02-15','2026-02-20',5004,'D'),
  -- MAO case ledger
  (200005,1,1,202511,'N',275.00,16500.00,15950.00,275.00,
   '2025-11-01','WGE','2025-11-01','2025-11-05',5005,'D');
GO

-- ============================================================
-- 22. t_compare_fields  (Sample comparison metadata)
-- ============================================================
INSERT INTO [dbo].[t_compare_fields]
  ([view_name],[source_table],[target_column],[match_count],[mismatch_count])
VALUES
  ('VCASE','T1044_CASE','StatusCase_CODE',3,0),
  ('VCASE','T1044_CASE','County_IDNO',3,0),
  ('VCMEM','T1082_CASE_PART','CaseRelationship_CODE',9,0),
  ('VDEMO','T1043_PART','Last_NAME',7,0),
  ('VDEMO','T1043_PART','MemberSex_CODE',7,0);
GO

PRINT 'Dummy DACSES data loaded successfully.';
GO
