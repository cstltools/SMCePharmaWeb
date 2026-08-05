CREATE FUNCTION [dbo].[fn_GetTerritoryInfo]
(
    @RoleType NVARCHAR(MAX),
    @EmpId INT
)
RETURNS @TerritoryInfo TABLE
(
    TerritoryCode NVARCHAR(MAX),
    TerritoryName NVARCHAR(MAX),
	   TerritoryId int,
      AreaId int,
      RegionId int,
      GroupId int
)
AS
BEGIN
    DECLARE @marCo NVARCHAR(MAX)
    DECLARE @marName NVARCHAR(MAX)
    DECLARE @TerritoryId int=0
    DECLARE @AreaId int=0
    DECLARE @RegionId int=0
    DECLARE @GroupId int=0

    IF (@RoleType = 'MIO')
    BEGIN
        SELECT TOP 1 
            @marCo = Tr.TerritoryCode, 
            @marName = Tr.TerritoryName, @TerritoryId=M.TerritoryId
        FROM dbo.tblMIOInfo AS M 
        LEFT JOIN dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  
        WHERE Tr.IsActive = 1 AND M.EmployeeId = @EmpId AND M.IsActive = 1
        ORDER BY M.MIOId DESC

        --IF (@marCo IS NULL)
        --BEGIN
        --    SELECT TOP 1 
        --        @marCo = Tr.TerritoryCode, 
        --        @marName = Tr.TerritoryName, @TerritoryId=M.TerritoryId
        --    FROM dbo.tblMIOInfo AS M 
        --    LEFT JOIN dbo.tblTerritory AS Tr ON M.TerritoryId = Tr.TerritoryId  
        --    WHERE Tr.IsActive = 1 AND M.EmployeeId = @EmpId
        --    ORDER BY M.MIOId DESC
        --END
    END

    ELSE IF (@RoleType = 'AM')
    BEGIN
        SELECT TOP 1 
            @marCo = Ar.AreaCode, 
            @marName = Ar.AreaName, @AreaId=AM.AreaId
        FROM dbo.tblASMInfo AS AM 
        LEFT JOIN dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
        WHERE Ar.IsActive = 1 AND AM.EmployeeId = @EmpId AND AM.IsActive = 1
        ORDER BY AM.ASMId DESC

        --IF (@marCo IS NULL)
        --BEGIN
        --    SELECT TOP 1 
        --        @marCo = Ar.AreaCode, 
        --        @marName = Ar.AreaName, @AreaId=AM.AreaId
        --    FROM dbo.tblASMInfo AS AM 
        --    LEFT JOIN dbo.tblArea AS Ar ON AM.AreaId = Ar.AreaId
        --    WHERE Ar.IsActive = 1 AND AM.EmployeeId = @EmpId
        --    ORDER BY AM.ASMId DESC
        --END
    END

    ELSE IF (@RoleType = 'DZSM')
    BEGIN
        SELECT TOP 1 
            @marCo = Rg.RegionCode, 
            @marName = Rg.RegionName, @RegionId=RM.RegionId
        FROM dbo.tblRSMInfo AS RM 
        LEFT JOIN dbo.tblRegion AS Rg ON RM.RegionId = Rg.RegionId
        WHERE Rg.IsActive = 1 AND RM.EmployeeId = @EmpId AND RM.IsActive = 1
        ORDER BY RM.RSMId DESC

        IF (@marCo IS NULL)
        BEGIN
            SELECT TOP 1 
                @marCo = Rg.RegionCode, 
                @marName = Rg.RegionName, @RegionId=RM.RegionId
            FROM dbo.tblRSMInfo AS RM 
            LEFT JOIN dbo.tblRegion AS Rg ON RM.RegionId = Rg.RegionId
            WHERE Rg.IsActive = 1 AND RM.EmployeeId = @EmpId
            ORDER BY RM.RSMId DESC
        END
    END

    ELSE IF (@RoleType = 'NSM')
    BEGIN
        SELECT TOP 1 
            @marCo = Tr.GroupCode, 
            @marName = Tr.GroupName, @GroupId=M.GroupId
        FROM dbo.tblNSMInfo AS M 
        LEFT JOIN dbo.tbl_Group AS Tr ON M.GroupId = Tr.GroupId  
        WHERE Tr.IsActive = 1 AND M.EmployeeId = @EmpId
        ORDER BY M.NSMId DESC
    END

    -- Insert the result into the return table
    INSERT INTO @TerritoryInfo (TerritoryCode, TerritoryName, TerritoryId, AreaId, RegionId, GroupId)
    VALUES (@marCo, @marName,  isnull(@TerritoryId,0),  isnull(@AreaId,0),  isnull(@RegionId,0),  isnull(@GroupId,0))

    RETURN
END
