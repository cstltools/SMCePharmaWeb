CREATE PROCEDURE [dbo].[sp_Get_ALlOrderSummaryByChemist_Pivot]
  @Parm  NVARCHAR(max) ,
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max)
AS
BEGIN

DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N' SELECT * FROM (SELECT  mas.TerritoryCode_Ord +'' : ''+ mas.TerritoryName_Ord [Territory], mas.MarketCode_Ord +'' : ''+ mas.MarketName_Ord [Market], VCus.CustomerName [Customer Name],mas.CustomerCode [Customer Code],OrderSenderName+'' : ''+OrderSenderCode AS [Received By],ISNULL(sum(mas.GrossValue-mas.TotalDiscount),0) OrderAmount,  format(mas.SubmissionDate,''MMM-yyyy'')  SubmissionDate FROM dbo.View_CustomerMaster_ActiveInactive VCus  with (nolock) 
LEFT JOIN dbo.tblOrder mas  with (nolock)  ON mas.CustomerMasterId=VCus.CustomerMasterId
LEFT JOIN dbo.tbluser us  with (nolock)  ON mas.EntryBy=us.UserId

 
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = us.EmpInfoId

 where mas.OrderId is not null '+ @Parm+'
 
GROUP BY   mas.TerritoryCode_Ord +'' : ''+ mas.TerritoryName_Ord, mas.MarketCode_Ord +'' : ''+ mas.MarketName_Ord,   VCus.CustomerName,mas.CustomerCode,OrderSenderName,OrderSenderCode,format(mas.SubmissionDate,''MMM-yyyy'')
HAVING COUNT(OrderId)>0 


) StudentResults
    PIVOT (
      SUM([OrderAmount])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable   order by Territory asc
  ';

 EXEC(@SqlStatement)
 
END