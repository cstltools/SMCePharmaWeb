

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_Vali_EmployeeInfoUpdate]
	-- Add the parameters for the stored procedure here
	  @EmpMasterCode  nvarchar(max) ,
	  @EmpId  INT  
AS
BEGIN
		 	  
	SELECT LoginName FROM dbo.tblUser WHERE LoginName=@EmpMasterCode AND  EmpInfoId NOT IN ( @EmpId)
		union all 
	SELECT EmpMasterCode FROM dbo.tblEmpGeneralInfo WHERE EmpMasterCode=@EmpMasterCode AND  EmpInfoId NOT IN ( @EmpId)


END



