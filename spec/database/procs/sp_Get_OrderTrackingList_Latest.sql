
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_OrderTrackingList_Latest]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
  

		  SELECT ComUnitName,CustomerCode, CustomerName,  case when mas.IsInvoice=1 then ''Yes'' else ''No'' end Invoice, mas.OrderId, mas.OrderCode, mas.GrossValue,mas.TotalVat,mas.TotalDiscount, mas.TotalNetPayable,  mas.OrderSenderCode+ '' : ''+mas.OrderSenderName CreateBy,  case when mas.ActionStatus=''0'' then ''Pending''  when mas.ActionStatus=''1'' then ''Verified'' when mas.ActionStatus=''2'' then ''Approved'' when mas.ActionStatus=''3'' then ''Rejected''  else mas.ActionStatus end ApprovalStatus, FORMAT(mas.ServerDateTime,''dd-MMM-yyyy hh:mm tt'') SubmissionDate, DZSM.EmpMasterCode+'' : ''+DZSM.EmpName DZSMEmpName, AM.EmpMasterCode+'' : ''+AM.EmpName AMEmpName,MIO.EmpMasterCode+'' : ''+MIO.EmpName MIOEmpName, mas.GroupName_Ord GroupName, mas.RegionName_Ord RegionName,mas.AreaName_Ord AreaName,mas.TerritoryCode_Ord TerritoryCode,mas.TerritoryName_Ord   TerritoryName,mas. SubTerritoryName_Ord SubTerritoryName,mas.MarketName_Ord MarketName,rt.RouteName,  mas.GroupCode_Ord GroupCode, mas.RegionCode_Ord RegionCode, mas.AreaCode_Ord AreaCode,mas.TerritoryCode_Ord TerritoryCode,mas.SubTerritoryCode_Ord SubTerritoryCode, mas.MarketCode_ord MarketCode FROM dbo.tblOrder mas WITH (NOLOCK)

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tbluser us  with (nolock)  ON mas.EntryBy=us.UserId

 
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = us.EmpInfoId
		 
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
		
		 WHERE OrderId IS NOT NULL
  '+@Parm +'   order by mas.EntryDate desc '


EXEC sp_executesql @Q
	
END