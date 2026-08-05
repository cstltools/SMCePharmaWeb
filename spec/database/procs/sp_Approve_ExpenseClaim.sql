

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Approve_ExpenseClaim]
	-- Add the parameters for the stored procedure here   
    @Id NVARCHAR(MAX) ,
    @ApprovedBy NVARCHAR(50),
	@ActionId INT
  
AS
	
    BEGIN
       
      DECLARE @status VARCHAR (20);

	  Select @status=ActionValue from tblAction where ActionId = @ActionId
   
	  UPDATE tbl_ExpenseClaim 
	  Set ApprovalStatus = @status ,
	      ApprovedBy = @ApprovedBy,
		  ApprovedDate = GETDATE()

	  WHERE  ExpenseClaimID in (select * from fnSplit(@Id,','))

    END
	

