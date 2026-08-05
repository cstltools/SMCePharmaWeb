

CREATE PROCEDURE AppMonitoringViewList
	@Parameter NVARCHAR(MAX)
AS
    BEGIN
	
 DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'select emp.EmpMasterCode, emp.EmpName, ur.Rolename, tblAppVer.AppVersion, format(tblSyn.SynchronizationDate, ''dd MMMM, yyyy hh:mm tt'') SynchronizationDate from tblEmpGeneralInfo emp  with (nolock)
left join (select top 1 EmpInfoId, AppVersion from tblEmpAppVersion  with (nolock)  order by EmpAppVersionId desc) tblAppVer on tblAppVer.EmpInfoId=emp.EmpInfoId

left join (select top 1 EmpInfoId, SynchronizationDate from tblSynchronizationInfo  with (nolock)  order by SynchronizationInfoId desc) tblSyn on tblSyn.EmpInfoId=emp.EmpInfoId
left join tbluser us  with (nolock) on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo ur  with (nolock) on us.UserRoleID=ur.UserRoleID

where emp.EmpInfoId is not null ' + @Parameter


   --SELECT GP.GroupCode + ':'+ GP.GroupName AS GroupName FROM tbl_Group AS GP
   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
