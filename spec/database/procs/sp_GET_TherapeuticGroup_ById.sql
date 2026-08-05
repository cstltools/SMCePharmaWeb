CREATE PROCEDURE [dbo].[sp_GET_TherapeuticGroup_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblTherapeuticGroup where TherapeuticGroupId = @id
      
    END