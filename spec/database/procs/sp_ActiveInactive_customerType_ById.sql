
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ActiveInactive_customerType_ById]
	-- Add the parameters for the stored procedure here
    @CustomerTypeId   INT,
	@InactiveBy INT

AS
    BEGIN

	DECLARE @Flag bit 

	Select @Flag=IsActive from tblCustomerType where CustomerTypeId = @CustomerTypeId

	IF @Flag = 1
        UPDATE  [dbo].[tblCustomerType] SET  IsActive = 0 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()  WHERE  CustomerTypeId = @CustomerTypeId    
    ElSE
	    UPDATE  [dbo].[tblCustomerType] SET  IsActive = 1 , InactiveBy=@InactiveBy, InactiveDate = GETDATE()   WHERE  CustomerTypeId = @CustomerTypeId   
    END


