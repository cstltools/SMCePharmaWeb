
CREATE PROCEDURE [dbo].[sp_Get_TourType_ById]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

         SELECT * 	  
		  FROM [dbo].tbl_TourPlanType A
				WHERE A.TourTypeId = @id

    END
