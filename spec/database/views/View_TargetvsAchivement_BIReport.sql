


   
   CREATE View [dbo].[View_TargetvsAchivement_BIReport] 
   as


   
   select  TOP (100) PERCENT  rg.RegionName [Zone_Name],   DATENAME(MONTH, DATEFROMPARTS(2000, tm.MonthName, 1)) targetMonth, tm.YearValue targetYear, ISNULL(sum(CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))),0) AS TargetValue,  ISNULL(sum(TotalSales),0) SalesValue     from   
        tblTerritory tr with (nolock)
INNER JOIN  tblArea ar  with (nolock)  ON ar.AreaId = tr.AreaId
INNER JOIN  tblRegion rg  with (nolock)  ON ar.RegionId = rg.RegionId
INNER JOIN  tbl_Group grp  with (nolock)  ON grp.GroupId = rg.GroupId 
INNER JOIN  tblTerritoryDataMigration tm   with (nolock)  ON tm.TerritoryId = tr.TerritoryId 
left join (SELECT ord.TerritoryId ,  month(A.UpdateDate) SalesMonth, Year(A.UpdateDate) SalesYear, convert(decimal(18,2), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
,0)) TotalSales
        FROM    dbo.tblInvoice A   with (nolock)
		inner join tblInvoiceDetail ID    with (nolock) on A.InvoiceId=ID.InvoiceId
		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId  
   WHERE DeliveryInvoiceStatus in ('Full','Partial') 
		group by ord.TerritoryId, month(A.UpdateDate)  , Year(A.UpdateDate)) tblSal on tblSal.TerritoryId=tr.TerritoryId and SalesMonth=tm.MonthName and SalesYear=tm.YearValue 
		group by tm.MonthName  , tm.YearValue ,    rg.RegionName   
		ORDER BY tm.YearValue, tm.MonthName , rg.RegionName

		 

--		select ISNULL( (CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))),0) from   tblTerritory tr with (nolock)
--INNER JOIN  tblArea ar  with (nolock)  ON ar.AreaId = tr.AreaId
--INNER JOIN  tblRegion rg  with (nolock)  ON ar.RegionId = rg.RegionId
--INNER JOIN  tbl_Group grp  with (nolock)  ON grp.GroupId = rg.GroupId 
--INNER JOIN  tblTerritoryDataMigration tm   with (nolock)  ON tm.TerritoryId = tr.TerritoryId  where tm.MonthName='7' and tm.YearValue='2024' and rg.RegionName='Sylhet'

--   WITH PreAggregatedSales AS (
--    SELECT 
--        ord.TerritoryId,
--        CONVERT(DATE, A.UpdateDate) AS SalesDate,
--        SUM(CONVERT(DECIMAL(18, 2), ISNULL(ID.TotalPrice - ID.DiscountAmount, 0) 
--            - ISNULL(ID.AdjustmentAmount, 0))) AS TotalSales
--    FROM dbo.tblInvoice A WITH (NOLOCK)
--    INNER JOIN tblInvoiceDetail ID WITH (NOLOCK) ON A.InvoiceId = ID.InvoiceId
--    INNER JOIN tblOrder ord WITH (NOLOCK) ON ord.OrderId = A.OrderId
--    WHERE DeliveryInvoiceStatus IN ('Full', 'Partial')
--    GROUP BY ord.TerritoryId, CONVERT(DATE, A.UpdateDate)
--)
--SELECT 
--    grp.GroupName AS Group_Name,
--    grp.GroupCode AS Group_Code,
--    rg.RegionName AS Zone_Name,
--    rg.RegionCode AS Zone_Code,
--    ar.AreaName AS Area_Name,
--    ar.AreaCode AS Area_Code,
--    tm.TerritoryCode AS Territory_Code,
--    tr.TerritoryName AS Territory_Name,
--    DATENAME(MONTH, DATEFROMPARTS(2000, tm.MonthName, 1)) AS TargetMonth,
--    tm.YearValue AS TargetYear,
--    SUM(CAST(ISNULL(tm.Value, 0) AS DECIMAL(18, 2))) AS TargetValue,
--    SUM(tblSal.TotalSales) AS SalesValue,
--    tblSal.SalesDate AS SalesDate
--FROM tblTerritory tr WITH (NOLOCK)
--INNER JOIN tblArea ar WITH (NOLOCK) ON ar.AreaId = tr.AreaId
--INNER JOIN tblRegion rg WITH (NOLOCK) ON ar.RegionId = rg.RegionId
--INNER JOIN tbl_Group grp WITH (NOLOCK) ON grp.GroupId = rg.GroupId
--INNER JOIN tblTerritoryDataMigration tm WITH (NOLOCK) ON tm.TerritoryId = tr.TerritoryId
--LEFT JOIN PreAggregatedSales tblSal ON tblSal.TerritoryId = tr.TerritoryId
--    AND MONTH(tblSal.SalesDate) = tm.MonthName 
--    AND YEAR(tblSal.SalesDate) = tm.YearValue
--GROUP BY 
--    tm.MonthName, 
--    tm.YearValue, 
--    grp.GroupCode,
--    grp.GroupName,
--    rg.RegionCode,
--    rg.RegionName,
--    ar.AreaName,
--    ar.AreaCode,
--    tm.TerritoryCode,
--    tr.TerritoryName,
--    tblSal.SalesDate;


