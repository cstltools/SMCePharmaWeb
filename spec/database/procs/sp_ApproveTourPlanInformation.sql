
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ApproveTourPlanInformation]
	-- Add the parameters for the stored procedure here
   
    @TPMaster NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) ,
	@Status NVARCHAR(50)   
  

AS
    BEGIN
        
		IF(@Status='3')

		UPDATE tbl_TourPlanMaster  
	    SET IsFinalSubmit=0, ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  TPMaster in (select * from fnSplit(@TPMaster,','))
		ELSE
        
		UPDATE tbl_TourPlanMaster 
	    Set ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  TPMaster in (select * from fnSplit(@TPMaster,','))
    END
	

