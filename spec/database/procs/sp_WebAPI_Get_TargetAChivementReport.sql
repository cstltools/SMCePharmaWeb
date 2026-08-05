-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_WebAPI_Get_TargetAChivementReport]
	-- Add the parameters for the stored procedure here 

	   @empId nvarchar(max)=null,
                 
                 @FromDate nvarchar(max)=null,
                 @ToDate nvarchar(max)=null ,
				 @Role  nvarchar(max)=null

AS
BEGIN

DECLARE @TerrId INT
DECLARE @AreaId INT
DECLARE @ZoneId INT
DECLARE @GroupId INT
 
 SELECT  @FromDate =  CONVERT(date,[StartDate] )
  FROM [dbo].[tblFinancialYear]  where  getdate() between   [StartDate] 
      and [EndDate]
	   
set @ToDate =  CONVERT(date, CONVERT(DATE, EOMONTH(GETDATE())))

SELECT @TerrId=TerritoryId, @AreaId=AreaId,@ZoneId=RegionId,@GroupId=GroupId FROM dbo.View_Webapi_EmployeeFieldForceInfo WHERE EmpInfoId=@empId



   
   select  CASE
       WHEN CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
       ELSE CAST(ISNULL(OrderValue, 0) * 100.0 / CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
   END as  OrderAchiv  ,  CASE
       WHEN CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
       ELSE CAST(ISNULL(InvoiceValue, 0) * 100.0 / CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
   END as InvoiceAchiv,  CASE
       WHEN CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
       ELSE CAST(ISNULL(SalesValue, 0) * 100.0 / CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
   END as SalesAchiv, * from (
	SELECT  
    ROW_NUMBER() OVER (ORDER BY tm.TerritoryCode) AS SerialNo, tm.TerritoryCode,
    tm.TerritoryCode + ' : ' + tr.TerritoryName AS TerritoryName,
   sum(CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))) AS TargetValue,
    (ISNULL( tblOrd.TotalOrder,0)) AS OrderValue,
    
     (isnull(tblInv.TotalInvoice,0)) AS InvoiceValue,
     (isnull(tblSal.TotalSales, 0)) AS SalesValue 
FROM 
      tblTerritory tr with (nolock)
INNER JOIN  tblArea ar  with (nolock)  ON ar.AreaId = tr.AreaId
INNER JOIN  tblRegion rg  with (nolock)  ON ar.RegionId = rg.RegionId

INNER JOIN  tblTerritoryDataMigration tm  ON tm.TerritoryId = tr.TerritoryId

	left join (select Ord.TerritoryId,  convert(decimal(18,2), ISNULL(sum(OrdD.TotalTradePrice)-sum(OrdD.DiscountAmount),0) )TotalOrder from tblOrder  Ord with (nolock) 
	
inner join tblOrderDetail OrdD with (nolock)  on Ord.OrderId= OrdD.OrderId
	where Ord.ActionStatus='2'  and  convert(Date,Ord.SubmissionDate) between convert(Date, @FromDate) and convert(Date,@ToDate)  Group by Ord.TerritoryId) tblOrd on tblOrd.TerritoryId=tr.TerritoryId

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


WHERE  tm.TerritoryId IS NOT NULL and tm.TerritoryId IS NOT NULL and	( tr.TerritoryId= @TerrId or  
			ar.AreaId=@AreaId OR rg.RegionId=@ZoneId)   
    AND tm.MonthName in (SELECT MonthValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))  
    AND tm.YearValue  in (SELECT  YearValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate)) 

	group by tm.TerritoryCode, tr.TerritoryName, (ISNULL( tblOrd.TotalOrder,0))  ,
    
     (isnull(tblInv.TotalInvoice,0))  ,
     (isnull(tblSal.TotalSales, 0))  
)tbl
ORDER BY  
     TerritoryCode

 
END

