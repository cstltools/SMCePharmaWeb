CREATE PROCEDURE [dbo].[sp_Delete_TourPurpose]
	-- Add the parameters for the stored procedure here
    @TourPurposeId INT = 0 ,
    @DeleteBy NVARCHAR(50)
AS
    BEGIN

        UPDATE [dbo].[tblTourPurpose]
        SET     
                DeleteBy = @DeleteBy ,
                DeleteDate = GETDATE() ,
				IsDelate = 1                     
        WHERE   TourPurposeId = @TourPurposeId    
    END

