
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Get_SubmarketData_ById]
@id int
AS
    BEGIN
	
        SELECT  sm.SMId ,
                sm.SMCode ,
                sm.SMName ,
                sm.MarketId ,
                sm.IsActive ,
                sm.AcOrInAcDate ,
                sm.CreatedBy ,
                sm.CreatedDate ,
                sm.UpdatedBy ,
                sm.UpdatedDate ,
                sm.Remarks,
				t.TerritoryId,
				a.AreaId,
				z.ZoneId
        FROM    dbo.tbl_SubMarket sm
		LEFT JOIN dbo.tbl_Market m ON m.MarketId = sm.MarketId
		LEFT JOIN dbo.tbl_Territory T ON T.TerritoryId=m.TerritoryId
		LEFT JOIN dbo.tbl_Area A ON A.AreaId = T.AreaId
		LEFT JOIN dbo.tbl_Zone z ON z.ZoneId = A.ZoneId
		WHERE sm.SMId = @id


    END


