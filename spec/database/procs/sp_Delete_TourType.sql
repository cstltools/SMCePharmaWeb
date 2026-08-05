CREATE PROCEDURE [dbo].[sp_Delete_TourType]
	-- Add the parameters for the stored procedure here
    @TourTypeId  INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE [dbo].[tblTourType]
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   TourTypeId = @TourTypeId   
    END

