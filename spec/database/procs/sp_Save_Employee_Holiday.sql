
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Save_Employee_Holiday]
	-- Add the parameters for the stored procedure here
	@HolidayId INT,
    @FiscalYear INT =null,
	@HolidayDate DATETIME = null,
	@HolidayToDate DATETIME = null,
	@IsActive BIT =null,
	@DayName NVARCHAR(MAX) =null,
    @EntryBy NVARCHAR(MAX) = null

AS
    BEGIN

	if not exists (select DayName from Employee_GovtHolidays where DayName=@DayName)
begin 
 INSERT  INTO dbo.Employee_GovtHolidays
                ( FiscalYear ,   
				  DayName,
				  HolidayDate,       
                  IsActive ,        
                  EntryBy ,
                  EntryDate , HolidayToDate
	            )
        VALUES  ( @FiscalYear ,
                  @DayName,
				  @HolidayDate,
                  @IsActive ,
                  @EntryBy,
                  GETDATE() , @HolidayToDate	
	            )
SELECT SCOPE_IDENTITY()
End
else  Return 0
			
END



