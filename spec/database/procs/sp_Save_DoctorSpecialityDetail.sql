-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_DoctorSpecialityDetail]
	-- Add the parameters for the stored procedure here
@DoctorId INT = NULL,
@SpecialityId NVARCHAR(max) = NULL
AS
BEGIN

 


		INSERT INTO dbo.tblDoctorSpecialityDetail
		        ( DoctorId, SpecialityId )
		VALUES  ( @DoctorId,@SpecialityId)


END

