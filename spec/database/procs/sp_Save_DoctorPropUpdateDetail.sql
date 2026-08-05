CREATE PROCEDURE [dbo].[sp_Save_DoctorPropUpdateDetail]

	
    @CustPropUpdateDetailId INT NULL,
	    @CustPropMasterId INT NULL,
	    @CustCode NVARCHAR(MAX) NULL,
		@ProviderType NVARCHAR(MAX) NULL,
		@CustTypeCode NVARCHAR(MAX) NULL,
		@MarketCode NVARCHAR(MAX) NULL,
		@PharmaPlatformCode NVARCHAR(MAX) NULL



AS
BEGIN

--DELETE FROM dbo.tblApprovalMapDetail WHERE ApprovalMapMasterId=@ApprovalMapMasterId AND ToRoleId=@ToRoleId
DECLARE @CustId INT
DECLARE @ProvId INT
DECLARE @TypeId INT
DECLARE @MarketId INT

DECLARE @SMCTypeId INT


SELECT @CustId=DoctorId FROM dbo.tblDoctorMaster WHERE DoctorCode=@CustCode
SELECT @ProvId=ProgramTypeId FROM dbo.tblProgramType WHERE PrgmTypeCode=@ProviderType
SELECT @TypeId=DoctorTypeId FROM dbo.tblDoctorType WHERE DoctorTypeCode=@CustTypeCode
SELECT @MarketId=MarketId FROM dbo.tblMarket WHERE MarketCode=@MarketCode


SELECT @SMCTypeId=SMCTypeId FROM dbo.tblSMCType WHERE SMCTypeCode=@PharmaPlatformCode


	INSERT INTO dbo.tblDoctorPropUpdateDetail
	(
	    CustPropMasterId,
	    CustCode,
	    CustomerId,
	    ProviderType,
	    ProviderTypeId,
	    CustTypeCode,
	    CustTypeId,
	    MarketCode,
	    MarketId, PharmaPlatformCode, PharmaPlatformId
	)
	VALUES
	(   @CustPropMasterId,   -- CustPropMasterId - int
	    @CustCode, -- CustCode - nvarchar(50)
	    @CustId,   -- CustomerId - int
	    @ProviderType, -- ProviderType - nvarchar(50)
	    @ProvId,   -- ProviderTypeId - int
	    @CustTypeCode, -- CustTypeCode - nvarchar(50)
	    @TypeId,   -- CustTypeId - int
	    @MarketCode, -- MarketCode - nvarchar(50)
	    @MarketId    -- MarketId - int
		, @PharmaPlatformCode, @SMCTypeId
	    )

	SELECT SCOPE_IDENTITY()

END
