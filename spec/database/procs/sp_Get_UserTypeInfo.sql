


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Get_UserTypeInfo]
	-- Add the parameters for the stored procedure here

AS
BEGIN
    

	Select  * from tblUserType A  WITH (NOLOCK) where IsActive=1


END




