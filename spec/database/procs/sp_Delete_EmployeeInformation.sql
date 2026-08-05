
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Delete_EmployeeInformation]
	-- Add the parameters for the stored procedure here
    @EmpInfoId INT 
   
AS
    BEGIN

	Delete from tblEmpGeneralInfo where EmpInfoId = @EmpInfoId

    END
