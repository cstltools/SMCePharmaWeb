
CREATE PROCEDURE [dbo].[sp_Delete_DesignationInfo]
	-- Add the parameters for the stored procedure here
    @DesignationId INT 

AS
    BEGIN

       DELETE FROM tblDesignation WHERE DesignationId = @DesignationId
    END


