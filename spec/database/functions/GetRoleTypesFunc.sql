
CREATE FUNCTION dbo.GetRoleTypesFunc
(
    @RoleTypeIds VARCHAR(MAX)
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
    DECLARE @RoleTypes NVARCHAR(MAX);

    SELECT @RoleTypes = COALESCE(@RoleTypes + ', ', '') + RoleType
    FROM tblRoleType
    WHERE RoleTypeId IN (SELECT * FROM dbo.fnSplit(@RoleTypeIds, ','));

    RETURN @RoleTypes;
END