--   select  grp.GroupName Group_Name,grp.GroupCode Group_Code, rg.RegionName [Zone_Name], rg.RegionCode AS  [Zone_Code],ar.AreaName Area_Name, ar.AreaCode AS Area_Code,  
--             tm.TerritoryCode Territory_Code, tr.TerritoryName AS Territory_Name,   DATENAME(MONTH, DATEFROMPARTS(2000, tm.MonthName, 1)) targetMonth, tm.YearValue targetYear, sum(CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))) AS TargetValue, sum(TotalSales) SalesValue, SalesDate  SalesDate    from   
--        tblTerritory tr with (nolock)
--INNER JOIN  tblArea ar  with (nolock)  ON ar.AreaId = tr.AreaId
--INNER JOIN  tblRegion rg  with (nolock)  ON ar.RegionId = rg.RegionId
--INNER JOIN  tbl_Group grp  with (nolock)  ON grp.GroupId = rg.GroupId

--INNER JOIN  tblTerritoryDataMigration tm   with (nolock)  ON tm.TerritoryId = tr.TerritoryId

--left join (SELECT ord.TerritoryId ,  convert(Date,A.UpdateDate) SalesDate, convert(decimal(18,2), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
--,0)) TotalSales
--        FROM    dbo.tblInvoice A   with (nolock)
--		inner join tblInvoiceDetail ID    with (nolock) on A.InvoiceId=ID.InvoiceId
--		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
--   --     convert(Date,A.UpdateDate) between convert(Date, @FromDate) and convert(Date,@ToDate) and
--   WHERE DeliveryInvoiceStatus in ('Full','Partial')
	 
--		group by ord.TerritoryId,convert(Date,A.UpdateDate)) tblSal on tblSal.TerritoryId=tr.TerritoryId and MONTH( tblSal.SalesDate)=tm.MonthName and year(tblSal.SalesDate)=tm.YearValue

--		-- where CONVERT(date,SalesDate)='28-Jan-2024' and rg.RegionCode='RN-100'
--		group by tm.MonthName  , tm.YearValue ,   grp.GroupCode ,grp.GroupName, rg.RegionCode, rg.RegionName,  ar.AreaName , ar.AreaCode,tm.TerritoryCode, tr.TerritoryName,SalesDate 



















