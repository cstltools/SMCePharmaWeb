
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_ApproveCustomerInformation]
	-- Add the parameters for the stored procedure here
   
    @CustomerMasterId NVARCHAR(MAX) ,

    @ApprovedBy NVARCHAR(50) ,
	@Status NVARCHAR(MAX)= NULL
  

AS
    BEGIN
        --UPDATE  [dbo].[tblTransport]
        --SET     TransportName = @TransportName,
		      --  AllowancePerMileage =@AllowancePerMileage,
        --        UpdateBy = @UpdateBy,
        --        UpdateDate = GETDATE(),
        --        IsActive = @isActive 
        
        --WHERE   TransportId = @TransportId   


   DECLARE  @CustomerCode NVARCHAR(max)

SELECT @CustomerCode= CAST(ISNULL(MAX(ISNULL(CAST(CustomerCode as int),0)),0)+1 AS NVARCHAR(max)) FROM dbo.tblCustMaster  --WHERE  ActionStatus='Approved'
print @CustomerCode

		UPDATE tblCustMaster 
	    Set ActionStatus =  @Status ,CustomerCode= @CustomerCode,
	        ApproveBy = @ApprovedBy , ApproveDate=GETDATE()

	    WHERE  CustomerMasterId =@CustomerMasterId

    END
	

