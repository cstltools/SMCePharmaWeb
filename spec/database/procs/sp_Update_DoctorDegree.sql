-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_DoctorDegree]
	-- Add the parameters for the stored procedure here
    @DegreeId INT = 0 ,
    @DegreeName NVARCHAR(MAX) ,
	@DoctorTypeId int=null,

    @UpdateBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @IsActive BIT ,
    @Activedate DATETIME
AS
    BEGIN

        UPDATE  dbo.tblDoctorDegree
        SET     DegreeName = @DegreeName ,
                UpdateBy = @UpdateBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,      
                Activedate = @Activedate, DoctorTypeId=@DoctorTypeId
        WHERE   DegreeId = @DegreeId


    END


