-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_DoctorDesignation]
	-- Add the parameters for the stored procedure here
    @DesignationId INT = 0 ,
    @DesignationName  NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE  dbo.tblDoctorDesignation
        SET     DesignationName = @DesignationName ,
                UpdateBy = @UpdateBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,      
                Activedate = @Activedate
        WHERE   DesignationId = @DesignationId

    END


