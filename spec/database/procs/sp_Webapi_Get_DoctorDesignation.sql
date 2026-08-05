-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorDesignation]
	-- Add the parameters for the stored procedure here

AS
BEGIN
	
	SELECT DesignationId ,
           DesignationName  FROM dbo.tblDoctorDesignation WHERE IsActive = 1

END

