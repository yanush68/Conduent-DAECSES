USE [master]
GO
/****** Object:  Database [DACSES_POC_Source]    Script Date: 3/20/2026 9:30:06 AM ******/
CREATE DATABASE [DACSES_POC_Source]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'DACSES_POC_Source', FILENAME = N'E:\MSSQL\Data\DACSES_POC_Source.mdf' , SIZE = 4857856KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'DACSES_POC_Source_log', FILENAME = N'E:\MSSQL\Log\DACSES_POC_Source_log.ldf' , SIZE = 3022848KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [DACSES_POC_Source] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [DACSES_POC_Source].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [DACSES_POC_Source] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET ARITHABORT OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [DACSES_POC_Source] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [DACSES_POC_Source] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET  DISABLE_BROKER 
GO
ALTER DATABASE [DACSES_POC_Source] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [DACSES_POC_Source] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET RECOVERY FULL 
GO
ALTER DATABASE [DACSES_POC_Source] SET  MULTI_USER 
GO
ALTER DATABASE [DACSES_POC_Source] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [DACSES_POC_Source] SET DB_CHAINING OFF 
GO
ALTER DATABASE [DACSES_POC_Source] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [DACSES_POC_Source] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [DACSES_POC_Source] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [DACSES_POC_Source] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'DACSES_POC_Source', N'ON'
GO
ALTER DATABASE [DACSES_POC_Source] SET QUERY_STORE = ON
GO
ALTER DATABASE [DACSES_POC_Source] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [DACSES_POC_Source]
GO
USE [DACSES_POC_Source]
GO
/****** Object:  Sequence [dbo].[ConversionSeq]    Script Date: 3/20/2026 9:30:07 AM ******/
CREATE SEQUENCE [dbo].[ConversionSeq] 
 AS [bigint]
 START WITH 1
 INCREMENT BY 1
 MINVALUE -9223372036854775808
 MAXVALUE 9223372036854775807
 CACHE 
