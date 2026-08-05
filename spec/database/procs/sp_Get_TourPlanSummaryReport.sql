

 CREATE PROCEDURE [dbo].[sp_Get_TourPlanSummaryReport]
	-- Add the parameters for the stored procedure here
		@EmpInfoId int=0,
		@UserRoleId int=0,
		@Month int,
		@Year int
AS
BEGIN  
DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
DECLARE @EndDate   DATE = EOMONTH(@StartDate);

;WITH DateRange AS (
    -- Ei CTE te full month er sob date generate hobe
    SELECT DATEADD(DAY, v.Number, @StartDate) AS WorkDate
    FROM master.dbo.spt_values v
    WHERE v.Type = 'P'
      AND v.Number BETWEEN 0 AND DATEDIFF(DAY, @StartDate, @EndDate)
),
WorkingDays AS (
    -- Friday baad dile ekhane working days count korte paro
    SELECT COUNT(*) AS WorkingDays
    FROM DateRange
    -- WHERE DATEPART(WEEKDAY, WorkDate) <> 6  -- jodi Friday baad dite chao
)

SELECT 
    ROW_NUMBER() OVER (ORDER BY tblTerr.TerritoryCode_TP) AS SL, 
    PM.EmpName AS EmployeeName,  
    PM.EmpInfoId,
    PM.EmpMasterCode AS EmployeeCode,   
    --usRT.RoleType AS Role, 
    usR.RoleName Role, 
    tblTerr.TerritoryCode_TP AS TerritoryCode,
     isnull(tblDayOfHQ.DayOfHQ,0) DayOfHQ,
     isnull(tblNoOfExHQ.NoOfExHQ,0) NoOfExHQ,
    isnull( tblNoOfOS.NoOfOS,0) NoOfOS,
     isnull(tblNoOfOSDCC.NoOfOSDCC,0) NoOfOSDCC,
    isnull( isnull(tblDayOfHQ.DayOfHQ,0)+
    isnull(tblNoOfExHQ.NoOfExHQ,0)+
    isnull(tblNoOfOS.NoOfOS,0)+
    isnull(tblNoOfOSDCC.NoOfOSDCC,0),0)   NoOfDaysWork, 
    COALESCE(
    CASE 
        WHEN (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0) < 0
        THEN 0
        ELSE (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0)
    END, 
    0
) AS NoOfDaysLeave,

    '' AS DaysWorkTeamMate  
    
FROM 
    tblEmpGeneralInfo PM
    INNER JOIN tblUser us WITH (NOLOCK) ON PM.EmpInfoId = us.EmpInfoId
    INNER JOIN tbl_UserRoleInfo usR WITH (NOLOCK) ON usR.UserRoleId = us.UserRoleId
    INNER JOIN tblRoleType usRT WITH (NOLOCK) ON usR.RoleTypeId = usRT.RoleTypeId
    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            dtl.TerritoryCode_TP,
            dtl.TourPlanDate,
            ROW_NUMBER() OVER (PARTITION BY dtl.EmpInfoId ORDER BY dtl.TourPlanDate DESC) AS RowNum
        FROM 
            tbl_TourPlanInfo dtl  
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   and dtl.SerialNo='1'
    ) tblTerr ON tblTerr.EmpInfoId = PM.EmpInfoId AND tblTerr.RowNum = 1

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS DayOfHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   
            AND tps.StationTypeName = 'HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblDayOfHQ ON tblDayOfHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfExHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'Ex. HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfExHQ ON tblNoOfExHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOS
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOS ON tblNoOfOS.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOSDCC
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS-DCC'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOSDCC ON tblNoOfOSDCC.EmpInfoId = PM.EmpInfoId
	 
    --LEFT JOIN (
    --    SELECT 
    --        dtl.EmpInfoId,
    --        dtl.RegionCode_TP + ' ' + cast(count(dtl.TourPlanId) as nvarchar(max))+ ' D' DaysWorkTeamMate
    --    FROM 
    --        tbl_TourPlanInfo dtl  
			 
    --    WHERE    dtl.VisitedWithEmpInfoId is not null and
    --        MONTH(dtl.TourPlanDate) = @Month 
    --        AND YEAR(dtl.TourPlanDate) = @Year   and dtl.TourTypeId is not null and dtl.SerialNo='1' 
    --    GROUP BY dtl.EmpInfoId, dtl.RegionCode_TP
    --) tblDaysWorkTeamMate ON tblDaysWorkTeamMate.EmpInfoId = PM.EmpInfoId

   where tblTerr.TerritoryCode_TP is not null  
   AND (PM.EmpInfoId = @EmpInfoId OR @EmpInfoId = 0 OR @EmpInfoId IS NULL)
   and   (us.UserRoleId = @UserRoleId OR @UserRoleId = 0 OR @UserRoleId IS NULL)
 and usRT.RoleType='MIO'


 union all
 SELECT 
    ROW_NUMBER() OVER (ORDER BY tblTerr.TerritoryCode_TP) AS SL, 
    PM.EmpName AS EmployeeName,  
    PM.EmpInfoId,
    PM.EmpMasterCode AS EmployeeCode,   
    --usRT.RoleType AS Role, 
    usR.RoleName Role, 
    tblTerr.TerritoryCode_TP AS TerritoryCode,
     isnull(tblDayOfHQ.DayOfHQ,0) DayOfHQ,
     isnull(tblNoOfExHQ.NoOfExHQ,0) NoOfExHQ,
    isnull( tblNoOfOS.NoOfOS,0) NoOfOS,
     isnull(tblNoOfOSDCC.NoOfOSDCC,0) NoOfOSDCC,
    isnull( isnull(tblDayOfHQ.DayOfHQ,0)+
    isnull(tblNoOfExHQ.NoOfExHQ,0)+
    isnull(tblNoOfOS.NoOfOS,0)+
    isnull(tblNoOfOSDCC.NoOfOSDCC,0),0)   NoOfDaysWork, 
    COALESCE(
    CASE 
        WHEN (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0) < 0
        THEN 0
        ELSE (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0)
    END, 
    0
) AS NoOfDaysLeave,

    '' AS DaysWorkTeamMate  
    
