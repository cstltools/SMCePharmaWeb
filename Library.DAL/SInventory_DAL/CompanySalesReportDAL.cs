using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class CompanySalesReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable CompanyReportMainDataDAL(DateTime fromDate, DateTime toDate)
        {
            const string query = @"select @FromDate as FromDate, @ToDate as ToDate";
            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        public DataTable CompanyReportDetailDataDAL(DateTime fromDate, DateTime toDate)
        {
            const string query = @"select ProductCode,Product, sum(TotalQuantity) as TotalQty ,sum(Price) as TotalAmount from View_MIAWiseSalesReport  where InvoiceDate between @FromDate and @ToDate group by ProductCode,Product";
            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        //SalesReturn
        public DataTable SalesReturnReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT ReturnInvoiceNo,i.InvoiceNo,IV.InvoiceDate as OrderNo ,IV.ReceivableAmount as  OrderDate,IV.DeliveryTpGrandTotal as InvoiceDate,I.Remarks as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,IV.InvoiceNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.ReturnInvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,ID.ExpDate,103) ExpDate,ID.Quantity as DeliveryQuantity,I.TpGrandTotal as DeliveryNetAmount,
ID.TotalPriceVatAmount as  DeliveryTotalPriceVatAmount,DiscountAmount as  DeliveryDiscountAmount,ID.DelivarySpecialAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,I.MarketCode,I.MarketName,I.Types as Type,I.TpGrandTotal,I.TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal
FROM dbo.tblReturnInvoice I  with(nolock)
INNER JOIN dbo.tblReturnInvoiceDetail ID ON ID.ReturnInvoiceId = I.ReturnInvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
left JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
left JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
left JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId

inner JOIN dbo.tblInvoice IV ON I.ReturnInvoiceNo = IV.AdjustInvoiceNo_ReturnInvoiceNo
WHERE   CU.ComUnitId=@ComUnitId and I.ReturnInvoiceDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, UnitDateRangeParameters(districtId, fromDate, toDate));
        }

        public DataTable SalesReturnReportNationalDAl(DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT ReturnInvoiceNo,i.InvoiceNo,IV.InvoiceDate as OrderNo ,IV.ReceivableAmount as  OrderDate,IV.DeliveryTpGrandTotal as InvoiceDate,I.Remarks as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,IV.InvoiceNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.ReturnInvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,ID.ExpDate,103) ExpDate,ID.Quantity as DeliveryQuantity,I.TpGrandTotal as DeliveryNetAmount,
ID.TotalPriceVatAmount as  DeliveryTotalPriceVatAmount,DiscountAmount as  DeliveryDiscountAmount,ID.DelivarySpecialAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,I.MarketCode,I.MarketName,I.Types as Type,I.TpGrandTotal,I.TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal
FROM dbo.tblReturnInvoice I  with(nolock)
INNER JOIN dbo.tblReturnInvoiceDetail ID ON ID.ReturnInvoiceId = I.ReturnInvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
left JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
left JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
left JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId

inner JOIN dbo.tblInvoice IV ON I.ReturnInvoiceNo = IV.AdjustInvoiceNo_ReturnInvoiceNo
WHERE  I.ReturnInvoiceDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        // Sales Report 
        public DataTable SalesReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.DeliveryQuantity,DeliveryNetAmount,
