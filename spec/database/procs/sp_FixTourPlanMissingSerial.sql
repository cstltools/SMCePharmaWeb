CREATE PROCEDURE [dbo].[sp_FixTourPlanMissingSerial]
AS
BEGIN

	SET NOCOUNT ON;

	UPDATE dbo.tbl_TourPlanInfo
	SET SerialNo = 1
	WHERE CONVERT(date, TourPlanDate) = CONVERT(date, GETDATE())
		AND EmpInfoId NOT IN (
			SELECT EmpInfoId
			FROM dbo.tbl_TourPlanInfo
			WHERE SerialNo = 1 AND CONVERT(date, TourPlanDate) = CONVERT(date, GETDATE())
		);

	SELECT @@ROWCOUNT AS UpdatedRows;

END
