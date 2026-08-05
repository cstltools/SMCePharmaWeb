
create PROCEDURE [dbo].[sp_Get_ALl_Division_List]
	-- Add the parameters for the stored procedure here

AS
BEGIN


Select DivisionName,* from tbl_Division WITH (NOLOCK)


END
