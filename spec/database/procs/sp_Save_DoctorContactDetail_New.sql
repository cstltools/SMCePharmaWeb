-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_DoctorContactDetail_New]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@ContactTypeId INT,
	@ContactType NVARCHAR(500),
	@Contact NVARCHAR(500)

AS
BEGIN
	
	INSERT INTO [dbo].[tblDoctorContactDetail]
           (DoctorId
           ,ContactType
           ,ContactTypeId
           ,Contact)
     VALUES
           (@DoctorId
           ,@ContactType,@ContactTypeId
           ,@Contact)
END

