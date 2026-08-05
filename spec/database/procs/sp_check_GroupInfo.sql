

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_check_GroupInfo]
	-- Add the parameters for the stored procedure here
	  @id  INT ,
      @Name     NVARCHAR(MAX) 
AS
BEGIN
		 
	SELECT * FROM dbo.tbl_Group WHERE GroupName=@Name AND  GroupId NOT IN ( @id)

END



