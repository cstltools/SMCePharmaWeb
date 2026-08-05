
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ApproveAttendanceInformation]
	-- Add the parameters for the stored procedure here
   
    @AttendanceId NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) ,
	@Status BIT NULL
  

AS
    BEGIN
        --UPDATE  [dbo].[tblTransport]
        --SET     TransportName = @TransportName,
		      --  AllowancePerMileage =@AllowancePerMileage,
        --        UpdateBy = @UpdateBy,
        --        UpdateDate = GETDATE(),
        --        IsActive = @isActive 
        
        --WHERE   TransportId = @TransportId   

		UPDATE tblMarketAttendance_Master_webapi 
	    Set Status =  @Status ,
	        ApprovedBy = @ApprovedBy , ApprovedDate=GETDATE()

	    WHERE  AttendanceId in (select * from fnSplit(@AttendanceId,','))

    END
	

