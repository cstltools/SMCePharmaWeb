
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetMonthWiseSale]
(
    @FromDate NVARCHAR(MAX),
	@ToDate NVARCHAR(MAX)
)
RETURNS 

		@MasterTable TABLE 
		(
				RowNo int Identity(1,1) Primary Key not null,
				SalesManCode NVARCHAR(MAX) NULL,
				SalesManName NVARCHAR(MAX) NULL,
				SaleAmount decimal(18,2) NULL,
				Designation NVARCHAR(MAX),
				MonthYear NVARCHAR(MAX),
				TotalSaleAmount decimal(18,2) NULL
		)

		AS

		BEGIN
		INSERT INTO @MasterTable
				( 
				 SalesManCode ,
				SalesManName ,
				SaleAmount ,
				Designation ,
				MonthYear 
				)



			SELECT  MioCode as SalesManCode,MIAName as SalesManName,TotalAmount as SaleAmount, Designation,datename(month, convert(Date,MonthYear))MonthYear
					FROM (
			SELECT  Distinct I.MIACode as MioCode , M.MIAName , 'MIO' as Designation , sum(DeliveryTpGrandTotal)TotalAmount
			,'1-'+(datename(month, UpdateDate))+'-'+CONVERT(nvarchar(20),year(UpdateDate)) as MonthYear 
			from tblInvoice I
			inner  JOIN tblMIAInfo M ON I.MIACode = M.MIACode
			GROUP BY I.MIACode  , M.MIAName,datename(month, UpdateDate),CONVERT(nvarchar(20),year(UpdateDate))

			) AS tblQ WHERE CONVERT(DATE,(MonthYear)) BETWEEN @FromDate  AND @ToDate 


			union all

			SELECT  DZSMCODE as SalesManCode,DZSMNAME as SalesManName,TotalAmount as SaleAmount, Designation,datename(month, convert(Date,MonthYear))MonthYear
					FROM (
			SELECT  Distinct I.RegionCode as DZSMCODE , R.RegionName as DZSMNAME , 'DZSM' as Designation , sum(DeliveryTpGrandTotal)TotalAmount
,'1-'+(datename(month, UpdateDate))+'-'+CONVERT(nvarchar(20),year(UpdateDate)) as MonthYear
from tblInvoice I
inner  JOIN tblRegion R ON I.RegionCode = R.RegionCode
GROUP BY I.RegionCode,R.RegionName,datename(month, UpdateDate),CONVERT(nvarchar(20),year(UpdateDate))

			) AS tblQ WHERE CONVERT(DATE,(MonthYear)) BETWEEN @FromDate  AND @ToDate 


			union all

			SELECT  FECode as SalesManCode,DistrictName as SalesManName,TotalAmount as SaleAmount, Designation,datename(month, convert(Date,MonthYear))MonthYear
					FROM (
			SELECT  Distinct I.DisCode as FECode , D.DistrictName , 'FE' as Designation , sum(DeliveryTpGrandTotal)TotalAmount
			,'1-'+(datename(month, UpdateDate))+'-'+CONVERT(nvarchar(20),year(UpdateDate)) as MonthYear
			from tblInvoice I
			inner  JOIN tblDistrict D ON I.DisCode = D.DistrictCode
			GROUP BY I.DisCode  , D.DistrictName,datename(month, UpdateDate),CONVERT(nvarchar(20),year(UpdateDate))

			) AS tblQ WHERE CONVERT(DATE,(MonthYear)) BETWEEN @FromDate  AND @ToDate 







		DECLARE @SalesManCode NVARCHAR(MAX)
		DECLARE @SaleAmount decimal(18,2)

		DECLARE @Main CURSOR
		SET @Main = CURSOR FAST_FORWARD
		FOR
		SELECT SalesManCode,SUM(SaleAmount) FROM @MasterTable GROUP BY SalesManCode
		OPEN @Main
		FETCH NEXT FROM @Main
		INTO @SalesManCode,@SaleAmount
		WHILE @@FETCH_STATUS=0
		BEGIN
		UPDATE @MasterTable SET TotalSaleAmount=@SaleAmount   WHERE  SalesManCode=@SalesManCode

		FETCH NEXT FROM @Main
		INTO  @SalesManCode,@SaleAmount
		END
		CLOSE @Main
		DEALLOCATE @Main

















		RETURN
		END




