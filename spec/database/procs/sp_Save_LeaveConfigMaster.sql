-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_LeaveConfigMaster]
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
	
     INSERT INTO [dbo].[tblLeaveConfig]
           ([LeaveName]
           ,[CountGovtLeave]
           ,[CountEmployeeHoliday]
           ,[EligbleforProbationEmployee]
           ,[LeaveTypeId]
           ,[EntryBy]
           ,[EntryDate]
          
           ,[DayNameId],  IsActive)
     VALUES
           (@LeaveName 
           ,@CountGovtLeave 
           ,@CountEmployeeHoliday 
           ,@EligbleforProbationEmployee 
           ,@LeaveTypeId 
           ,@EntryBy 
           ,GETDATE()
          
           ,@DayNameId, @IsActive )

SELECT SCOPE_IDENTITY()

END

