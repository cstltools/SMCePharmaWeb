-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_PrescriptionType]
	-- Add the parameters for the stored procedure here
    @PrescriptionTypeId  INT = 0 ,
    @PrescriptionType NVARCHAR(MAX) ,
    @UpdateBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN
        UPDATE  dbo.tbl_PrescriptionType
        SET     PrescriptionType = @PrescriptionType,
                UpdateBy = @UpdateBy,
                UpdateDate = GETDATE(),
                IsActive = @isActive,      
                ActiveInactiveDate = @Activedate
        WHERE   PrescriptionTypeId = @PrescriptionTypeId
    END

