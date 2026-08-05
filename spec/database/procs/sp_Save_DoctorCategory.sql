-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Save_DoctorCategory]
	-- Add the parameters for the stored procedure here
	@CategoryId INT,
    @CategoryName NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
		if not exists (select CategoryName from tblDoctorCategory where CategoryName=@CategoryName)
begin 
        INSERT  INTO dbo.tblDoctorCategory
                ( CategoryName ,                 
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @CategoryName ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()





End
else  Return 0
	
 
		
END

