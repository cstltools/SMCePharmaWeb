-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorCustomer]
	-- Add the parameters for the stored procedure here
	@DoctorId INT,
    @CustomerCode NVARCHAR(MAX) ,
    @CustomerName NVARCHAR(MAX)


AS
    BEGIN
	

        INSERT INTO tblDoctorCustomerDetail
           (DoctorId
           ,CustomerCode
           ,CustomerName)
     VALUES
           (@DoctorId
           ,@CustomerCode
           ,@CustomerName)

SELECT SCOPE_IDENTITY()
		
END


