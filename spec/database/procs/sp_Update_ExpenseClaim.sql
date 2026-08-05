
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_ExpenseClaim]
	-- Add the parameters for the stored procedure here
  @ExpenseClaimID INT,
	@ExpenseTypeId INT=null,
    @ExpenseDate DATETIME =Null ,
	@EmpInfoId  INT=null,
	@Amount  DECIMAL=null,
	@Remarks  NVARCHAR(max)=null,
	@UpdateBy NVARCHAR(50) 
AS
    BEGIN
	INSERT INTO tbl_ExpenseClaimLog ([ExpenseTypeId]
           ,[ExpenseDate]
           ,[EmpInfoId]
           ,[Amount]
           ,[Remarks]
           ,[ImageName]
           ,[ImagePath]
           ,[EntryBy]
           ,[EntryDate]
           ,[ApprovalStatus]
           ,[IsFromApp]
           ,[ApprovedBy]
           ,[ApprovedDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,[DelBy]
           ,[DelDate])
SELECT [ExpenseTypeId]
           ,[ExpenseDate]
           ,[EmpInfoId]
           ,[Amount]
           ,[Remarks]
           ,[ImageName]
           ,[ImagePath]
           ,[EntryBy]
           ,[EntryDate]
           ,[ApprovalStatus]
           ,[IsFromApp]
           ,[ApprovedBy]
           ,[ApprovedDate]
           ,[UpdateBy]
           ,[UpdateDate]
           ,@UpdateBy
           ,GETDATE()
FROM tbl_ExpenseClaim
WHERE  ExpenseClaimID=@ExpenseClaimID

        UPDATE [dbo].[tbl_ExpenseClaim]
   SET [ExpenseTypeId] =@ExpenseTypeId 
      ,[ExpenseDate] =@ExpenseDate 
      ,[EmpInfoId] =@EmpInfoId 
      ,[Amount] =@Amount 
      ,[Remarks] =@Remarks 
    
       
      ,[IsFromApp] =0,
       UpdateBy=@UpdateBy,
	   UpdateDate=GETDATE()
	   WHERE  ExpenseClaimID=@ExpenseClaimID
		Delete from tbl_ExpenseClaimDetails where ExpenseClaimID = @ExpenseClaimID
    END


