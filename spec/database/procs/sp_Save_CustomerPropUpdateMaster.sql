CREATE PROCEDURE [dbo].[sp_Save_CustomerPropUpdateMaster]

	
    @CustPropMasterId INT NULL,
	    @TypeId INT NULL,
	    @EntryBy NVARCHAR(MAX) NULL,
		 
		@ConvertType NVARCHAR(MAX) NULL



AS
BEGIN

--DELETE FROM dbo.tblApprovalMapDetail WHERE ApprovalMapMasterId=@ApprovalMapMasterId AND ToRoleId=@ToRoleId


	INSERT INTO dbo.tblCustomerPropUpdateMaster
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
	    GETDATE(), -- EntryDate - datetime
	    @ConvertType,       -- ConvertType - nvarchar(50)
	    '0'       -- IsTransfer - bit
	    )

	SELECT SCOPE_IDENTITY()

END

