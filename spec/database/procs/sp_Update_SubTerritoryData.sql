-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_Update_SubTerritoryData]
	-- Add the parameters for the stored procedure here
    @id INT = 0 ,
    @TerritoryId INT ,
    @Name NVARCHAR(MAX) ,
    @createdBy NVARCHAR(50) ,
    @remarks NVARCHAR(MAX) = NULL ,
    @isActive BIT ,
    @acInAcDate DATETIME
AS
    BEGIN

        UPDATE  dbo.tblSubTerritory
        SET     SubTerritoryName = @Name ,
                TerritoryId = @TerritoryId ,
                UpdateBy = @createdBy ,
                UpdateDate = GETDATE() ,
                IsActive = @isActive ,
                Remarks = @remarks ,
                AcOrInAcDate = @acInAcDate
        WHERE   SubTerritoryId = @id

		--DELETE FROM dbo.tbl_TerritoryThanaRelation WHERE TerritoryId = @id

    END

