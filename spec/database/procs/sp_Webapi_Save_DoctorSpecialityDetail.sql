-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorSpecialityDetail]
	-- Add the parameters for the stored procedure here
@masterId INT = NULL,
@itemName NVARCHAR(max) = NULL
AS
BEGIN


		DECLARE @dgId INT 


	SELECT @dgId =  SpecialityId FROM dbo.tblDoctorSpeciality WHERE SpecialityName = @itemName


		INSERT INTO dbo.tblDoctorSpecialityDetail
		        ( DoctorId, SpecialityId )
		VALUES  ( @masterId,@dgId
		          )


END

