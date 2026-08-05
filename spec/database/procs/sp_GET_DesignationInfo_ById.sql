

 CREATE PROCEDURE [dbo].[sp_GET_DesignationInfo_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblDesignation where DesignationId = @id
      
    END


