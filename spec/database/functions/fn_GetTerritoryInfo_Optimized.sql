CREATE FUNCTION [dbo].[fn_GetTerritoryInfo_Optimized]
(
    @RoleType NVARCHAR(MAX),
    @EmpId INT
)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        TerritoryCode = 
            CASE 
                WHEN @RoleType = 'MIO' THEN Tr.TerritoryCode
                WHEN @RoleType = 'AM' THEN Ar.AreaCode
                WHEN @RoleType = 'DZSM' THEN Rg.RegionCode
                WHEN @RoleType = 'NSM' THEN Gr.GroupCode
                ELSE NULL
            END,
        TerritoryName = 
            CASE 
                WHEN @RoleType = 'MIO' THEN Tr.TerritoryName
                WHEN @RoleType = 'AM' THEN Ar.AreaName
                WHEN @RoleType = 'DZSM' THEN Rg.RegionName
                WHEN @RoleType = 'NSM' THEN Gr.GroupName
                ELSE NULL
            END,
        TerritoryId = ISNULL(MIO.TerritoryId, 0),
        AreaId = ISNULL(AM.AreaId, 0),
        RegionId = ISNULL(RSM.RegionId, 0),
        GroupId = ISNULL(NSM.GroupId, 0)
    FROM 
        tblEmpGeneralInfo E
        LEFT JOIN tblMIOInfo MIO ON @RoleType = 'MIO' AND MIO.EmployeeId = @EmpId AND MIO.IsActive = 1
        LEFT JOIN tblTerritory Tr ON MIO.TerritoryId = Tr.TerritoryId AND Tr.IsActive = 1

        LEFT JOIN tblASMInfo AM ON @RoleType = 'AM' AND AM.EmployeeId = @EmpId AND AM.IsActive = 1
        LEFT JOIN tblArea Ar ON AM.AreaId = Ar.AreaId AND Ar.IsActive = 1

        LEFT JOIN tblRSMInfo RSM ON @RoleType = 'DZSM' AND RSM.EmployeeId = @EmpId AND RSM.IsActive = 1
        LEFT JOIN tblRegion Rg ON RSM.RegionId = Rg.RegionId AND Rg.IsActive = 1

        LEFT JOIN tblNSMInfo NSM ON @RoleType = 'NSM' AND NSM.EmployeeId = @EmpId
        LEFT JOIN tbl_Group Gr ON NSM.GroupId = Gr.GroupId AND Gr.IsActive = 1
)

