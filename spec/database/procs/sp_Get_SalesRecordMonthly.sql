
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_SalesRecordMonthly]
	-- Add the parameters for the stored procedure here

	 
	@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)
AS
BEGIN
   --SELECT 'Campaign Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   --LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   --WHERE IsCampaignProduct=1 AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year

   DECLARE @Q NVARCHAR(MAX)
	SET @Q=' SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''Campaign Sales''AS Criteria,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM dbo. tblInvoice with (nolock)

		  INNER JOIN dbo.tblOrder  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewDetail  with (nolock)  ON tbl_BonusCampaignNewDetail.CampaignDetailId = dbo.tblOrderDetail.CampaignType

   LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock) ON tbl_BonusCampaignNewDetail.CampaignMasterId =tbl_BonusCampaignNewMaster.CampgainMasterId


   
   WHERE tblOrder.CustTypeId=1 and  IsCampaignProduct=1 AND tbl_BonusCampaignNewMaster.CampgainMasterId not in (1,2,3)   AND Convert(Date,InvoiceDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+'  
  ) AS tblt
   GROUP BY tblt.Criteria


   UNION ALL


   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''General Sales''AS Criteria,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM dbo. tblInvoice
		  INNER JOIN dbo.tblOrder ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId

   LEFT JOIN dbo.tblOrderDetail ON tblOrderDetail.OrderId = tblOrder.OrderId
    LEFT JOIN dbo.tbl_BonusCampaignNewDetail  with (nolock)  ON tbl_BonusCampaignNewDetail.CampaignDetailId = dbo.tblOrderDetail.CampaignType

   LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock) ON tbl_BonusCampaignNewDetail.CampaignMasterId =tbl_BonusCampaignNewMaster.CampgainMasterId


   
   WHERE tblOrder.CustTypeId=1 and  IsCampaignProduct=0  AND Convert(Date,InvoiceDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 
    ) AS tblt
   GROUP BY tblt.Criteria
   
   
   UNION ALL
   
   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''FCB Sales''AS Criteria,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   	inner join tblOrder   with (nolock) on tblOrder.OrderId=tblInvoice.OrderId
   WHERE (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (tblOrder.custtypeid=2) AND Convert(Date,InvoiceDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+'  
   ) AS tblt GROUP BY tblt.Criteria



   UNION ALL
   
   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount  FROM (SELECT ''Institute Sales''AS Criteria,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   LEFT JOIN dbo.tblOrder ON tblOrder.OrderId = tblInvoice.OrderId
   WHERE  (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (tblOrder.custtypeid=3) AND Convert(Date,InvoiceDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 
  ) AS tblt
	GROUP BY tblt.Criteria
   UNION ALL
   
   SELECT tblt.Criteria,
          SUM(tblt.Amount)Amount FROM (SELECT ''Total Sales''AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   inner join tblOrder   with (nolock) on tblOrder.OrderId=tblInvoice.OrderId
   WHERE   Convert(Date,InvoiceDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 
  ) AS tblt
   GROUP BY tblt.Criteria
   

   			 '

EXEC sys.sp_executesql @Q


END
