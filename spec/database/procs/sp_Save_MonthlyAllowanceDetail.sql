
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_MonthlyAllowanceDetail]
	-- Add the parameters for the stored procedure here
	@MonthlyAllowanceId INT,
    @EmpInfoId int =Null ,
    @UserRoleId int =Null 
   
	 
AS
    BEGIN
	
     INSERT INTO [dbo].[tbl_MonthlyAllowanceDetail]
           ([MonthlyAllowanceId]
           ,[EmpInfoId]
           ,[UserRoleId])
     VALUES
           (@MonthlyAllowanceId
           ,@EmpInfoId
           ,@UserRoleId)

 

END


