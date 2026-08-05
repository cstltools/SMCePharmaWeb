


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Zero_PaymentInfo]
	-- Add the parameters for the stored procedure here

AS
BEGIN
		 

DECLARE @OrderNo NVARCHAR(500)
DECLARE @TerritoryCode decimal(18,2)
DECLARE @AMCode NVARCHAR(500)
DECLARE @ZoneCode NVARCHAR(500)
DECLARE @TerritoryId NVARCHAR(500)

--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
select CustPayDetailId,PaymentAmount from tblCustPayDetail where TPAmount=0 and VATAmount=0 and PaymentAmount<>0

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@OrderNo,@TerritoryCode
WHILE @@FETCH_STATUS = 0
BEGIN

update tblCustPayDetail SET  TPAmount=@TerritoryCode where CustPayDetailId=@OrderNo

FETCH NEXT FROM @MyCursor
INTO 
@OrderNo,@TerritoryCode
END
CLOSE @MyCursor
DEALLOCATE @MyCursor




END




