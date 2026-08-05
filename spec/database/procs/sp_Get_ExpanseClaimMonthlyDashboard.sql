
CREATE

 PROCEDURE [dbo].[sp_Get_ExpanseClaimMonthlyDashboard]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max),

	@param nvarchar(max)

AS
BEGIN 
  
 

    DECLARE @Q NVARCHAR(MAX)='SELECT ety.ExpenseTypeName Criteria,SUM(Amount)Amount FROM dbo.tbl_ExpenseClaim mas with (nolock)
 left join tbl_ExpenseTypeMaster ety with (nolock) on mas.ExpenseTypeId=ety.ExpenseTypeId

WHERE mas.ExpenseClaimID is not null '+@param+' 
   GROUP BY ety.ExpenseTypeName'

						
EXEC sp_executesql @Q

END
             
   
--     union all SELECT ''Total'' Criteria,SUM(Amount)Amount FROM dbo.tbl_ExpenseClaim mas with (nolock)
  
--WHERE mas.ExpenseClaimID is not null  '+@param


