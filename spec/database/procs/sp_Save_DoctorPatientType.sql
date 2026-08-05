-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Save_DoctorPatientType]
	-- Add the parameters for the stored procedure here
	@PatientTypeId INT,
    @PatientType  NVARCHAR(MAX) ,
	@IsActive  BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN
	if not exists (select PatientType from [tblDoctorPatientType] where PatientType=@PatientType)
begin 
        INSERT  INTO [dbo].[tblDoctorPatientType]
                ( PatientType,                  
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @PatientType ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()



End
else  Return 0
	
 
		
END