FROM 
    tblEmpGeneralInfo PM
    INNER JOIN tblUser us WITH (NOLOCK) ON PM.EmpInfoId = us.EmpInfoId
    INNER JOIN tbl_UserRoleInfo usR WITH (NOLOCK) ON usR.UserRoleId = us.UserRoleId
    INNER JOIN tblRoleType usRT WITH (NOLOCK) ON usR.RoleTypeId = usRT.RoleTypeId
    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            dtl.AreaCode_TP TerritoryCode_TP,
            dtl.TourPlanDate,
            ROW_NUMBER() OVER (PARTITION BY dtl.EmpInfoId ORDER BY dtl.TourPlanDate DESC) AS RowNum
        FROM 
            tbl_TourPlanInfo dtl  
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   and dtl.SerialNo='1'
    ) tblTerr ON tblTerr.EmpInfoId = PM.EmpInfoId AND tblTerr.RowNum = 1

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS DayOfHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   
            AND tps.StationTypeName = 'HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblDayOfHQ ON tblDayOfHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfExHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'Ex. HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfExHQ ON tblNoOfExHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOS
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOS ON tblNoOfOS.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOSDCC
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS-DCC'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOSDCC ON tblNoOfOSDCC.EmpInfoId = PM.EmpInfoId
	 
    --LEFT JOIN (
    --    SELECT 
    --        dtl.EmpInfoId,
    --        dtl.RegionCode_TP + ' ' + cast(count(dtl.TourPlanId) as nvarchar(max))+ ' D' DaysWorkTeamMate
    --    FROM 
    --        tbl_TourPlanInfo dtl  
			 
    --    WHERE    dtl.VisitedWithEmpInfoId is not null and
    --        MONTH(dtl.TourPlanDate) = @Month 
    --        AND YEAR(dtl.TourPlanDate) = @Year   and dtl.TourTypeId is not null and dtl.SerialNo='1' 
    --    GROUP BY dtl.EmpInfoId, dtl.RegionCode_TP
    --) tblDaysWorkTeamMate ON tblDaysWorkTeamMate.EmpInfoId = PM.EmpInfoId

   where tblTerr.TerritoryCode_TP is not null  
   AND (PM.EmpInfoId = @EmpInfoId OR @EmpInfoId = 0 OR @EmpInfoId IS NULL)
   and   (us.UserRoleId = @UserRoleId OR @UserRoleId = 0 OR @UserRoleId IS NULL)
 and usRT.RoleType='AM'


 
 union all
 SELECT 
    ROW_NUMBER() OVER (ORDER BY tblTerr.TerritoryCode_TP) AS SL, 
    PM.EmpName AS EmployeeName,  
    PM.EmpInfoId,
    PM.EmpMasterCode AS EmployeeCode,   
    --usRT.RoleType AS Role, 
    usR.RoleName Role, 
    tblTerr.TerritoryCode_TP AS TerritoryCode,
     isnull(tblDayOfHQ.DayOfHQ,0) DayOfHQ,
     isnull(tblNoOfExHQ.NoOfExHQ,0) NoOfExHQ,
    isnull( tblNoOfOS.NoOfOS,0) NoOfOS,
     isnull(tblNoOfOSDCC.NoOfOSDCC,0) NoOfOSDCC,
    isnull( isnull(tblDayOfHQ.DayOfHQ,0)+
    isnull(tblNoOfExHQ.NoOfExHQ,0)+
    isnull(tblNoOfOS.NoOfOS,0)+
    isnull(tblNoOfOSDCC.NoOfOSDCC,0),0)   NoOfDaysWork, 
    COALESCE(
    CASE 
        WHEN (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0) < 0
        THEN 0
        ELSE (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0)
    END, 
    0
) AS NoOfDaysLeave,

    '' AS DaysWorkTeamMate  
    
