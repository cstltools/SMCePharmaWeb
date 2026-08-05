
CREATE

 PROCEDURE [dbo].[sp_Get_DAMonthlyDashboard_DayWise]
	-- Add the parameters for the stored procedure here

	@Month nvarchar(max),
	@Year nvarchar(max),

	@param nvarchar(max)

AS
BEGIN 
  
 

    DECLARE @Q NVARCHAR(MAX)='SELECT  Convert(Date,mas.TadaDate) ExpenseDate,  FORMAT(mas.TadaDate, ''dd-MMM'') Criteria,isnull(SUM(DAAmount),0) Amount FROM dbo.tbl_TadaClaimMaster mas with (nolock)
  

WHERE mas.TadaID is not null '+@param+' 
  group by Convert(Date,mas.TadaDate), FORMAT(mas.TadaDate, ''dd-MMM'')  
    having isnull(SUM(DAAmount),0)>0
    order by Convert(Date,mas.TadaDate) asc'

						
EXEC sp_executesql @Q

END
             
   
--     union all SELECT ''Total'' Criteria,SUM(Amount)Amount FROM dbo.tbl_ExpenseClaim mas with (nolock)
  
--WHERE mas.ExpenseClaimID is not null  '+@param


