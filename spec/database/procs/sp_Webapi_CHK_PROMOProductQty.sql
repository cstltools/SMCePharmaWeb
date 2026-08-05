-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_CHK_PROMOProductQty]
	-- Add the parameters for the stored procedure here
    @EmpInfoId INT,
    @ProductId INT,
    @Qty int


AS
    BEGIN
	
        SELECT  ISNULL(SUM(TransactionQTY) ,0)TransactionQTY FROM dbo.tblGroupWisePromoQty WHERE EmpInfoId=@EmpInfoId AND ProductId=@ProductId HAVING ISNULL(SUM(TransactionQTY) ,0)>=@Qty


    END

