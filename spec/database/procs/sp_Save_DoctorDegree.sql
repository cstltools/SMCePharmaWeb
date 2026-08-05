-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_DoctorDegree]
	-- Add the parameters for the stored procedure here
	@DegreeId INT,
	@DoctorTypeId int=null,
    @DegreeName NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)


AS
    BEGIN

 
	if not exists (select DegreeName from tblDoctorDegree where DegreeName=@DegreeName and DoctorTypeId=@DoctorTypeId)
begin 
 INSERT  INTO dbo.tblDoctorDegree
                ( DegreeName , DoctorTypeId,               
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @DegreeName ,@DoctorTypeId,
                
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )
SELECT SCOPE_IDENTITY()
End
else  Return 0
	
 
		
END


