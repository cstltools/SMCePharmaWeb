-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorProgramType] 
	-- Add the parameters for the stored procedure here

AS
BEGIN
		
		SELECT ProgramTypeId, ProgramTypeName ProgramType
			    FROM dbo.tblProgramType WHERE IsActive = 1


END

