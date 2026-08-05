-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_ExpenseClaim]
	-- Add the parameters for the stored procedure here
@id int,

@typeid INT ,
	@expDate DATETIME,
	@empId int,
	@amount DECIMAL(18,2),
	@remarks NVARCHAR(max) = NULL,
	@isFromApp bit
AS
BEGIN


UPDATE [dbo].[tbl_ExpenseClaim]
   SET [ExpenseTypeId] = @typeid 
      ,[ExpenseDate] = @expDate 
      ,[EmpInfoId] = @empId 
      ,[Amount] = @Amount 
      ,[Remarks] = @Remarks 
     
       
   
      ,[IsFromApp] = @IsFromApp 
       
      ,[UpdateBy] = @empId
      ,[UpdateDate] = getdate() 
	  where ExpenseClaimID=@id
	
	INSERT INTO  [tbl_ExpenseClaimDetailsDel] ([ExpenseDetailId]
      ,[ExpenseClaimID]
      ,[ExpenseTypDetailsId]
      ,[ValueText])
SELECT  [ExpenseDetailId]
      ,[ExpenseClaimID]
      ,[ExpenseTypDetailsId]
      ,[ValueText]
  FROM [dbo].tbl_ExpenseClaimDetails
 
WHERE ExpenseClaimID=@id 
 
	DELETE FROM dbo.tbl_ExpenseClaimDetails WHERE ExpenseClaimID =@id



END

