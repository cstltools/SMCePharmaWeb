	CREATE PROCEDURE [dbo].[sp_Get_TourPlanByTourPlanDate]
	-- Add the parameters for the stored procedure here
    @tadaDate DATETIME = NULL ,
    @empId INT = NULL  
AS
    BEGIN


	DECLARE @RoleTypeId INT=0
	DECLARE @TPId INT=0
		DECLARE @TourTypeId INT=0

		SELECT @RoleTypeId=RoleTypeId FROM dbo.tblUser
		LEFT JOIN dbo.tbl_UserRoleInfo ON tbl_UserRoleInfo.UserRoleID = tblUser.UserRoleID
		WHERE EmpInfoId=@empId	

	DECLARE @amount DECIMAL(18,2)=0

		SELECT @amount=ISNULL(DAAmount,0) FROM dbo.tbl_TADAMarketRulesConfig WHERE TourType in (SELECT TourTypeId FROM dbo.tbl_TourPlanInfo WHERE EmpInfoId=@empId   and tbl_TourPlanInfo.SerialNo='1' and CONVERT(date,TourPlanDate)=@tadaDate) AND UserRoleID=@RoleTypeId
		AND IsActive=1
	select	@TPId =ISNULL(TPId,0) FROM dbo.tbl_TourPlanInfo WHERE EmpInfoId=@empId   and tbl_TourPlanInfo.SerialNo='1' and CONVERT(date,TourPlanDate)=@tadaDate

	if(@TPId=0)
	begin
	update tbl_TourPlanInfo set TPId=1    WHERE EmpInfoId=@empId   and tbl_TourPlanInfo.SerialNo='1' and CONVERT(date,TourPlanDate)=@tadaDate
	end

	SELECT @amount DAAmount, * FROM dbo.tbl_TourPlanInfo WHERE EmpInfoId=@empId   and tbl_TourPlanInfo.SerialNo='1' and CONVERT(date,TourPlanDate)=@tadaDate



	end