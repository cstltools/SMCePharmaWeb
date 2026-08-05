-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorBrandDetail]
	-- Add the parameters for the stored procedure here

	@DoctorId INT,
	@BrandId int

AS
BEGIN
	
	INSERT INTO [dbo].[tblDoctorBrandDetail]
           (DoctorId
           ,BrandId)
     VALUES
           (@DoctorId,
		   @BrandId)
END

