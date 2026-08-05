
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_OrderTrackingList_DBH]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max)=null
AS
BEGIN
   DECLARE @Q NVARCHAR(MAX)='
  

		  SELECT    mas.CustomerCode, mas.CustomerName, mas.TerritoryCode_Ord TerritoryCode,mas.TerritoryName_Ord   TerritoryName, mas.OrderCode, ISNULL(sum(mas.GrossValue-mas.TotalDiscount),0) GrossValue FROM dbo.tblOrder mas WITH (NOLOCK)

LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN dbo.tbluser us  with (nolock)  ON mas.EntryBy=us.UserId

 
 LEFT JOIN dbo.View_Webapi_EmployeeFieldForceInfo  with (nolock) ON View_Webapi_EmployeeFieldForceInfo.EmpInfoId = us.EmpInfoId
		 
		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
		
		 WHERE  mas.ActionStatus<>''3'' 
  '+@Parm +'  group by mas.CustomerCode, mas.CustomerName, mas.TerritoryCode_Ord  ,mas.TerritoryName_Ord    , mas.OrderCode  order by mas.TerritoryCode_Ord '


EXEC sp_executesql @Q
	
END