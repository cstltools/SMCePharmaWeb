
CREATE PROCEDURE [dbo].[sp_Update_TourType]
	-- Add the parameters for the stored procedure here
    @TourTypeId  INT = 0 ,
    @TourTypeName   NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE [dbo].tbl_TourPlanType
        SET     TourTypeName = @TourTypeName,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive,      
                Activedate = @Activedate
        WHERE   TourTypeId = @TourTypeId  

    END
