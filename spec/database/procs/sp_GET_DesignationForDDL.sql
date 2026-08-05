


CREATE PROCEDURE [dbo].[sp_GET_DesignationForDDL]
	-- Add the parameters for the stored procedure here
 
AS
    BEGIN

	Select DesignationId, DesigName from tblDesignation where IsActive=1

	END

