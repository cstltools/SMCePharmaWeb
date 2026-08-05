

 CREATE PROCEDURE [dbo].[sp_GET_GroupInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tbl_Group where GroupId = @id
      
    END


