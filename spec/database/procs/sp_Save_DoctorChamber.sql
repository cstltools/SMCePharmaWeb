-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Save_DoctorChamber]
	-- Add the parameters for the stored procedure here
	@ChamberId INT,
    @ChamberName NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
		if not exists (select ChamberName from tblDoctorChamber where ChamberName=@ChamberName)
begin 
        INSERT  INTO dbo.tblDoctorChamber
                ( ChamberName ,                  
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @ChamberName ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()

End
else  Return 0
	
 
		
END
