-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_Employee_Holiday]
	-- Add the parameters for the stored procedure here
   	@HolidayId INT,
    @FiscalYear INT =null,
	@HolidayDate DATETIME = null,
	@HolidayToDate DATETIME = null,
	@IsActive BIT =null,
	@DayName NVARCHAR(MAX) =null,
    @UpdateBy NVARCHAR(MAX) = null
AS
    BEGIN

        UPDATE  dbo.Employee_GovtHolidays
        SET     FiscalYear = @FiscalYear ,   HolidayToDate=@HolidayToDate, 
		        DayName = @DayName,
                HolidayDate = @HolidayDate ,
				UpdateBy = @UpdateBy,
                UpdateDate = GETDATE() ,
                IsActive = @isActive    
 
        WHERE   HolidayId = @HolidayId


    END


