CREATE PROCEDURE [dbo].[sp_Get_UserLocationTracking] 
	-- Add the parameters for the stored procedure here
@empid INT, -- this is actully empId
@trackDate DATETIME
AS
BEGIN


--DECLARE @empIdMain INT

--SELECT @empIdMain = EmpInfoId FROM dbo.tblUser WHERE UserId=@empid
	
	SELECT DISTINCT TrackingId ,
           EmpInfoId ,
           LatValue ,
           LongValue ,
           AddressName ,
			 CONVERT(varchar(15),  CAST(Time AS TIME), 100) AS Time,
           TrackDate FROM dbo.tbl_UserTracking
	WHERE EmpInfoId = @empid AND CONVERT(date,TrackDate) = CONVERT(date,@trackDate) 


END
