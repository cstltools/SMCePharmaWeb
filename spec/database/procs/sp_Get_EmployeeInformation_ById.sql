-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
CREATE PROCEDURE [dbo].[sp_Get_EmployeeInformation_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT  FORMAT(A.ProbitionEndDate,'dd MMMM, yyyy') ProbitionEndDate,   FORMAT(A.JobLeftDate,'dd MMMM, yyyy') JobLeftDate, FORMAT(A.DateOfBirth,'dd MMMM, yyyy') DateOfBirth,FORMAT(A.JoiningDate,'dd MMMM, yyyy') JoiningDate, *,

		 STUFF(( SELECT  ',' + CAST(AllowanceId AS NVARCHAR(50))
                FROM    dbo.EmployeeAllowance
				WHERE EmpInfoId = @id
              FOR
                XML PATH('')
              ), 1, 1, '') AS AllowanceId 

		 FROM [dbo].[tblEmpGeneralInfo] A


		 WHERE A.EmpInfoId = @id



    END

