


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Approve_Prescription]
	-- Add the parameters for the stored procedure here
   
    @Id NVARCHAR(MAX) ,
    @ApprovedBy NVARCHAR(50),
	@ActionId INT 
  

AS
    BEGIN
         
		DECLARE @Status NVARCHAR(50);

		Select  @Status=ActionValue from tblAction where ActionId = @ActionId

		UPDATE tbl_PrescriptionMaster 
	    Set ApprovalStatus = @Status ,
	        ApprovedBy = @ApprovedBy ,
			ApprovedDate = GETDATE()

	    WHERE  PrescriptionId in (select * from fnSplit(@Id,','))

    END
	



