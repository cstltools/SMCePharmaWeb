-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_TerritoryData]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @areaId INT ,
    @CodeStr NVARCHAR(MAX) ,
    @Name NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME
AS
    BEGIN

        UPDATE  dbo.tblTerritory
        SET     TerritoryName = @Name ,
                AreaId = @areaId ,
                UpdateBy = @createdBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive , TerritoryCode=@CodeStr,
                Remarks = @remarks ,
                AcOrInAcDate = @acInAcDate
        WHERE   TerritoryId = @id

		DELETE FROM dbo.tbl_TerritoryThanaRelation WHERE TerritoryId = @id

    END

