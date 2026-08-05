-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[sp_Get_Thana_WithTagInfo_TerritoryEdit]
	-- Add the parameters for the stored procedure here
	@id int
AS
BEGIN

SELECT DISTINCT  A.ThanaId ,
        CASE WHEN A.ThanaId IN (
                  SELECT    tr.ThanaId
                  FROM      dbo.tblTerritory T
                            INNER JOIN dbo.tbl_TerritoryThanaRelation tr ON tr.TerritoryId = T.TerritoryId
                  WHERE     T.IsActive = 1 AND T.TerritoryId <> 1)
             THEN A.ThanaName + ' [' + C.TerritoryName + ']'
             ELSE A.ThanaName
        END AS ThanaName ,
        CASE WHEN A.ThanaId IN (
                  SELECT    tr.ThanaId
                  FROM      dbo.tblTerritory T
                            INNER JOIN dbo.tbl_TerritoryThanaRelation tr ON tr.TerritoryId = T.TerritoryId
                  WHERE     T.IsActive = 1 AND T.TerritoryId <> 1)
             THEN 1
             ELSE 0
        END AS IsDisable
FROM    dbo.tbl_Thana A
        LEFT JOIN dbo.tbl_TerritoryThanaRelation B ON B.ThanaId = A.ThanaId
        LEFT JOIN dbo.tblTerritory C ON C.TerritoryId = B.TerritoryId
		WHERE A.IsActive = 1





END

