
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Check_TourSetupEmployeeListRoleType]
	-- Add the parameters for the stored procedure here
	@RoleTypeId int=null
AS
BEGIN

SELECT   emp.EmpInfoId FROM dbo.tblTourSetupEmployee emp
 
where emp.RoleTypeId=@RoleTypeId  
 
END