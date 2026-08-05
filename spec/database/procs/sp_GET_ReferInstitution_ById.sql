
Create PROCEDURE [dbo].[sp_GET_ReferInstitution_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblReferInstitution where InstitutionId = @id
      
    END

