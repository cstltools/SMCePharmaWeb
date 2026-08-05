-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_WebAI_Get_TTargetAChivementReport]
	-- Add the parameters for the stored procedure here 

	   @empId nvarchar(max)=null,
                 
                 @FromDate nvarchar(max)=null,
                 @ToDate nvarchar(max)=null ,
				 @Role  nvarchar(max)=null

AS
BEGIN
   
	SELECT  
    ROW_NUMBER() OVER (ORDER BY tm.TerritoryCode) AS SerialNo,
    tm.TerritoryCode + ' : ' + tr.TerritoryName AS TerritoryName,
   CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) AS TargetValue,
   ISNULL( tblOrd.TotalOrder,0) AS OrderValue,
   CASE
       WHEN CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
       ELSE CAST(ISNULL(tblOrd.TotalOrder, 0) * 100.0 / CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
   END as  OrderAchiv,
    isnull(tblInv.TotalInvoice,0) AS InvoiceValue,
   CASE
       WHEN CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
       ELSE CAST(isnull(tblInv.TotalInvoice,0) * 100.0 / CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
   END as  InvoiceAchiv,
    isnull(tblSal.TotalSales, 0) AS SalesValue,
 CASE
       WHEN CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
       ELSE CAST(isnull(tblSal.TotalSales, 0) * 100.0 / CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
   END as SalesAchiv
FROM 
      tblTerritory tr with (nolock)
INNER JOIN  tblArea ar  with (nolock)  ON ar.AreaId = tr.AreaId
INNER JOIN  tblRegion rg  with (nolock)  ON ar.RegionId = rg.RegionId

INNER JOIN  tblTerritoryDataMigration tm  ON tm.TerritoryId = tr.TerritoryId

	left join (select Ord.TerritoryId,  convert(decimal(18,2), ISNULL(sum(Ord.GrossValue-Ord.TotalDiscount),0)) TotalOrder from tblOrder  Ord with (nolock)  where  convert(Date,Ord.SubmissionDate) between convert(Date, @FromDate) and convert(Date,@ToDate)  Group by Ord.TerritoryId) tblOrd on tblOrd.TerritoryId=tr.TerritoryId

	left join (SELECT ord.TerritoryId ,   convert(decimal(18,2), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalInvoice
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
     WHERE   convert(Date,A.InvoiceDate) between convert(Date, @FromDate) and convert(Date,@ToDate)
	 
		group by ord.TerritoryId) tblInv on tblInv.TerritoryId=tr.TerritoryId

		left join (SELECT ord.TerritoryId ,   convert(decimal(18,0), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalSales
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
     WHERE   convert(Date,A.UpdateDate) between convert(Date, @FromDate) and convert(Date,@ToDate) and DeliveryInvoiceStatus in ('Full','Partial')
	 
		group by ord.TerritoryId) tblSal on tblSal.TerritoryId=tr.TerritoryId


WHERE  tm.TerritoryId IS NOT NULL 

 --and   ((rg.RegionId= COALESCE( NULLIF(@_Zone , 0) ,rg.RegionId)) and ar.AreaId= COALESCE( NULLIF(@_Area , 0) ,ar.AreaId) and tr.TerritoryId= COALESCE( NULLIF(@_Tr , 0) ,tr.TerritoryId))  
    AND tm.MonthName = month(convert(Date, @FromDate)) 
    AND tm.YearValue = year(convert(Date, @FromDate)) 
ORDER BY  
    tm.TerritoryCode;

END

