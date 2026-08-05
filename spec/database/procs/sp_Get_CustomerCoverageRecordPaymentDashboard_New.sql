CREATE

 PROCEDURE [dbo].[sp_Get_CustomerCoverageRecordPaymentDashboard_New]
	-- Add the parameters for the stored procedure here
	@Month INT,
	@Year INT,
	@param nvarchar(max)


AS
BEGIN
   

    DECLARE @Q NVARCHAR(MAX)
	SET @Q='select tblRegion.RegionName as Criteria,ISNULL(Amount,0)Amount from tblRegion 
left join 
(SELECT rg.RegionCode AS Criteria,ISNULL(COUNT(tblInvoice.CustomerMasterId),0)Amount FROM   dbo.tblRegion rg with (nolock) 
 INNER JOIN dbo.tblOrder  with (nolock) ON rg.RegionId=dbo.tblOrder.RegionId
 INNER JOIN dbo.tblInvoice  with (nolock) ON tblInvoice.OrderId=dbo.tblOrder.OrderId
   
   WHERE   MONTH(tblInvoice.UpdateDate)='+convert(nvarchar(max),@Month)+' AND YEAR(tblInvoice.UpdateDate)='+convert(nvarchar(max),@Year)+' '+@param+'  
      group by rg.RegionCode) as tblt on tblt.Criteria=tblRegion.RegionCode

    where Amount>0
   

    '

EXEC sys.sp_executesql @Q


END