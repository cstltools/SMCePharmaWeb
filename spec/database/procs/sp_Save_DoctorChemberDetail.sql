-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorChemberDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@ChamberTypeId INT,
	@Name NVARCHAR(500),
	@Phone NVARCHAR(500),
	@Address NVARCHAR(500)

AS
BEGIN
	
	INSERT INTO [dbo].[tblDoctorChemberDetail]
           (DoctorId,
		    ChamberTypeId
           ,Name
           ,Phone
           ,Address)
     VALUES
           (@DoctorId,
		   @ChamberTypeId
           ,@Name
           ,@Phone
           ,@Address)
END

