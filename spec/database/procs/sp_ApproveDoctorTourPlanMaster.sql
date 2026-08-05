
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ApproveDoctorTourPlanMaster]
	-- Add the parameters for the stored procedure here
   
    @TPMaster NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) ,
	@Status NVARCHAR(50)   
  

AS
    BEGIN
          
		IF(@Status='Rejected')
		UPDATE tbl_DoctorTourPlanMaster 
	    SET IsFinalSubmit=0, ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  DocTPMaster in (select * from fnSplit(@TPMaster,','))

		ELSE
		UPDATE tbl_DoctorTourPlanMaster 
	    SET   ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  DocTPMaster in (select * from fnSplit(@TPMaster,','))
    END
	

