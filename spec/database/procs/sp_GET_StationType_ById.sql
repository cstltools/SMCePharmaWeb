

 CREATE PROCEDURE [dbo].[sp_GET_StationType_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblStationType where StationTypeId = @id
      
    END


