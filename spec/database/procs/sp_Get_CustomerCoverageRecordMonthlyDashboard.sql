

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_CustomerCoverageRecordMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT

AS
BEGIN
   

   SELECT ComUnitName Criteria,COUNT(tblt.CustomerMasterId)AS Amount FROM (SELECT DISTINCT ComUnitId,CustomerMasterId FROM dbo.tblInvoice
   WHERE MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year) AS  tblt
   LEFT JOIN dbo.tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblt.ComUnitId
   GROUP BY ComUnitName

   
   




END

