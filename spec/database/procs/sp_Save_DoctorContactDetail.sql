-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorContactDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@ContactType NVARCHAR(500),
	@Contact NVARCHAR(500)

AS
BEGIN
	
	INSERT INTO [dbo].[tblDoctorContactDetail]
           (DoctorId
           ,ContactType
           ,Contact)
     VALUES
           (@DoctorId
           ,@ContactType
           ,@Contact)
END

