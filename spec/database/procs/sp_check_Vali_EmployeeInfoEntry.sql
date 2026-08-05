

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_check_Vali_EmployeeInfoEntry]
	-- Add the parameters for the stored procedure here
	  @MasterId   NVARCHAR(MAX) ,
      @PageName     NVARCHAR(MAX) 

AS
BEGIN

if(@PageName='UserEmpCode')
	BEGIN	 
	 SELECT LoginName FROM dbo.tblUser WHERE  LoginName=@MasterId and tblUser.UserStatus='Active'

	END

	if(@PageName='MIObyTeriID')
	BEGIN	 
	 SELECT TerritoryId FROM dbo.tblMIOInfo WHERE  TerritoryId=@MasterId and IsActive=1

	END

	 if(@PageName='MIObyTeriID')
	BEGIN	 
	 SELECT TerritoryId FROM dbo.tblMIOInfo WHERE IsActive=1 and  TerritoryId=@MasterId

	END



	 if(@PageName='AMbyAreaID')
	BEGIN	 
	 SELECT AreaId FROM dbo.tblASMInfo 
 WHERE  IsActive=1 and  AreaId=@MasterId

	END


	 if(@PageName='AMbyAreaID')
	BEGIN	 
	 SELECT AreaId FROM dbo.tblASMInfo 
 WHERE  IsActive=1 and  AreaId=@MasterId

	END


	if(@PageName='DZSMbyZoneID')
	BEGIN	 
	 SELECT RegionId FROM dbo.tblRSMInfo 
 WHERE  IsActive=1 and  RegionId=@MasterId

	END


	if(@PageName='NSMbyGroupID')
	BEGIN	 
	 SELECT GroupId FROM dbo.tblNSMInfo
 
 WHERE  IsActive=1 and  GroupId=@MasterId

	END
	

	
END



