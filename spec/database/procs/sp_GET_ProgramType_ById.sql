

 CREATE PROCEDURE [dbo].[sp_GET_ProgramType_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblProgramType where ProgramTypeId = @id
      
    END


