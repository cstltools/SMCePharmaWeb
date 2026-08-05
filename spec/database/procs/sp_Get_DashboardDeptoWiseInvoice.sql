CREATE PROCEDURE [dbo].[sp_Get_DashboardDeptoWiseInvoice] 
	-- Add the parameters for the stored procedure here
   
   
AS
    BEGIN
	
	declare  @currentDate DATETIME


set	@currentDate=getdate()
 
	
      SELECT rg.RegionName ComUnitName,   convert(decimal(18,0), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))

,0)) TotalInvoice
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId
		inner join tblRegion rg with (nolock) on ord.RegionId=rg.RegionId
     WHERE   convert(Date,A.InvoiceDate) = convert(Date,@currentDate)
	 
		group by rg.RegionName

 having ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0))

,0)>0

    END