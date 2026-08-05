
CREATE PROCEDURE [dbo].[sp_Get_ALlOrderSummaryByChemist]
  @Parm  NVARCHAR(max) 
AS
BEGIN

DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'SELECT VCus.CustomerName,mas.CustomerCode,OrderSenderName+'' : ''+OrderSenderCode AS ReceieveBy,COUNT(OrderId)OrderCount,ISNULL(sum(mas.GrossValue-mas.TotalDiscount),0) OrderAmount FROM dbo.View_CustomerMaster_ActiveInactive VCus  with (nolock) 
LEFT JOIN dbo.tblOrder mas  with (nolock)  ON mas.CustomerMasterId=VCus.CustomerMasterId
LEFT JOIN dbo.tbluser us  with (nolock)  ON mas.EntryBy=us.UserId

 
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = us.EmpInfoId

 where mas.OrderId is not null
'+ @Parm+'
GROUP BY   VCus.CustomerName,mas.CustomerCode,OrderSenderName,OrderSenderCode
HAVING COUNT(OrderId)>0'

 EXEC(@SqlStatement)
 
END