
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Update_EmployeeInformation]
	-- Add the parameters for the stored procedure here
  @EmpInfoId int ,
	@CompanyId int =null ,
	@EmpName nvarchar(max) =null,
	@EmpMasterCode nvarchar(max) =null,

	@FatherName nvarchar(max) =null,
	@MotherName nvarchar(max) =null,
	@Religion nvarchar(max) =null,
	@Nationality nvarchar(max) =null,
	@DateOfBirth datetime ,

	@BloodGroup nvarchar(max) =null,
	@Gender nvarchar(max) =null,
	@AddressPresent nvarchar(max) =null ,
	@AddressPermanent nvarchar(max) =null,


	@NationalIdNo nvarchar(max) =null,
	@CellNumber nvarchar(max) =null ,
	@Email nvarchar(max) =null,
	@EmrgContactNo nvarchar(max)=null ,
	@MaritalStatus nvarchar(max) =null,
	@RefName nvarchar(max)=null ,
	@RefContactNo nvarchar(max) =null,
	@DesignationId int =null ,
	@DepartmentId int =null ,
	@JoiningDate datetime =null,
	@UpdateBy nvarchar(max) =null,
	@FirstHoliday nvarchar(max) =null,
    @SecondHoliDay nvarchar(max) =NULL,
	
	@ShiftId int =null ,
	@EmployeeStatus nvarchar(max) =NULL,
	@JobLeftDate datetime =NULL,@LastCompanyName nvarchar(max) =NULL,@LastJobLocation  nvarchar(max) =NULL,

	@IsProbition bit =null,
	@IsTempEmployeeCode bit=null,
    @EmrgContactNoRelaton nvarchar(max) =NULL,
    @ProbitionEndDate datetime =NULL

AS
    BEGIN
     UPDATE [dbo].[tblEmpGeneralInfo]
     SET 
       CompanyId = @CompanyId
      ,[EmpName] = @EmpName,
	   EmpMasterCode=@EmpMasterCode
      ,[FatherName] = @FatherName
      ,[MotherName] = @MotherName
      ,[Religion] = @Religion
      ,[Nationality] = @Nationality
      ,[DateOfBirth] = @DateOfBirth
  
      ,[BloodGroup] = @BloodGroup
      ,[Gender] = @Gender
      ,[AddressPresent] = @AddressPresent
      ,[AddressPermanent] = @AddressPermanent
       
      ,[NationalIdNo] = @NationalIdNo
      ,[CellNumber] = @CellNumber
      ,[Email] = @Email
      ,[EmrgContactNo] = @EmrgContactNo
      ,[MaritalStatus] = @MaritalStatus
      ,[RefName] = @RefName
      ,[RefContactNo] = @RefContactNo
      ,[DesignationId] = @DesignationId
      ,[DepartmentId] = @DepartmentId
      ,[JoiningDate] = @JoiningDate
	  ,[FirstHoliday] = @FirstHoliday
	  ,[SecondHoliDay] = @SecondHoliDay
	 ,ShiftId= @ShiftId
      ,[UpdateBy] = @UpdateBy
      ,[UpdateDate] = GETDATE(), EmployeeStatus=@EmployeeStatus,  JobLeftDate=@JobLeftDate,LastCompanyName=@LastCompanyName,LastJobLocation=@LastJobLocation, IsProbition=@IsProbition,
	IsTempEmployeeCode=@IsTempEmployeeCode,
    EmrgContactNoRelaton=@EmrgContactNoRelaton, ProbitionEndDate=@ProbitionEndDate
 WHERE EmpInfoId = @EmpInfoId

 if(@EmployeeStatus='Inactive')
 begin

 update tblUser set UserStatus=@EmployeeStatus  where EmpInfoId=@EmpInfoId


 declare @RoleType nvarchar(max) 
 SELECT @RoleType=rt.RoleType FROM tblUser u
inner join tbl_UserRoleInfo usr ON usr.UserRoleID=u.UserRoleID
inner join tblRoleType rt ON rt.RoleTypeId=usr.RoleTypeId

where EmpInfoId=@EmpInfoId

if(@RoleType='MIO')
begin
update tblMIOInfo set IsActive=0 where EmployeeId=@EmpInfoId
end
if(@RoleType='AM')
begin
update tblASMInfo set IsActive=0 where EmployeeId=@EmpInfoId

end

if(@RoleType='DZSM')
begin
update tblRSMInfo set IsActive=0 where EmployeeId=@EmpInfoId

end

if(@RoleType='NSM')
begin
update tblNSMInfo set IsActive=0 where EmployeeId=@EmpInfoId

end

 --delete from [EmployeeAllowance] where EmpInfoId=@EmpInfoId
 end
    END


