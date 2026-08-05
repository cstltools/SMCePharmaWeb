 CREATE PROCEDURE [dbo].[sp_Get_TourPlanReportListNN]
	-- Add the parameters for the stored procedure here
		@param NVARCHAR(max)
AS
BEGIN
   
 
   DECLARE @Query NVARCHAR(MAX)

SET @Query = '
SELECT  distinct
    dtl.EmpMasterCode, 
    dtl.EmpName, 
    usr.RoleName,
   convert(date, dtlT.TourPlanDate)  TourPlanDate 
FROM 
    dbo.tbl_TourPlanMaster mas  WITH (NOLOCK) 
    inner JOIN dbo.tblEmpGeneralInfo dtl   WITH (NOLOCK) ON dtl.EmpInfoId = mas.EmpInfoId
    LEFT JOIN dbo.tblUser us  WITH (NOLOCK)  ON us.EmpInfoId = mas.EmpInfoId
    LEFT JOIN dbo.tbl_UserRoleInfo usr  WITH (NOLOCK)  ON usr.UserRoleID = us.UserRoleID
    LEFT JOIN dbo.tblDesignation dgs  WITH (NOLOCK)  ON dgs.DesignationId = dtl.DesignationId
 
    inner JOIN tbl_TourPlanInfo  dtlT  WITH (NOLOCK)  ON dtlT.TPMaster = mas.TPMaster 

	 

	  LEFT JOIN (
        SELECT 
            dtl.TPMaster TPMasterM, 
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateS 
        FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
        WHERE 
            dtl.isMarketVisit = 1 
            AND IsMorning = 1
    ) tblMor ON tblMor.TPMasterM = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblMor.TourPlanDateS)

	  --  LEFT JOIN (
   --     SELECT 
   --         dtl.TPMaster, 
   --         CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDate,  
   --         dtl.MarketName AS SMarketNameE,  
   --         dtl.Starttime AS SStarttimeE,  
   --         ISNULL(tt.TPName, '') AS STourPurposeE,
   --         dtl.MarketNameEnd AS EMarketNameE,  
   --         dtl.Endtime AS EEndtimeE  , dtl.Objective SObjectiveE
   --     FROM  
   --         tbl_TourPlanInfo dtl WITH (NOLOCK)
   --         LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
   --     WHERE 
   --         dtl.isMarketVisit = 1 
   --         AND IsEvening = 1
   -- ) tblEve ON tblEve.TPMaster = mas.TPMaster  and  convert(date, dtlT.TourPlanDate) =tblEve.TourPlanDate
  


WHERE convert(date, dtlT.TourPlanDate) is not null   '+  @param+  ' order by    EmpMasterCode  asc , convert(date, dtlT.TourPlanDate)  asc'
 
END

EXEC (@Query)

	  
