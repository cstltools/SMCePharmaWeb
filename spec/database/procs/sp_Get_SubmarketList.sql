
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_SubmarketList]
AS
    BEGIN
	
        SELECT  sm.SMId ,
                sm.SMCode ,
                sm.SMName ,
                sm.MarketId ,
                sm.IsActive ,
                CONVERT(NVARCHAR(50),sm.AcOrInAcDate,106)as AcOrInAcDate,
                sm.CreatedBy ,
                sm.CreatedDate ,
                sm.UpdatedBy ,
                sm.UpdatedDate ,
                sm.Remarks,
				m.MarketName,
				t.TerritoryName,
				a.AreaName,
				z.ZoneName
        FROM    dbo.tbl_SubMarket sm
		LEFT JOIN dbo.tbl_Market m ON m.MarketId = sm.MarketId
		LEFT JOIN dbo.tbl_Territory T ON T.TerritoryId=m.TerritoryId
		LEFT JOIN dbo.tbl_Area A ON A.AreaId = T.AreaId
		LEFT JOIN dbo.tbl_Zone z ON z.ZoneId = A.ZoneId


    END


