-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorSpecialDay]
	-- Add the parameters for the stored procedure here
	@SpecialDayId  INT,
    @SpecialDay NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
		if not exists (select SpecialDay from tblDoctorSpecialDay where  SpecialDay=@SpecialDay)
begin 
        INSERT  INTO [dbo].[tblDoctorSpecialDay] 
                ( SpecialDay ,                   
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @SpecialDay ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()



End
else  Return 0
	
 
		
END
