-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_PrescriptionType]
	-- Add the parameters for the stored procedure here
	@PrescriptionTypeId INT,
    @PrescriptionType NVARCHAR(MAX) ,
	@IsActive BIT,
	@Activedate DATETIME,
    @EntryBy NVARCHAR(MAX)
AS
    BEGIN

	if not exists (select PrescriptionType from tbl_PrescriptionType where PrescriptionType=@PrescriptionType)
begin 
       INSERT  INTO [dbo].[tbl_PrescriptionType]
                ( PrescriptionType ,                
                  IsActive ,
                  ActiveInactiveDate ,
                  EntryBy ,
                  EntryDate 
	            )
        VALUES  ( @PrescriptionType ,              
                  @IsActive ,
                  @Activedate,
                  @EntryBy ,
                  GETDATE() 	
	            )

SELECT SCOPE_IDENTITY()


End
else  Return 0
	
        
END

