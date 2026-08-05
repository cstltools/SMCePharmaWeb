CREATE PROCEDURE [dbo].[sp_Webapi_Get_LeaveType]
	@empId INT,
	@year INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Always current year use
    SET @year = YEAR(GETDATE());

    ----------------------------------------------------------------------
    -- Annual leave row (hardcoded YearlyLeaveBalance = 1)
    ----------------------------------------------------------------------
    SELECT
        'Annual' AS LeaveTypeName,
        1       AS LeaveBalanceId,
        CAST(1 AS INT) AS YearlyLeaveBalance
    FROM tblEmpGeneralInfo PM WITH (NOLOCK)
    LEFT JOIN (
        SELECT 
            SUM(mas.YearlyLeaveBalance) AS PreviousLeave,
            mas.EmployeeInfoId          AS EmployeeInfoId
        FROM Employee_YearlyLeaveBalance mas
        WHERE mas.LeaveTypeId = 3
          AND mas.FiscalYear = (CAST(@year AS INT) - 1)
        GROUP BY mas.EmployeeInfoId
    ) tblPre ON PM.EmpInfoId = tblPre.EmployeeInfoId
    LEFT JOIN (
        SELECT 
            SUM(mas.YearlyLeaveQty) AS Annual,
            mas.EmployeeInfoId      AS EmployeeInfoId
        FROM Employee_YearlyLeaveBalance mas
        WHERE mas.LeaveTypeId = 1
        GROUP BY mas.EmployeeInfoId
    ) tblAnnual ON PM.EmpInfoId = tblAnnual.EmployeeInfoId
    LEFT JOIN (
        SELECT 
            EmpId,
            SUM(AccumulateLeave) AS AccumulateLeave
        FROM dbo.tblLeaveEncashBlnc
        WHERE YearVal = (CAST(@year AS INT) - 1)
        GROUP BY EmpId
    ) tblAccMu ON tblAccMu.EmpId = PM.EmpInfoId
    WHERE PM.EmpInfoId = @empId
      AND ISNULL(tblPre.PreviousLeave, 0) 
        + ISNULL(tblAnnual.Annual, 0) 
        + ISNULL(tblAccMu.AccumulateLeave, 0) > 0

    UNION ALL

    ----------------------------------------------------------------------
    -- Other leave types (hardcoded YearlyLeaveBalance = 1)
    ----------------------------------------------------------------------
    SELECT DISTINCT
        B.LeaveConType          AS LeaveTypeName,
        A.LeaveTypeId           AS LeaveBalanceId,
        CAST(1 AS INT)          AS YearlyLeaveBalance
    FROM dbo.Employee_YearlyLeaveBalance A
    INNER JOIN tblLeaveConType B 
        ON B.LeaveConTypeId = A.LeaveTypeId
    INNER JOIN dbo.Employee_YearlyLeaveTranscations C 
        ON C.LeaveBalanceId = A.LeaveBalanceId
    WHERE A.EmployeeInfoId = @empId
      AND A.FiscalYear    = @year
      AND A.LeaveTypeId  NOT IN (1)   -- Annual already upore nicchi
    GROUP BY  
        B.LeaveConType, 
        A.LeaveBalanceId,     
        A.LeaveTypeId
    HAVING SUM(A.YearlyLeaveBalance) > 0;

END;
