-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Up_LeaveConfigMaster]
	-- Add the parameters for the stored procedure here
	@LeaveConfigId int out 
      ,@LeaveName nvarchar(max)=NULL 
      ,@CountGovtLeave BIT=NULl
      ,@CountEmployeeHoliday BIT=NULL 
      ,@EligbleforProbationEmployee BIT=NULL 
      ,@LeaveTypeId int=NULL 
      ,@EntryBy int=NULL 
      
     
      ,@DayNameId int=NULL ,
       @IsActive bit=NULL 


AS
    BEGIN
	
     UPDATE [dbo].[tblLeaveConfig]
   SET [LeaveName] = @LeaveName 
      ,[CountGovtLeave] = @CountGovtLeave 
      ,[CountEmployeeHoliday] = @CountEmployeeHoliday 
      ,[EligbleforProbationEmployee] = @EligbleforProbationEmployee 
      ,[LeaveTypeId] = @LeaveTypeId 
      ,[UpdateBy] = @EntryBy 
      ,[UpdateDate] = getdate() 
      ,[DayNameId] = @DayNameId 
      ,[IsActive] = @IsActive  where  LeaveConfigId=@LeaveConfigId

	  delete from [dbo].[tblLeaveConfigCountDtl]  where  LeaveConfigId=@LeaveConfigId
	  delete from [dbo].tblLeaveConfigForeignId  where  LeaveConfigId=@LeaveConfigId

END

