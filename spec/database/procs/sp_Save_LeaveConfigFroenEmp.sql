-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_LeaveConfigFroenEmp]
	-- Add the parameters for the stored procedure here
	@LeaveConfigId int  
      
      
      ,@EmployeeId int=NULL 
     
       

AS
    BEGIN
	
   
INSERT INTO [dbo].[tblLeaveConfigForeignId]
           ([LeaveConfigId]
           ,[EmployeeId])
     VALUES
           (@LeaveConfigId  
           ,@EmployeeId)

END

