

 create PROCEDURE [dbo].[sp_GET_SMCType_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblSMCType where SMCTypeId = @id
      
    END


