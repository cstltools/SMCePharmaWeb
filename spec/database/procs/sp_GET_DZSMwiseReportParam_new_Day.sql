
CREATE PROCEDURE [dbo].[sp_GET_DZSMwiseReportParam_new_Day] 

    @FromDate nvarchar(Max),
	@ToDate nvarchar(Max),
	@parm  nvarchar(Max)
		
AS
BEGIN
DECLARE @SqlStatement NVARCHAR(MAX)

DECLARE @Month int 
DECLARE @year int 



 set @Month=  MONTH(CONVERT(date, @FromDate))

 set @year= Year(CONVERT(date, @FromDate))

  

SET @SqlStatement = N'Select [AreaCode]
      ,[AreaName]
      ,sum(NumberofProformaInvoice) [NumberofProformaInvoice]
      ,sum([SumofNetProformaAmount]) SumofNetProformaAmount
      ,sum([ProTpVat]) ProTpVat
      ,sum([NumberofInvoiceSold])NumberofInvoiceSold
      ,sum([SumofNetSalesAmount])SumofNetSalesAmount
      ,sum([DelTpVat])DelTpVat
      ,sum([NumberofReturnInvoice])NumberofReturnInvoice
      ,sum([SumofNetReturnAmount])SumofNetReturnAmount
      ,sum([DelReTpVat])DelReTpVat
      ,sum([CustomerCoverPer])CustomerCoverPer
      ,sum([SumofNetSalesAmountFixed])SumofNetSalesAmountFixed
      ,sum([SumofNetSalesAmountCamp])SumofNetSalesAmountCamp
      ,sum([FinalSales])FinalSales
      ,sum([SumofNetSalesAmountFixed2])SumofNetSalesAmountFixed2
      ,sum([SumofNetSalesAmountCamp2])SumofNetSalesAmountCamp2
      ,sum([FinalSales2])FinalSales2
      ,sum([CustomerCoverPerProforma])CustomerCoverPerProforma
      ,sum([BlueNetSell])BlueNetSell
      ,sum([GreenNetSell])GreenNetSell
      ,sum([DelBlueNetSell])DelBlueNetSell
      ,sum([DelGreenNetSell])DelGreenNetSell
      ,sum([BlueCov])BlueCov
      ,sum([greenCov])greenCov
      ,sum([DelBlueCov])DelBlueCov
      ,sum([DelgreenCov]) DelgreenCov from  tblDZSMwiseReportParam with (nolock)

 where  RegionId is not null  and convert(Date,ProcessDate)  between '''+CAST(@FromDate as nvarchar(max))+''' and  '''+CAST(@ToDate as nvarchar(max))+''''+ @parm +  ' group by  [AreaCode]
      ,[AreaName]  order by AreaCode asc'
  EXEC(@SqlStatement)
END
