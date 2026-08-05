

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_check_EmployeeInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @Name     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tblEmpGeneralInfo WHERE EmpMasterCode=@Name AND  EmpInfoId NOT IN ( @id)

END



