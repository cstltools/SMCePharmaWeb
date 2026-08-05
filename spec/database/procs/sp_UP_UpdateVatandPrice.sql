-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_UP_UpdateVatandPrice] -- exec SAP_API_Data..sp_UP_UpdateVatandPrice
	-- Add the parameters for the stored procedure here


AS
BEGIN
   
DECLARE @OrderNo NVARCHAR(500)
DECLARE @TerritoryCode NVARCHAR(500)
DECLARE @AMCode NVARCHAR(500)
DECLARE @ZoneCode NVARCHAR(500)
DECLARE @TerritoryId NVARCHAR(500)

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
select S.SL,U.UnitPrice,(S.Quantity * VATAmountPerUnit)vat from [dbo].[tbl_DeliveryConfirmation_Sales] S
inner join SalesDisDB_SMC_NEWDB..tblProduct P on S.ProductCode = P.SAP_Code
inner join SalesDisDB_SMC_NEWDB..tblUnitPrice U on U.ProductCode=P.ProductCode
 where (S.UnitPrice=0 or S.VAT=0) and FOCFlag='B'
 and tbl_DeliveryConfirmation_Sales.SalesDocDate='2023-11-05'

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@OrderNo,@TerritoryCode,@ZoneCode
WHILE @@FETCH_STATUS = 0
BEGIN

--update tblOrder SET  MIOSAPCode_Ord=@TerritoryCode   where MIOId=@OrderNo 
--update tblOrder SET  AMSAPCode_Ord=@TerritoryCode   where ASMId=@OrderNo 
--update tblOrder SET  DZSMSAPCode_Ord=@TerritoryCode   where RSMId=@OrderNo 
update [dbo].[tbl_DeliveryConfirmation_Sales]  SET  UnitPrice=@TerritoryCode, VAT=@ZoneCode  where SL=@OrderNo 

FETCH NEXT FROM @MyCursor
INTO 
@OrderNo,@TerritoryCode,@ZoneCode
END
CLOSE @MyCursor
DEALLOCATE @MyCursor









END
