 CREATE PROCEDURE [dbo].sp_Get_TourPlanReportList
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
   convert(date, dtlT.TourPlanDate)  TourPlanDate ,tblMor.*,tblEve.*, tblOther.*
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
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateS ,
			  dtl.MarketName AS SMarketName,
			   dtl.Starttime AS SStarttime,
			     dtl.MarketNameEnd AS EMarketName,
				  dtl.Endtime AS EEndtime  , dtl.Objective SObjective,  tt.TPName  AS STourPurpose ,
			   STUFF( (SELECT  CONCAT( mm.MarketName , '''') FROM tblMarket mm (NOLOCK) INNER JOIN dbo.tblTPMarketDetail mgd ON mgd.MarketId=mm.MarketId WHERE mgd.TourPlanId=dtl.TourPlanId ORDER BY mgd.MarketId FOR XML PATH ('''') ),1,1,'''') as   OtherVisitM 
              FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
        WHERE 
            dtl.isMarketVisit = 1 
            AND IsMorning = 1
    ) tblMor ON tblMor.TPMasterM = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblMor.TourPlanDateS)



	

	  LEFT JOIN (
        SELECT 
            dtl.TPMaster TPMasterE, 
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateE ,
			  dtl.MarketName AS SMarketNameE,
			   dtl.Starttime AS SStarttimeE,
			     dtl.MarketNameEnd AS EMarketNameE,
				  dtl.Endtime AS EEndtimeE  , dtl.Objective SObjectiveE,  tt.TPName  AS STourPurposeE ,
			   STUFF( (SELECT  CONCAT( mm.MarketName , '''') FROM tblMarket mm (NOLOCK) INNER JOIN dbo.tblTPMarketDetail mgd ON mgd.MarketId=mm.MarketId WHERE mgd.TourPlanId=dtl.TourPlanId ORDER BY mgd.MarketId FOR XML PATH ('''') ),1,1,'''') as   OtherVisitME 
              FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
        WHERE 
            dtl.isMarketVisit = 1 
            AND IsEvening = 1
    ) tblEve ON tblEve.TPMasterE = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblEve.TourPlanDateE)

 


   LEFT JOIN (
        SELECT 
            dtl.TPMaster TPMasterO, 
            CONVERT(DATE, dtl.TourPlanDate) AS TourPlanDateO ,
		  tt.TPName  AS STourPurposeO  
			     FROM  
            tbl_TourPlanInfo dtl WITH (NOLOCK)
            LEFT JOIN dbo.tbl_TourPlanPurpose tt WITH (NOLOCK) ON tt.TPID = dtl.TPID
        WHERE 
            dtl.IsOtherVisit = 1 
            
    ) tblOther ON tblOther.TPMasterO = mas.TPMaster and  convert(date, dtlT.TourPlanDate) =convert(date, tblOther.TourPlanDateO)

 

 

WHERE convert(date, dtlT.TourPlanDate) is not null   '+  @param+  ' order by    EmpMasterCode  asc , convert(date, dtlT.TourPlanDate)  asc'
 
END

EXEC (@Query)

	  
