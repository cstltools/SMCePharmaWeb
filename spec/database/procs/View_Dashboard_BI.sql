

 create PROCEDURE [dbo].[View_Dashboard_BI]   -- exec sp_GET_Dashboard_BI
	-- Add the parameters for the stored procedure here
   --@FinancialYearId NVARCHAR(max),
   --  @Month NVARCHAR(max),
   --     @ZoneId NVARCHAR(max) ,
   --             @AreaId NVARCHAR(max)  
AS
    BEGIN

     Declare @Year int = 2026
    Declare @Month int = 1

    DECLARE @FromDate DATE = DATEFROMPARTS(@Year, @Month, 1);
    DECLARE @ToDate   DATE = DATEADD(MONTH, 1, @FromDate);
    
-- DECLARE @FinancialYearId INT = 3;  -- FY Id (mandatory)
--DECLARE @Month INT = 1;            -- mandatory (1-12)
--DECLARE @ZoneId INT = 1;           -- NULL হলে National
--DECLARE @AreaId INT = 1;           -- NULL হলে All Areas
DECLARE @StartDate DATETIME, @EndDate DATETIME;

SELECT 
    @StartDate = fy.StartDate,
    @EndDate   = fy.EndDate
FROM tblFinancialYear fy
--WHERE fy.FinancialYearId = @FinancialYearId
 

SELECT 
    @Year  AS SalesYear,
           @Month AS SalesMonth,
           DATENAME(MONTH, @FromDate) AS SalesMonthName,

    SUM(od.Quantity) AS MTDOrderQuantity ,  SUM(od.Quantity) AS YTDOrderQuantity ,  
    SUM(od.Quantity) AS MTDInvoiceQuantity ,  SUM(od.Quantity) AS YTDInvoiceQuantity , 
     SUM(od.Quantity) AS MTDSaleQuantity ,  SUM(od.Quantity) AS YTDSaleQuantity , 
       SUM(od.Quantity) AS MTDtReturnQuantity ,  SUM(od.Quantity) AS YTDReturnQuantity , 
       SUM(od.TotalTradePrice) AS MTDOrderAmount ,  SUM(od.TotalTradePrice) AS YTDOrderAmount, 
        SUM(od.TotalTradePrice) AS MTDInvoiceAmount ,  SUM(od.TotalTradePrice) AS YTDInvoiceAmount , 
         SUM(od.TotalTradePrice) AS MTDSaleAmount ,  SUM(od.TotalTradePrice) AS YTDSaleAmount , 
           SUM(od.TotalTradePrice) AS MTDtReturnAmount ,  SUM(od.TotalTradePrice) AS YTDReturnAmount ,
            SUM(od.TotalTradePrice) AS MTDOrderLPC  ,  SUM(od.TotalTradePrice) AS YTDOrderLPC , 
            SUM(od.TotalTradePrice) AS MTDInvoiceLPC  ,  SUM(od.TotalTradePrice) AS YTDInvoiceLPC ,
              SUM(od.TotalTradePrice) AS MTDSaleLPC  ,  SUM(od.TotalTradePrice) AS YTDSaleLPC  , 
               SUM(od.TotalTradePrice) AS MTDtReturnLPC  ,  SUM(od.TotalTradePrice) AS YTDReturnLPC , 
    o.RegionId as ZoneID, o.AreaId as AreaID
         
FROM tblOrder o
INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
WHERE
   
     MONTH(o.SubmissionDate) = 1
    AND Year(o.SubmissionDate) = 2026
    and o.RegionId=1  and o.AreaId=3

    group by o.RegionId , o.AreaId 
    --AND (@ZoneId IS NULL OR o.RegionId = @ZoneId)
    --AND (@AreaId IS NULL OR o.AreaId = @AreaId);



    
--SELECT 
--    SUM(od.Quantity) AS MTDInvoiceQuantity ,  SUM(od.Quantity) AS YTDInvoiceQuantity ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
 
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--      and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 

--    SELECT 
--    SUM(od.Quantity) AS MTDSaleQuantity ,  SUM(od.Quantity) AS YTDSaleQuantity ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
 
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--       and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 

    
--    SELECT 
--    SUM(od.Quantity) AS MTDtReturnQuantity ,  SUM(od.Quantity) AS YTDReturnQuantity ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
  
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--       and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 




    ----

--    SELECT 
--    SUM(od.TotalTradePrice) AS MTDOrderAmount ,  SUM(od.TotalTradePrice) AS YTDOrderAmount,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
   
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--     and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 


    
--SELECT 
--    SUM(od.TotalTradePrice) AS MTDInvoiceAmount ,  SUM(od.TotalTradePrice) AS YTDInvoiceAmount ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
 
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--     and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 


--    SELECT 
--    SUM(od.TotalTradePrice) AS MTDSaleAmount ,  SUM(od.TotalTradePrice) AS YTDSaleAmount ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
    
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
-- and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 

    
--    SELECT 
--    SUM(od.TotalTradePrice) AS MTDtReturnAmount ,  SUM(od.TotalTradePrice) AS YTDReturnAmount ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
 
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--     and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 


    --------------



--       SELECT 
--    SUM(od.TotalTradePrice) AS MTDOrderLPC  ,  SUM(od.TotalTradePrice) AS YTDOrderLPC ,   o.RegionId as ZoneID, o.AreaId as AreaID
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
   
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--      and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 


    
--SELECT 
--    SUM(od.TotalTradePrice) AS MTDInvoiceLPC  ,  SUM(od.TotalTradePrice) AS YTDInvoiceLPC ,   o.RegionId as ZoneID, o.AreaId as AreaID 
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
  
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--      and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 



--    SELECT 
--    SUM(od.TotalTradePrice) AS MTDSaleLPC  ,  SUM(od.TotalTradePrice) AS YTDSaleLPC  ,   o.RegionId as ZoneID, o.AreaId as AreaID 
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
 
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--       and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 

    
--    SELECT 
--    SUM(od.TotalTradePrice) AS MTDtReturnLPC  ,  SUM(od.TotalTradePrice) AS YTDReturnLPC ,   o.RegionId as ZoneID, o.AreaId as AreaID 
--FROM tblOrder o
--INNER JOIN tblOrderDetail od ON o.OrderId = od.OrderId
--WHERE
   
--     MONTH(o.SubmissionDate) = 1
--    AND Year(o.SubmissionDate) = 2026
--     and o.RegionId=1  and o.AreaId=3
--          group by o.RegionId , o.AreaId 

      
    END


