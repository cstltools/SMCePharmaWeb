CREATE PROCEDURE [dbo].[sp_RPT_TourPlanMissingSerial]
AS
BEGIN

	SET NOCOUNT ON;

	SELECT DISTINCT
		tp.EmpInfoId,
		emp.EmpName
	FROM dbo.tbl_TourPlanInfo tp WITH (NOLOCK)
	LEFT JOIN dbo.tblEmpGeneralInfo emp WITH (NOLOCK) ON emp.EmpInfoId = tp.EmpInfoId
	WHERE CONVERT(date, tp.TourPlanDate) = CONVERT(date, GETDATE())
		AND tp.EmpInfoId NOT IN (
			SELECT EmpInfoId
			FROM dbo.tbl_TourPlanInfo WITH (NOLOCK)
			WHERE SerialNo = 1 AND CONVERT(date, TourPlanDate) = CONVERT(date, GETDATE())
		)
	ORDER BY tp.EmpInfoId;

END
