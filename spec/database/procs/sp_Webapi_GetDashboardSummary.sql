
-- Summary SP
CREATE   PROC dbo.sp_Webapi_GetDashboardSummary
    @empId INT
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH latest AS (
        SELECT TOP 1 *
        FROM dbo.DashboardSummary WITH (NOLOCK)
        WHERE EmpInfoId = @empId
        ORDER BY CreatedOn DESC
    )
    SELECT
        PunchInTime      = ISNULL(FORMAT(PunchInTime, 'hh:mm tt'), ''),
        PunchOutTime     = ISNULL(FORMAT(PunchOutTime, 'hh:mm tt'), ''),
        WorkingHours     = ISNULL(WorkingHours, 0),
        MeetingsCount    = ISNULL(MeetingsCount, 0),
        ProviderCount    = ISNULL(ProviderCount, 0),
        PendingTaskCount = ISNULL(PendingTaskCount, 0),
        TrainingCount    = ISNULL(TrainingCount, 0),
        TourPlanCount    = ISNULL(TourPlanCount, 0)
    FROM latest;
END
