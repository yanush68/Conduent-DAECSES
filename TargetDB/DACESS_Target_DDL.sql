USE [DACSES_POC_Target]
GO
/****** Object:  Table [dbo].[VCASE]    Script Date: 3/20/2026 9:47:39 AM ******/
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
/****** Object:  Table [dbo].[VCMEM]    Script Date: 3/20/2026 9:47:39 AM ******/
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
/****** Object:  Table [dbo].[VDEMO]    Script Date: 3/20/2026 9:47:39 AM ******/
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
/****** Object:  Table [dbo].[VLSUP]    Script Date: 3/20/2026 9:47:39 AM ******/
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
/****** Object:  Table [dbo].[VOBLE]    Script Date: 3/20/2026 9:47:39 AM ******/
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
/****** Object:  Table [dbo].[VSORD]    Script Date: 3/20/2026 9:47:39 AM ******/
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
ALTER TABLE [dbo].[VCMEM]  WITH CHECK ADD  CONSTRAINT [FK_VCMEM_VCASE] FOREIGN KEY([Case_IDNO])
REFERENCES [dbo].[VCASE] ([Case_IDNO])
GO
ALTER TABLE [dbo].[VCMEM] CHECK CONSTRAINT [FK_VCMEM_VCASE]
GO
ALTER TABLE [dbo].[VCMEM]  WITH CHECK ADD  CONSTRAINT [FK_VCMEM_VDEMO] FOREIGN KEY([MemberMci_IDNO])
REFERENCES [dbo].[VDEMO] ([MemberMci_IDNO])
GO
ALTER TABLE [dbo].[VCMEM] CHECK CONSTRAINT [FK_VCMEM_VDEMO]
GO
ALTER TABLE [dbo].[VLSUP]  WITH CHECK ADD  CONSTRAINT [FK_VLSUP_VOBLE] FOREIGN KEY([Case_IDNO], [OrderSeq_NUMB], [ObligationSeq_NUMB])
REFERENCES [dbo].[VOBLE] ([Case_IDNO], [OrderSeq_NUMB], [ObligationSeq_NUMB])
GO
ALTER TABLE [dbo].[VLSUP] CHECK CONSTRAINT [FK_VLSUP_VOBLE]
GO
ALTER TABLE [dbo].[VOBLE]  WITH CHECK ADD  CONSTRAINT [FK_VOBLE_VSORD] FOREIGN KEY([Case_IDNO], [OrderSeq_NUMB])
REFERENCES [dbo].[VSORD] ([Case_IDNO], [OrderSeq_NUMB])
GO
ALTER TABLE [dbo].[VOBLE] CHECK CONSTRAINT [FK_VOBLE_VSORD]
GO
ALTER TABLE [dbo].[VSORD]  WITH CHECK ADD  CONSTRAINT [FK_VSORD_VCASE] FOREIGN KEY([Case_IDNO])
REFERENCES [dbo].[VCASE] ([Case_IDNO])
GO
ALTER TABLE [dbo].[VSORD] CHECK CONSTRAINT [FK_VSORD_VCASE]
GO
