-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Webapi_Get_MileageDetailsByID]
	-- Add the parameters for the stored procedure here
@id int
AS
BEGIN


SELECT  CONVERT(NVARCHAR(50), A.MileageDate, 106) AS MileageDate ,
        B.TransportName ,
        A.MileageInKM ,
        A.MeterReading ,
        C.SMName ,
        D.MarketName ,
        E.TerritoryName ,
        ar.AreaName ,
        A.Remarks ,
        A.ApprovalStatus
FROM    dbo.tbl_MileageClaim A
        LEFT JOIN dbo.tbl_Transport B ON B.TransportId = A.TransportId
        LEFT JOIN dbo.tbl_SubMarket C ON C.SMId = A.SMId
        LEFT JOIN dbo.tblMarket D ON D.MarketId = C.MarketId
        LEFT JOIN dbo.tblTerritory E ON E.TerritoryId = D.TerritoryId
        LEFT JOIN dbo.tblArea ar ON ar.AreaId = E.AreaId
WHERE   A.MileageClaimId = @id


END

