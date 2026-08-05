
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_TerritoryData_ByTerritoryId]
	-- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        SELECT  A.TerritoryId ,
                A.TerritoryName ,
                A.TerritoryCode ,
                A.AreaId ,
                A.IsActive ,
                A.AcOrInAcDate ,
         
                A.Remarks ,
                C.RegionId ,
				G.GroupId,
                STUFF(( SELECT  ',' + CAST(ThanaId AS NVARCHAR(50))
                        FROM    dbo.tbl_TerritoryThanaRelation
                        WHERE   TerritoryId = @id
                      FOR
                        XML PATH('')
                      ), 1, 1, '') AS thanaId
        FROM    dbo.tblTerritory A
                LEFT JOIN dbo.tblArea B ON B.AreaId = A.AreaId
                LEFT JOIN dbo.tblRegion C ON C.RegionId = B.RegionId
				LEFT JOIN dbo.tbl_Group G ON G.GroupId = C.GroupId
				WHERE A.TerritoryId = @id


    END


