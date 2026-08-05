CREATE PROCEDURE [dbo].[sp_Webapi_Get_DoctorList]
    @empId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE 
        @sql NVARCHAR(MAX) = '',
        @filter NVARCHAR(MAX) = '',
        @ids NVARCHAR(MAX),
        @roleType NVARCHAR(10)

    -- Get RoleType of employee
    SELECT @roleType = UR.RoleTypeId
    FROM dbo.tblUser U
    LEFT JOIN dbo.tbl_UserRoleInfo UR ON UR.UserRoleID = U.UserRoleID
    WHERE U.EmpInfoId = @empId;

    -- Base query
    SET @sql = '
    SELECT DISTINCT 
        DM.MarketCode,
        DM.DoctorId,
        ISNULL(DM.DoctorCode, '''') AS DoctorCode,
        DM.DoctorName,
        ISNULL(DM.DocContact, ''N/A'') AS DocContact,
        ISNULL(DM.DoctorTypeName, ''N/A'') AS DoctorTypeName,
        ISNULL(DM.ProgramTypeName, ''N/A'') AS ProgramTypeName,
        ISNULL(DM.ChemberName, ''N/A'') AS ChemberName,
        DM.GroupId,
        DM.RegionId,
        DM.AreaId,
        DM.TerritoryId,
        DM.SubTerritoryId,
        DM.MarketId,
        DM.MarketName,
        ISNULL(DM.SMCTypeId, 0) AS SMCTypeId,
        ISNULL(DM.SMCType, ''N/A'') AS SMCType,
        ISNULL(DM.ProgramTypeId, 0) AS ProgramTypeId,
        ISNULL(DM.DoctorTypeId, 0) AS DoctorTypeId
    FROM View_DoctorMaster DM WITH (NOLOCK)
    ';

    -- Append WHERE clause based on RoleType
    IF @roleType = '1'
    BEGIN
        SELECT @ids = TRY_CAST(EFI.EmpTerrId AS NVARCHAR)
        FROM View_Webapi_EmployeeFieldForceInfo EFI
        WHERE EFI.EmpInfoId = @empId;

        SET @filter = 'WHERE DM.TerritoryId = ' + QUOTENAME(@ids, '''');
    END
    ELSE IF @roleType = '2'
    BEGIN
        SELECT @ids = STUFF((
            SELECT ',' + CAST(EFI.EmpAreaId AS VARCHAR)
            FROM View_Webapi_EmployeeFieldForceInfo EFI WITH (NOLOCK)
            WHERE EFI.EmpInfoId = @empId
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SET @filter = 'WHERE DM.AreaId IN (' + @ids + ')';
    END
    ELSE IF @roleType = '3'
    BEGIN
        SELECT @ids = STUFF((
            SELECT ',' + CAST(EFI.EmpRegionId AS VARCHAR)
            FROM View_Webapi_EmployeeFieldForceInfo EFI WITH (NOLOCK)
            WHERE EFI.EmpInfoId = @empId
            FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, '');

        SET @filter = 'WHERE DM.RegionId IN (' + @ids + ')';
    END
    ELSE IF @roleType = '4'
    BEGIN
        SELECT @ids = TRY_CAST(EFI.EmpGroupId AS NVARCHAR)
        FROM View_Webapi_EmployeeFieldForceInfo EFI
        WHERE EFI.EmpInfoId = @empId;

        SET @filter = 'WHERE DM.GroupId = ' + QUOTENAME(@ids, '''');
    END

    -- Combine full query
    SET @sql = @sql + CHAR(13) + @filter;

    -- Execute the dynamic query
    EXEC sp_executesql @sql;
END
