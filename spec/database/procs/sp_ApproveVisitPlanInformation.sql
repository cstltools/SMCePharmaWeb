
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_ApproveVisitPlanInformation]
	-- Add the parameters for the stored procedure here
   
    @TPMaster NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) ,
	@Status NVARCHAR(50)   
  

AS
    BEGIN
        
		IF(@Status='3')

		UPDATE tbl_DoctorTourPlanMaster  
	    SET IsFinalSubmit=0, ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  DocTPMaster in (select * from fnSplit(@TPMaster,','))
		ELSE
        
		UPDATE tbl_DoctorTourPlanMaster 
	    Set ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  DocTPMaster in (select * from fnSplit(@TPMaster,','))
    END
	

