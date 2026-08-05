

 CREATE PROCEDURE [dbo].[sp_GET_UserRoleInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select FORMAT(ActiveInActiveDate,'dd-MMM-yyyy') ActiveDateStr, * from tbl_UserRoleInfo where UserRoleID = @id
      
    END


