-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Webapi_Get_DoctorType] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT DoctorTypeId,DoctorTypeName
			    FROM dbo.tblDoctorType with (nolock) WHERE IsActive = 1


END

