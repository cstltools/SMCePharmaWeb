-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_LeaveConfigDtl]
	-- Add the parameters for the stored procedure here
	@LeaveConfigId int  
      ,@LeaveName nvarchar(max)=NULL 
      
      ,@JoiningDateCountId int=NULL 
     
      
     
      ,@DaysPerMonthly decimal(18,16)=NULL 

AS
    BEGIN
	
   
INSERT INTO [dbo].[tblLeaveConfigCountDtl]
           ([LeaveConfigId]
           ,[JoiningDateCountId]
           ,[DaysPerMonthly])
     VALUES
           (@LeaveConfigId 
           ,@JoiningDateCountId 
           ,@DaysPerMonthly)

END

