

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_check_LeaveInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @Name     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.Employe_LeaveTypeInfos WHERE LeaveTypeName=@Name AND  LeaveTypeId NOT IN ( @id)

END



