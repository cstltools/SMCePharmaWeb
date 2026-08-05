
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_CapturedBY_For_DDL]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    

	SELECT B.UserId EmpInfoId,(A.EmpName+'('+A.EmpMasterCode+')') AS EmpName  FROM dbo.tblEmpGeneralInfo A 
	INNER JOIN dbo.tblUser B ON B.EmpInfoId = A.EmpInfoId
	where B.IsAppsUser=1


	
	--SELECT * FROM tbl_PrescriptionType WHERE IsActive = 1

END


