CREATE PROCEDURE [dbo].[sp_Upsertdate_EmpInfo]

	
    @employee_id INT NULL,
    @employee_code nvarchar(max) NULL,
    @RoleType nvarchar(max) NULL,
	@UpdateBy int,
	@ActionStatus nvarchar(max) NULL
AS
BEGIN 

DECLARE @sapEmpCode NVARCHAR(50);
set @sapEmpCode=@employee_code
 

SET @employee_code = SUBSTRING(@sapEmpCode, 6, LEN(@sapEmpCode));
declare @EmpInfoIdMaster int=0

 declare @TerritoryId int=0, @MIOId int=0,   @DataCheck int=0, @CountforAction int=0 


 declare @EmpName NVARCHAR(MAX),
 
    
    @EmployeeStatus NVARCHAR(MAX),
    @PhoneNo NVARCHAR(MAX),
    @isActive bit  , @EmpStatus NVARCHAR(MAX),

   
    
    @JoiningDate DATETIME 

IF NOT EXISTS (select EmpInfoId from tblEmpGeneralInfo where  ltrim(rtrim(EmpMasterCode)) =ltrim(rtrim( @employee_code))  )
    BEGIN 


	

	select @EmpName=name,@PhoneNo= mobile_no, @isActive= isnull(is_active,0) ,@JoiningDate=joining_date from SAP_API_Data..tblSAP_Employee where  ltrim(rtrim(employee_id)) =ltrim(rtrim( @employee_id)) 
    

	if(@isActive=1)
	begin
	set @EmpStatus='Active'
	end
	else
		begin
	set @EmpStatus='Inactive'
	end
	


	 INSERT INTO [dbo].[tblEmpGeneralInfo] (
        [EmpName], [EmpMasterCode],  [EmployeeStatus], [PhoneNo], [CellNumber],
        [JoiningDate], [EntryBy], [EntryDate], [SAPEmpCode],ShiftId
    )
    VALUES (
        @EmpName,  ltrim(rtrim( @employee_code)), @EmpStatus, @PhoneNo, @PhoneNo, 
        @JoiningDate, @UpdateBy, getdate(), ltrim(rtrim( @sapEmpCode)),2
    )
	set  @EmpInfoIdMaster=SCOPE_IDENTITY()
    SELECT SCOPE_IDENTITY() AS EmpInfoId;

	   DECLARE  @CampaignCode NVARCHAR(max)

SELECT @CampaignCode='U_'+ CAST(ISNULL(MAX(ISNULL(UserId,0)),0)+1001 AS NVARCHAR(max)) FROM dbo.[tblUser]

   	if(@RoleType='MIO')
	begin
  INSERT INTO [dbo].[tblUser]
           ([UserName]
           ,[UserType]
           ,[UserCode]
           ,[LoginName]
           ,[Password]
         
          
           ,[EmpInfoId]
           ,[IsAppsUser]
           ,[IMEI_One]
           ,[IMEI_Two]
           ,[UserRoleID]
           ,[ActiveInActiveDate]
           ,[UserTypeId],EntryBy,EntryDate, UserStatus,IsMainDashboard,IsDepotDashboard)
     VALUES
           (  ltrim(rtrim( @employee_code)) 
           ,'Employee' 
           ,@CampaignCode 
           , ltrim(rtrim( @employee_code)) 
           ,ltrim(rtrim( @employee_code))  
          
          
          
           ,@EmpInfoIdMaster 
           ,1 
           ,null 
           ,null 
           ,1 
         
           ,GETDATE()
           ,3,@UpdateBy,GETDATE(),'Active',0,1 )

	end


	   	if(@RoleType='AM')
	begin
  INSERT INTO [dbo].[tblUser]
           ([UserName]
           ,[UserType]
           ,[UserCode]
           ,[LoginName]
           ,[Password]
         
          
           ,[EmpInfoId]
           ,[IsAppsUser]
           ,[IMEI_One]
           ,[IMEI_Two]
           ,[UserRoleID]
           ,[ActiveInActiveDate]
           ,[UserTypeId],EntryBy,EntryDate, UserStatus,IsMainDashboard,IsDepotDashboard)
     VALUES
           (  ltrim(rtrim( @employee_code)) 
           ,'Employee' 
           ,@CampaignCode 
           , ltrim(rtrim( @employee_code)) 
           ,ltrim(rtrim( @employee_code))  
          
          
          
           ,@EmpInfoIdMaster 
           ,3 
           ,null 
           ,null 
           ,3
         
           ,GETDATE()
           ,3,@UpdateBy,GETDATE(),'Active',0,1 )

	end


	   	if(@RoleType='DZSM')
	begin
  INSERT INTO [dbo].[tblUser]
           ([UserName]
           ,[UserType]
           ,[UserCode]
           ,[LoginName]
           ,[Password]
         
          
           ,[EmpInfoId]
           ,[IsAppsUser]
           ,[IMEI_One]
           ,[IMEI_Two]
           ,[UserRoleID]
           ,[ActiveInActiveDate]
           ,[UserTypeId],EntryBy,EntryDate, UserStatus,IsMainDashboard,IsDepotDashboard)
     VALUES
           (  ltrim(rtrim( @employee_code)) 
           ,'Employee' 
           ,@CampaignCode 
           , ltrim(rtrim( @employee_code)) 
           ,ltrim(rtrim( @employee_code))  
          
          
          
           ,@EmpInfoIdMaster 
           ,1 
           ,null 
           ,null 
           ,7
         
           ,GETDATE()
           ,3,@UpdateBy,GETDATE(),'Active',0,1 )

	end
	end
	else
	begin
	select @EmpInfoIdMaster= EmpInfoId from tblEmpGeneralInfo where  ltrim(rtrim(EmpMasterCode)) =ltrim(rtrim( @employee_code))
	end
	 

	if(@EmpInfoIdMaster>0)
	begin

	if(@RoleType='MIO')
	begin

	 select  @TerritoryId=Ttr.TerritoryId  from SAP_API_Data..tblSAP_Territory_Assign  trr
  inner join tblTerritory Ttr  on  Ttr.SAP_Code=trr.to_territory_code
  where   trr.employee_id=@employee_id

	select  @CountforAction=isnull(count(*),0) from tblMIOInfo c where c.IsActive=1 and   c.EmployeeId=@EmpInfoIdMaster
  select @MIOId =isnull(MIOId,0) from tblMIOInfo c where c.IsActive=1 and    c.EmployeeId=@EmpInfoIdMaster
  

  if(@ActionStatus='update')
  begin
   update  tblMIOInfo set  IsActive=0  where   MIOId = @MIOId  
  end

  if(@isActive=0)
  begin
   update  tblMIOInfo set  IsActive=0  where   MIOId = @MIOId  
  end
  else
  begin
 
        INSERT INTO tblMIOInfo
           (CompanyId
           ,TerritoryId
           ,EmployeeId
           ,IsActive
           ,ActiveInActiveDate
           ,EntryBy
           ,EntryDate, SAP_MIOCode)
     VALUES
           (0,
		   @TerritoryId,
		   @EmpInfoIdMaster,
		   1,
		   GETDATE(),
		   @UpdateBy,
		   GETDATE(),ltrim(rtrim( @employee_code)))
	end
	end


		if(@RoleType='AM')
	begin

	 select  @TerritoryId=Ttr.AreaId  from SAP_API_Data..tblSAP_Area_Assign  trr
