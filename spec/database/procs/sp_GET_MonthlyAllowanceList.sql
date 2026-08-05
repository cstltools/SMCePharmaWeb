
--------------------------------------------------
-- PROCEDURE: sp_GET_MonthlyAllowanceList
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_MonthlyAllowanceList
    @RoleName NVARCHAR(100) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    SELECT MonthlyAllowanceId,
           RoleName,
           AllowanceName,
           AllowanceAmount,
           IsActive,
           CASE WHEN IsActive = 1 THEN 'Active' ELSE 'Inactive' END AS ActiveStatus,
           CONVERT(VARCHAR(11), EntryDate, 106) AS EntryDateText
    FROM dbo.tblMonthlyAllowances WITH (NOLOCK)
    WHERE (@RoleName IS NULL OR RoleName = @RoleName)
    ORDER BY MonthlyAllowanceId DESC;
END

