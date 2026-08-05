CREATE PROCEDURE [dbo].[sp_Get_subTerritoryData_BySubTerritoryId]
    -- Add the parameters for the stored procedure here
    @id INT
AS
    BEGIN

        SELECT  A.TerritoryId ,
                A.TerritoryName ,
                A.TerritoryCode ,
                A.AreaId ,
                SA.IsActive ,
              FORMAT(SA.AcOrInAcDate,'dd MMMM, yyyy') AcOrInAcDate  ,
         
                A.Remarks ,
                C.RegionId ,
                G.GroupId ,SA.*
        FROM    dbo.tblSubTerritory SA
                LEFT JOIN dbo.tblTerritory A ON SA.TerritoryId = A.TerritoryId
                LEFT JOIN dbo.tblArea B ON B.AreaId = A.AreaId
                LEFT JOIN dbo.tblRegion C ON C.RegionId = B.RegionId
                LEFT JOIN dbo.tbl_Group G ON G.GroupId = C.GroupId
                WHERE SA.SubTerritoryId = @id


    END