inner join tblArea Ttr  on  Ttr.SAP_Code=trr.to_area_code
  where   trr.employee_id=@employee_id

	select  @CountforAction=isnull(count(*),0) from tblASMInfo c where c.IsActive=1 and   c.EmployeeId=@EmpInfoIdMaster
  select @MIOId =isnull(ASMId,0) from tblASMInfo c where c.IsActive=1 and    c.EmployeeId=@EmpInfoIdMaster
 

  if(@ActionStatus='update')
  begin
   update  tblASMInfo set  IsActive=0  where   ASMId = @MIOId  
  end

  if(@isActive=0)
  begin
   update  tblASMInfo set  IsActive=0  where   ASMId = @MIOId  
  end
  else
  begin
 
        INSERT INTO tblASMInfo
           (CompanyId
           ,AreaId
           ,EmployeeId
           ,IsActive
           ,ActiveInActiveDate
           ,EntryBy
           ,EntryDate, ASMSapCode)
     VALUES
           (0,
		   @TerritoryId,
		   @EmpInfoIdMaster,
		   1,
		   GETDATE(),
		   @UpdateBy,
		   GETDATE(),ltrim(rtrim( @employee_code)))
	end
	end



		if(@RoleType='DZSM')
	begin

	 select  @TerritoryId=Ttr.RegionId  from SAP_API_Data..tblSAP_Zone_Assign  trr
  inner join tblRegion Ttr  on  Ttr.SAP_Code=trr.to_zone_code
  where   trr.employee_id=@employee_id

	select  @CountforAction=isnull(count(*),0) from tblRSMInfo c where c.IsActive=1 and   c.EmployeeId=@EmpInfoIdMaster
  select @MIOId =isnull(RSMId,0) from tblRSMInfo c where c.IsActive=1 and    c.EmployeeId=@EmpInfoIdMaster
 

  if(@ActionStatus='update')
  begin
   update  tblRSMInfo set  IsActive=0  where   RSMId = @MIOId  
  end

  if(@isActive=0)
  begin
   update  tblRSMInfo set  IsActive=0  where   RSMId = @MIOId  
  end
  else
  begin
 
        INSERT INTO tblRSMInfo
           (CompanyId
           ,RegionId
           ,EmployeeId
           ,IsActive
           ,ActiveDate
           ,EntryBy
           ,EntryDate, DZSMSapCode)
     VALUES
           (0,
		   @TerritoryId,
		   @EmpInfoIdMaster,
		   1,
		   GETDATE(),
		   @UpdateBy,
		   GETDATE(),ltrim(rtrim( @employee_code)))
	end
	end

	end

UPDATE SAP_API_Data..tblSAP_Employee SET Is_EpharmaSystemUpdate=1, EpharmaSystemUpdate_Datetime=getdate() WHERE employee_id=@employee_id

END