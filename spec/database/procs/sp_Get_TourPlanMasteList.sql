-- =============================================
-- Author:		<Author,,Tareq>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TourPlanMasteList]
	-- Add the parameters for the stored procedure here
			@param NVARCHAR(max)
AS
BEGIN
    SET NOCOUNT ON;
    DECLARE @Query NVARCHAR(MAX)

SET @Query = 'SELECT   case when mas.ApprovalStatus=''0'' then ''Pending''  when mas.ApprovalStatus=''1'' then ''Verified''  when mas.ApprovalStatus=''2'' then ''Approved''  WHEN mas.ApprovalStatus=''3'' then ''Rejected''  else mas.ApprovalStatus end ApprovalStatus,  mas.FinalSubmitRemarks,  usr.RoleName, dgs.DesigName,   CASE WHEN mas.MonthValue=1 THEN ''January'' WHEN mas.MonthValue=2 THEN ''February'' WHEN mas.MonthValue=3 THEN ''March'' WHEN mas.MonthValue=4 THEN ''April'' WHEN mas.MonthValue=5 THEN ''May'' WHEN mas.MonthValue=6 THEN ''June''  WHEN mas.MonthValue=7 THEN ''July'' WHEN mas.MonthValue=8 THEN ''August'' WHEN mas.MonthValue=9 THEN ''September''  WHEN mas.MonthValue=10 THEN ''October''  WHEN mas.MonthValue=11 THEN ''November''  WHEN mas.MonthValue=12 THEN ''December'' ELSE '''' END  MonthName1    ,* FROM dbo.tbl_TourPlanMaster mas   WITH (NOLOCK)
left JOIN dbo.tblEmpGeneralInfo dtl   WITH (NOLOCK) ON dtl.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tblUser us   WITH (NOLOCK) ON us.EmpInfoId = mas.EmpInfoId
left JOIN dbo.tbl_UserRoleInfo usr ON usr.UserRoleID = us.UserRoleID
left JOIN dbo.tblDesignation dgs ON dgs.DesignationId = dtl.DesignationId
--LEFT JOIN tbl_TourPlanInfo tpdtl ON tpdtl.TPMaster = mas.TPMaster
--LEFT JOIN dbo.tblMarket mr ON tpdtl.MarketId = mr.MarketId
--LEFT JOIN dbo.tblTerritory tr ON tr.TerritoryId = mr.TerritoryId
--LEFT JOIN dbo.tblArea ar ON tr.AreaId = ar.AreaId
--LEFT JOIN dbo.tbl_Zone zn ON zn.ZoneId = ar.RegionId
--LEFT JOIN dbo.tbl_Group gp ON gp.GroupId = zn.GroupId
  where   mas.TPMaster is not null 	
'+  @param
 
END

EXEC (@Query)