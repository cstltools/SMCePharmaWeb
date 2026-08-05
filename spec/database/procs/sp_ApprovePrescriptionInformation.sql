
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_ApprovePrescriptionInformation]
	-- Add the parameters for the stored procedure here
   
    @TPMaster NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) ,
	@Status NVARCHAR(50)   
  

AS
    BEGIN
        
		--IF(@Status='Rejected')

		--UPDATE tbl_TourPlanMaster  
	 --   SET IsFinalSubmit=0, ApprovalStatus =  @Status ,
	 --       ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	 --   WHERE  TPMaster in (select * from fnSplit(@TPMaster,','))
		--ELSE
        
		UPDATE dbo.tbl_PrescriptionMaster 
	    Set ApprovalStatus =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  PrescriptionId in (select * from fnSplit(@TPMaster,','))
    END
	

