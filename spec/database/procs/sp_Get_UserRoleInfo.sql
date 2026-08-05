


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_UserRoleInfo]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    

	Select * from tbl_UserRoleInfo A  WITH (NOLOCK) where IsActive=1


END




