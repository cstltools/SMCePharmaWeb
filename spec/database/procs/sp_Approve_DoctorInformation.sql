
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Approve_DoctorInformation]
	-- Add the parameters for the stored procedure here
   
    @DoctorId NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) 
  

AS
    BEGIN
        --UPDATE  [dbo].[tblTransport]
        --SET     TransportName = @TransportName,
		      --  AllowancePerMileage =@AllowancePerMileage,
        --        UpdateBy = @UpdateBy,
        --        UpdateDate = GETDATE(),
        --        IsActive = @isActive 
        
        --WHERE   TransportId = @TransportId   

		UPDATE tblDoctorMaster 
	    Set ApprovalStatus = 'Approved' ,
	        ApprovedBy = @ApprovedBy 

	    WHERE  DoctorId in (select * from fnSplit(@DoctorId,','))

    END
	

