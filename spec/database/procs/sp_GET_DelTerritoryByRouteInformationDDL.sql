

 create PROCEDURE [dbo].[sp_GET_DelTerritoryByRouteInformationDDL]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max),
   @IvDate NVARCHAR(max)

AS
    BEGIN
    SET NOCOUNT ON;
 

    select distinct  terry.TerritoryId AS TerritoryId, terry.TerritoryCode+ ' : '+terry.TerritoryName AS TerritoryName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
 INNER JOIN dbo.tblTerritory terry   with (nolock) ON terry.TerritoryId = ord.TerritoryId  

 where DelivaryInvoiceNo  is null  and     ord.DistributionRouteId=@id  AND    convert(date, Inv.InvoiceDate)=@IvDate     
 

      
    END


