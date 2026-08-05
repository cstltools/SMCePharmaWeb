
CREATE PROCEDURE [dbo].[sp_Get_DACollectionReport] 
	-- Add the parameters for the stored procedure here
   
    
  @Parm nvarchar(max),
  @Parm2 nvarchar(max)

AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='select   rto.RouteName,   tblCompanyUnit.ComUnitName, tblCompanyUnit.ComUnitName, trr.TerritoryCode , trr.TerritoryName,     tblDAInfo.DACode AS DACode,
        tblDAInfo.Name  AS Name,tblCustPayDetail.custPaymentDate,tblCustPayDetail.TPAmount,tblCustPayDetail.VATAmount, isnull(tblCustPayDetail.TPAmount,0)+isnull(tblCustPayDetail.VATAmount,0) TotalAmount
 from tblCustPayDetail
left join tblDAInfo on tblDAInfo.DAId=tblCustPayDetail.DANameId
inner join tblInvoice on tblCustPayDetail.InvoiceId=tblInvoice.InvoiceId
inner join tblOrder ord on ord.OrderId=tblInvoice.OrderId
inner join tblCompanyUnit on tblCompanyUnit.ComUnitId=tblInvoice.ComUnitId
inner join tblCustMaster cst on cst.CustomerMasterId=tblInvoice.CustomerMasterId
left join tblMarket mr on cst.MarketId=mr.MarketId
left join tblSubTerritory strr on strr.SubTerritoryId=mr.SubTerritoryId
left join tblTerritory  trr on strr.TerritoryId=trr.TerritoryId 
 left join tblRouteInformationMarketDetail  rtoMD on rtoMD.MarketId=mr.MarketId
left join tblRouteInformationMaster  rto on rto.RouteInformationMasterId=rtoMD.RouteInformationMasterId



where  tblCustPayDetail.InvoiceId  is not null   '  +@Parm+' order by tblCustPayDetail.custPaymentDate desc'  
EXEC sp_executesql @Q

END
              