FROM 
    tblEmpGeneralInfo PM
    INNER JOIN tblUser us WITH (NOLOCK) ON PM.EmpInfoId = us.EmpInfoId
    INNER JOIN tbl_UserRoleInfo usR WITH (NOLOCK) ON usR.UserRoleId = us.UserRoleId
    INNER JOIN tblRoleType usRT WITH (NOLOCK) ON usR.RoleTypeId = usRT.RoleTypeId
    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            dtl.RegionCode_TP TerritoryCode_TP,
            dtl.TourPlanDate,
            ROW_NUMBER() OVER (PARTITION BY dtl.EmpInfoId ORDER BY dtl.TourPlanDate DESC) AS RowNum
        FROM 
            tbl_TourPlanInfo dtl  
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   and dtl.SerialNo='1'
    ) tblTerr ON tblTerr.EmpInfoId = PM.EmpInfoId AND tblTerr.RowNum = 1

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS DayOfHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   
            AND tps.StationTypeName = 'HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblDayOfHQ ON tblDayOfHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfExHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'Ex. HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfExHQ ON tblNoOfExHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOS
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOS ON tblNoOfOS.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOSDCC
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS-DCC'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOSDCC ON tblNoOfOSDCC.EmpInfoId = PM.EmpInfoId
	 
    --LEFT JOIN (
    --    SELECT 
    --        dtl.EmpInfoId,
    --        dtl.RegionCode_TP + ' ' + cast(count(dtl.TourPlanId) as nvarchar(max))+ ' D' DaysWorkTeamMate
    --    FROM 
    --        tbl_TourPlanInfo dtl  
			 
    --    WHERE    dtl.VisitedWithEmpInfoId is not null and
    --        MONTH(dtl.TourPlanDate) = @Month 
    --        AND YEAR(dtl.TourPlanDate) = @Year   and dtl.TourTypeId is not null and dtl.SerialNo='1' 
    --    GROUP BY dtl.EmpInfoId, dtl.RegionCode_TP
    --) tblDaysWorkTeamMate ON tblDaysWorkTeamMate.EmpInfoId = PM.EmpInfoId

   where tblTerr.TerritoryCode_TP is not null  
   AND (PM.EmpInfoId = @EmpInfoId OR @EmpInfoId = 0 OR @EmpInfoId IS NULL)
   and   (us.UserRoleId = @UserRoleId OR @UserRoleId = 0 OR @UserRoleId IS NULL)
 and usRT.RoleType='DZSM'


 
 
 union all
 SELECT 
    ROW_NUMBER() OVER (ORDER BY tblTerr.TerritoryCode_TP) AS SL, 
    PM.EmpName AS EmployeeName,  
    PM.EmpInfoId,
    PM.EmpMasterCode AS EmployeeCode,   
    --usRT.RoleType AS Role, 
    usR.RoleName Role, 
    tblTerr.TerritoryCode_TP AS TerritoryCode,
     isnull(tblDayOfHQ.DayOfHQ,0) DayOfHQ,
     isnull(tblNoOfExHQ.NoOfExHQ,0) NoOfExHQ,
    isnull( tblNoOfOS.NoOfOS,0) NoOfOS,
     isnull(tblNoOfOSDCC.NoOfOSDCC,0) NoOfOSDCC,
    isnull( isnull(tblDayOfHQ.DayOfHQ,0)+
    isnull(tblNoOfExHQ.NoOfExHQ,0)+
    isnull(tblNoOfOS.NoOfOS,0)+
    isnull(tblNoOfOSDCC.NoOfOSDCC,0),0)   NoOfDaysWork, 
    COALESCE(
    CASE 
        WHEN (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0) < 0
        THEN 0
        ELSE (SELECT WorkingDays FROM WorkingDays) 
             - ISNULL(tblDayOfHQ.DayOfHQ, 0)
             - ISNULL(tblNoOfExHQ.NoOfExHQ, 0)
             - ISNULL(tblNoOfOS.NoOfOS, 0)
             - ISNULL(tblNoOfOSDCC.NoOfOSDCC, 0)
    END, 
    0
) AS NoOfDaysLeave,

    '' AS DaysWorkTeamMate  
    
