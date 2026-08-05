CREATE FUNCTION dbo.fn_GetExistenceStatus(@CellNo NVARCHAR(MAX))
RETURNS NVARCHAR(50)
AS
BEGIN
    DECLARE @ExistenceStatus NVARCHAR(50)

    SELECT @ExistenceStatus = 
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM dbo.tblCustMaster m WITH (NOLOCK)
                WHERE m.CellNo = @CellNo and   [ActionStatus] <>'3'
                GROUP BY m.CellNo
                HAVING COUNT(*) > 1
            ) THEN 'Already Exists'
            ELSE 'Not Exists'
        END

    RETURN @ExistenceStatus
END;
