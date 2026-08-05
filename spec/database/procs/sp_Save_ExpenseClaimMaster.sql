
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ExpenseClaimMaster]
	-- Add the parameters for the stored procedure here
	@ExpenseClaimID INT,
	@ExpenseTypeId INT=null,
    @ExpenseDate DATETIME =Null ,
	@EmpInfoId  INT=null,
	@Amount  DECIMAL=null,
	@Remarks  NVARCHAR(max)=null,
	 
    @EntryBy NVARCHAR(50) =null
AS
    BEGIN
	
        INSERT INTO [dbo].[tbl_ExpenseClaim]
           ([ExpenseTypeId]
           ,[ExpenseDate]
           ,[EmpInfoId]
           ,[Amount]
           ,[Remarks]
          
           ,[EntryBy]
           ,[EntryDate]
           ,[ApprovalStatus]
           ,[IsFromApp]
           )
     VALUES
           (@ExpenseTypeId 
           ,@ExpenseDate 
           ,@EmpInfoId 
           ,@Amount 
           ,@Remarks 
         
           ,@EntryBy 
           ,GETDATE() 
           ,'2' 
           ,0
        )

SELECT SCOPE_IDENTITY()

END


