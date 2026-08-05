-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE   PROCEDURE sp_OPAPI_updateCustomerLocation
    -- Add the parameters for the stored procedure here
    @latVl NVARCHAR(50),
    @longV NVARCHAR(50),
    @custtomerId INT,
    @empId INT
AS
BEGIN

    UPDATE dbo.tblCustMaster
    SET Latitude = @latVl,
        Longitude = @longV,
        LocationUpdateBy = @empId,
        LocationUpdateTime = GETDATE()
    WHERE CustomerMasterId = @custtomerId;



END;
