
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_ExpenseClaimDetails]
	-- Add the parameters for the stored procedure here
	 
 
	@ExpenseClaimID INT= null  ,
	@ExpenseTypDetailsId INT= null  ,
    @ValueText NVARCHAR(MAX) = null  
	 

AS
    BEGIN
	
       INSERT INTO [dbo].[tbl_ExpenseClaimDetails]
           ([ExpenseClaimID]
           ,[ExpenseTypDetailsId]
           ,[ValueText])
     VALUES
           (@ExpenseClaimID 
           ,@ExpenseTypDetailsId
           ,@ValueText)

 

END


