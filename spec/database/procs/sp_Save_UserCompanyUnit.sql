-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_UserCompanyUnit]
	-- Add the parameters for the stored procedure here

	@UserId INT,
	@ComUnitId INT

AS
BEGIN
	
	INSERT INTO [dbo].tblUserCompanyUnit
           (UserId
           ,CompanyUnitId,CWHPermission,NationalReportPermission)
     VALUES
           (@UserId
           ,@ComUnitId,0,0)
END

