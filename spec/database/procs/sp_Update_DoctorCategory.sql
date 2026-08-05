-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Update_DoctorCategory]
	-- Add the parameters for the stored procedure here
    @CategoryId INT = 0 ,
    @CategoryName NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE  dbo.tblDoctorCategory
        SET     CategoryName = @CategoryName ,
                UpdateBy = @UpdateBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,      
                Activedate = @Activedate
        WHERE   CategoryId = @CategoryId

    END


