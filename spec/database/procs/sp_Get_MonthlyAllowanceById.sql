
--------------------------------------------------
-- PROCEDURE: sp_Get_MonthlyAllowanceById
--------------------------------------------------

CREATE   PROCEDURE dbo.sp_Get_MonthlyAllowanceById
    @MonthlyAllowanceId INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT MonthlyAllowanceId,
           RoleName,
           AllowanceName,
           AllowanceAmount,
           IsActive
    FROM dbo.tblMonthlyAllowances WITH (NOLOCK)
    WHERE MonthlyAllowanceId = @MonthlyAllowanceId;
END