GO
/****** Object:  Table [dbo].[t_compare_fields]    Script Date: 3/20/2026 9:30:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_compare_fields](
	[view_name] [varchar](20) NOT NULL,
	[source_table] [varchar](30) NOT NULL,
	[target_column] [varchar](50) NOT NULL,
	[match_count] [int] NOT NULL,
	[mismatch_count] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_compare_report]    Script Date: 3/20/2026 9:30:07 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_compare_report](
	[view_name] [varchar](20) NOT NULL,
	[source_table] [varchar](30) NOT NULL,
	[source_column] [varchar](50) NOT NULL,
	[target_column] [varchar](50) NOT NULL,
	[key_value] [varchar](30) NOT NULL,
	[detail_1] [varchar](200) NULL,
	[detail_2] [varchar](200) NULL,
	[detail_3] [varchar](200) NULL,
	[detail_4] [varchar](200) NULL,
	[detail_5] [varchar](200) NULL,
	[source_value] [varchar](200) NULL,
	[target_value] [varchar](200) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[t_reference]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[t_reference](
	[view_nam] [varchar](10) NOT NULL,
	[field_nam] [varchar](50) NOT NULL,
	[old_code] [varchar](20) NOT NULL,
	[new_code] [varchar](20) NOT NULL,
	[description] [varchar](100) NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1005_LS_LIC_MATCH]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1005_LS_LIC_MATCH](
	[NCP_MCI_NUM] [varchar](10) NOT NULL,
	[LIC_AGENCY_CD] [char](3) NOT NULL,
	[LIC_TYPE_CD] [char](3) NOT NULL,
	[LIC_NUM] [char](12) NULL,
	[FIRST_MATCH_DT] [date] NULL,
	[WKR_ID] [char](4) NULL,
	[CREATE_DT] [date] NULL,
	[UPDATE_DT] [date] NULL,
	[LIC_EXPIRE_DT] [date] NULL,
 CONSTRAINT [PK_T1005] PRIMARY KEY CLUSTERED 
(
	[NCP_MCI_NUM] ASC,
	[LIC_AGENCY_CD] ASC,
	[LIC_TYPE_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1018_SS_DEBT]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1018_SS_DEBT](
	[CASE_NUM] [varchar](6) NOT NULL,
	[SUB_TYP_CD] [char](6) NOT NULL,
	[SS_TYP_CD] [char](6) NOT NULL,
	[BAL_DUE] [decimal](10, 2) NULL,
	[CREDIT_TO_DT] [decimal](10, 2) NULL,
	[DEBIT_TO_DT] [decimal](10, 2) NULL,
 CONSTRAINT [PK_T1018] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[SUB_TYP_CD] ASC,
	[SS_TYP_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1038_FTIN_ELIG]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1038_FTIN_ELIG](
	[CASE_NUM] [varchar](6) NOT NULL,
	[BLIND_KEY] [char](16) NOT NULL,
	[MCI_NUM] [varchar](10) NOT NULL,
	[CASE_TYP_CD] [char](4) NULL,
	[AFDC_ARREARS_AMT] [decimal](9, 0) NULL,
	[NPA_ARREARS_AMT] [decimal](9, 0) NULL,
	[STAX_ARREARS_AMT] [decimal](9, 0) NULL,
	[TAX_INT_STS_CD] [char](4) NULL,
	[TAX_INT_STS_DT] [date] NULL,
	[PREV_INT_STS_CD] [char](4) NULL,
	[AFDC_ELIG_IND] [char](1) NULL,
	[NPA_ELIG_IND] [char](1) NULL,
	[STX_LOT_ELIG_IND] [char](1) NULL,
	[NOTICE_SENT_DT] [date] NULL,
	[CREATE_DT] [date] NULL,
	[ARCHIVE_DT] [date] NULL,
	[LAST_UPD_DT] [date] NULL,
	[LAST_WKR_ID] [char](4) NULL,
 CONSTRAINT [PK_T1038] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[BLIND_KEY] ASC,
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1043_PART]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1043_PART](
	[MCI_NUM] [varchar](10) NOT NULL,
	[DCIS1_CASE_NUM] [varchar](6) NULL,
	[DCIS1_SUFFIX_CD] [char](2) NULL,
	[NAM] [varchar](24) NOT NULL,
	[BIRTH_DT] [date] NULL,
	[SEX_CD] [char](1) NULL,
	[ETHNIC_CD] [char](2) NULL,
	[EFT_ACCT_NUM] [char](18) NULL,
	[PAT_ESTB_DT] [date] NULL,
	[MMCB_IND] [char](1) NULL,
	[AP_WAGE_SUPP_IND] [char](1) NULL,
	[PAT_ESTB_CD] [char](1) NULL,
	[DCIS2_CASE_NUM] [varchar](10) NULL,
	[DCIS2_CASE_STS_CD] [char](4) NULL,
	[DCIS2_PGM_CD] [char](3) NULL,
	[DCIS2_SUB_PGM_CD] [char](1) NULL,
	[DCIS2_AG_SEQ_NUM] [char](5) NULL,
	[PAT_EFF_DT] [date] NULL,
	[TFM_TRACK_CD] [char](1) NULL,
	[SOC_SEC_NUM] [varchar](9) NULL,
	[PART_ACCT_NUM] [varchar](6) NULL,
	[SSN_VER_CD] [char](4) NULL,
 CONSTRAINT [PK_T1043] PRIMARY KEY CLUSTERED 
(
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1044_CASE]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1044_CASE](
	[CASE_NUM] [varchar](6) NOT NULL,
	[STATUS_CD] [char](4) NULL,
	[STATUS_EFF_DT] [date] NULL,
	[CLOSING_CD] [char](4) NULL,
	[PROCESSING_CD] [char](4) NULL,
	[PROC_STS_EFF_DT] [date] NULL,
	[CONTACT_WORKER_ID] [char](4) NULL,
	[UNWORK_RSN_CD] [char](4) NULL,
	[UNWORK_RSN_EFF_DT] [date] NULL,
	[IVD_TYP_CD] [char](4) NULL,
	[IVD_TYP_EFF_DT] [date] NULL,
	[PREV_IVD_TYP_CD] [char](4) NULL,
	[PREV_IVD_TYP_EF_DT] [date] NULL,
	[COUNTY_CD] [char](3) NULL,
	[FAM_COURT_FILE] [char](11) NULL,
	[LAST_PMT_DT] [date] NULL,
	[CREDIT_BUR_CD] [char](4) NULL,
	[URESA_TYP_CD] [char](4) NULL,
	[RESP_WORKER_ID] [char](4) NULL,
	[PMT_TYP_CD] [char](4) NULL,
	[PAY_OVERRIDE_IND] [char](1) NULL,
	[NEXT_CHARGE_DT] [date] NULL,
	[CHARGE_FREQ_CD] [char](4) NULL,
	[AUDIT_DT] [date] NULL,
	[EMAN_STS_IND] [char](1) NULL,
	[MED_SUP_ONLY_IND] [char](1) NULL,
	[INIT_RESP_ST_CD] [char](1) NULL,
	[LAST_CHRG_DT] [date] NULL,
	[APPL_REQ_DT] [date] NULL,
	[APPL_PROVIDED_DT] [date] NULL,
	[APPL_RETURN_DT] [date] NULL,
	[LAST_DLQ_DT] [date] NULL,
	[INS_AVAIL_IND] [char](1) NULL,
	[FCR_RPT_IND] [char](1) NULL,
	[INTACT_FAM_IND] [char](1) NULL,
	[AFDC_GRANT_AMT] [decimal](10, 2) NULL,
	[GOOD_CAUSE_RSN_CD] [char](4) NULL,
	[UNWORK_OVERRIDE_CD] [char](4) NULL,
	[PFA_IND] [char](1) NULL,
	[WAGE_OVERRIDE_IND] [char](1) NULL,
	[TAX_EXCL_IND] [char](1) NULL,
	[WAGE_SUPPRESS_IND] [char](1) NULL,
	[BILLING_IND] [char](1) NULL,
	[LEGAL_FILE_ID] [char](5) NULL,
	[LAST_PMT_RCP_TYP] [char](4) NULL,
	[DRA_FEE_ELIG_IND] [char](1) NULL,
 CONSTRAINT [PK_T1044] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1045_AP_EXT]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1045_AP_EXT](
	[MCI_NUM] [varchar](10) NOT NULL,
	[EYE_COLOR] [char](5) NULL,
	[HAIR_COLOR] [char](5) NULL,
	[HEIGHT] [char](5) NULL,
	[WEIGHT] [varchar](22) NULL,
	[IDENT_MARKS] [char](18) NULL,
	[LICENSE_STATE] [char](2) NULL,
	[LICENSE_NUM] [char](12) NULL,
	[LAST_SEEN_DT] [date] NULL,
	[MILITARY] [char](9) NULL,
	[MILITARY_ST_DT] [date] NULL,
	[MILITARY_EN_DT] [date] NULL,
	[BIRTH_CITY] [char](16) NULL,
	[BIRTH_STATE] [char](2) NULL,
	[NOTE1] [varchar](78) NULL,
	[NOTE2] [varchar](78) NULL,
	[NOTE3] [varchar](78) NULL,
 CONSTRAINT [PK_T1045] PRIMARY KEY CLUSTERED 
(
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1048_SUB_ACCT]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1048_SUB_ACCT](
	[CASE_NUM] [varchar](6) NOT NULL,
	[SUB_TYP_CD] [char](6) NOT NULL,
	[BALANCE] [decimal](10, 2) NULL,
	[STATUS_CD] [char](4) NULL,
	[PAYEE_ACCT_NUM] [varchar](6) NULL,
	[URESA_CD] [decimal](9, 0) NULL,
	[DEBIT_TO_DT_AMT] [decimal](10, 2) NULL,
	[CREDIT_TO_DT_AMT] [decimal](10, 2) NULL,
	[FREQ_AMT] [decimal](10, 2) NULL,
	[PERIOD_AMT] [decimal](10, 2) NULL,
 CONSTRAINT [PK_T1048] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[SUB_TYP_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1049_COURT_ORDER]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1049_COURT_ORDER](
	[CASE_NUM] [varchar](6) NOT NULL,
	[BLIND_KEY] [decimal](2, 0) NOT NULL,
	[COURT_OFF_NAM] [char](24) NULL,
	[COURT_DT] [date] NULL,
	[CREATE_WORKER_ID] [char](4) NULL,
	[CHRG_FREQ_CD] [char](4) NULL,
	[MOD_TYP_CD] [char](4) NULL,
	[ORDER_START_DT] [date] NULL,
	[ORDER_END_DT] [date] NULL,
	[ORDER_METHOD_CD] [char](2) NULL,
	[ORIGINATING_ST_CD] [char](2) NULL,
	[INS_ORDERED_IND] [char](1) NULL,
	[INS_PROV_BY_CD] [char](4) NULL,
	[CREATE_DT] [date] NULL,
	[PFA_IND] [char](1) NULL,
	[NEW_ORD_ENTRY_IND] [char](1) NULL,
	[MELSON_DEV_IND] [char](1) NULL,
	[MAILED_DT] [date] NULL,
	[NOTE_TXT] [varchar](78) NULL,
 CONSTRAINT [PK_T1049] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[BLIND_KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1050_ORD_SUB_ACCT]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1050_ORD_SUB_ACCT](
	[CASE_NUM] [varchar](6) NOT NULL,
	[BLIND_KEY] [decimal](2, 0) NOT NULL,
	[SUB_TYP_CD] [char](6) NOT NULL,
	[FREQ_AMT] [decimal](10, 2) NULL,
	[ORDERED_ARR_AMT] [decimal](10, 2) NULL,
	[ARR_ADJ_AMT] [decimal](10, 2) NULL,
 CONSTRAINT [PK_T1050] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[BLIND_KEY] ASC,
	[SUB_TYP_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1051_PART_ADDRESS]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1051_PART_ADDRESS](
	[MCI_NUM] [varchar](10) NOT NULL,
	[BLIND_KEY] [char](16) NOT NULL,
	[STREET_1_ADR] [char](31) NULL,
	[EFFECTIVE_DT] [date] NULL,
	[HSE_PHONE_NUM] [varchar](10) NULL,
	[ADD_TYP_CD] [char](4) NULL,
	[ADD_VER_CD] [char](4) NULL,
	[APARTMENT_ADR] [char](5) NULL,
	[STREET_2_ADR] [char](31) NULL,
	[CITY_ADR] [char](16) NULL,
	[STATE_ADR] [char](2) NULL,
	[ZIP_ADR] [char](5) NULL,
	[ZIP_SFX_ADR] [char](4) NULL,
	[CORR_FIPS_CD] [varchar](9) NULL,
	[UPDATE_WORKER_ID] [char](4) NULL,
	[PAYMENT_FIPS_CD] [varchar](9) NULL,
	[LAST_KNOWN_CA_IND] [char](1) NULL,
	[UPDATE_DT] [date] NULL,
	[NOTE_TXT] [varchar](78) NULL,
 CONSTRAINT [PK_T1051] PRIMARY KEY CLUSTERED 
(
	[MCI_NUM] ASC,
	[BLIND_KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1052_ORD_CHLD_INC]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1052_ORD_CHLD_INC](
	[CASE_NUM] [varchar](6) NOT NULL,
	[BLIND_KEY] [decimal](2, 0) NOT NULL,
	[MCI_NUM] [varchar](10) NOT NULL,
 CONSTRAINT [PK_T1052] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[BLIND_KEY] ASC,
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1074_EVENT]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1074_EVENT](
	[CASE_NUM] [varchar](6) NOT NULL,
	[BLIND_KEY] [char](16) NOT NULL,
	[CREATE_DT] [date] NULL,
	[CREATE_TM] [varchar](8) NULL,
	[TYP_CD] [char](4) NULL,
	[DISPOSITION_CD] [char](4) NULL,
	[DISP_WORKER_ID] [char](4) NULL,
	[COUNTY_CD] [char](3) NULL,
	[CREATE_WORKER_ID] [char](4) NULL,
	[INIT_EVNT_TYP_CD] [char](4) NULL,
	[DESC_TXT] [varchar](45) NULL,
	[UPDATE_WORKER_ID] [char](4) NULL,
	[UPDATE_DT] [date] NULL,
	[DISP_DT] [date] NULL,
	[RESP_WORKER_ID] [char](4) NULL,
 CONSTRAINT [PK_T1074] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[BLIND_KEY] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1082_CASE_PART]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1082_CASE_PART](
	[CASE_NUM] [varchar](6) NOT NULL,
	[MCI_NUM] [varchar](10) NOT NULL,
	[TYP_CD] [char](4) NULL,
	[STATUS_CD] [char](1) NULL,
	[RELATION_CD] [char](4) NULL,
	[FCR_RPTD_CD] [char](1) NULL,
	[MMAP_IND] [char](1) NULL,
 CONSTRAINT [PK_T1082] PRIMARY KEY CLUSTERED 
(
	[CASE_NUM] ASC,
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[T1096_PATERNITY]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[T1096_PATERNITY](
	[CHILD_MCI_NUM] [varchar](10) NOT NULL,
	[CHILD_BIM] [char](1) NULL,
	[PAT_ESTB] [char](1) NULL,
	[PAT_ESTB_BY] [char](4) NULL,
	[PAT_ESTB_DT] [date] NULL,
	[PAT_ESTB_LOC] [char](2) NULL,
	[ADOPT_DT] [date] NULL,
	[BIRTH_ST] [char](2) NULL,
	[CONCV_ST] [char](2) NULL,
	[PAT_EFF_DT] [date] NULL,
	[ADOPT_LOC] [char](2) NULL,
	[ADOPT_IND] [char](1) NULL,
	[UPDT_WKR_ID] [char](4) NULL,
	[UPDT_DT] [date] NULL,
 CONSTRAINT [PK_T1096] PRIMARY KEY CLUSTERED 
(
	[CHILD_MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VCASE]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VCASE](
	[Case_IDNO] [decimal](6, 0) NOT NULL,
	[StatusCase_CODE] [char](1) NULL,
	[TypeCase_CODE] [char](1) NULL,
	[RsnStatusCase_CODE] [char](2) NULL,
	[RespondInit_CODE] [char](1) NULL,
	[SourceRfrl_CODE] [char](3) NULL,
	[Opened_DATE] [date] NULL,
	[Marriage_DATE] [date] NULL,
	[Divorced_DATE] [date] NULL,
	[StatusCurrent_DATE] [date] NULL,
	[AprvIvd_DATE] [date] NULL,
	[County_IDNO] [decimal](3, 0) NULL,
	[Office_IDNO] [decimal](3, 0) NULL,
	[AssignedFips_CODE] [char](7) NULL,
	[GoodCause_CODE] [char](1) NULL,
	[GoodCause_DATE] [date] NULL,
	[Restricted_INDC] [char](1) NULL,
	[Intercept_CODE] [char](1) NULL,
	[MedicalOnly_INDC] [char](1) NULL,
	[Jurisdiction_INDC] [char](1) NULL,
	[IvdApplicant_CODE] [char](3) NULL,
	[Application_IDNO] [decimal](15, 0) NULL,
	[AppSent_DATE] [date] NULL,
	[AppReq_DATE] [date] NULL,
	[AppRetd_DATE] [date] NULL,
	[CpRelationshipToNcp_CODE] [char](3) NULL,
	[Worker_ID] [char](30) NULL,
	[AppSigned_DATE] [date] NULL,
	[ClientLitigantRole_CODE] [char](2) NULL,
	[DescriptionComments_TEXT] [char](200) NULL,
	[NonCoop_CODE] [char](1) NULL,
	[NonCoop_DATE] [date] NULL,
	[BeginValidity_DATE] [date] NULL,
	[WorkerUpdate_ID] [char](30) NULL,
	[TransactionEventSeq_NUMB] [decimal](19, 0) NULL,
	[Update_DTTM] [datetime2](7) NULL,
	[Referral_DATE] [date] NULL,
	[CaseCategory_CODE] [char](2) NULL,
	[File_ID] [char](10) NULL,
	[ApplicationFee_CODE] [char](1) NULL,
	[FeePaid_DATE] [date] NULL,
	[ServiceRequested_CODE] [char](1) NULL,
	[FeeCheckNo_TEXT] [char](20) NULL,
	[ReasonFeeWaived_CODE] [char](2) NULL,
	[StatusEnforce_CODE] [char](4) NULL,
 CONSTRAINT [PK_VCASE] PRIMARY KEY CLUSTERED 
(
	[Case_IDNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VCMEM]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VCMEM](
	[Case_IDNO] [decimal](6, 0) NOT NULL,
	[MemberMci_IDNO] [decimal](10, 0) NOT NULL,
	[CaseRelationship_CODE] [char](1) NULL,
	[CaseMemberStatus_CODE] [char](1) NULL,
	[CpRelationshipToChild_CODE] [char](3) NULL,
	[NcpRelationshipToChild_CODE] [char](3) NULL,
	[BenchWarrant_INDC] [char](1) NULL,
	[Applicant_CODE] [char](1) NULL,
	[BeginValidity_DATE] [date] NULL,
	[WorkerUpdate_ID] [char](30) NULL,
	[TransactionEventSeq_NUMB] [decimal](19, 0) NULL,
	[Update_DTTM] [datetime2](7) NULL,
	[FAMILYVIOLENCE_INDC] [char](1) NULL,
	[FAMILYVIOLENCE_DATE] [date] NULL,
	[TYPEFAMILYVIOLENCE_CODE] [char](2) NULL,
	[REASONMEMBERSTATUS_CODE] [char](2) NULL,
 CONSTRAINT [PK_VCMEM] PRIMARY KEY CLUSTERED 
(
	[Case_IDNO] ASC,
	[MemberMci_IDNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VDEMO]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VDEMO](
	[MemberMci_IDNO] [decimal](10, 0) NOT NULL,
	[INDIVIDUAL_IDNO] [decimal](8, 0) NULL,
	[Last_NAME] [char](20) NULL,
	[First_NAME] [char](16) NULL,
	[Middle_NAME] [char](20) NULL,
	[Suffix_NAME] [char](4) NULL,
	[Title_NAME] [char](8) NULL,
	[FullDisplay_NAME] [char](60) NULL,
	[MemberSex_CODE] [char](1) NULL,
	[MemberSsn_NUMB] [decimal](9, 0) NULL,
	[Birth_DATE] [date] NULL,
	[Emancipation_DATE] [date] NULL,
	[LastMarriage_DATE] [date] NULL,
	[LastDivorce_DATE] [date] NULL,
	[BirthCity_NAME] [char](28) NULL,
	[BirthState_CODE] [char](2) NULL,
	[BirthCountry_CODE] [char](2) NULL,
	[DescriptionHeight_TEXT] [char](3) NULL,
	[DescriptionWeightLbs_TEXT] [char](3) NULL,
	[Race_CODE] [char](1) NULL,
	[ColorHair_CODE] [char](3) NULL,
	[ColorEyes_CODE] [char](3) NULL,
	[FACIALHAIR_INDC] [char](1) NULL,
	[Language_CODE] [char](3) NULL,
	[TypeProblem_CODE] [char](3) NULL,
	[Deceased_DATE] [date] NULL,
	[CerDeathNo_TEXT] [char](9) NULL,
	[LicenseDriverNo_TEXT] [char](25) NULL,
	[AlienRegistn_ID] [char](10) NULL,
	[WorkPermitNo_TEXT] [char](10) NULL,
	[BeginPermit_DATE] [date] NULL,
	[EndPermit_DATE] [date] NULL,
	[HomePhone_NUMB] [decimal](15, 0) NULL,
	[WorkPhone_NUMB] [decimal](15, 0) NULL,
	[CellPhone_NUMB] [decimal](15, 0) NULL,
	[Fax_NUMB] [decimal](15, 0) NULL,
	[CONTACT_EML] [char](100) NULL,
	[Spouse_NAME] [char](40) NULL,
	[Graduation_DATE] [date] NULL,
	[EducationLevel_CODE] [char](2) NULL,
	[Restricted_INDC] [char](1) NULL,
	[Military_ID] [char](10) NULL,
	[MilitaryBranch_CODE] [char](2) NULL,
	[MilitaryStatus_CODE] [char](2) NULL,
	[MilitaryBenefitStatus_CODE] [char](2) NULL,
	[SecondFamily_INDC] [char](1) NULL,
	[MeansTestedInc_INDC] [char](1) NULL,
	[SsIncome_INDC] [char](1) NULL,
	[VeteranComps_INDC] [char](1) NULL,
	[Assistance_CODE] [char](3) NULL,
	[DescriptionIdentifyingMarks_TEXT] [char](40) NULL,
	[Divorce_INDC] [char](1) NULL,
	[BeginValidity_DATE] [date] NULL,
	[WorkerUpdate_ID] [char](30) NULL,
	[TransactionEventSeq_NUMB] [decimal](19, 0) NULL,
	[Update_DTTM] [datetime2](7) NULL,
	[Disable_INDC] [char](1) NULL,
	[TypeOccupation_CODE] [char](3) NULL,
	[COUNTYBIRTH_IDNO] [decimal](3, 0) NULL,
	[MotherMaiden_NAME] [char](30) NULL,
	[FileLastDivorce_ID] [char](15) NULL,
	[CityDivorce_NAME] [char](28) NULL,
	[CityMarriage_NAME] [char](28) NULL,
	[FormerMci_IDNO] [decimal](10, 0) NULL,
	[IveParty_IDNO] [decimal](10, 0) NULL,
	[StateDivorce_CODE] [char](2) NULL,
	[StateMarriage_CODE] [char](2) NULL,
	[TribalAffiliations_CODE] [char](3) NULL,
 CONSTRAINT [PK_VDEMO] PRIMARY KEY CLUSTERED 
(
	[MemberMci_IDNO] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VLSUP]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VLSUP](
	[Case_IDNO] [decimal](6, 0) NOT NULL,
	[OrderSeq_NUMB] [decimal](2, 0) NOT NULL,
	[ObligationSeq_NUMB] [decimal](2, 0) NOT NULL,
	[SupportYearMonth_NUMB] [decimal](6, 0) NULL,
	[TypeWelfare_CODE] [char](1) NULL,
	[TransactionCurSup_AMNT] [decimal](11, 2) NULL,
	[OweTotCurSup_AMNT] [decimal](11, 2) NULL,
	[AppTotCurSup_AMNT] [decimal](11, 2) NULL,
	[MtdCurSupOwed_AMNT] [decimal](11, 2) NULL,
	[TransactionExptPay_AMNT] [decimal](11, 2) NULL,
	[OweTotExptPay_AMNT] [decimal](11, 2) NULL,
	[AppTotExptPay_AMNT] [decimal](11, 2) NULL,
	[TransactionNaa_AMNT] [decimal](11, 2) NULL,
	[OweTotNaa_AMNT] [decimal](11, 2) NULL,
	[AppTotNaa_AMNT] [decimal](11, 2) NULL,
	[TransactionPaa_AMNT] [decimal](11, 2) NULL,
	[OweTotPaa_AMNT] [decimal](11, 2) NULL,
	[AppTotPaa_AMNT] [decimal](11, 2) NULL,
	[TransactionTaa_AMNT] [decimal](11, 2) NULL,
	[OweTotTaa_AMNT] [decimal](11, 2) NULL,
	[AppTotTaa_AMNT] [decimal](11, 2) NULL,
	[TransactionCaa_AMNT] [decimal](11, 2) NULL,
	[OweTotCaa_AMNT] [decimal](11, 2) NULL,
	[AppTotCaa_AMNT] [decimal](11, 2) NULL,
	[TransactionUpa_AMNT] [decimal](11, 2) NULL,
	[OweTotUpa_AMNT] [decimal](11, 2) NULL,
	[AppTotUpa_AMNT] [decimal](11, 2) NULL,
	[TransactionUda_AMNT] [decimal](11, 2) NULL,
	[OweTotUda_AMNT] [decimal](11, 2) NULL,
	[AppTotUda_AMNT] [decimal](11, 2) NULL,
	[TransactionIvef_AMNT] [decimal](11, 2) NULL,
	[OweTotIvef_AMNT] [decimal](11, 2) NULL,
	[AppTotIvef_AMNT] [decimal](11, 2) NULL,
	[TransactionMedi_AMNT] [decimal](11, 2) NULL,
	[OweTotMedi_AMNT] [decimal](11, 2) NULL,
	[AppTotMedi_AMNT] [decimal](11, 2) NULL,
	[TransactionNffc_AMNT] [decimal](11, 2) NULL,
	[OweTotNffc_AMNT] [decimal](11, 2) NULL,
	[AppTotNffc_AMNT] [decimal](11, 2) NULL,
	[TransactionNonIvd_AMNT] [decimal](11, 2) NULL,
	[OweTotNonIvd_AMNT] [decimal](11, 2) NULL,
	[AppTotNonIvd_AMNT] [decimal](11, 2) NULL,
	[Batch_DATE] [date] NULL,
	[SourceBatch_CODE] [char](3) NULL,
	[Batch_NUMB] [decimal](4, 0) NULL,
	[SeqReceipt_NUMB] [decimal](6, 0) NULL,
	[Receipt_DATE] [date] NULL,
	[Distribute_DATE] [date] NULL,
	[EventFunctionalSeq_NUMB] [decimal](4, 0) NULL,
	[EventGlobalSeq_NUMB] [decimal](19, 0) NULL,
	[TransactionFuture_AMNT] [decimal](11, 2) NULL,
	[AppTotFuture_AMNT] [decimal](11, 2) NULL,
	[CHECKRECIPIENT_ID] [char](10) NULL,
	[CheckRecipient_CODE] [char](1) NULL,
	[TYPERECORD_CODE] [char](1) NULL,
 CONSTRAINT [PK_VLSUP] PRIMARY KEY CLUSTERED 
(
	[Case_IDNO] ASC,
	[OrderSeq_NUMB] ASC,
	[ObligationSeq_NUMB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VOBLE]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VOBLE](
	[Case_IDNO] [decimal](6, 0) NOT NULL,
	[OrderSeq_NUMB] [decimal](2, 0) NOT NULL,
	[ObligationSeq_NUMB] [decimal](2, 0) NOT NULL,
	[MemberMci_IDNO] [decimal](10, 0) NULL,
	[TypeDebt_CODE] [char](2) NULL,
	[Fips_CODE] [char](7) NULL,
	[FreqPeriodic_CODE] [char](1) NULL,
	[Periodic_AMNT] [decimal](11, 2) NULL,
	[ExpectToPay_AMNT] [decimal](11, 2) NULL,
	[ExpectToPay_CODE] [char](1) NULL,
	[BeginObligation_DATE] [date] NULL,
	[EndObligation_DATE] [date] NULL,
	[AccrualLast_DATE] [date] NULL,
	[AccrualNext_DATE] [date] NULL,
	[CHECKRECIPIENT_ID] [char](10) NULL,
	[CheckRecipient_CODE] [char](1) NULL,
	[EventGlobalBeginSeq_NUMB] [decimal](19, 0) NULL,
	[EventGlobalEndSeq_NUMB] [decimal](19, 0) NULL,
	[BeginValidity_DATE] [date] NULL,
	[EndValidity_DATE] [date] NULL,
	[REASONCHANGE_CODE] [char](2) NULL,
 CONSTRAINT [PK_VOBLE] PRIMARY KEY CLUSTERED 
(
	[Case_IDNO] ASC,
	[OrderSeq_NUMB] ASC,
	[ObligationSeq_NUMB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VSORD]    Script Date: 3/20/2026 9:30:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VSORD](
	[Case_IDNO] [decimal](6, 0) NOT NULL,
	[OrderSeq_NUMB] [decimal](2, 0) NOT NULL,
	[Order_IDNO] [decimal](15, 0) NULL,
	[File_ID] [char](10) NULL,
	[OrderEnt_DATE] [date] NULL,
	[OrderIssued_DATE] [date] NULL,
	[OrderEffective_DATE] [date] NULL,
	[OrderEnd_DATE] [date] NULL,
	[ReasonStatus_CODE] [char](2) NULL,
	[StatusOrder_CODE] [char](1) NULL,
	[StatusOrder_DATE] [date] NULL,
	[InsOrdered_CODE] [char](1) NULL,
	[MedicalOnly_INDC] [char](1) NULL,
	[Iiwo_CODE] [char](2) NULL,
	[NoIwReason_CODE] [char](2) NULL,
	[IwoInitiatedBy_CODE] [char](1) NULL,
	[GuidelinesFollowed_INDC] [char](1) NULL,
	[DeviationReason_CODE] [char](2) NULL,
	[DescriptionDeviationOthers_TEXT] [char](30) NULL,
	[OrderOutOfState_ID] [char](15) NULL,
	[CejStatus_CODE] [char](1) NULL,
	[CejFips_CODE] [char](7) NULL,
	[IssuingOrderFips_CODE] [char](7) NULL,
	[Qdro_INDC] [char](1) NULL,
	[UnreimMedical_INDC] [char](1) NULL,
	[CpMedical_PCT] [decimal](5, 2) NULL,
	[NcpMedical_PCT] [decimal](5, 2) NULL,
	[ParentingTime_PCT] [decimal](5, 2) NULL,
	[NoParentingDays_QNTY] [decimal](3, 0) NULL,
	[PetitionerAppeared_INDC] [char](1) NULL,
	[RespondentAppeared_INDC] [char](1) NULL,
	[OthersAppeared_INDC] [char](1) NULL,
	[PetitionerReceived_INDC] [char](1) NULL,
	[RespondentReceived_INDC] [char](1) NULL,
	[OthersReceived_INDC] [char](1) NULL,
	[PetitionerMailed_INDC] [char](1) NULL,
	[RespondentMailed_INDC] [char](1) NULL,
	[OthersMailed_INDC] [char](1) NULL,
	[PetitionerMailed_DATE] [date] NULL,
	[RespondentMailed_DATE] [date] NULL,
	[OthersMailed_DATE] [date] NULL,
	[CoverageMedical_CODE] [char](1) NULL,
	[CoverageDrug_CODE] [char](1) NULL,
	[CoverageMental_CODE] [char](1) NULL,
	[CoverageDental_CODE] [char](1) NULL,
	[CoverageVision_CODE] [char](1) NULL,
	[CoverageOthers_CODE] [char](1) NULL,
	[DescriptionCoverageOthers_TEXT] [char](30) NULL,
	[WorkerUpdate_ID] [char](30) NULL,
	[BeginValidity_DATE] [date] NULL,
	[EndValidity_DATE] [date] NULL,
	[EventGlobalBeginSeq_NUMB] [decimal](19, 0) NULL,
	[EventGlobalEndSeq_NUMB] [decimal](19, 0) NULL,
	[DescriptionParentingNotes_TEXT] [varchar](4000) NULL,
	[LastIrscReferred_DATE] [date] NULL,
	[LastIrscUpdated_DATE] [date] NULL,
	[LastIrscReferred_AMNT] [decimal](11, 2) NULL,
	[StatusControl_CODE] [char](1) NULL,
	[StateControl_CODE] [char](2) NULL,
	[OrderControl_ID] [char](15) NULL,
	[PetitionerAttorneyAppeared_INDC] [char](1) NULL,
	[RespondentAttorneyAppeared_INDC] [char](1) NULL,
	[PetitionerAttorneyReceived_INDC] [char](1) NULL,
	[RespondentAttorneyReceived_INDC] [char](1) NULL,
	[PetitionerAttorneyMailed_INDC] [char](1) NULL,
	[RespondentAttorneyMailed_INDC] [char](1) NULL,
	[PetitionerAttorneyMailed_DATE] [date] NULL,
	[RespondentAttorneyMailed_DATE] [date] NULL,
	[TypeOrder_CODE] [char](1) NULL,
	[ReviewRequested_DATE] [date] NULL,
	[NextReview_DATE] [date] NULL,
	[LastReview_DATE] [date] NULL,
	[LastNoticeSent_DATE] [date] NULL,
	[DirectPay_INDC] [char](1) NULL,
	[SourceOrdered_CODE] [char](1) NULL,
 CONSTRAINT [PK_VSORD] PRIMARY KEY CLUSTERED 
(
	[Case_IDNO] ASC,
	[OrderSeq_NUMB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_compare_fields_view]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_compare_fields_view] ON [dbo].[t_compare_fields]
(
	[view_name] ASC,
	[target_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_compare_report_key]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_compare_report_key] ON [dbo].[t_compare_report]
(
	[view_name] ASC,
	[key_value] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_compare_report_view]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_compare_report_view] ON [dbo].[t_compare_report]
(
	[view_name] ASC,
	[target_column] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_t_reference_lookup]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_t_reference_lookup] ON [dbo].[t_reference]
(
	[view_nam] ASC,
	[field_nam] ASC,
	[old_code] ASC
)
INCLUDE([new_code]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1038_MCI]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1038_MCI] ON [dbo].[T1038_FTIN_ELIG]
(
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1043_SSN]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1043_SSN] ON [dbo].[T1043_PART]
(
	[SOC_SEC_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1044_IVD]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1044_IVD] ON [dbo].[T1044_CASE]
(
	[IVD_TYP_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1044_STS]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1044_STS] ON [dbo].[T1044_CASE]
(
	[STATUS_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1051_TYP]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1051_TYP] ON [dbo].[T1051_PART_ADDRESS]
(
	[ADD_TYP_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1082_MCI]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1082_MCI] ON [dbo].[T1082_CASE_PART]
(
	[MCI_NUM] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_T1082_TYP]    Script Date: 3/20/2026 9:30:08 AM ******/
