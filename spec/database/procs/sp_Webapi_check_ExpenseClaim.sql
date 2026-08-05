


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_check_ExpenseClaim]
	-- Add the parameters for the stored procedure here
	 @typeid  INT , @id  INT ,@EmpInfoId int,@ExpenseDate datetime 
AS
BEGIN
		 
	SELECT * FROM dbo.tbl_ExpenseClaim WHERE EmpInfoId=@EmpInfoId and CONVERT(date, ExpenseDate)=CONVERT(date,@ExpenseDate) and    ExpenseTypeId=@typeid AND ExpenseClaimID NOT IN ( @id)  

END




