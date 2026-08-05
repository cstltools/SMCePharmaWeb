create PROCEDURE [dbo].[DynamicPivotUserWiseAttendance]
  @ColumnToPivot  NVARCHAR(max),
  @ListToPivot    NVARCHAR(max),
  @Month NVARCHAR(max),
  @Year NVARCHAR(max)
AS
BEGIN
 
  DECLARE @SqlStatement NVARCHAR(MAX)
  SET @SqlStatement = N'
    SELECT * FROM (
     select emp.EmpMasterCode [Employee ID], emp.EmpName+'' (''+usrRl.RoleName+'')'' [Employee Name],  EFF.RegionCode,  case when usrRT.RoleTypeId=4   then EFF.GroupCode when usrRT.RoleTypeId=3  then  EFF.RegionCode when usrRT.RoleTypeId=2  then  EFF.AreaCode   else EFF.TerritoryCode end TerritoryCode,   CONVERT(date,mas.PrescriptionDate)  DcrDate,  isnull((mas.EntryBy),0) ProductQty   from tbl_PrescriptionMaster mas    WITH (NOLOCK) 
 inner join  tblUser usr WITH (NOLOCK)    on mas.EntryBy=usr.UserId
 inner join  tbl_UserRoleInfo usrRl WITH (NOLOCK)    on usr.UserRoleID=usrRl.UserRoleID
 inner join  tblRoleType usrRT WITH (NOLOCK)    on usrRT.RoleTypeId=usrRl.RoleTypeId
 inner join  tblEmpGeneralInfo emp WITH (NOLOCK)    on usr.EmpInfoId=emp.EmpInfoId
  inner join View_Webapi_EmployeeFieldForceInfo EFF  WITH (NOLOCK) on emp.EmpInfoId=EFF.EmpInfoId 
  where Month(mas.DcrDate)='+@Month+' and Year(mas.DcrDate)='+@Year+'
    ) StudentResults
    PIVOT (
      count([ProductQty])
      FOR ['+@ColumnToPivot+']
      IN (
        '+@ListToPivot+'
      )
    ) AS PivotTable
  ';
 
  EXEC(@SqlStatement)
 
END
 