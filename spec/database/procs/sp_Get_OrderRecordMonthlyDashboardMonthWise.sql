

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_OrderRecordMonthlyDashboardMonthWise]
	-- Add the parameters for the stored procedure here

	 
	@Month nvarchar(max),
	@Year nvarchar(max),
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
	SET @Q='SELECT rg.RegionCode AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM dbo.tblOrder  with (nolock) 
   LEFT JOIN dbo.tblOrderDetail  with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock)  ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType

      LEFT JOIN dbo.tblRegion rg with (nolock)  ON rg.RegionId = tblOrder.RegionId
	 where tblOrder.OrderId is not null  AND month(Convert(Date,SubmissionDate)) = '''+convert(nvarchar(max), @Month)+''' AND Year(Convert(Date,SubmissionDate)) ='''+convert(nvarchar(max),@Year)+''' '+@param+'
	  group by rg.RegionCode   order by rg.RegionCode' 
 

   

EXEC sys.sp_executesql @Q


END