FROM 
    tblEmpGeneralInfo PM
    INNER JOIN tblUser us WITH (NOLOCK) ON PM.EmpInfoId = us.EmpInfoId
    INNER JOIN tbl_UserRoleInfo usR WITH (NOLOCK) ON usR.UserRoleId = us.UserRoleId
    INNER JOIN tblRoleType usRT WITH (NOLOCK) ON usR.RoleTypeId = usRT.RoleTypeId
    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            dtl.GroupCode_TP TerritoryCode_TP,
            dtl.TourPlanDate,
            ROW_NUMBER() OVER (PARTITION BY dtl.EmpInfoId ORDER BY dtl.TourPlanDate DESC) AS RowNum
        FROM 
            tbl_TourPlanInfo dtl  
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   and dtl.SerialNo='1'
    ) tblTerr ON tblTerr.EmpInfoId = PM.EmpInfoId AND tblTerr.RowNum = 1

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS DayOfHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year   
            AND tps.StationTypeName = 'HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblDayOfHQ ON tblDayOfHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfExHQ
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'Ex. HQ'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfExHQ ON tblNoOfExHQ.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOS
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOS ON tblNoOfOS.EmpInfoId = PM.EmpInfoId

    LEFT JOIN (
        SELECT 
            dtl.EmpInfoId,
            ISNULL(COUNT(dtl.TourPlanId),0) AS NoOfOSDCC
        FROM 
            tbl_TourPlanInfo dtl 
            LEFT JOIN dbo.tblStationType tps WITH (NOLOCK) ON tps.StationTypeId = dtl.TourTypeId
        WHERE   
            MONTH(dtl.TourPlanDate) = @Month 
            AND YEAR(dtl.TourPlanDate) = @Year  
            AND tps.StationTypeName = 'OS-DCC'   and dtl.SerialNo='1'
        GROUP BY dtl.EmpInfoId
    ) tblNoOfOSDCC ON tblNoOfOSDCC.EmpInfoId = PM.EmpInfoId
	 
    --LEFT JOIN (
    --    SELECT 
    --        dtl.EmpInfoId,
    --        dtl.RegionCode_TP + ' ' + cast(count(dtl.TourPlanId) as nvarchar(max))+ ' D' DaysWorkTeamMate
    --    FROM 
    --        tbl_TourPlanInfo dtl  
			 
    --    WHERE    dtl.VisitedWithEmpInfoId is not null and
    --        MONTH(dtl.TourPlanDate) = @Month 
    --        AND YEAR(dtl.TourPlanDate) = @Year   and dtl.TourTypeId is not null and dtl.SerialNo='1' 
    --    GROUP BY dtl.EmpInfoId, dtl.RegionCode_TP
    --) tblDaysWorkTeamMate ON tblDaysWorkTeamMate.EmpInfoId = PM.EmpInfoId

   where tblTerr.TerritoryCode_TP is not null  
   AND (PM.EmpInfoId = @EmpInfoId OR @EmpInfoId = 0 OR @EmpInfoId IS NULL)
   and   (us.UserRoleId = @UserRoleId OR @UserRoleId = 0 OR @UserRoleId IS NULL)
 and usRT.RoleType='NSM'


 order by TerritoryCode_TP
	end
--	select * from tblStationType



--SELECT 
--            *
--        FROM 
--            tbl_TourPlanInfo dtl 
--        WHERE   
--            MONTH(dtl.TourPlanDate) = @Month 
--            AND YEAR(dtl.TourPlanDate) = @Year    and dtl.SerialNo='1' 
--        and dtl.EmpInfoId=8

 