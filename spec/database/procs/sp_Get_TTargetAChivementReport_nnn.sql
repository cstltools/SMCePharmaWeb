create PROCEDURE [dbo].[sp_Get_TTargetAChivementReport_nnn]
	-- Add the parameters for the stored procedure here 

	   
                 @FromDate nvarchar(max)=null,
                 @ToDate nvarchar(max)=null ,
                 @Type nvarchar(max)=null ,
				 @ZoneId nvarchar(max)=null ,
				 @Area nvarchar(max)=null ,
				 @Terr nvarchar(max)=null 


AS
BEGIN
 



  if(@Type='Zone')
   begin
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
    ROW_NUMBER() OVER (ORDER BY rg.RegionCode) AS SerialNo,rg.RegionCode,
    rg.RegionName + ' : ' + rg.RegionCode AS RegionName,
   sum(CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))) AS TargetValue,
    (ISNULL( tblOrd.TotalOrder,0)) AS OrderValue,
    
     (isnull(tblInv.TotalInvoice,0)) AS InvoiceValue,
     (isnull(tblSal.TotalSales, 0)) AS SalesValue 
FROM 
       tblRegion rg with (nolock)
 

INNER JOIN  tblTerritoryDataMigration tm  ON tm.ZoneId_tr = rg.RegionId

	left join (select Ord.RegionId,  convert(decimal(18,2), ISNULL(sum(OrdD.TotalTradePrice)-sum(OrdD.DiscountAmount),0) )TotalOrder from tblOrder  Ord with (nolock) 
	
inner join tblOrderDetail OrdD with (nolock)  on Ord.OrderId= OrdD.OrderId
	where Ord.ActionStatus='2'  and  convert(Date,Ord.SubmissionDate) between convert(Date, @FromDate) and convert(Date,@ToDate)  Group by Ord.RegionId) tblOrd on tblOrd.RegionId=rg.RegionId

	left join (SELECT ord.RegionId ,   convert(decimal(18,2), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalInvoice
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
     WHERE   convert(Date,A.InvoiceDate) between convert(Date, @FromDate) and convert(Date,@ToDate)
	 
		group by ord.RegionId) tblInv on tblInv.RegionId=rg.RegionId

		left join (SELECT ord.RegionId ,   convert(decimal(18,0), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalSales
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
     WHERE   convert(Date,A.UpdateDate) between convert(Date, @FromDate) and convert(Date,@ToDate) and DeliveryInvoiceStatus in ('Full','Partial')
	 
		group by ord.RegionId) tblSal on tblSal.RegionId=rg.RegionId


WHERE  tm.TerritoryId IS NOT NULL  and   ((rg.RegionId= COALESCE( NULLIF(@ZoneId , 0) ,rg.RegionId))  
    AND tm.MonthName in (SELECT MonthValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))  
    AND tm.YearValue  in (SELECT  YearValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate)) 
	)
	group by rg.RegionCode, rg.RegionName, (ISNULL( tblOrd.TotalOrder,0))  ,
    
     (isnull(tblInv.TotalInvoice,0))  ,
     (isnull(tblSal.TotalSales, 0))  
)tbl
ORDER BY  
      RegionCode
END


  if(@Type='Area')
   begin
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
    ROW_NUMBER() OVER (ORDER BY ar.AreaCode) AS SerialNo,rg.RegionCode,ar.AreaCode, 
    rg.RegionName + ' : ' + rg.RegionCode AS RegionName,     ar.AreaName + ' : ' + ar.AreaCode AS AreaName,    
   sum(CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))) AS TargetValue,
    (ISNULL( tblOrd.TotalOrder,0)) AS OrderValue,
    
     (isnull(tblInv.TotalInvoice,0)) AS InvoiceValue,
     (isnull(tblSal.TotalSales, 0)) AS SalesValue 
FROM 
        tblArea ar with (nolock)
 INNER JOIN  tblTerritoryDataMigration tm  ON tm.AreaId_tr = ar.AreaId
INNER JOIN  tblRegion rg  with (nolock)  ON tm.ZoneId_tr = rg.RegionId



	left join (select Ord.AreaId,  convert(decimal(18,2), ISNULL(sum(OrdD.TotalTradePrice)-sum(OrdD.DiscountAmount),0) )TotalOrder from tblOrder  Ord with (nolock) 
	
inner join tblOrderDetail OrdD with (nolock)  on Ord.OrderId= OrdD.OrderId
	where Ord.ActionStatus='2'  and  convert(Date,Ord.SubmissionDate) between convert(Date, @FromDate) and convert(Date,@ToDate)  Group by Ord.AreaId) tblOrd on tblOrd.AreaId=ar.AreaId

	left join (SELECT ord.AreaId ,   convert(decimal(18,2), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalInvoice
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
     WHERE   convert(Date,A.InvoiceDate) between convert(Date, @FromDate) and convert(Date,@ToDate)
	 
		group by ord.AreaId) tblInv on tblInv.AreaId=ar.AreaId

		left join (SELECT ord.AreaId ,   convert(decimal(18,0), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalSales
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
     WHERE   convert(Date,A.UpdateDate) between convert(Date, @FromDate) and convert(Date,@ToDate) and DeliveryInvoiceStatus in ('Full','Partial')
	 
		group by ord.AreaId) tblSal on tblSal.AreaId=ar.AreaId


WHERE  tm.TerritoryId IS NOT NULL  and   ((rg.RegionId= COALESCE( NULLIF(@ZoneId , 0) ,rg.RegionId))    and   ( ar.AreaId= COALESCE( NULLIF(@Area , 0) ,ar.AreaId))   
    AND tm.MonthName in (SELECT MonthValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))  
    AND tm.YearValue  in (SELECT  YearValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate)) 
	)
	group by rg.RegionCode, rg.RegionName,  ar.AreaName , ar.AreaCode,   (ISNULL( tblOrd.TotalOrder,0))  ,
    
     (isnull(tblInv.TotalInvoice,0))  ,
     (isnull(tblSal.TotalSales, 0))  
)tbl
ORDER BY  
     AreaCode
END




  if(@Type='Territory')
   begin
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
    ROW_NUMBER() OVER (ORDER BY tm.TerritoryCode) AS SerialNo,rg.RegionCode,ar.AreaCode, tm.TerritoryCode,
    rg.RegionName + ' : ' + rg.RegionCode AS RegionName,     ar.AreaName + ' : ' + ar.AreaCode AS AreaName,     tm.TerritoryCode + ' : ' + tr.TerritoryName AS TerritoryName,
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


WHERE  tm.TerritoryId IS NOT NULL  and   ((rg.RegionId= COALESCE( NULLIF(@ZoneId , 0) ,rg.RegionId))    and   ( ar.AreaId= COALESCE( NULLIF(@Area , 0) ,ar.AreaId))   
    AND tm.MonthName in (SELECT MonthValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate))  
    AND tm.YearValue  in (SELECT  YearValue FROM dbo.GetMonthYearValuesDateRange(@FromDate, @ToDate)) 
	)
	group by rg.RegionCode, rg.RegionName,  ar.AreaName , ar.AreaCode,tm.TerritoryCode, tr.TerritoryName,  (ISNULL( tblOrd.TotalOrder,0))  ,
    
     (isnull(tblInv.TotalInvoice,0))  ,
     (isnull(tblSal.TotalSales, 0))  
)tbl
ORDER BY  
      TerritoryCode
END
END

