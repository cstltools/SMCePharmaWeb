CREATE PROCEDURE [dbo].[sp_WebAPI_GetAttendanceData_New]
	-- Add the parameters for the stored procedure here
    @empId INT ,
    @fromDate  nvarchar(max)= NULL,
    @toDate  nvarchar(max)= NULL
AS
    BEGIN
	
  --      SELECT  CONVERT(NVARCHAR(50), AttendanceDate, 107)AS  AttendanceDate,
  --              PunchInTime ,
  --              PunchOutTime ,
  --              PInLat ,
  --              PInLog ,
  --              PunchOutTime ,
  --              POutLat ,
  --              POutLong
  --      FROM    dbo.tblMarketAttendance_Master_webapi
		--WHERE EmpInfoId = @empId AND AttendanceDate BETWEEN @fromDate AND @toDate

		 IF @FromDate IS NOT NULL
BEGIN
    DECLARE @FromDateString VARCHAR(20) = CONVERT(VARCHAR, @FromDate, 106);
    SET @FromDateString = REPLACE(@FromDateString, 'Sept', 'Sep');
    SET @FromDate = CONVERT(DATETIME, @FromDateString, 106);
END

IF @ToDate IS NOT NULL
BEGIN
    DECLARE @ToDateString VARCHAR(20) = CONVERT(VARCHAR, @ToDate, 106);
    SET @ToDateString = REPLACE(@ToDateString, 'Sept', 'Sep');
    SET @ToDate = CONVERT(DATETIME, @ToDateString, 106);
END


		  
	 SELECT  distinct  CONVERT(NVARCHAR(50), att1.AttendanceDate, 107)AS  AttendanceDate, 
                att1.PunchInTime ,
              
                att1.PInLat ,
                att1.PInLog  , att2.PunchInTime  PunchOutTime,
              
                att2.PInLat POutLat,
                att2.PInLog  POutLong
        FROM    dbo.tblMarketAttendance_Master_webapi att1 

		left join (select CONVERT(NVARCHAR(50),  AttendanceDate, 107)AS  AttendanceDate, PunchInTime,PInLat,PInLog, EmpInfoId from  tblMarketAttendance_Master_webapi  where  AttType=2 ) att2 on att2.EmpInfoId=att1.EmpInfoId

		  and  CONVERT(DATE,att1.AttendanceDate)=CONVERT(DATE,att2.AttendanceDate)
		 
		WHERE att1.AttType=1 and att1.EmpInfoId = @empId AND convert(Date, att1.AttendanceDate) BETWEEN @fromDate AND @toDate 

    
    END
