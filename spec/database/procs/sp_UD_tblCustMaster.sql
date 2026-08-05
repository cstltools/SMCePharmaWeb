-- =============================================
-- Author:		Liton
-- Create date: 02-Sep-2016
-- Description:	Update
-- =============================================
Create PROCEDURE [dbo].[sp_UD_tblCustMaster] 
	(
		@CategoryId int ,
		@CustomerName NVARCHAR(MAX)=null,
		@Address NVARCHAR(MAX)=null,
		@CellNo NVARCHAR(MAX)=null,
		@Addrees2 NVARCHAR(MAX)=null,
		@City NVARCHAR(MAX)=null,
		@ShippingCond NVARCHAR(MAX)=null,
		@MarketCode NVARCHAR(MAX)=null,
		@MarketName NVARCHAR(MAX)=null,
		@MIACode NVARCHAR(MAX)=null,
		@MiaName NVARCHAR(MAX)=null,
		@AreaCode NVARCHAR(MAX)=null,
		@DisCode NVARCHAR(MAX)=null,
		@FEName NVARCHAR(MAX)=null,
		@ComUnitCode NVARCHAR(MAX)=null,
		@ComUnitName NVARCHAR(MAX)=null,
		@RegionCode NVARCHAR(MAX)=null,
		@DZSMName NVARCHAR(MAX)=null,
		@CustomerMasterId int=null
		
	)
AS
BEGIN

		UPDATE [dbo].[tblCustMaster]
        SET  
				CategoryId=@CategoryId,
				CustomerName=@CustomerName,
				Address=@Address,
				CellNo=@CellNo,
				Addrees2=@Addrees2,
				City=@City,
				ShippingCond=@ShippingCond,
				MarketCode=@MarketCode,
				MarketName=@MarketName,
				MIACode=@MIACode,
				MIAName=@MiaName,
				AreaCode=@AreaCode,
				DisCode=@DisCode,
				FEName=@FEName,
				ComUnitCode=@ComUnitCode,
				ComUnitName=@ComUnitName,
				RegionCode=@RegionCode,
				DZSMName=@DZSMName
			
		WHERE CustomerMasterId=@CustomerMasterId

END
