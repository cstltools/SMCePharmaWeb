-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Update_DoctorSpecialDay]
	-- Add the parameters for the stored procedure here
    @SpecialDayId INT = 0 ,
    @SpecialDay  NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE  [dbo].[tblDoctorSpecialDay] 
        SET     SpecialDay = @SpecialDay ,
                UpdateBy = @UpdateBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,      
                Activedate = @Activedate
        WHERE   SpecialDayId = @SpecialDayId

    END

