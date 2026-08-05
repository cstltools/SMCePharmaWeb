CREATE PROCEDURE [dbo].[sp_GetCustomer_Doctor_TransferAppList]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null,
	@Type nvarchar(max)=null

AS
BEGIN

if(@Type=0)
begin
  select  distinct MasterId MasterId, mr.MarketCode+' : '+  mr.MarketName MarketName, case when cast(emp.EmpInfoId as nvarchar(max)) is null then us.LoginName else emp.EmpMasterCode+' : '+emp.EmpName end  EmpEntryBy, FORMAT(mas.TranferDate,'dd-MMM-yyyy hh:mm tt')  EntryDate,count(  * ) noOfCus  from [dbo].tblCustMaster_TranferLog mas with (nolock)
  left join tbluser us on   us.UserId=mas.TranferBy
  left join tblMarket mr on   mr.MarketId=mas.MarketId

  left join tblEmpGeneralInfo emp on   emp.EmpInfoId=us.EmpInfoId
  where IsApprove=0 and mas.TranferBy=@Parm

  group by MasterId, mr.MarketCode+' : '+  mr.MarketName, case when cast(emp.EmpInfoId as nvarchar(max)) is null then us.LoginName else emp.EmpMasterCode+' : '+emp.EmpName end   , FORMAT(mas.TranferDate,'dd-MMM-yyyy hh:mm tt')
   
END

else if(@Type=1)

begin

 
  select  distinct MasterId MasterId, mr.MarketCode+' : '+  mr.MarketName MarketName, case when cast(emp.EmpInfoId as nvarchar(max)) is null then us.LoginName else emp.EmpMasterCode+' : '+emp.EmpName end  EmpEntryBy, FORMAT(mas.TranferDate,'dd-MMM-yyyy hh:mm tt')  EntryDate,count(  * ) noOfCus  from [dbo].tblDoctorMaster_TranferLog mas with (nolock)
  left join tbluser us on   us.UserId=mas.TranferBy
  left join tblMarket mr on   mr.MarketId=mas.MarketId

  left join tblEmpGeneralInfo emp on   emp.EmpInfoId=us.EmpInfoId
  where IsApprove=0 and mas.TranferBy=@Parm

  group by MasterId, mr.MarketCode+' : '+  mr.MarketName, case when cast(emp.EmpInfoId as nvarchar(max)) is null then us.LoginName else emp.EmpMasterCode+' : '+emp.EmpName end   , FORMAT(mas.TranferDate,'dd-MMM-yyyy hh:mm tt')
END
END
