CREATE PROCEDURE [dbo].[sp_GetDCRRXDoctorWiseRptView]  
		@Month nvarchar(max), 
		@Year nvarchar(max),
		@Type nvarchar(max)
AS
BEGIN
select * from   tblDCRRXDoctorWiseReport with (nolock) where  Month=@Month and Year=@Year and Type=@Type

end