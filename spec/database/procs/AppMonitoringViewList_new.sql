

CREATE PROCEDURE [dbo].[AppMonitoringViewList_new]
	@Parameter NVARCHAR(MAX)
AS
    BEGIN
	
 DECLARE @Query NVARCHAR(MAX)

   SET @Query = 'select emp.EmpMasterCode, emp.EmpName, ur.Rolename, ISNULL(us.IMEI_One,'''') IMEI_One, ISNULL(us.IMEI_Two,'''') IMEI_Two, ISNULL(us.DeviceInfo_1,'''') DeviceInfo_1, ISNULL(us.DeviceInfo_2,'''') DeviceInfo_2,   ISNULL(us.AppVer_1,'''') AppVer_1, ISNULL(us.AppVer_2,'''') AppVer_2,format(us.LastAccessTime_1, ''dd MMMM, yyyy hh:mm tt'') LastAccessTime_1,format(us.LastAccessTime_2, ''dd MMMM, yyyy hh:mm tt'') LastAccessTime_2, ISNULL(us.OS_1,'''') OS_1, ISNULL(us.OS_2,'''') OS_2, ISNULL(us.OS_Version_1,'''') OS_Version_1, ISNULL(us.OS_Version_2,'''') OS_Version_2  from tbluser  us with (nolock)

left join tblEmpGeneralInfo emp   with (nolock) on us.EmpInfoId=emp.EmpInfoId
left join tbl_UserRoleInfo ur  with (nolock) on us.UserRoleID=ur.UserRoleID

where emp.EmpInfoId is not null ' + @Parameter


   --SELECT GP.GroupCode + ':'+ GP.GroupName AS GroupName FROM tbl_Group AS GP
   --SELECT DISTINCT ASMId,COUNT(ASMId) NoOf FROM tblOrder AS INV GROUP BY ASMId
   

   EXEC(@Query)

 
END
