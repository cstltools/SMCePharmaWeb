

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_OrderRecordMonthlyDashboard_New]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT,
	@param nvarchar(max)

AS
BEGIN
   --SELECT 'Campaign Sales'AS Criteria,ISNULL(SUM(NetAmount),0)Amount FROM dbo.tblInvoice
   --LEFT JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId
   --WHERE IsCampaignProduct=1 AND MONTH(InvoiceDate)=@Month AND YEAR(InvoiceDate)=@Year
   --select  GrossValue-TPDiscount * from tblOrder
    DECLARE @Q NVARCHAR(MAX)
	SET @Q='select tblRegion.RegionName as Criteria,ISNULL(Amount,0)Amount from tblRegion 
left join 
(SELECT rg.RegionCode AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM   dbo.tblRegion rg with (nolock) 
 inner JOIN dbo.tblOrder  with (nolock) ON rg.RegionId=dbo.tblOrder.RegionId
   --LEFT JOIN dbo.tblOrderDetail  with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   --LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock)  ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   WHERE  tblOrder.ActionStatus<>''3'' and  MONTH(SubmissionDate)='+convert(nvarchar(max),@Month)+' AND YEAR(SubmissionDate)='+convert(nvarchar(max),@Year)+' '+@param+'  
      group by rg.RegionCode) as tblt on tblt.Criteria=tblRegion.RegionCode where Amount>0
  '
EXEC sys.sp_executesql @Q


END

