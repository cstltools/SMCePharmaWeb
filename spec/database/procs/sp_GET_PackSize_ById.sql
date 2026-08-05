CREATE PROCEDURE [dbo].[sp_GET_PackSize_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 SELECT ISNULL(IsActive,0) IsActive, * from tblPackSize where PackSizeId = @id
      
    END