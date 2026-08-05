CREATE   PROCEDURE [dbo].[sp_Webapi_Get_PunchInOutStatus]
	-- Add the parameters for the stored procedure here
	@empId NVARCHAR(MAX)= NULL,
	@AttType NVARCHAR(MAX)= NULL,
	@pInTime NVARCHAR(MAX)= NULL


	AS
    BEGIN
	 DECLARE @OverTimeDuration TIME(0)
DECLARE @TimeLimit TIME(0)
set @TimeLimit='00:00:00'

	if(@AttType='1')
	   BEGIN

	   DECLARE @stInTime  TIME(0)
	select @stInTime=st.StartTime from   dbo.tbl_TourPlanInfo  TP
 LEFT JOIN dbo.tblStationType st ON ST.StationTypeId=TP.TourTypeId
 where TP.EmpInfoId=@empId and TP.serialno='1' and convert(Date, TP.TourPlanDate)=convert(Date, GETDATE())
	  if( @pInTime>@stInTime)
	 begin 
Select @OverTimeDuration=  (CAST(DATEDIFF(SECOND, st.StartTime, @pInTime) / 3600 as VARCHAR) + ':' + 
			CAST((DATEDIFF(SECOND, st.StartTime, @pInTime) % 3600) / 60 as VARCHAR) + ':' + 
			CAST(DATEDIFF(SECOND,  st.StartTime, @pInTime) % 60 as VARCHAR)) 
	          from tblEmpGeneralInfo emp
	 LEFT JOIN dbo.tbl_TourPlanInfo TP ON TP.EmpInfoId = emp.EmpInfoId AND convert(Date, TP.TourPlanDate)=convert(Date, GETDATE())
 LEFT JOIN dbo.tblStationType st ON ST.StationTypeId=TP.TourTypeId
 where emp.EmpInfoId=@empId and TP.serialno='1'
 
	IF(@OverTimeDuration>@TimeLimit)
			
			begin 
		select 	'Late IN' TextField
			end	 
		 	IF(@OverTimeDuration=@TimeLimit)
			
			begin 
				select 	' ' TextField

			end	
			IF(@OverTimeDuration<@TimeLimit)
				begin 
				select 	'Early IN' TextField

			end	 
			end	 
			begin 
				select 	'Early IN' TextField

			end	 
	end
		if(@AttType='2')
	   BEGIN
	    DECLARE @stEndTime  TIME(0)
	select @stEndTime=st.EndTime from   dbo.tbl_TourPlanInfo  TP
 LEFT JOIN dbo.tblStationType st ON ST.StationTypeId=TP.TourTypeId
 where TP.EmpInfoId=@empId and TP.serialno='1' and convert(Date, TP.TourPlanDate)=convert(Date, GETDATE())
	  if( @pInTime>@stEndTime)
	  BEGIN
Select @OverTimeDuration=  (CAST(DATEDIFF(SECOND, st.EndTime, @pInTime) / 3600 as VARCHAR) + ':' + 
			CAST((DATEDIFF(SECOND, st.EndTime, @pInTime) % 3600) / 60 as VARCHAR) + ':' + 
			CAST(DATEDIFF(SECOND,  st.EndTime, @pInTime) % 60 as VARCHAR))     from tblEmpGeneralInfo emp
	 LEFT JOIN dbo.tbl_TourPlanInfo TP ON TP.EmpInfoId = emp.EmpInfoId AND convert(Date, TP.TourPlanDate)=convert(Date, GETDATE())
 LEFT JOIN dbo.tblStationType st ON ST.StationTypeId=TP.TourTypeId
 where emp.EmpInfoId=@empId and TP.serialno='1'
	 

	IF(@OverTimeDuration>@TimeLimit)
			
			begin 
		select 	'Late OUT' TextField
			end	 
		 	IF(@OverTimeDuration=@TimeLimit)
			
			begin 
				select 	' ' TextField

			end	
			IF(@OverTimeDuration<@TimeLimit)
				begin 
				select 	'Early OUT' TextField

			end	
			
			
	end

	 
	else
			begin 
			select 	'Early OUT' TextField
			end 
		end
		end