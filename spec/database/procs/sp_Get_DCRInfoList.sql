-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE
 PROCEDURE [dbo].[sp_Get_DCRInfoList]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
 
    DECLARE @Query NVARCHAR(MAX)

 SET @Query = '
SELECT STUFF( (SELECT CONCAT('', '', mm.EmpMasterCode+'': '' +mm.EmpName, '''') FROM tblEmpGeneralInfo mm (NOLOCK) INNER JOIN dbo.tbl_DcrVisitedWithDetails mgd ON mgd.EmpInfoId=mm.EmpInfoId WHERE mgd.DcrId=DCR.DcrId ORDER BY mgd.DcrVisitWithId FOR XML PATH ('''') ),1,1,'''') AS empVisit,  CASE WHEN DCR.DocTPDetailsId =0 THEN ''Unplanned'' ELSE  ''Planned''   end Planned,   cham.Name ChamberName,   ISNULL(mr.MarketName,mrdcr.MarketName) MarketName, ISNULL(tr.TerritoryName,trdcr.TerritoryName) TerritoryName, docMas.DoctorName+''''+ docMas.DoctorCode DoctorName,  usr.RoleName, dgs.DesigName, dtl.EmpMasterCode, dtl.EmpName,convert(varchar,DCR.DcrDate, 0)  DcrDate, * FROM  tbl_DCRInfo  DCR WITH (NOLOCK)
LEFT JOIN dbo.tbl_DoctorTourPlanDetail dtldoc ON dtldoc.DocTPDetailsId = DCR.DocTPDetailsId
LEFT JOIN tbl_DoctorTourPlanMaster  mas ON  mas.DocTPMaster=dtldoc.DocTPMaster

left JOIN dbo.tblUser us ON us.UserId = DCR.Entryby
left JOIN dbo.tblEmpGeneralInfo dtl ON dtl.EmpInfoId = us.EmpInfoId
left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = dtl.DesignationId
left JOIN dbo.tblDoctorMaster docMas ON docMas.DoctorId = DCR.DoctorId
left JOIN dbo.tblMarket mr  ON mr.MarketId = dtldoc.MarketId
left JOIN dbo.tblTerritory tr  ON mr.TerritoryId = tr.TerritoryId


left JOIN dbo.tblMarket mrdcr  ON mrdcr.MarketId = DCR.MarketId
left JOIN dbo.tblTerritory trdcr  ON trdcr.TerritoryId = DCR.TerritoryId

left JOIN   tblDoctorChemberDetail cham  ON cham.ChemberId = DCR.ChemberId	
	where	 DCR.DcrId is not null   
'+  @param
 
END

EXEC (@Query)
