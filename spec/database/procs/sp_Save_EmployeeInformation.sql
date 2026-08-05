-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
 CREATE PROCEDURE [dbo].[sp_Save_EmployeeInformation]
	-- Add the parameters for the stored procedure here
    @EmpInfoId int ,
	@CompanyId int =null ,
	@EmpName nvarchar(max) =null,
	@EmpMasterCode nvarchar(max) =null,

	@FatherName nvarchar(max) =null,
	@MotherName nvarchar(max) =null,
	@Religion nvarchar(max) =null,
	@Nationality nvarchar(max) =null,
	@DateOfBirth DATETIME=null ,

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
	@EntryBy nvarchar(max) =null,
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
        

     --IF EXISTS ( SELECT  * FROM    dbo.tblEmpGeneralInfo where EmpMasterCode='3333333')
           -- BEGIN
       
	 declare @CountData int=0

	 if(ISNULL(@IsTempEmployeeCode,0)=0)
	  BEGIN 
SELECT @CountData=COUNT(*) FROM dbo.tblEmpGeneralInfo WHERE EmpMasterCode=@EmpMasterCode 
end
print @CountData
 IF(@CountData=0)
 BEGIN 

        INSERT  INTO [dbo].[tblEmpGeneralInfo]
                (    
	EmpMasterCode,
	CompanyId  ,
	EmpName  ,
	FatherName  ,
	MotherName  ,
	Religion  ,
	Nationality  ,
	DateOfBirth  ,
	BloodGroup  ,
	Gender  ,
	AddressPresent  ,
	AddressPermanent  ,
	NationalIdNo  ,
	CellNumber  ,
	Email  ,
	EmrgContactNo  ,
	MaritalStatus  ,
	RefName  ,
	RefContactNo  ,
	DesignationId   ,
	DepartmentId   ,
	JoiningDate  ,
	EntryBy  ,
	EntryDate,
	FirstHoliday,
	SecondHoliDay  ,
	 ShiftId, EmployeeStatus,JobLeftDate,LastCompanyName,LastJobLocation, IsProbition,
	IsTempEmployeeCode,
    EmrgContactNoRelaton,  ProbitionEndDate
	 )
        VALUES  (       
    @EmpMasterCode,
	@CompanyId  ,
	@EmpName  ,




	@FatherName  ,
	@MotherName  ,
	@Religion  ,
	@Nationality  ,
	@DateOfBirth  ,

	@BloodGroup  ,
	@Gender  ,
	@AddressPresent  ,
	@AddressPermanent  ,
	@NationalIdNo  ,
	@CellNumber  ,
	@Email  ,
	@EmrgContactNo  ,
	@MaritalStatus  ,
	@RefName  ,
	@RefContactNo  ,
	@DesignationId   ,
	@DepartmentId   ,
	@JoiningDate  ,
	@EntryBy  ,
	GETDATE() ,
	@FirstHoliday,
	@SecondHoliDay	,@ShiftId,@EmployeeStatus,@JobLeftDate,@LastCompanyName,@LastJobLocation,@IsProbition,
	@IsTempEmployeeCode,
    @EmrgContactNoRelaton, @ProbitionEndDate
	            )

SELECT SCOPE_IDENTITY()

END
END

