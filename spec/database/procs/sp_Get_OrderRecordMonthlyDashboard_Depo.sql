

-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE

 PROCEDURE [dbo].[sp_Get_OrderRecordMonthlyDashboard_Depo]
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
	SET @Q='select tblCompanyUnit.ShortName as Criteria,ISNULL(Amount,0)Amount from tblCompanyUnit   with (nolock) 
left join 
(SELECT rg.ComUnitCode AS Criteria,ISNULL(SUM(GrossValue-TPDiscount),0)Amount FROM   dbo.tblCompanyUnit rg with (nolock) 
 inner JOIN dbo.tblOrder  with (nolock) ON rg.ComUnitId=dbo.tblOrder.ComUnitId
   --LEFT JOIN dbo.tblOrderDetail  with (nolock)  ON tblOrderDetail.OrderId = tblOrder.OrderId
   --LEFT JOIN dbo.tbl_BonusCampaignNewMaster  with (nolock)  ON tbl_BonusCampaignNewMaster.CampgainMasterId = dbo.tblOrderDetail.CampaignType
   WHERE  tblOrder.ActionStatus<>''3'' and  MONTH(SubmissionDate)='+convert(nvarchar(max),@Month)+' AND YEAR(SubmissionDate)='+convert(nvarchar(max),@Year)+' '+@param+'  
     group by rg.ComUnitCode) as tblt on tblt.Criteria=tblCompanyUnit.ComUnitCode  where Amount>0
  '
EXEC sys.sp_executesql @Q


END

