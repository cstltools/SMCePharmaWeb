

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_OrderRecordMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	 
	@param nvarchar(max),
	@FrmDate nvarchar(max),
	@ToDate nvarchar(max)

AS
BEGIN
   --SELECT 'Campaign Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   --LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   --WHERE IsCampaignProduct=1 AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year
   --select  GrossValue-TPDiscount * from tblOrder
    DECLARE @Q NVARCHAR(MAX)
	SET @Q='SELECT ''Campaign Order''AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM dbo.tblOrder  with (nolock) 
   LEFT JOIN dbo.tblOrderDetail  with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock)  ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   
   WHERE tblOrder.CustTypeId=1 and  IsCampaignProduct=1 AND tbl_BonusCampaignNewMaster.CampgainMasterId not in (1,2,3)   AND Convert(Date,SubmissionDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 
   


   UNION ALL
   SELECT ''General Order''AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM dbo.tblOrder   with (nolock) 
   LEFT JOIN dbo.tblOrderDetail   with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster   with (nolock)  ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   
   WHERE tblOrder.CustTypeId=1 and  IsCampaignProduct=0  AND Convert(Date,SubmissionDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 
   
   
   UNION ALL
   SELECT ''FCB Order''AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM dbo.tblOrder   with (nolock) 
   LEFT JOIN dbo.tblOrderDetail   with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   
   
   WHERE (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (tblOrder.custtypeid=2)  
  AND Convert(Date,SubmissionDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 

   UNION ALL
   SELECT ''Institute Order''AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM dbo.tblOrder   with (nolock) 
   LEFT JOIN dbo.tblOrderDetail   with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   
   WHERE  (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (tblOrder.custtypeid=3) AND Convert(Date,SubmissionDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 

   UNION ALL
   SELECT ''Total Order''AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM dbo.tblOrder   with (nolock) 
   LEFT JOIN dbo.tblOrderDetail   with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   WHERE   Convert(Date,SubmissionDate) between '''+convert(nvarchar(max),Convert(Date,@FrmDate))+''' AND  '''+convert(nvarchar(max),Convert(Date,@ToDate))+'''  '+@param+' 
   

   
   			 '

EXEC sys.sp_executesql @Q


END

