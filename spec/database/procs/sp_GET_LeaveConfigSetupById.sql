

 CREATE PROCEDURE [dbo].[sp_GET_LeaveConfigSetupById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 
	 Select  dtl.JoiningDateCountId,  dtl.DaysPerMonthly CountDays,  STUFF( (SELECT CONCAT(',', brn.EmployeeId , '') FROM dbo.tblLeaveConfigForeignId brn(NOLOCK)  WHERE brn.LeaveConfigId=tblLeaveConfig.LeaveConfigId ORDER BY brn.EmployeeId FOR XML PATH ('') ),1,1,'') AS ProductDCID,    * from tblLeaveConfig
	 left join tblLeaveConfigCountDtl dtl on tblLeaveConfig.LeaveConfigId=dtl.LeaveConfigId
	  where tblLeaveConfig.LeaveConfigId = @id
      
    END


