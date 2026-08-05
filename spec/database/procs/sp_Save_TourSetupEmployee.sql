

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_TourSetupEmployee]

 
    @IsRoleWise bit =null,
    @IsEmployeeWise bit =null,
    @EmpInfoId INT =null,
    @StationTypeId INT =null,
    @CountNo INT =null,
    @RoleTypeId INT =null,

	 
    @EntryBy INT =null,
	@EntryDate DATETIME = NULL

AS
BEGIN


  if(@IsEmployeeWise=1)
	BEGIN	 

	SELECT @RoleTypeId=  usrR.RoleTypeId FROM dbo.tblEmpGeneralInfo emp
inner join tblUser usr on usr.EmpInfoId=emp.EmpInfoId
inner join tbl_UserRoleInfo usrR on usrR.UserRoleID=usr.UserRoleID
where   emp.EmpInfoId=@EmpInfoId

	INSERT INTO [dbo].[tblTourSetupEmployee]
           ([IsRoleWise]
           ,[IsEmployeeWise]
           ,[EmpInfoId]
           ,[StationTypeId]
           ,[CountNo]
           ,[EntryBy]
           ,[EntryDate]
            
           ,[RoleTypeId])
     VALUES
           (@IsRoleWise 
           ,@IsEmployeeWise 
           ,@EmpInfoId 
           ,@StationTypeId 
           ,@CountNo 
           ,@EntryBy 
           ,@EntryDate
            
           ,@RoleTypeId )

	SELECT SCOPE_IDENTITY()
	end

	if(@IsRoleWise=1)
	BEGIN	 
	DECLARE @EMPID int 



--------------------------------------------------------
DECLARE @MyCursor CURSOR
SET @MyCursor = CURSOR FAST_FORWARD
FOR
---------------
SELECT   emp.EmpInfoId FROM dbo.tblEmpGeneralInfo emp
inner join tblUser usr on usr.EmpInfoId=emp.EmpInfoId
inner join tbl_UserRoleInfo usrR on usrR.UserRoleID=usr.UserRoleID
where usrR.RoleTypeId=@RoleTypeId and emp.EmployeeStatus='Active' and usr.UserStatus='Active'

----------
OPEN @MyCursor
FETCH NEXT FROM @MyCursor
INTO 
@EMPID 

WHILE @@FETCH_STATUS = 0
BEGIN


INSERT INTO [dbo].[tblTourSetupEmployee]
           ([IsRoleWise]
           ,[IsEmployeeWise]
           ,[EmpInfoId]
           ,[StationTypeId]
           ,[CountNo]
           ,[EntryBy]
           ,[EntryDate]
            
           ,[RoleTypeId])
     VALUES
           (@IsRoleWise 
           ,@IsEmployeeWise 
           ,@EMPID 
           ,@StationTypeId 
           ,@CountNo 
           ,@EntryBy 
           ,@EntryDate
            
           ,@RoleTypeId )




FETCH NEXT FROM @MyCursor
INTO 
@EMPID

END
CLOSE @MyCursor
DEALLOCATE @MyCursor


	

	SELECT SCOPE_IDENTITY()
	end
END