CREATE NONCLUSTERED INDEX [IX_T1082_TYP] ON [dbo].[T1082_CASE_PART]
(
	[TYP_CD] ASC,
	[RELATION_CD] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[T1005_LS_LIC_MATCH]  WITH CHECK ADD  CONSTRAINT [FK_T1005_T1043] FOREIGN KEY([NCP_MCI_NUM])
REFERENCES [dbo].[T1043_PART] ([MCI_NUM])
GO
ALTER TABLE [dbo].[T1005_LS_LIC_MATCH] CHECK CONSTRAINT [FK_T1005_T1043]
GO
ALTER TABLE [dbo].[T1018_SS_DEBT]  WITH CHECK ADD  CONSTRAINT [FK_T1018_T1044] FOREIGN KEY([CASE_NUM])
REFERENCES [dbo].[T1044_CASE] ([CASE_NUM])
GO
ALTER TABLE [dbo].[T1018_SS_DEBT] CHECK CONSTRAINT [FK_T1018_T1044]
GO
ALTER TABLE [dbo].[T1038_FTIN_ELIG]  WITH CHECK ADD  CONSTRAINT [FK_T1038_T1044] FOREIGN KEY([CASE_NUM])
REFERENCES [dbo].[T1044_CASE] ([CASE_NUM])
GO
ALTER TABLE [dbo].[T1038_FTIN_ELIG] CHECK CONSTRAINT [FK_T1038_T1044]
GO
ALTER TABLE [dbo].[T1045_AP_EXT]  WITH CHECK ADD  CONSTRAINT [FK_T1045_T1043] FOREIGN KEY([MCI_NUM])
REFERENCES [dbo].[T1043_PART] ([MCI_NUM])
GO
ALTER TABLE [dbo].[T1045_AP_EXT] CHECK CONSTRAINT [FK_T1045_T1043]
GO
ALTER TABLE [dbo].[T1048_SUB_ACCT]  WITH CHECK ADD  CONSTRAINT [FK_T1048_T1044] FOREIGN KEY([CASE_NUM])
REFERENCES [dbo].[T1044_CASE] ([CASE_NUM])
GO
ALTER TABLE [dbo].[T1048_SUB_ACCT] CHECK CONSTRAINT [FK_T1048_T1044]
GO
ALTER TABLE [dbo].[T1049_COURT_ORDER]  WITH CHECK ADD  CONSTRAINT [FK_T1049_T1044] FOREIGN KEY([CASE_NUM])
REFERENCES [dbo].[T1044_CASE] ([CASE_NUM])
GO
ALTER TABLE [dbo].[T1049_COURT_ORDER] CHECK CONSTRAINT [FK_T1049_T1044]
GO
ALTER TABLE [dbo].[T1050_ORD_SUB_ACCT]  WITH CHECK ADD  CONSTRAINT [FK_T1050_T1049] FOREIGN KEY([CASE_NUM], [BLIND_KEY])
REFERENCES [dbo].[T1049_COURT_ORDER] ([CASE_NUM], [BLIND_KEY])
GO
ALTER TABLE [dbo].[T1050_ORD_SUB_ACCT] CHECK CONSTRAINT [FK_T1050_T1049]
GO
ALTER TABLE [dbo].[T1051_PART_ADDRESS]  WITH CHECK ADD  CONSTRAINT [FK_T1051_T1043] FOREIGN KEY([MCI_NUM])
REFERENCES [dbo].[T1043_PART] ([MCI_NUM])
GO
ALTER TABLE [dbo].[T1051_PART_ADDRESS] CHECK CONSTRAINT [FK_T1051_T1043]
GO
ALTER TABLE [dbo].[T1052_ORD_CHLD_INC]  WITH CHECK ADD  CONSTRAINT [FK_T1052_T1049] FOREIGN KEY([CASE_NUM], [BLIND_KEY])
REFERENCES [dbo].[T1049_COURT_ORDER] ([CASE_NUM], [BLIND_KEY])
GO
ALTER TABLE [dbo].[T1052_ORD_CHLD_INC] CHECK CONSTRAINT [FK_T1052_T1049]
GO
ALTER TABLE [dbo].[T1074_EVENT]  WITH CHECK ADD  CONSTRAINT [FK_T1074_T1044] FOREIGN KEY([CASE_NUM])
REFERENCES [dbo].[T1044_CASE] ([CASE_NUM])
GO
ALTER TABLE [dbo].[T1074_EVENT] CHECK CONSTRAINT [FK_T1074_T1044]
GO
ALTER TABLE [dbo].[T1082_CASE_PART]  WITH CHECK ADD  CONSTRAINT [FK_T1082_T1043] FOREIGN KEY([MCI_NUM])
REFERENCES [dbo].[T1043_PART] ([MCI_NUM])
GO
ALTER TABLE [dbo].[T1082_CASE_PART] CHECK CONSTRAINT [FK_T1082_T1043]
GO
ALTER TABLE [dbo].[T1082_CASE_PART]  WITH CHECK ADD  CONSTRAINT [FK_T1082_T1044] FOREIGN KEY([CASE_NUM])
REFERENCES [dbo].[T1044_CASE] ([CASE_NUM])
GO
ALTER TABLE [dbo].[T1082_CASE_PART] CHECK CONSTRAINT [FK_T1082_T1044]
GO
ALTER TABLE [dbo].[T1096_PATERNITY]  WITH CHECK ADD  CONSTRAINT [FK_T1096_T1043] FOREIGN KEY([CHILD_MCI_NUM])
REFERENCES [dbo].[T1043_PART] ([MCI_NUM])
GO
ALTER TABLE [dbo].[T1096_PATERNITY] CHECK CONSTRAINT [FK_T1096_T1043]
GO
USE [master]
GO
ALTER DATABASE [DACSES_POC_Source] SET  READ_WRITE 
GO
