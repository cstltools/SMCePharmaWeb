CREATE PROCEDURE [dbo].[sp_GET_GenericGroup_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblGenericGroup where GenericGroupId = @id
      
    END