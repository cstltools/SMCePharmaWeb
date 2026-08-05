
Create PROCEDURE [dbo].[sp_Delete_CustomerTypeInfo]
	-- Add the parameters for the stored procedure here
    @CustomerTypeId  INT 
	
AS
    BEGIN

       DELETE FROM tblCustomerType WHERE CustomerTypeId = @CustomerTypeId
    END


