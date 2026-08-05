CREATE PROCEDURE [dbo].[sp_Get_AllSalesReportListDHB]
	-- Add the parameters for the stored procedure here
	@Parm nvarchar(max) ,
	@Parm2 nvarchar(max) 
AS
BEGIN
   
   DECLARE @Q NVARCHAR(MAX)='SELECT   mas.TerritoryCode+'' : ''+mas.TerritoryName_Ord TerritoryName, C.CustomerCode+'' : ''+C.CustomerName CustomerName,  ISNULL(sum(I.DeliveryTpTotal-I.DeliveryTpDiscount),0)  TotalNetPayable 
FROM dbo.tblInvoice I  with(nolock)
--INNER JOIN dbo.tblInvoiceDetail ID   with(nolock) ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblOrder mas   with(nolock) ON I.OrderId = mas.OrderId
-- LEFT JOIN tblProgramType ptt   with(nolock)  ON mas.ProgramTypeId = ptt.ProgramTypeId
--    LEFT JOIN tblCustomertype ct   with(nolock) ON mas.CusttypeId = ct.CustomerTypeId
--    LEFT JOIN tblDCStore dst   with(nolock) ON ID.DCStoreId = dst.DCStoreId
 INNER JOIN tblCustMaster C   with(nolock) ON C.CustomerMasterId = mas.CustomerMasterId
--INNER JOIN dbo.tblProduct P   with(nolock) ON ID.ProductCode = P.ProductCode 
--INNER JOIN dbo.tblProductSQ SQ   with(nolock) ON P.ProductBrandId = SQ.ProductBrandId 
--INNER JOIN dbo.tblCompanyUnit CU   with(nolock) ON CU.ComUnitId = mas.ComUnitId


--INNER JOIN dbo.tblOrderDetail masdtl  with(nolock) ON ID.OrderDetailsId = masdtl.OrderDetailId
--left JOIN dbo.[tbl_BonusCampaignNewDetail] camp  with(nolock) ON camp.CampaignDetailId = masdtl.CampaignType


--LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
--LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
--LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
 
	 
--		left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
 
where  C.CustomerCode is not null    ' +@Parm + @Parm2+  '  group by mas.TerritoryCode+'' : ''+mas.TerritoryName_Ord  , C.CustomerCode+'' : ''+C.CustomerName   order by mas.TerritoryCode+'' : ''+mas.TerritoryName_Ord'	
EXEC sp_executesql @Q

END
             



--                       and CU.ComUnitId='" + districtId.Trim() + "' and I.UpdateDate between '" + fromDate + "' and '" + toDate + "' 