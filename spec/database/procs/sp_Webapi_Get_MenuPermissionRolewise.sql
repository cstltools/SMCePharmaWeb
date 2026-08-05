
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_MenuPermissionRolewise]
	-- Add the parameters for the stored procedure here
    @MenuId int = NULL ,
    @MenuName nvarchar(max) = NULL,
	@RoleTypeId int null
AS
    BEGIN
	

        select * from tblUserMenuPermissionApp
		where MenuId=@MenuId and MenuName=Isnull(@MenuName,MenuName) and RoleTypeId=@RoleTypeId




    END


