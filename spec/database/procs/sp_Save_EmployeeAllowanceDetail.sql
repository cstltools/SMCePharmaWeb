-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Save_EmployeeAllowanceDetail]
	-- Add the parameters for the stored procedure here

	@EmpInfoId INT,
	@AllowanceId INT

AS
BEGIN
	
	INSERT INTO [dbo].[EmployeeAllowance]
           ([EmpInfoId]
           ,[AllowanceId])
     VALUES
           (@EmpInfoId, 
           @AllowanceId)
END

