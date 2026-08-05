

 CREATE PROCEDURE [dbo].[sp_GET_TerritoryByRouteInformationDDL]
	-- Add the parameters for the stored procedure here
   @id NVARCHAR(max)

AS
    BEGIN
    SET NOCOUNT ON;
	
    select distinct  terry.TerritoryId AS TerritoryId, terry.TerritoryCode+ ' : '+terry.TerritoryName AS TerritoryName

from tblOrder ord
--left join tblOrder ord on ord.OrderId=Inv.OrderId
 left JOIN dbo.tblTerritory terry   with (nolock) ON terry.TerritoryId = ord.TerritoryId  
  WHERE ord.DistributionRouteId = @id
 
  and IsInvoice=0
      
    END


