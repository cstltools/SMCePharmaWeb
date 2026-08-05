CREATE PROCEDURE [dbo].[sp_webapi_SavePunchInInfo]
	-- Add the parameters for the stored procedure here
@attendaceDate DATETIME,
@pInTime NVARCHAR(50),
@pInLat NVARCHAR(50),
@pInLong NVARCHAR(50),
@empId INT,
@EntryDate DATETIME
AS
BEGIN


DECLARE @mioId INT,@shiftId int

SELECT @mioId = MIOId FROM dbo.tblMIOInfo WHERE EmployeeId = @empId


--SELECT @shiftId = FROM dbo.tblEmpGeneralInfo WHERE EmpInfoId = @empId

IF(NOT EXISTS (SELECT * FROM dbo.tblMarketAttendance_Master_webapi WHERE EmpInfoId = @empId AND AttendanceDate = @attendaceDate))
BEGIN
	INSERT INTO dbo.tblMarketAttendance_Master_webapi
        ( MIOId ,
          EmpInfoId ,
          PunchInTime ,
          PInLat ,
          PInLog ,
          AttendanceDate,
		  PINCreatedDateTime
        )
VALUES  ( 
			@mioId,
			@empId,
			@pInTime,
			@pInLat,
			@pInLong,
			@attendaceDate,
			@EntryDate
        )



END




END
