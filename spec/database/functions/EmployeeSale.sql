
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[EmployeeSale]
(
    --@FromDate NVARCHAR(MAX),
	--@ToDate NVARCHAR(MAX)
)
RETURNS 

		@MasterTable TABLE 
		(
				RowNo int Identity(1,1) Primary Key not null,
				SalesManCode NVARCHAR(MAX) NULL,
				SalesManName NVARCHAR(MAX) NULL,
				SaleAmount decimal(18,2) NULL,
				Designation NVARCHAR(MAX),vat decimal(18,2) NULL,Discount decimal(18,2) NULL,NetSales decimal(18,2) NULL,TDqty decimal(18,2) NULL,
				ProductName NVARCHAR(MAX)
				
		)

		AS

		BEGIN
		INSERT INTO @MasterTable
				( 
				 SalesManCode ,
				SalesManName ,
				SaleAmount ,
				Designation ,
				Discount, vat,NetSales,TDqty,ProductName
				)



			SELECT  MioCode as SalesManCode,MIAName as SalesManName,TotalAmount as SaleAmount, Designation,Discount,vat,NetSales,TDqty,ProductName
					FROM (
		select tblO.MioCode,tblSS.MiaName,tblSS.Designation,tblO.TDqty,tblSS.TotalAmount,tblSS.Discount,tblSS.vat,tblSS.NetSales,ProductName from (
	
	SELECT  Distinct I.MIACode as MioCode,sum(DeliveryQuantity)TDqty,tblProduct.ProductName
			
			from tblInvoice I
			inner join tblInvoiceDetail on I.InvoiceId=tblInvoiceDetail.InvoiceId
			inner join tblProduct on tblInvoiceDetail.ProductCode=tblProduct.ProductCode
			inner  JOIN tblMIAInfo M ON I.MIACode = M.MIACode
			GROUP BY I.MIACode  , M.MIAName,tblProduct.ProductName) tblO left join  
			(
				SELECT  Distinct I.MIACode as MioCode , M.MIAName , 'MIO' as Designation , sum(DeliveryTpGrandTotal)TotalAmount,sum(DeliveryTpDiscount)Discount,
			sum(DeliveryTpVat)vat,(sum(DeliveryTpTotal)-sum(DeliveryTpDiscount))NetSales
			
					from tblInvoice I
			
			inner  JOIN tblMIAInfo M ON I.MIACode = M.MIACode
			
			GROUP BY I.MIACode  , M.MIAName)tblSS on tblO.MioCode=tblSS.MioCode

			) AS tblQ 
			--WHERE CONVERT(DATE,(MonthYear)) BETWEEN @FromDate  AND @ToDate 


			union all

			SELECT DZSMCODE as SalesManCode,DZSMNAME as SalesManName,TotalAmount as SaleAmount, Designation,Discount,vat,NetSales,TDqty,ProductName
					FROM (
		select tblO.DZSMCODE,tblSS.DZSMNAME,tblSS.Designation,tblO.TDqty,tblSS.TotalAmount,tblSS.Discount,tblSS.vat,tblSS.NetSales,ProductName from (
	
	SELECT  Distinct I.RegionCode as DZSMCODE ,sum(DeliveryQuantity)TDqty,tblProduct.ProductName
			
			from tblInvoice I
			inner join tblInvoiceDetail on I.InvoiceId=tblInvoiceDetail.InvoiceId
			inner join tblProduct on tblInvoiceDetail.ProductCode=tblProduct.ProductCode
			inner  JOIN tblRegion R ON I.RegionCode = R.RegionCode
			GROUP BY I.RegionCode,R.RegionName,tblProduct.ProductName) tblO left join  
			(
				SELECT  Distinct I.RegionCode as DZSMCODE , R.RegionName as DZSMNAME , 'DZSM' as Designation , sum(DeliveryTpGrandTotal)TotalAmount,sum(DeliveryTpDiscount)Discount,
			sum(DeliveryTpVat)vat,(sum(DeliveryTpTotal)-sum(DeliveryTpDiscount))NetSales
			
					from tblInvoice I
			
			inner  JOIN tblRegion R ON I.RegionCode = R.RegionCode
			
			GROUP BY I.RegionCode,R.RegionName)tblSS on tblO.DZSMCODE=tblSS.DZSMCODE

			) AS tblQ 
			--WHERE CONVERT(DATE,(MonthYear)) BETWEEN @FromDate  AND @ToDate 


			union all

		SELECT FECode as SalesManCode,DistrictName as SalesManName,TotalAmount as SaleAmount, Designation,Discount,vat,NetSales,TDqty,ProductName
					FROM (
		select tblO.FECode,tblSS.DistrictName,tblSS.Designation,tblO.TDqty,tblSS.TotalAmount,tblSS.Discount,tblSS.vat,tblSS.NetSales,ProductName from (
	
	SELECT  Distinct I.DisCode as FECode,sum(DeliveryQuantity)TDqty,tblProduct.ProductName
			
			from tblInvoice I
			inner join tblInvoiceDetail on I.InvoiceId=tblInvoiceDetail.InvoiceId
			inner join tblProduct on tblInvoiceDetail.ProductCode=tblProduct.ProductCode
			inner  JOIN tblDistrict D ON I.DisCode = D.DistrictCode
			GROUP BY I.DisCode  , D.DistrictName,tblProduct.ProductName) tblO left join  
			(
				SELECT  Distinct I.DisCode as FECode , D.DistrictName , 'FE' as Designation , sum(DeliveryTpGrandTotal)TotalAmount,sum(DeliveryTpDiscount)Discount,
			sum(DeliveryTpVat)vat,(sum(DeliveryTpTotal)-sum(DeliveryTpDiscount))NetSales
			
					from tblInvoice I
			
		inner  JOIN tblDistrict D ON I.DisCode = D.DistrictCode
			
			GROUP BY I.DisCode  , D.DistrictName)tblSS on tblO.FECode=tblSS.FECode

			) AS tblQ 
			--WHERE CONVERT(DATE,(MonthYear)) BETWEEN @FromDate  AND @ToDate 







		--DECLARE @SalesManCode NVARCHAR(MAX)
		--DECLARE @SaleAmount decimal(18,2)

		--DECLARE @Main CURSOR
		--SET @Main = CURSOR FAST_FORWARD
		--FOR
		--SELECT SalesManCode,SUM(SaleAmount) FROM @MasterTable GROUP BY SalesManCode
		--OPEN @Main
		--FETCH NEXT FROM @Main
		--INTO @SalesManCode,@SaleAmount
		--WHILE @@FETCH_STATUS=0
		--BEGIN
		--UPDATE @MasterTable SET TotalSaleAmount=@SaleAmount   WHERE  SalesManCode=@SalesManCode

		--FETCH NEXT FROM @Main
		--INTO  @SalesManCode,@SaleAmount
		--END
		--CLOSE @Main
		--DEALLOCATE @Main

















		RETURN
		END




