
CREATE PROCEDURE [dbo].[sp_GET_PendingSalesConfirmationReport]
	-- Add the parameters for the stored procedure here
	@districtId nvarchar(max) 


AS
BEGIN
   
    DECLARE @Q NVARCHAR(MAX)=' SELECT tblD.AdjustmentAmount,tblD.TotalNetPayable ,tblD.GrossValue,tblD.TotalVat, tblD.TotalDiscount, MIO.EmpMasterCode MainMIOCODE, MIO.EmpName MainMIONAME, tblOrder.TerritoryCode  Territory, tblOrder.RegionCode_Ord  DZSMCode, tblOrder.AreaCode_Ord AMCode,tblOrder.OrderSenderCode+'' : ''+tblOrder.OrderSenderName OrderSenderName,  0 TpGrandTotal, case when   (CONVERT(date,tblInvoice.InvoiceDate))>=   (CONVERT(date,''30-June-2022'')) then ''True'' else ''False'' end chkStatus ,tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder With (nolock)
            
            inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            inner JOIN dbo. tblCustMaster  V   With (nolock)  ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                       inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId 
					   LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON tblOrder.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON tblOrder.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON tblOrder.MIOId=MIO.EmpInfoId
					         INNER JOIN (SELECT   ID.InvoiceId,  isnull(sum(ID.AdjustmentAmount),0) AdjustmentAmount, isnull(sum(ID.NetAmount),0) as TotalNetPayable,
     isnull(sum(ID.TotalPrice),0) AS GrossValue,isnull(sum(ID.totalPriceVatAmount),0) AS TotalVat, isnull(sum(ID.DiscountAmount),0)  AS TotalDiscount FROM tblInvoiceDetail ID  with (nolock)
                    
                    group by  ID.InvoiceId   ) as tblD ON tblInvoice.InvoiceId = tblD.InvoiceId   
            WHERE  tblD.GrossValue>0  and  tblInvoice.DelivaryInvoiceNo is null ' + @districtId  

	EXEC sp_executesql @Q

END
              