
CREATE PROCEDURE [dbo].[sp_Save_TourType]
	-- Add the parameters for the stored procedure here
	@TourTypeId INT,
    @TourTypeName  NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
	
        INSERT  INTO [dbo].tbl_TourPlanType
                ( TourTypeName ,                   
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate, IsDelate
	            )
        VALUES  ( @TourTypeName  ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE(),0 	
	            )

SELECT SCOPE_IDENTITY()

END
