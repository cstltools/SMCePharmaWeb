
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create

 PROCEDURE [dbo].[sp_Get_SalesReturnRecordMonthly_New]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT,
	@param nvarchar(max)

AS
BEGIN
   --SELECT 'Campaign Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   --LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   --WHERE IsCampaignProduct=1 AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year

   DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''Campaign Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblOrder
   LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   INNER JOIN dbo.tblInvoice ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   WHERE IsCampaignProduct=1 AND IsTradePolicy<>1 AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+'  '+@param+'  
   UNION ALL
   SELECT ''Campaign Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblOrder
   LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   INNER JOIN dbo.tblSubInvoiceMaster ON dbo.tblSubInvoiceMaster.OrderId=dbo.tblOrder.OrderId
   WHERE IsCampaignProduct=1 AND IsTradePolicy<>1 AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+'  '+@param+' ) AS tblt
   GROUP BY tblt.Criteria


   UNION ALL


   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''General Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblOrder
   LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   INNER JOIN dbo.tblInvoice ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   WHERE IsTradePolicy=1 AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year) +'   '+@param+' 
   UNION ALL 
   SELECT ''General Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblOrder
   LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   INNER JOIN dbo.tblSubInvoiceMaster ON dbo.tblSubInvoiceMaster.OrderId=dbo.tblOrder.OrderId
   WHERE IsTradePolicy=1 AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+'  '+@param+' ) AS tblt
   GROUP BY tblt.Criteria
   
   
   UNION ALL
   
   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''FCB Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   
   WHERE (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (FixedCustomer=1) AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+'  '+@param+' 
   UNION ALL
   SELECT ''FCB Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblSubInvoiceMaster
   LEFT JOIN dbo.tblSubInvoiceDetail ON tblSubInvoiceMaster.InvoiceId = tblSubInvoiceDetail.InvoiceId
   
   WHERE (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (FixedCustomer=1) AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+'  '+@param+' ) AS tblt GROUP BY tblt.Criteria



   UNION ALL
   
   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount  FROM (SELECT ''Institute Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   LEFT JOIN dbo.tblOrder ON tblOrder.OrderId = tblInvoice.OrderId
   WHERE IsSpDis=1 AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+' '+@param+'
   UNION ALL
   
   SELECT ''Institute Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblSubInvoiceMaster
   LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceDetail.InvoiceId = dbo.tblSubInvoiceMaster.InvoiceId
   LEFT JOIN dbo.tblOrder ON tblOrder.OrderId = dbo.tblSubInvoiceMaster.OrderId
   WHERE IsSpDis=1 AND MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+' '+@param+') AS tblt
	GROUP BY tblt.Criteria
   UNION ALL
   
   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''Total Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   WHERE MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+' '+@param+'
   UNION ALL
   SELECT ''Total Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblSubInvoiceMaster
   LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceDetail.InvoiceId = dbo.tblSubInvoiceMaster.InvoiceId
   WHERE MONTH(InvoiceDate)='+convert(nvarchar(max),@Month)+' AND YEAR(InvoiceDate)='+convert(nvarchar(max),@Year)+' '+@param+') AS tblt
   GROUP BY tblt.Criteria
   

   			 '

EXEC sys.sp_executesql @Q


END
