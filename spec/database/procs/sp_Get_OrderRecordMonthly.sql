
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Get_OrderRecordMonthly]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT

AS
BEGIN
   SELECT 'Campaign Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   WHERE IsCampaignProduct=1 AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year
   UNION ALL
   SELECT 'General Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   
   WHERE (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (FixedCustomer=0 OR FixedCustomer IS NULL) AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year
   UNION ALL
   SELECT 'FCB Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   
   WHERE (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (FixedCustomer=1) AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year
   UNION ALL
   SELECT 'Total Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   WHERE MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year
   




END
