CREATE PROCEDURE [dbo].[sp_GET_VacentGroup]
	
	-- Add the parameters for the stored procedure here
	

AS
BEGIN


	SELECT * FROM tbl_Group AS GP WITH (NOLOCK)
	LEFT JOIN tblNSMInfo AS NSM ON GP.GroupId = NSM.GroupId
	WHERE GP.IsActive = 1 AND  GP.GroupId not in (select GroupId from tblNSMInfo where IsActive = 1)
		
END


