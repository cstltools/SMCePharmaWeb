-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_UserByRoleId]
	-- Add the parameters for the stored procedure here
	@id INT,
	@empId int
AS
BEGIN


		SELECT B.EmpInfoId,B.EmpName,B.EmpMasterCode FROM dbo.tblUser A 
		INNER JOIN dbo.tblEmpGeneralInfo B ON B.EmpInfoId = A.EmpInfoId
		WHERE A.UserRoleID = @id AND A.EmpInfoId !=@empId



END

