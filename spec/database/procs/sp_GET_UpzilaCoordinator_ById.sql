
 Create PROCEDURE [dbo].[sp_GET_UpzilaCoordinator_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblUpazilaCoordinator where UpCoordinatorId = @id
      
    END

