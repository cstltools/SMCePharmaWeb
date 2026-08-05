-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Update_MileageClaim]
	-- Add the parameters for the stored procedure here
@MileageClaimId int,
 @mileagDate DATETIME = NULL ,
    @transportId INT = NULL ,
    @mileageInKM DECIMAL(18, 2) = NULL ,
    @meterReading DECIMAL(18, 2) = NULL ,
    @MarketId INT = NULL ,
    
   
    @remakrs NVARCHAR(MAX) = NULL ,
    @empId INT
AS
BEGIN

 DECLARE @userId INT
  SELECT  @userId = UserId
        FROM    dbo.tblUser
        WHERE   EmpInfoId = @empId

UPDATE [dbo].tbl_MileageClaim
   SET Remarks = @remakrs 
      ,MileageInKM = @mileageInKM
      ,MeterReading = @meterReading
      ,TransportId = @transportId
       
     
       
   
    
      ,UpdatedBy = @userId
      ,UpdatedDate = getdate() 
	  where  MileageClaimId=@MileageClaimId
	
	 


END

