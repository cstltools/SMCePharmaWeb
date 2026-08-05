
 Create PROCEDURE [dbo].[sp_GET_DistrictCoordinator_ById]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN

	 Select * from tblDistrictCoordinator where DistCoordinatorId = @id
      
    END

