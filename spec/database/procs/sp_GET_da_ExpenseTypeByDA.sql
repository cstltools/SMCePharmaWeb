
--------------------------------------------------
-- PROCEDURE: sp_GET_da_ExpenseTypeByDA
--------------------------------------------------

CREATE   PROCEDURE [dbo].[sp_GET_da_ExpenseTypeByDA]
    @RoleId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        ExpenseTypeId,
        ExpenseTypeName,
        ImageRequired,
        ISNULL([ExpenseAmount], 0) AS ExpenseAmount,
        ISNULL([isFixed], 0) AS isFixed
    FROM dbo.tbl_ExpenseTypeMaster v
    LEFT JOIN dbo.tblRoleType rt
        ON v.RoleType_xp = rt.RoleTypeId
    CROSS APPLY
    (
        SELECT x.value('.', 'VARCHAR(10)') AS RoleVal
        FROM
        (
            SELECT CAST('<i>' + REPLACE(ISNULL(v.RoleTypeMult, ''), ',', '</i><i>') + '</i>' AS XML) AS xmlData
        ) t
        CROSS APPLY t.xmlData.nodes('/i') AS a(x)
    ) AS split
    WHERE TRY_CONVERT(INT, LTRIM(RTRIM(split.RoleVal))) = 15  and IsActive=1
END

