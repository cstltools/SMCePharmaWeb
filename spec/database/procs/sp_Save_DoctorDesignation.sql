-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Save_DoctorDesignation]
	-- Add the parameters for the stored procedure here
	@DesignationId INT,
    @DesignationName NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)

AS
    BEGIN

		if not exists (select DesignationName from tblDoctorDesignation where DesignationName=@DesignationName)
begin 
        INSERT  INTO dbo.tblDoctorDesignation
                (  DesignationName,                  
                  IsActive ,
                  Activedate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @DesignationName ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()

End
else  Return 0
	
 
		
END
