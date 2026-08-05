
CREATE PROCEDURE [dbo].[sp_GET_GroupInfo]
	-- Add the parameters for the stored procedure here
  

AS
    BEGIN
	
		SELECT GroupId,GroupCode+' : '+ GroupName GroupName
	FROM tbl_Group AS GRP   with(nolock) WHERE IsActive = 1


 END
