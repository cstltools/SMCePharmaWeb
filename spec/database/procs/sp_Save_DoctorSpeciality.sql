-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorSpeciality]
	-- Add the parameters for the stored procedure here
	@SpecialityId   INT,
    @SpecialityName  NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
	if not exists (select SpecialityName from tblDoctorSpeciality where SpecialityName=@SpecialityName)
begin 
        INSERT  INTO [dbo].[tblDoctorSpeciality]
                ( SpecialityName ,                   
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @SpecialityName ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()


End
else  Return 0
	
 
		
END
