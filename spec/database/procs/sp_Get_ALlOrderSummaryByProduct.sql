CREATE PROCEDURE [dbo].[sp_Get_ALlOrderSummaryByProduct]
  @Parm  NVARCHAR(max) 
AS
BEGIN

DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'SELECT dtl.ProductCode,dtl.ProductName,mas.OrderSenderName+'' : ''+mas.OrderSenderCode AS ReceieveBy
,COUNT(mas.OrderId) AS OrderCount,COUNT(dtl.ProductId) ProductCount,ISNULL(sum(dtl.TotalTradePrice),0)  OrderAmount
,COUNT(CustomerMasterId)CustCount
 FROM dbo.tblProduct pro   with (nolock) 
LEFT JOIN dbo.tblOrderDetail dtl   with (nolock)  ON dtl.ProductId = pro.ProductId
LEFT JOIN dbo.tblOrder  mas  with (nolock)  ON mas.OrderId=dtl.OrderId
LEFT JOIN dbo.tbluser us  with (nolock)  ON mas.EntryBy=us.UserId

 
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = us.EmpInfoId
where mas.OrderId is not null
'+ @Parm+'
group by  dtl.ProductCode,dtl.ProductName,mas.OrderSenderName+'' : ''+mas.OrderSenderCode '

 EXEC(@SqlStatement)
 
END
