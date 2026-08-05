

 CREATE PROCEDURE [dbo].[sp_GET_UserMaster_ByEmpId]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 SELECT STUFF( (SELECT CONCAT(',', brn.CompanyUnitId , '') FROM dbo.tblUserCompanyUnit brn(NOLOCK)  WHERE brn.UserId=tblUser.UserId ORDER BY brn.CompanyUnitId FOR XML PATH ('') ),1,1,'') AS UserDCID, FORMAT(ActiveInActiveDate, 'dd MMMM, yyyy')  ActiveDateStr,  * from tblUser where EmpInfoId = @id
      
    END


