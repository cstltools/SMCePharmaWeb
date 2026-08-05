-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorInstitute]
	-- Add the parameters for the stored procedure here

AS
BEGIN

SELECT  InstitutionId,  Institution  FROM dbo.tblInstitutionInfo with(nolock)  WHERE IsActive = 1
		
		--SELECT 1 AS InstitutionId,'Ins -1' AS Institution



END

