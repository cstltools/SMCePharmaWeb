

CREATE PROCEDURE [dbo].[sp_Delete_GroupInfo]
	-- Add the parameters for the stored procedure here
    @Id INT 

AS
    BEGIN

       DELETE FROM tbl_Group WHERE GroupId = @Id
    END



