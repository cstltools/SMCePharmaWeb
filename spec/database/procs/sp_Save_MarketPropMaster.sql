CREATE PROCEDURE [dbo].[sp_Save_MarketPropMaster]

	
    @MarketPropMasterId INT NULL,
	    @TypeId INT NULL,
	    @EntryBy NVARCHAR(MAX) NULL,
		@EntryDate DATETIME NULL,
		@ConvertType NVARCHAR(MAX) NULL



AS
BEGIN

--DELETE FROM dbo.tblApprovalMapDetail WHERE ApprovalMapMasterId=@ApprovalMapMasterId AND ToRoleId=@ToRoleId


	INSERT INTO dbo.tblMarketPropMaster
	(
	    TypeId,
	    EntryBy,
	    EntryDate,
	    ConvertType,
	    IsTransfer
	)
	VALUES
	(   @TypeId,         -- TypeId - int
	    @EntryBy,       -- EntryBy - nvarchar(50)
	    @EntryDate, -- EntryDate - datetime
	    @ConvertType,       -- ConvertType - nvarchar(50)
	    '0'       -- IsTransfer - bit
	    )

	SELECT SCOPE_IDENTITY()

END

