

-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetDateWiseSale]
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
				MainDate NVARCHAR(MAX)
				
		)

		AS

		BEGIN
		INSERT INTO @MasterTable
				( 
				 SalesManCode ,
				SalesManName ,
				SaleAmount ,
				Designation ,
				MainDate 
				)



			SELECT  MioCode as SalesManCode,MIAName as SalesManName,TotalAmount as SaleAmount, Designation,MainDate
					FROM (
			SELECT  Distinct I.MIACode as MioCode , M.MIAName , 'MIO' as Designation , sum(DeliveryTpGrandTotal)TotalAmount
			,UpdateDate as MainDate
			from tblInvoice I
			inner  JOIN tblMIAInfo M ON I.MIACode = M.MIACode
			GROUP BY I.MIACode  , M.MIAName,UpdateDate

			) AS tblQ WHERE MainDate BETWEEN @FromDate  AND @ToDate 


			union all

			SELECT  DZSMCODE as SalesManCode,DZSMNAME as SalesManName,TotalAmount as SaleAmount, Designation,MainDate
					FROM (
			SELECT  Distinct I.RegionCode as DZSMCODE , R.RegionName as DZSMNAME , 'DZSM' as Designation , sum(DeliveryTpGrandTotal)TotalAmount
,UpdateDate as MainDate
from tblInvoice I
inner  JOIN tblRegion R ON I.RegionCode = R.RegionCode
GROUP BY I.RegionCode,R.RegionName,UpdateDate

			) AS tblQ WHERE MainDate BETWEEN @FromDate  AND @ToDate 


			union all

			SELECT  FECode as SalesManCode,DistrictName as SalesManName,TotalAmount as SaleAmount, Designation,MainDate
					FROM (
			SELECT  Distinct I.DisCode as FECode , D.DistrictName , 'FE' as Designation , sum(DeliveryTpGrandTotal)TotalAmount
			,UpdateDate as MainDate
			from tblInvoice I
			inner  JOIN tblDistrict D ON I.DisCode = D.DistrictCode
			GROUP BY I.DisCode  , D.DistrictName,UpdateDate

			) AS tblQ WHERE MainDate BETWEEN @FromDate  AND @ToDate 



		RETURN
		END