--   select    CASE
--       WHEN CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
--       ELSE CAST(ISNULL(OrderValue, 0) * 100.0 / CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
--   END as  OrderAchiv  ,  CASE
--       WHEN CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
--       ELSE CAST(ISNULL(InvoiceValue, 0) * 100.0 / CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
--   END as InvoiceAchiv,  CASE
--       WHEN CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) = 0 THEN 0
--       ELSE CAST(ISNULL(SalesValue, 0) * 100.0 / CAST(ISNULL( TargetValue, 0)  AS DECIMAL(18, 2)) AS DECIMAL(18, 2))
--   END as SalesAchiv, * from (
--	SELECT  
--    ROW_NUMBER() OVER (ORDER BY tm.TerritoryCode) AS SerialNo ,grp.GroupName Group_Name,grp.GroupCode Group_Code, rg.RegionName [Zone_Name], rg.RegionCode AS  [Zone_Code],ar.AreaName Area_Name, ar.AreaCode AS Area_Code,  
--             tm.TerritoryCode Territory_Code, tr.TerritoryName AS Territory_Name,
--   sum(CAST(ISNULL( tm.Value, 0)  AS DECIMAL(18, 2))) AS TargetValue,
--    (ISNULL( tblOrd.TotalOrder,0)) AS OrderValue,
    
--     (isnull(tblInv.TotalInvoice,0)) AS InvoiceValue ,
--     (isnull(tblSal.TotalSales, 0)) AS SalesValue ,OrderSubmissionDate Order_Submission_Date,InvoiceDate Invoice_Date,SalesDate Sales_Date, MIOCode MIO_Code, MIOName MIO_Name
--FROM 
--        tblTerritory tr with (nolock)
--INNER JOIN  tblArea ar  with (nolock)  ON ar.AreaId = tr.AreaId
--INNER JOIN  tblRegion rg  with (nolock)  ON ar.RegionId = rg.RegionId
--INNER JOIN  tbl_Group grp  with (nolock)  ON grp.GroupId = rg.GroupId

--INNER JOIN  tblTerritoryDataMigration tm   with (nolock)  ON tm.TerritoryId = tr.TerritoryId

--	left join (select Ord.OrderSenderCode MIOCode, Ord.OrderSenderName MIOName, Ord.TerritoryId, convert(Date,Ord.SubmissionDate) OrderSubmissionDate,  convert(decimal(18,2), ISNULL(sum(OrdD.TotalTradePrice)-sum(OrdD.DiscountAmount),0) )TotalOrder from tblOrder  Ord with (nolock) 
	
--inner join tblOrderDetail OrdD with (nolock)  on Ord.OrderId= OrdD.OrderId
--	where Ord.ActionStatus='2' 
--	--and  convert(Date,Ord.SubmissionDate) between convert(Date, @FromDate) and convert(Date,@ToDate)
--	Group by Ord.OrderSenderCode  , Ord.OrderSenderName, Ord.TerritoryId,convert(Date,Ord.SubmissionDate)) tblOrd on tblOrd.TerritoryId=tr.TerritoryId   and MONTH( tblOrd.OrderSubmissionDate)=tm.MonthName and year(tblOrd.OrderSubmissionDate)=tm.YearValue

--	left join (SELECT ord.TerritoryId ,convert(Date,A.InvoiceDate) InvoiceDate,   convert(decimal(18,2), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
--,0)) TotalInvoice
--        FROM    dbo.tblInvoice A   with (nolock)
--		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
--		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
--   --  WHERE   convert(Date,A.InvoiceDate) between convert(Date, @FromDate) and convert(Date,@ToDate)
	 
--		group by ord.TerritoryId,convert(Date,A.InvoiceDate) ) tblInv on tblInv.TerritoryId=tr.TerritoryId   and MONTH(tblInv.InvoiceDate)=tm.MonthName and year(tblInv.InvoiceDate)=tm.YearValue

--		left join (SELECT ord.TerritoryId ,  convert(Date,A.UpdateDate) SalesDate, convert(decimal(18,0), ISNULL(SUM(ID.TotalPrice-ID.DiscountAmount) - sum(ISNULL(ID.AdjustmentAmount,0)) 
--,0)) TotalSales
--        FROM    dbo.tblInvoice A   with (nolock)
--		inner join tblInvoiceDetail ID on A.InvoiceId=ID.InvoiceId
--		inner join tblOrder ord with (nolock) on ord.OrderId=A.OrderId 
--   --     convert(Date,A.UpdateDate) between convert(Date, @FromDate) and convert(Date,@ToDate) and
--   WHERE DeliveryInvoiceStatus in ('Full','Partial')
	 
--		group by ord.TerritoryId,convert(Date,A.UpdateDate)) tblSal on tblSal.TerritoryId=tr.TerritoryId and MONTH( tblSal.SalesDate)=tm.MonthName and year(tblSal.SalesDate)=tm.YearValue


--WHERE  tm.TerritoryId IS  not NULL  
--	group by  grp.GroupCode ,grp.GroupName, rg.RegionCode, rg.RegionName,  ar.AreaName , ar.AreaCode,tm.TerritoryCode, tr.TerritoryName,  (ISNULL( tblOrd.TotalOrder,0))  ,
    
--     (isnull(tblInv.TotalInvoice,0))  ,
--     (isnull(tblSal.TotalSales, 0))  , OrderSubmissionDate,InvoiceDate,SalesDate,  MIOCode, MIOName
--)tbl
 

 

