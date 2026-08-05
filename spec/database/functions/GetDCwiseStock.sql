
-- =============================================
-- Author:      <Author,,Name>
-- Create date: <Create Date,,>
-- Description: <Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetDCwiseStock]
(

)
RETURNS 

		@MasterTable TABLE 
		(
				RowNo int Identity(1,1) Primary Key not null,
				DistributionCenterCode NVARCHAR(MAX) NULL,
				DistributionCenter NVARCHAR(MAX) NULL,
				StockQty INT NULL,
				TotalValue decimal(18,2) NULL,
				Total INT,
				TotalValueAmount decimal(18,2) NULL,
				ProductName NVARCHAR(MAX),
				ProductCode NVARCHAR(MAX)
		)

		AS

		BEGIN
		INSERT INTO @MasterTable
				( 
				  DistributionCenterCode,
				  DistributionCenter ,
				  StockQty ,
				  TotalValue,
				  ProductName,
				  ProductCode
				)


		SELECT  ComUnitCode,ComUnitName ,Stock ,TotalValue,ProductName,tblQ.ProductCode
		FROM 
		(

		select ComUnitCode,ComUnitName,tblCompanyUnit.ComUnitId,Sum(StockQty)Stock,tblDCStore.ProductCode,Sum(StockQty) * (tblPP.TotalProductValue) as TotalValue  from tblDCStore 
		inner join tblCompanyUnit on tblDCStore.ComUnitId=tblCompanyUnit.ComUnitId
		inner join (select ProductCode,(UnitPrice+VATAmountPerUnit) as TotalProductValue from tblUnitPrice where IsActive=1  ) tblPP  on tblDCStore.ProductCode=tblPP.ProductCode
		group by ComUnitName,tblCompanyUnit.ComUnitId,tblDCStore.ProductCode,ComUnitCode,tblPP.TotalProductValue

        ) AS tblQ 

		left join  (select ProductId,ProductCode,ProductName from tblProduct) tblProduct on tblQ.ProductCode=tblProduct.ProductCode 
		union all 

		select 'WH01' as  ComUnitCode ,'Central Wearhouse' as ComUnitName,sum(Quantity)Stock , sum(Quantity)* (UnitPrice+VATPerUnit) TotalValue,P.ProductName,P.ProductCode
		from tblCentralStore W
		inner join tblProduct P on W.ProductId = P.ProductId
		group by  P.ProductName,P.ProductCode,UnitPrice,VATPerUnit


		DECLARE @DistributionCenter NVARCHAR(MAX)
		DECLARE @TotalQty Int
		DECLARE @Totalvalue decimal(18,2)


		DECLARE @Main CURSOR
		SET @Main = CURSOR FAST_FORWARD
		FOR
		SELECT DistributionCenter,SUM(StockQty),sum(TotalValue) FROM @MasterTable GROUP BY DistributionCenter
		OPEN @Main
		FETCH NEXT FROM @Main
		INTO @DistributionCenter,@TotalQty,@Totalvalue
		WHILE @@FETCH_STATUS=0
		BEGIN
		UPDATE @MasterTable SET Total=@TotalQty,TotalValueAmount=@Totalvalue   WHERE  DistributionCenter=@DistributionCenter

		FETCH NEXT FROM @Main
		INTO  @DistributionCenter,@TotalQty,@Totalvalue
		END
		CLOSE @Main
		DEALLOCATE @Main

		RETURN
		END



