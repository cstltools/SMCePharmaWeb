
-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_SalesRecordMonthlyDayWsiePayment]
	-- Add the parameters for the stored procedure here

	@Month INT,
	@Year INT,
	@CustomerTypeId INT,
	@param nvarchar(max)

AS
BEGIN
  
  declare @NewParam nvarchar(max)=''
  -- if(@CustomerTypeId=1)
  -- begin 
  --set @NewParam =' and tblOrder.CustTypeId=1 and  IsCampaignProduct=0 '
  -- end


  --  if(@CustomerTypeId=2)
  -- begin 
  --set @NewParam =' and  (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) AND (tblOrder.custtypeid=2) '
  -- end


  --  if(@CustomerTypeId=3)
  -- begin 
  --set @NewParam =' and  (IsCampaignProduct=0 OR IsCampaignProduct IS NULL) '
  -- end


   DECLARE @Q NVARCHAR(MAX)
	SET @Q='select tblRegion.RegionName as Criteria,ISNULL(Amount,0)Amount from tblRegion 
left join 
(SELECT rg.RegionCode Criteria ,ISNULL(SUM(ID.DeliveryTotalPrice-ID.DeliveryDiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))

,0)Amount FROM   dbo.tblRegion rg with (nolock)

  left JOIN dbo.tblOrder  with (nolock) ON rg.RegionId=dbo.tblOrder.RegionId
		  left JOIN dbo.tblInvoice  with (nolock) ON dbo.tblInvoice.OrderId=dbo.tblOrder.OrderId
		  left JOIN dbo.tblInvoiceDetail  ID with (nolock) ON dbo.tblInvoice.InvoiceId=ID.InvoiceId
   --LEFT JOIN dbo.tblOrderDetail  with (nolock) ON tblOrderDetail.OrderId = tblOrder.OrderId
   --LEFT JOIN dbo.tbl_BonusCampaignNewDetail  with (nolock)  ON tbl_BonusCampaignNewDetail.CampaignDetailId = dbo.tblOrderDetail.CampaignType

   --LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock) ON tbl_BonusCampaignNewDetail.CampaignMasterId =tbl_BonusCampaignNewMaster.CampgainMasterId

   
   WHERE  MONTH(tblInvoice.UpdateDate)='''+convert(nvarchar(max),@Month)+''' AND YEAR(tblInvoice.UpdateDate)='''+convert(nvarchar(max),@Year)+'''  '+@param+'   '+@NewParam+'  
    group by rg.RegionCode) as tblt on tblt.Criteria=tblRegion.RegionCode   where Amount>0
  '

EXEC sys.sp_executesql @Q


END
