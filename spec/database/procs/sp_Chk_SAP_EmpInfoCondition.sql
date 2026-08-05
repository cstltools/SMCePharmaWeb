CREATE PROCEDURE [dbo].[sp_Chk_SAP_EmpInfoCondition]
	-- Add the parameters for the stored procedure here
	@femployee_id nvarchar(max) ,
	@employee_code nvarchar(max) ,
	@RoleType nvarchar(max), 
	@ActionStatus nvarchar(max) 

AS
BEGIN

 declare @TerritoryId int=0, @MIOId int=0,     @DataCheck int=0, @CountforAction int=0, @Msg nvarchar(max)=''  




if(@RoleType='MIO')

begin



--select MIOId from tblMIOInfo where  SAP_MIOCode =@employee_code and IsActive=1 
 
 select  @TerritoryId=Ttr.TerritoryId  from SAP_API_Data..tblSAP_Territory_Assign  trr
  inner join tblTerritory Ttr  on  Ttr.SAP_Code=trr.to_territory_code
  where   trr.employee_id=@femployee_id
  
  select  @CountforAction=isnull(count(*),0) from tblMIOInfo c where c.IsActive=1 and   c.SAP_MIOCode=@employee_code
  select @MIOId =isnull(count(*),0) from tblMIOInfo c where c.IsActive=1 and   c.SAP_MIOCode=@employee_code
 

  if(@ActionStatus='create')
  begin
   select @DataCheck  =isnull(MIOId,0) from tblMIOInfo where  TerritoryId = @TerritoryId and IsActive=1
  end


   if(@ActionStatus='update')
  begin
   
   select @DataCheck  =isnull(MIOId,0) from tblMIOInfo where   TerritoryId=@TerritoryId AND  MIOId NOT IN ( @MIOId)
	 and IsActive=1
  end

 if(@DataCheck>0)
 begin
 set @Msg= 'Already Assigned in MIO Info!'
 end

 
 end



 if(@RoleType='AM')

begin



--select MIOId from tblMIOInfo where  SAP_MIOCode =@employee_code and IsActive=1 
 
 select  @TerritoryId=Ttr.AreaId   from SAP_API_Data..tblSAP_Area_Assign  trr
  inner join tblArea Ttr  on  Ttr.SAP_Code=trr.to_area_code
  where   trr.employee_id=@femployee_id


select  @CountforAction=isnull(count(*),0) from tblASMInfo c where c.IsActive=1 and   c.ASMSapCode=@employee_code
  select @MIOId =isnull(count(*),0) from tblASMInfo c where c.IsActive=1 and   c.ASMSapCode=@employee_code
  

  if(@ActionStatus='create')
  begin
   select @DataCheck  =isnull(ASMId,0) from tblASMInfo where  AreaId = @TerritoryId and IsActive=1
  end


   if(@ActionStatus='update')
  begin
   
   select @DataCheck  =isnull(ASMId,0) from tblASMInfo where   AreaId=@TerritoryId AND  ASMId NOT IN ( @MIOId)
	 and IsActive=1
  end

 if(@DataCheck>0)
 begin
 set @Msg= 'Already Assigned in AM Info!'
 end

 
 end




  if(@RoleType='DZSM')

begin



--select MIOId from tblMIOInfo where  SAP_MIOCode =@employee_code and IsActive=1 
 
 select  @TerritoryId=Ttr.RegionId  from  SAP_API_Data..tblSAP_Zone_Assign  trr
  inner join tblRegion Ttr  on  Ttr.SAP_Code=trr.to_zone_code
  where   trr.employee_id=@femployee_id

  select  @CountforAction=isnull(count(*),0) from tblRSMInfo c where c.IsActive=1 and   c.DZSMSapCode=@employee_code
  select @MIOId =isnull(count(*),0) from tblRSMInfo c where c.IsActive=1 and   c.DZSMSapCode=@employee_code
 

  if(@ActionStatus='create')
  begin
   select @DataCheck  =isnull(RSMId,0) from tblRSMInfo where  RegionId = @TerritoryId and IsActive=1
  end


   if(@ActionStatus='update')
  begin

  
   select @DataCheck  =isnull(RSMId,0) from tblRSMInfo where   RegionId=@TerritoryId AND  RSMId NOT IN ( @MIOId)
	 and IsActive=1
  end

 if(@DataCheck>0)
 begin
 set @Msg= 'Already Assigned in DZSM Info!'
 end

 
 end


  select @DataCheck Datacheck ,  @Msg Msg


  end 

			  