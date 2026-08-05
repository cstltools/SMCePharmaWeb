
CREATE PROCEDURE [dbo].[sp_Get_SAP_EmpInfo]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   --MIO
     select emp.employee_id, emp.employee_code, emp.name, rt.RoleType, format(emp.joining_date, 'dd-MMM-yyyy') joining_date,emp.mobile_no,  format(emp.SAP_ReceiveDatetime, 'dd-MMM-yyyy')  SAP_ReceiveDatetime, Ftr.TerritoryCode+' : '+ Ftr.TerritoryName FTerritoryName,  Ttr.TerritoryCode+' : '+  Ttr.TerritoryName TTerritoryName , '' FAreaName,  '' TAreaName  , '' FZoneName, '' TZoneName, emp.action  from SAP_API_Data..tblSAP_Employee emp with (nolock)
 inner join SAP_API_Data..tblSAP_Territory_Assign trr on  emp.employee_id=trr.employee_id
 left join tblTerritory Ftr  on  Ftr.SAP_Code=trr.from_territory_code
 left join tblTerritory Ttr  on  Ttr.SAP_Code=trr.to_territory_code

 inner join  tblRoleType rt on  emp.role=rt.SAP_RoleTypeCode

	  where emp.role='1001' and isnull(emp.Is_EpharmaSystemUpdate,0)=0 and isnull(trr.Is_EpharmaSystemUpdate,0)=0 and CONVERT(date,emp.SAP_ReceiveDatetime)>= CONVERT(date,'27-Dec-2023')

	  union all
	  --AM
	     select emp.employee_id, emp.employee_code, emp.name, rt.RoleType, format(emp.joining_date, 'dd-MMM-yyyy') joining_date,emp.mobile_no,  format(emp.SAP_ReceiveDatetime, 'dd-MMM-yyyy')  SAP_ReceiveDatetime, '' FTerritoryName, '' TTerritoryName, Ftr.AreaCode+' : '+ Ftr.AreaName FAreaName,  Ttr.AreaCode+' : '+  Ttr.AreaName TAreaName, '' FZoneName, '' TZoneName   , emp.action  from SAP_API_Data..tblSAP_Employee emp with (nolock)
 inner join SAP_API_Data..tblSAP_Area_Assign trr on  emp.employee_id=trr.employee_id
 left join tblArea Ftr  on  Ftr.SAP_Code=trr.from_area_code
 left join tblArea Ttr  on  Ttr.SAP_Code=trr.to_area_code

 inner join  tblRoleType rt on  emp.role=rt.SAP_RoleTypeCode

	  where emp.role='1002' and isnull(emp.Is_EpharmaSystemUpdate,0)=0 and isnull(trr.Is_EpharmaSystemUpdate,0)=0 and CONVERT(date,emp.SAP_ReceiveDatetime)>= CONVERT(date,'27-Dec-2023')


	    union all
	  --DZSM
	     select emp.employee_id, emp.employee_code, emp.name, rt.RoleType, format(emp.joining_date, 'dd-MMM-yyyy') joining_date,emp.mobile_no,  format(emp.SAP_ReceiveDatetime, 'dd-MMM-yyyy')  SAP_ReceiveDatetime, '' FTerritoryName, '' TTerritoryName, '' FAreaName, '' TAreaName  , Ftr.RegionCode+' : '+ Ftr.RegionName FZoneName,  Ttr.RegionCode+' : '+  Ttr.RegionName TZoneName  , emp.action  from SAP_API_Data..tblSAP_Employee emp with (nolock)
 inner join SAP_API_Data..tblSAP_Zone_Assign trr on  emp.employee_id=trr.employee_id
 left join tblRegion Ftr  on  Ftr.SAP_Code=trr.from_zone_code
 left join tblRegion Ttr  on  Ttr.SAP_Code=trr.to_zone_code

 inner join  tblRoleType rt on  emp.role=rt.SAP_RoleTypeCode

	  where emp.role='1003' and isnull(emp.Is_EpharmaSystemUpdate,0)=0 and CONVERT(date,emp.SAP_ReceiveDatetime)>= CONVERT(date,'27-Dec-2023')


 --select * from tblRoleType
 --select * from SAP_API_Data..tblSAP_Zone_Assign

END
             

			  