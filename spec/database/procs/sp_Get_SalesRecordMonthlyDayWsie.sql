
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_SalesRecordMonthlyDayWsie]
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
	SET @Q='select tblRegion.RegionCode as Criteria,ISNULL(Amount,0)Amount from tblRegion 
left join 
(SELECT rg.RegionCode Criteria ,ISNULL(SUM(tblInvoice.TpTotal-tblInvoice.TpDiscount),0)Amount FROM   dbo.tblRegion rg with (nolock)

  left JOIN dbo.tblOrder  with (nolock) ON rg.RegionId=dbo.tblOrder.RegionId
		  left JOIN dbo.tblInvoice  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
   LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
   LEFT JOIN dbo.tbl_BonusCampaignNewDetail  with (nolock)  ON tbl_BonusCampaignNewDetail.CampaignDetailId = dbo.tblOrderDetail.CampaignType

   LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock) ON tbl_BonusCampaignNewDetail.CampaignMasterId =tbl_BonusCampaignNewMaster.CampgainMasterId

   
   WHERE  MONTH(InvoiceDate)='''+convert(nvarchar(max),@Month)+''' AND YEAR(InvoiceDate)='''+convert(nvarchar(max),@Year)+'''  '+@param+'  
    group by rg.RegionCode) as tblt on tblt.Criteria=tblRegion.RegionCode
  '

EXEC sys.sp_executesql @Q


END
