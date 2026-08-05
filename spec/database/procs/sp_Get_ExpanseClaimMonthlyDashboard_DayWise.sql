
CREATE

 PROCEDURE [dbo].[sp_Get_ExpanseClaimMonthlyDashboard_DayWise]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max),

	@param nvarchar(max)

AS
BEGIN 
  
 

    DECLARE @Q NVARCHAR(MAX)='SELECT  Convert(Date,mas.ExpenseDate) ExpenseDate,  FORMAT(mas.ExpenseDate, ''dd-MMM'') Criteria,isnull(SUM(Amount),0)Amount FROM dbo.tbl_ExpenseClaim mas with (nolock)
  

WHERE mas.ExpenseClaimID is not null '+@param+' 
  group by Convert(Date,mas.ExpenseDate), FORMAT(mas.ExpenseDate, ''dd-MMM'')  
  having isnull(SUM(Amount),0)>0
    order by Convert(Date,mas.ExpenseDate) asc'

						
EXEC sp_executesql @Q

END
             
   
--     union all SELECT ''Total'' Criteria,SUM(Amount)Amount FROM dbo.tbl_ExpenseClaim mas with (nolock)
  
--WHERE mas.ExpenseClaimID is not null  '+@param


