create PROCEDURE [dbo].[sp_DICByregionid]
	-- Add the parameters for the stored procedure here
    @EmployeeId  INT ,
    @RoleId  INT 


AS
    begin

	select distinct mas.DCId from tblRouteInformationMarketDetail d
inner join tblRouteInformationMaster mas on mas.RouteInformationMasterId= d.RouteInformationMasterId
	 where regionid In (select   rg.RegionId   from View_Webapi_EmployeeFieldForceInfo mas
	 
	 inner join tblRegion rg  with (nolock) on mas.RegionId=rg.RegionId
		inner join dbo.tbl_Group gr  with (nolock) on gr.GroupId=gr.GroupId
		where mas.EmpInfoId=@EmployeeId  )

end

 
 