DeliveryTotalPriceVatAmount,DeliveryDiscountAmount,ID.DelivarySpecialAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,I.MarketCode,I.MarketName,I.Types as Type,I.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode 
INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
where ID.DeliveryStatus IN ('Full','Partial') 
                       and CU.ComUnitId=@ComUnitId and I.UpdateDate between @FromDate and @ToDate  UNION ALL SELECT SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,CampaignType AS ProductOffer, CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.DeliveryQuantity,DeliveryNetAmount, DeliveryTotalPriceVatAmount,DeliveryDiscountAmount,ID.DelivarySpecialAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,I.MarketCode,I.MarketName,C.Type,I.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal FROM dbo.tblSubInvoiceMaster I  with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId  INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId WHERE ID.DeliveryStatus IN ('Full','Partial')  and  CU.ComUnitId=@ComUnitId and I.UpdateDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, UnitDateRangeParameters(districtId, fromDate, toDate));
        }

        public DataTable GetInvoceLifecycleReport(int CiD, DateTime fromDate, DateTime toDate)
        {
            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@fromDate", fromDate));
            aSqlParameters.Add(new SqlParameter("@toDate", toDate));

            return aCommonInternalDal.GetDataTableAction("sp_InvoceLifecycle", aSqlParameters, "SSIDB");
        }

        // Sales Report 
        public DataTable SalesReportDAl(DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.DeliveryQuantity,DeliveryNetAmount,
DeliveryTotalPriceVatAmount,DeliveryDiscountAmount,ID.DelivarySpecialAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,I.MarketCode,I.MarketName,I.Types as Type,I.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal
FROM dbo.tblInvoice I  with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId 
INNER JOIN dbo.tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
where ID.DeliveryStatus IN ('Full','Partial') 
                       and I.UpdateDate between @FromDate and @ToDate  UNION ALL SELECT SQ.ProductSQName as Brand  ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,CampaignType AS ProductOffer, CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.DeliveryQuantity,DeliveryNetAmount, DeliveryTotalPriceVatAmount,DeliveryDiscountAmount,ID.DelivarySpecialAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,I.MarketCode,I.MarketName,C.Type,I.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.DeliveryTpTotal,I.DeliveryTpGrandTotal FROM dbo.tblSubInvoiceMaster I  with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId INNER JOIN dbo.tblProduct P ON ID.ProductCode = P.ProductCode INNER JOIN dbo.tblProductSQ SQ ON P.ProductBrandId = SQ.ProductBrandId  WHERE ID.DeliveryStatus IN ('Full','Partial')  and I.UpdateDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        // Delivery Return Report
        public DataTable DeliveryReturnReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @" SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,Convert(varchar,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,Campaign AS ProductOffer,
Convert(varchar,I.InvoiceDate,103)	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,Convert(varchar,DS.ExpDate,103) as ExpDate,
(ID.Quantity-ID.DeliveryQuantity)Quantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount,
(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,ReturnReason,
Convert(varchar,I.UpdateDate,103)	as UpdateDate ,I.MarketCode,I.MarketName,I.Types as Type,I.CustomerType as NewType
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
 where ID.DeliveryStatus IN ('Reject','Partial') and CU.ComUnitId=@ComUnitId  and I.UpdateDate between @FromDate and @ToDate  Union all SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,Convert(varchar,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,CampaignType AS ProductOffer,Convert(varchar,I.InvoiceDate,103)	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,Convert(varchar,DS.ExpDate,103) as ExpDate, (ID.Quantity-ID.DeliveryQuantity)Quantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount, (ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,ReturnReason, Convert(varchar,I.UpdateDate,103)	as UpdateDate ,I.MarketCode,I.MarketName,C.Type,I.CustomerType as NewType FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId  INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId  INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where ID.DeliveryStatus IN ('Reject','Partial') and CU.ComUnitId=@ComUnitId  and I.UpdateDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, UnitDateRangeParameters(districtId, fromDate, toDate));
        }

        public DataTable DeliveryReturnReportDAl(DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,Convert(varchar,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,Campaign AS ProductOffer,
Convert(varchar,I.InvoiceDate,103)	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,Convert(varchar,DS.ExpDate,103) as ExpDate,
(ID.Quantity-ID.DeliveryQuantity)Quantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount,
(ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,ReturnReason,
Convert(varchar,I.UpdateDate,103)	as UpdateDate ,I.MarketCode,I.MarketName,I.Types as Type,I.CustomerType as NewType
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId 
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId 
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
where ID.DeliveryStatus IN ('Reject','Partial') and  I.UpdateDate between @FromDate and @ToDate Union all SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,Convert(varchar,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer,CampaignType AS ProductOffer,Convert(varchar,I.InvoiceDate,103)	as InvoiceDate,I.DelivaryInvoiceNo,Convert(varchar,I.UpdateDate,103)	as UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,Convert(varchar,DS.ExpDate,103) as ExpDate, (ID.Quantity-ID.DeliveryQuantity)Quantity,(ID.NetAmount-ID.DeliveryNetAmount)Amount, (ID.TotalPriceVatAmount-ID.DeliveryTotalPriceVatAmount)VatAmount,I.AreaCode,I.MiaCode,I.DisCode as DistrictCode , I.RegionCode,ReturnReason, Convert(varchar,I.UpdateDate,103)	as UpdateDate ,I.MarketCode,I.MarketName,C.Type,I.CustomerType as NewType FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId  INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId  INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where ID.DeliveryStatus IN ('Reject','Partial')  and I.UpdateDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        public DataTable CustomerPaymentDAl(string PaymentStatus, DateTime fromDate, DateTime toDate, string salesCenter)
        {
            string query;
            //Partial Payment
            if (PaymentStatus == "0")
            {
                query =
                    @"SELECT O.CustomerType as NCOD,tblInvoice.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,DelivaryInvoiceNo,tblInvoice.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(tblCustPayDetail.PaymentAmount,0)PaymentAmount,DelivaryInvoiceNo as PaymentStatus,dbo.tblCustomerPay.PaymentDate
,tblInvoice.MarketCode,tblInvoice.MarketName,tblInvoice.AreaCode,tblInvoice.MiaCode,tblInvoice.DisCode as DistrictCode , tblInvoice.RegionCode,tblInvoice.MIAName,tblInvoice.Types as Type
FROM dbo.tblInvoice WITH (nolock) 
 INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblInvoice.ComUnitId
inner JOIN dbo.View_CustomerMaster ON dbo.tblInvoice.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
left JOIN dbo.tblCustPayDetail ON dbo.tblInvoice.InvoiceId = dbo.tblCustPayDetail.InvoiceId
left JOIN dbo.tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=dbo.tblCustomerPay.CustPayId
inner JOIN tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
inner JOIN tblOrder O ON dbo.tblInvoice.OrderId=O.OrderId


WHERE  (DeliveryInvoiceStatus='Full' or DeliveryInvoiceStatus= 'Partial') and DeliveryTpGrandTotal > 0 AND DeliveryTpGrandTotal > ISNULL(tblInvoice.PaymentAmount,0)+ISNULL(tblInvoice.AdjustAmount,0) and CU.ComUnitId=@ComUnitId  and tblInvoice.UpdateDate between @FromDate and @ToDate Union all  SELECT O.CustomerType as NCOD,tblSubInvoiceMaster.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,DelivaryInvoiceNo,tblSubInvoiceMaster.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(tblCustPayDetail.PaymentAmount,0)PaymentAmount,DelivaryInvoiceNo as PaymentStatus,dbo.tblCustomerPay.PaymentDate ,tblSubInvoiceMaster.MarketCode,tblSubInvoiceMaster.MarketName,tblSubInvoiceMaster.AreaCode,tblSubInvoiceMaster.MiaCode,tblSubInvoiceMaster.DisCode as DistrictCode , tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.MIAName,Type FROM dbo.tblSubInvoiceMaster WITH (nolock)   INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblSubInvoiceMaster.ComUnitId inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId left JOIN dbo.tblCustPayDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblCustPayDetail.SubDeportInvoiceId left JOIN dbo.tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=dbo.tblCustomerPay.CustPayId inner JOIN tblCompanyUnit ON dbo.tblSubInvoiceMaster.ComUnitId=dbo.tblCompanyUnit.ComUnitId  inner JOIN tblOrder O ON dbo.tblSubInvoiceMaster.OrderId=O.OrderId WHERE  (DeliveryInvoiceStatus='Full' or DeliveryInvoiceStatus= 'Partial') and DeliveryTpGrandTotal > 0 AND DeliveryTpGrandTotal > ISNULL(tblSubInvoiceMaster.PaymentAmount,0) and CU.ComUnitId=@ComUnitId  and tblSubInvoiceMaster.UpdateDate between @FromDate and @ToDate ";
            }
            //Full Payment
            else if (PaymentStatus == "1")
            {
                query =
                   @"SELECT O.CustomerType as NCOD,tblInvoice.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,tblCustMaster.CustomerCode,tblCustMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,tblInvoice.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(dbo.tblCustPayDetail.PaymentAmount,0)PaymentAmount,DelivaryInvoiceNo as PaymentStatus
,tblCustomerPay.PaymentDate
,tblInvoice.MarketCode,tblInvoice.MarketName,tblInvoice.AreaCode,tblInvoice.MiaCode,tblInvoice.DisCode as DistrictCode , tblInvoice.RegionCode,tblInvoice.MIAName,tblInvoice.Types as Type
FROM dbo.tblInvoice WITH (nolock)
 INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblInvoice.ComUnitId
left JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
left JOIN dbo.tblCustPayDetail ON dbo.tblInvoice.InvoiceId = dbo.tblCustPayDetail.InvoiceId
LEFT JOIN tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=tblCustomerPay.CustPayId
inner JOIN tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
inner JOIN tblOrder O ON O.OrderId=dbo.tblInvoice.OrderId


WHERE DeliveryTpGrandTotal > 0 and DeliveryTpGrandTotal = ISNULL(tblInvoice.PaymentAmount,0)+ISNULL(tblInvoice.AdjustAmount,0) and CU.ComUnitId=@ComUnitId and tblCustomerPay.PaymentDate  between  @FromDate and @ToDate  Union all  SELECT distinct O.CustomerType as NCOD,tblSubInvoiceMaster.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,tblSubInvoiceMaster.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(dbo.tblCustPayDetail.PaymentAmount,0)PaymentAmount,DelivaryInvoiceNo as PaymentStatus ,tblCustomerPay.PaymentDate ,tblSubInvoiceMaster.MarketCode,tblSubInvoiceMaster.MarketName,tblSubInvoiceMaster.AreaCode,tblSubInvoiceMaster.MiaCode,tblSubInvoiceMaster.DisCode as DistrictCode , tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.MIAName,Type FROM dbo.tblSubInvoiceMaster WITH (nolock)  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblSubInvoiceMaster.ComUnitId inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId left JOIN dbo.tblCustPayDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblCustPayDetail.SubDeportInvoiceId LEFT JOIN tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=tblCustomerPay.CustPayId inner JOIN tblCompanyUnit ON dbo.tblSubInvoiceMaster.ComUnitId=dbo.tblCompanyUnit.ComUnitId inner JOIN tblOrder O ON dbo.tblSubInvoiceMaster.OrderId=O.OrderId WHERE DeliveryTpGrandTotal > 0 and DeliveryTpGrandTotal = tblSubInvoiceMaster.PaymentAmount and CU.ComUnitId=@ComUnitId and tblCustomerPay.PaymentDate between  @FromDate and @ToDate order by PaymentDate";
            }
            else
            {
                return new DataTable();
            }

            return SInventorySql.GetDataTable(query, UnitDateRangeParameters(salesCenter, fromDate, toDate));
        }

        public DataTable CustomerPaymentDAl(string PaymentStatus, DateTime fromDate, DateTime toDate)
        {
            string query;
            //Partial Payment
            if (PaymentStatus == "0")
            {
                query =
                    @"SELECT O.CustomerType as NCOD,tblInvoice.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,DelivaryInvoiceNo,tblInvoice.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(tblCustPayDetail.PaymentAmount,0)PaymentAmount,PaymentStatus,dbo.tblCustomerPay.PaymentDate
,tblInvoice.MarketCode,tblInvoice.MarketName,tblInvoice.AreaCode,tblInvoice.MiaCode,tblInvoice.DisCode as DistrictCode , tblInvoice.RegionCode,tblInvoice.MIAName,tblInvoice.Types as Type
FROM dbo.tblInvoice WITH (nolock) 
 INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblInvoice.ComUnitId
inner JOIN dbo.View_CustomerMaster ON dbo.tblInvoice.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
left JOIN dbo.tblCustPayDetail ON dbo.tblInvoice.InvoiceId = dbo.tblCustPayDetail.InvoiceId
left JOIN dbo.tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=dbo.tblCustomerPay.CustPayId
inner JOIN tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
inner JOIN tblOrder O ON O.OrderId=dbo.tblInvoice.OrderId


WHERE  (DeliveryInvoiceStatus='Full' or DeliveryInvoiceStatus= 'Partial') and DeliveryTpGrandTotal > 0 AND DeliveryTpGrandTotal > ISNULL(tblInvoice.PaymentAmount,0)+ISNULL(tblInvoice.AdjustAmount,0)  and tblInvoice.UpdateDate between @FromDate and @ToDate Union all  SELECT O.CustomerType as NCOD,tblSubInvoiceMaster.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,DelivaryInvoiceNo,tblSubInvoiceMaster.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(tblCustPayDetail.PaymentAmount,0)PaymentAmount,PaymentStatus,dbo.tblCustomerPay.PaymentDate ,tblSubInvoiceMaster.MarketCode,tblSubInvoiceMaster.MarketName,tblSubInvoiceMaster.AreaCode,tblSubInvoiceMaster.MiaCode,tblSubInvoiceMaster.DisCode as DistrictCode , tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.MIAName,Type FROM dbo.tblSubInvoiceMaster WITH (nolock)   INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblSubInvoiceMaster.ComUnitId inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId left JOIN dbo.tblCustPayDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblCustPayDetail.SubDeportInvoiceId left JOIN dbo.tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=dbo.tblCustomerPay.CustPayId inner JOIN tblCompanyUnit ON dbo.tblSubInvoiceMaster.ComUnitId=dbo.tblCompanyUnit.ComUnitId inner JOIN tblOrder O ON O.OrderId=dbo.tblSubInvoiceMaster.OrderId WHERE  (DeliveryInvoiceStatus='Full' or DeliveryInvoiceStatus= 'Partial') and DeliveryTpGrandTotal > 0 AND DeliveryTpGrandTotal > ISNULL(tblSubInvoiceMaster.PaymentAmount,0) and tblSubInvoiceMaster.UpdateDate between @FromDate and @ToDate ";
            }
            //Full Payment
            else if (PaymentStatus == "1")
            {
                query =
                   @"SELECT O.CustomerType as NCOD,tblInvoice.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,tblInvoice.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(dbo.tblCustPayDetail.PaymentAmount,0)PaymentAmount,PaymentStatus
,tblCustomerPay.PaymentDate
,tblInvoice.MarketCode,tblInvoice.MarketName,tblInvoice.AreaCode,tblInvoice.MiaCode,tblInvoice.DisCode as DistrictCode , tblInvoice.RegionCode,tblInvoice.MIAName,tblInvoice.Types as Type
FROM dbo.tblInvoice WITH (nolock)
 INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblInvoice.ComUnitId
inner JOIN dbo.View_CustomerMaster ON dbo.tblInvoice.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
left JOIN dbo.tblCustPayDetail ON dbo.tblInvoice.InvoiceId = dbo.tblCustPayDetail.InvoiceId
LEFT JOIN tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=tblCustomerPay.CustPayId
inner JOIN tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
inner JOIN tblOrder O ON O.OrderId=dbo.tblInvoice.OrderId


WHERE DeliveryTpGrandTotal > 0 and DeliveryTpGrandTotal = ISNULL(tblInvoice.PaymentAmount,0)+ISNULL(tblInvoice.AdjustAmount,0) and  tblCustomerPay.PaymentDate  between  @FromDate and @ToDate  Union all  SELECT O.CustomerType as NCOD,tblSubInvoiceMaster.DeliveryTpVat as Vat,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName,View_CustomerMaster.CustomerCode,View_CustomerMaster.CustomerName,InvoiceNo,InvoiceDate as InvoiceDate,tblSubInvoiceMaster.UpdateDate as  DelivaryInvoiceDate,DeliveryTpGrandTotal,IsNull(dbo.tblCustPayDetail.PaymentAmount,0)PaymentAmount,PaymentStatus ,tblCustomerPay.PaymentDate ,tblSubInvoiceMaster.MarketCode,tblSubInvoiceMaster.MarketName,tblSubInvoiceMaster.AreaCode,tblSubInvoiceMaster.MiaCode,tblSubInvoiceMaster.DisCode as DistrictCode , tblSubInvoiceMaster.RegionCode,tblSubInvoiceMaster.MIAName,Type FROM dbo.tblSubInvoiceMaster WITH (nolock)  INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = tblSubInvoiceMaster.ComUnitId inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId left JOIN dbo.tblCustPayDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblCustPayDetail.SubDeportInvoiceId LEFT JOIN tblCustomerPay ON dbo.tblCustPayDetail.CustPayId=tblCustomerPay.CustPayId inner JOIN tblCompanyUnit ON dbo.tblSubInvoiceMaster.ComUnitId=dbo.tblCompanyUnit.ComUnitId inner JOIN tblOrder O ON O.OrderId=dbo.tblSubInvoiceMaster.OrderId WHERE DeliveryTpGrandTotal > 0 and DeliveryTpGrandTotal = tblSubInvoiceMaster.PaymentAmount  and tblCustomerPay.PaymentDate between  @FromDate and @ToDate order by PaymentDate";
            }
            else
            {
                return new DataTable();
            }

            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        // Sales Rejection 
        public DataTable SalesReectionReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT up.UnitPrice AS Batch,up.VATAmountPerUnit AS VatAmount,U.ComUnitCode,U.ComUnitName,C.MarketCode,C.MarketName,C.CustomerCode,C.CustomerName
                        ,O.OrderCode,CONVERT(NVARCHAR,O.SubmissionDate,103)SubmissionDate
                        ,D.ProductCode,PP.ProductName,I.InvoiceNo,CONVERT(NVARCHAR,I.InvoiceDate,103)InvoiceDate,D.Quantity AS RejectQuantity
                        ,D.TotalTradePrice AS NetRejectionAmount , CONVERT(NVARCHAR,I.InvoiceDate,103) AS DateofRejection,C.RegionCode AS DZSMCode,C.DistrictCode AS FECode , C.MiaCode AS MIOCode,C.AreaCode AS TerritoryCode
                        FROM dbo.tblOrder O
                        INNER JOIN dbo.tblOrderDetail D ON O.OrderId = D.OrderId
                        left JOIN dbo.tblCompanyUnit U ON O.ComUnitId = U.ComUnitId
                         left JOIN dbo.tblProduct PP ON D.ProductCode = PP.ProductCode
                        left JOIN dbo.View_CustomerMaster C ON O.CustomerCode = C.CustomerCode
                        left JOIN dbo.tblInvoice I ON O.OrderCode = I.OrderNo
                        left JOIN dbo.tblUnitPrice UP ON D.ProductCode = UP.ProductCode
                        WHERE Status='Undelivered' AND I.InvoiceNo IS NOT NULL
                        and O.ComUnitId=@ComUnitId and I.InvoiceDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, UnitDateRangeParameters(districtId, fromDate, toDate));
        }

        public DataTable SalesReectionReportDAl(DateTime fromDate, DateTime toDate)
        {
            const string query =
                       @"SELECT up.UnitPrice AS Batch,up.VATAmountPerUnit AS VatAmount,U.ComUnitCode,U.ComUnitName,C.MarketCode,C.MarketName,C.CustomerCode,C.CustomerName
                        ,O.OrderCode,CONVERT(NVARCHAR,O.SubmissionDate,103)SubmissionDate
                        ,D.ProductCode,PP.ProductName,I.InvoiceNo,CONVERT(NVARCHAR,I.InvoiceDate,103)InvoiceDate,D.Quantity AS RejectQuantity
                        ,D.TotalTradePrice AS NetRejectionAmount , CONVERT(NVARCHAR,I.InvoiceDate,103) AS DateofRejection,C.RegionCode AS DZSMCode,C.DistrictCode AS FECode , C.MiaCode AS MIOCode,C.AreaCode AS TerritoryCode
                        FROM dbo.tblOrder O
                        INNER JOIN dbo.tblOrderDetail D ON O.OrderId = D.OrderId
                        left JOIN dbo.tblCompanyUnit U ON O.ComUnitId = U.ComUnitId
                         left JOIN dbo.tblProduct PP ON D.ProductCode = PP.ProductCode
                        left JOIN dbo.View_CustomerMaster C ON O.CustomerCode = C.CustomerCode
                        left JOIN dbo.tblInvoice I ON O.OrderCode = I.OrderNo
                        left JOIN dbo.tblUnitPrice UP ON D.ProductCode = UP.ProductCode
                        WHERE Status='Undelivered' AND I.InvoiceNo IS NOT NULL
                        AND I.InvoiceDate between @FromDate and @ToDate";

            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        public DataTable SalesReportDAlParameter(DateTime fromDate, DateTime toDate, string parameter)
        {
            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,
                      CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.DeliveryQuantity,DeliveryNetAmount,
                         DeliveryTotalPriceVatAmount,DeliveryDiscountAmount,ID.DelivarySpecialAmount,A.AreaCode,MI.MiaCode,DIS.DistrictCode , R.RegionCode
                        FROM dbo.tblInvoice I 
                       INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId 
                       INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
                       INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
                       INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId 
                        LEFT JOIN dbo.tblArea A ON A.AreaId = C.AreaId
                      LEFT JOIN dbo.tblMIAInfo MI ON MI.MiaId =C.MiaId 
                       LEFT JOIN dbo.tblDistrict DIS ON DIS.DistrictId = C.DistrictId
                        INNER JOIN dbo.tblRegion R ON R.RegionId = C.RegionId
                      where ID.DeliveryStatus IN ('Full','Partial') 
                       and I.UpdateDate between @FromDate and @ToDate " + parameter;

            return SInventorySql.GetDataTable(query, DateRangeParameters(fromDate, toDate));
        }

        private static List<SqlParameter> DateRangeParameters(DateTime fromDate, DateTime toDate)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            };
        }

        private static List<SqlParameter> UnitDateRangeParameters(string comUnitId, DateTime fromDate, DateTime toDate)
        {
            var parameters = DateRangeParameters(fromDate, toDate);
            parameters.Add(new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId == null ? null : comUnitId.Trim())));
            return parameters;
        }
    }
}
