-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Save_DoctorDegreeDetail]
	-- Add the parameters for the stored procedure here
@masterId INT = NULL,
@itemName NVARCHAR(max) = NULL
AS
BEGIN


		DECLARE @dgId INT 


	SELECT @dgId =  DegreeId FROM dbo.tblDoctorDegree WHERE DegreeName = @itemName

	IF(@dgId IS NOT NULL)
	BEGIN
		
		INSERT INTO dbo.tblDoctorDegreeDetail
		        ( DoctorId, DegId )
		VALUES  ( @masterId,@dgId
		          )
	END




END

