
-- Tiles SP
CREATE   PROC dbo.sp_Webapi_GetDashboardTiles
    @empId INT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @summary TABLE
    (
        PunchInTime      DATETIME,
        PunchOutTime     DATETIME,
        WorkingHours     DECIMAL(10,2),
        MeetingsCount    INT,
        ProviderCount    INT,
        PendingTaskCount INT,
        TrainingCount    INT,
        TourPlanCount    INT
    );

    INSERT INTO @summary
    SELECT TOP 1 PunchInTime, PunchOutTime, WorkingHours, MeetingsCount, ProviderCount, PendingTaskCount, TrainingCount, TourPlanCount
    FROM dbo.DashboardSummary WITH (NOLOCK)
    WHERE EmpInfoId = @empId
    ORDER BY CreatedOn DESC;

    -- If no summary exists, seed a default empty row so tiles still return with zeros/placeholders
    IF NOT EXISTS (SELECT 1 FROM @summary)
    BEGIN
        INSERT INTO @summary
        VALUES (NULL, NULL, 0, 0, 0, 0, 0, 0);
    END

    -- build rows dynamically from summary using config
    SELECT
        tc.FieldName,
        tc.FieldBgColor,
        tc.FieldIcon,
        FieldCount = s.FieldCount,
        FieldValue = s.FieldValue
    FROM dbo.DashboardTileConfig tc WITH (NOLOCK)
    CROSS APPLY (
        SELECT
            FieldCount = CASE tc.FieldKey
                WHEN 'WorkingHours'     THEN ISNULL(CAST(ROUND(sm.WorkingHours, 0) AS INT), 0)
                WHEN 'MeetingsCount'    THEN ISNULL(sm.MeetingsCount, 0)
                WHEN 'ProviderCount'    THEN ISNULL(sm.ProviderCount, 0)
                WHEN 'PendingTaskCount' THEN ISNULL(sm.PendingTaskCount, 0)
                WHEN 'TrainingCount'    THEN ISNULL(sm.TrainingCount, 0)
                WHEN 'TourPlanCount'    THEN ISNULL(sm.TourPlanCount, 0)
                ELSE 0
            END,
            FieldValue = CASE tc.FieldKey
                WHEN 'PunchInTime'  THEN ISNULL(FORMAT(sm.PunchInTime, 'hh:mm tt'), '')
                WHEN 'PunchOutTime' THEN ISNULL(FORMAT(sm.PunchOutTime, 'hh:mm tt'), '')
                WHEN 'WorkingHours' THEN ISNULL(FORMAT(sm.WorkingHours, '0.##'), '0')
                ELSE NULL
            END
        FROM @summary sm
    ) s
    WHERE tc.IsActive = 1
    ORDER BY tc.FieldOrder;
END
