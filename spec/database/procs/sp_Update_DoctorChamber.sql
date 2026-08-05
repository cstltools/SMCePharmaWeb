-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_DoctorChamber]
	-- Add the parameters for the stored procedure here
    @ChamberId INT = 0 ,
    @ChamberName NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE  dbo.tblDoctorChamber
        SET     ChamberName = @ChamberName,
                UpdateBy = @UpdateBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,      
                Activedate = @Activedate
        WHERE   ChamberId = @ChamberId

    END


