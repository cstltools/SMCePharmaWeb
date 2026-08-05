

 create PROCEDURE [dbo].[sp_GET_UserRoleInfoRoleType_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select rtp.RoleType from tbl_UserRoleInfo ur
	 inner join tblRoleType rtp on ur.RoleTypeId=rtp.RoleTypeId
	  where UserRoleID = @id
      
    END


