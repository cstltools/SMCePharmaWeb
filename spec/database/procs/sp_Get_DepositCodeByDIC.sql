CREATE PROCEDURE [dbo].[sp_Get_DepositCodeByDIC]
    @Parm INT = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CompanyId INT = CASE WHEN ISNULL(@Parm, 0) > 0 THEN @Parm ELSE 1 END;

    SELECT
        com.ComUnitCode + '-' 
        + CONVERT(varchar(8), GETDATE(), 112)  -- yyyymmdd (FORMAT() না ব্যবহার করাই ভালো পারফরম্যান্সে)
        + '-' 
        + CONVERT(nvarchar(50), ISNULL(MAX(UNT.DepositId), 0) + 100) AS DepositCode
    FROM tblCompanyUnit com WITH (NOLOCK)
    LEFT JOIN tblCompanyWiseDeposit UNT WITH (NOLOCK)
        ON UNT.CompanyId = com.ComUnitId
    WHERE com.ComUnitId = @CompanyId
    GROUP BY com.ComUnitCode;
END
