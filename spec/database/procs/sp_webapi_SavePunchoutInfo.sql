CREATE PROCEDURE [dbo].[sp_webapi_SavePunchoutInfo]
	-- Add the parameters for the stored procedure here
@attendaceDate DATETIME,
@pOutTime NVARCHAR(50),
@pOutLat NVARCHAR(50),
@pOutLong NVARCHAR(50),
@remarks NVARCHAR(500),
@empId INT,
@EntryDate DATETIME
AS
BEGIN

DECLARE @count INT

SELECT @count =  COUNT(*) FROM dbo.tblMarketAttendance_Master_webapi WHERE AttendanceDate = @attendaceDate AND EmpInfoId = @empId

IF(@count > 0)
BEGIN
		
		UPDATE dbo.tblMarketAttendance_Master_webapi 
		SET PunchOutTime =@pOutTime,
			POutLat = @pOutLat,
			POutLong = @pOutLong,
			POutRemarks = @remarks,
			POUTCreatedDateTime = @EntryDate
			WHERE AttendanceDate = @attendaceDate AND EmpInfoId = @empId
		
END




END
