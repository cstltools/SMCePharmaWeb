using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class OrderInfoBLL
    {
        OrderInfoDAL aOrderInfoDal=new OrderInfoDAL();
        public DataTable LoadInvoiceReturn(string invoiceId)
        {
            return aOrderInfoDal.LoadInvoiceReturn(invoiceId);
        }
        public DataTable LoadSubInvoiceBatchId()
        {
            return aOrderInfoDal.LoadSubInvoiceBatchId();
        }

        public Int32 GenerateSubInvoiceByOrderId(int orderId, int userId, string batchn)
        {
            return aOrderInfoDal.GenerateSubInvoiceByOrderId(orderId, userId, batchn);
        }

        public DataTable LoadDoctorOrderForOrderCreation(string comunitId)
        {
            return aOrderInfoDal.LoadDoctorOrderForOrderCreation(comunitId);
        }

        public Int32 GenerateInvoiceByOrderId(int orderId, int userId, string batchn, string DANameId)
        {
            return aOrderInfoDal.GenerateInvoiceByOrderId(orderId, userId, batchn, DANameId);
        }

        public DataTable LoadSubInvoiceReturn(string invoiceId)
        {
            return aOrderInfoDal.LoadSubInvoiceReturn(invoiceId);
        }

        //public DataTable SubLoadInvoice(string invoiceId)
        //{
        //    return aOrderInfoDal.SubLoadInvoice(invoiceId);
        //}
        public DataTable LoadOrder(string comunitId, string manufacId, string marketId)
        {
            return aOrderInfoDal.LoadOrder(comunitId, manufacId, marketId);
        }
        public void LoadMarketByInvoice(DropDownList ddl, string comunitId)
        {
            aOrderInfoDal.LoadMarketByInvoice(ddl, comunitId);
        }
        public void SubdeportLoadMarketByInvoice(DropDownList ddl, string comunitId)
        {
            aOrderInfoDal.SubdeportLoadMarketByInvoice(ddl, comunitId);
        }
        public DataTable LoadOrderForOrderCreation(string comunitId, string manufacId, string marketId, string TerritoryId)
        {
            return aOrderInfoDal.LoadOrderForOrderCreation(comunitId, manufacId, marketId, TerritoryId);
        }

        //public DataTable LoadOrderForOrderCreation(string comunitId, string manufacId, string marketId)
        //{
        //    return aOrderInfoDal.LoadOrderForOrderCreation(comunitId, manufacId, marketId);
        //}
        public DataTable subDepoOrderLoad(string comunitId, string manufacId, string root)
        {
            return aOrderInfoDal.subDepoOrderLoad(comunitId, manufacId, root);
        }

        public DataTable LoadInvoiceBatchId()
        {
            return aOrderInfoDal.LoadInvoiceBatchId();
        }
        public void LoadMarketOrderWise(DropDownList ddl, string comunitId)
        {
            aOrderInfoDal.LoadMarketOrderWise(ddl,comunitId);
        }
        public void LoadMarketOrderWiseALl(DropDownList ddl, string comunitId)
        {
            aOrderInfoDal.LoadMarketOrderWiseALl(ddl, comunitId);
        }
        public void SubdeportLoadMarketOrderWise(DropDownList ddl, string comunitId,string SD )
        {
            aOrderInfoDal.SubdeportLoadMarketOrderWise(ddl, comunitId, SD);
        }
        public void LoadSC(DropDownList ddl)
        {
            aOrderInfoDal.LoadSC(ddl);
        }
        public void LoadArea(DropDownList ddl, string comUnitId)
        {
            aOrderInfoDal.LoadArea(ddl, comUnitId);
        }
        public void LoadSC(DropDownList ddl,string userId)
        {
            aOrderInfoDal.LoadSC(ddl,userId);
        }

        public void LoadDisRouteforInvoice(DropDownList ddl, int dis)
        {
            aOrderInfoDal.LoadDisRouteforInvoice(ddl, dis);
        }

        public void SubLoadDisRouteforInvoice(DropDownList ddl, int dis)
        {
            aOrderInfoDal.SubDepoLoadDisRouteforInvoice(ddl, dis);
        }
        public void LoadDZSM(DropDownList ddl, string userId)
        {
            aOrderInfoDal.LoadDZSM(ddl, userId);
        }
        public void LoadManufac(DropDownList ddl)
        {
            aOrderInfoDal.LoadManufac(ddl);
        }
        public void LoadDisRoute(DropDownList ddl)
        {
            aOrderInfoDal.LoadDisRoute(ddl);
        }

       

        public void LoadDeliveryDisRouteforInvoice(DropDownList ddl, int dis)
        {
            aOrderInfoDal.LoadDeliveryDisRouteforInvoice(ddl, dis);
        } 

        public void LoadRouteforReturn(DropDownList ddl, int dis)
        {
            aOrderInfoDal.LoadDeliveryDisRouteforInvoice(ddl, dis);
        }

        public void LoadDeliveryDisRouteforInvoice(DropDownList ddl, int dis, string Date)
        {
            aOrderInfoDal.LoadDeliveryDisRouteforInvoice(ddl, dis, Date);
        }

        public DataTable LoadOrderWithInvoice(string comunitId, string manufacId, string marketId)
        {
            return aOrderInfoDal.LoadOrderWithInvoice(comunitId, manufacId, marketId);
        }
        public DataTable LoadOrderWithInvoice(string param)
        {
            return aOrderInfoDal.LoadOrderWithInvoice(param);
        }

        public DataTable LoadDistributionRoute(string comunitId)
        {
            return aOrderInfoDal.LoadDistributionRoute(comunitId);
        }
        public DataTable SubDeportLoadOrderWithInvoice(string comunitId, string manufacId, string marketId)
        {
            return aOrderInfoDal.SubDeportLoadOrderWithInvoice(comunitId, manufacId, marketId);
        }

        public DataTable LoadInvoice(string invoiceId)
        {
            return aOrderInfoDal.LoadInvoice(invoiceId);
        }
        public DataTable LoadInvoicePartialPayment(string invoiceId)
        {
            return aOrderInfoDal.LoadInvoicePartialPayment(invoiceId);
        }
        public DataTable SubLoadInvoice(string invoiceId)
        {
            return aOrderInfoDal.SubLoadInvoice(invoiceId);
        }

        public DataTable LoadDelivaryInvoice(string invoiceno, string comunitId)
        {
            return aOrderInfoDal.LoadDelivaryInvoice(invoiceno, comunitId);
        }

        public DataTable GetQty(string invoicedetailId)
        {
            return aOrderInfoDal.GetQty(invoicedetailId);
        }

        public DataTable LoadOrderWithDetail(string orderid)
        {
            return  aOrderInfoDal.LoadOrderWithDetail(orderid);
        }
        public DataTable LoadOrderWithDetailIDCheck(string orderid, string DetailsId)
        {
            return aOrderInfoDal.LoadOrderWithDetailIDCheck(orderid, DetailsId);
        }

        public DataTable LoadDetalIdByMasCheck(string orderid)
        {
            return aOrderInfoDal.LoadDetalIdByMasCheck(orderid);
        }
        public DataTable GetInvoNOGetByInvoID(string orderid)
        {
            return aOrderInfoDal.GetInvoNOGetByInvoID(orderid);
        }
        public DataTable GetInvoNOGetByInvoNo(string InvoNo)
        {
            return aOrderInfoDal.GetInvoNOGetByInvoNo(InvoNo);
        }
        public DataTable GetInvoNOGetByBatchNo(string batchNO)
        {
            return aOrderInfoDal.GetInvoNOGetByBatchNo(batchNO);
        }
        public DataTable LoadInvoiceWithDetailIDCheck(string orderid, int DetailsId)
        {
            return aOrderInfoDal.LoadInvoiceWithDetailIDCheck(orderid, DetailsId);
        }


        public DataTable LoadOrderWithDetailFrindsHospital(string orderid,string deid)
        {
            return aOrderInfoDal.LoadOrderWithDetailFrindsHospital(orderid, deid);
        }

        public DataTable LoadOrderWithDetail()
        {
            return aOrderInfoDal.LoadOrderWithDetail();
        }

        public DataTable GetCustomerCredit(string cid)
        {
            return aOrderInfoDal.GetCustomerCredit(cid);
        }
        public DataTable LoadOffer(string InvoiceId)
        {
            return aOrderInfoDal.LoadOffer(InvoiceId);
        }
        public DataTable LoadCampaign(string InvoiceId)
        {
            return aOrderInfoDal.LoadCampaign(InvoiceId);
        }
        public DataTable LoadCampaignDtls(string InvoiceId)
        {
            return aOrderInfoDal.LoadCampaignDtls(InvoiceId);
        }
        public DataTable LoadCampaignsub(string InvoiceId)
        {
            return aOrderInfoDal.LoadCampaignsub(InvoiceId);
        }
        public DataTable subLoadOffer(string InvoiceId)
        {
            return aOrderInfoDal.subLoadOffer(InvoiceId);
        }
        public DataTable GetTradeTerm(string amount,int CustTypeId, string PaymentType, string SubmissionDate)
        {
            return aOrderInfoDal.GetTradeTerm(amount, CustTypeId,   PaymentType, SubmissionDate);
        }

        public DataTable GetParcentFromOrderDetails(string amount)
        {
            return aOrderInfoDal.GetParcentFromOrderDetails(amount);
        }
        public DataTable GetParcentFromOrderDetailsMasterID(string OrderId)
        {
            return aOrderInfoDal.GetParcentFromOrderDetailsMasterID(OrderId);
        }
        public DataTable getEzeventCampaignCheck(string OrderDetailId)
        {
            return aOrderInfoDal.getEzeventCampaignCheck(OrderDetailId);
        }
        public DataTable getEsomiumCampaignCheck(string OrderDetailId)
        {
            return aOrderInfoDal.getEsomiumCampaignCheck(OrderDetailId);
        }
        public DataTable getEsomiumCampaignCheckSeacoral(string OrderDetailId)
        {
            return aOrderInfoDal.getEsomiumCampaignCheckSeacoral(OrderDetailId);
        }
        public DataTable GetTradeTermOld(string amount)
        {
            return aOrderInfoDal.GetTradeTermOld(amount);
        }
        public DataTable GetFixedCustomer(string customercode)
        {
            return aOrderInfoDal.GetFixedCustomer(customercode);
        }
        public DataTable GetFixedCustomerfromInvoiceTable(string invoiceid)
        {
            return aOrderInfoDal.GetFixedCustomerfromInvoiceTable(invoiceid);
        }
        public DataTable SubDeportGetFixedCustomerfromInvoiceTable(string invoiceid)
        {
            return aOrderInfoDal.SubDeportGetFixedCustomerfromInvoiceTable(invoiceid);
        }
        public bool UpdateInvoiceStatus(string id)
        {
            return aOrderInfoDal.UpdateInvoiceStatus(id);
        }
        public bool UpdateInvoiceStatus(string id, SqlTransaction transaction)
        {
            return aOrderInfoDal.UpdateInvoiceStatus(id, transaction);
        }
        public DataTable ProductVat(string productcode)
        {
            return aOrderInfoDal.ProductVat(productcode);
        }
        public DataTable ProductDiscount(string productcode, string customerId, string invoicedate)
        {
            return aOrderInfoDal.ProductDiscount(productcode, customerId, invoicedate);
        }
        public DataTable ProductDiscountBatch(IEnumerable<string> productcodes, string customerId, string invoicedate)
        {
            return aOrderInfoDal.ProductDiscountBatch(productcodes, customerId, invoicedate);
        }
        public void LoadMarketbyArea(DropDownList ddl, string areaId)
        {
            aOrderInfoDal.LoadMarketbyArea(ddl, areaId);
        }
        public void LoadMarket(DropDownList ddl, string comunitId)
        {
            aOrderInfoDal.LoadMarket(ddl, comunitId);
        }
        public DataTable LoadInvoice(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            return aOrderInfoDal.LoadInvoice(ComUnitId, ManufId, marketid, invDate);
        }
        public DataTable LoadInvoiceSubdeport(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            return aOrderInfoDal.LoadInvoiceSubdeport(ComUnitId, ManufId, marketid, invDate);
        }
        public DataTable LoadOrderExistsBll(string orderid)
        {
            return aOrderInfoDal.LoadOrderExistsDal(orderid);
        }
        public DataTable LoadOrderExistsBll(string orderid, SqlTransaction transaction)
        {
            return aOrderInfoDal.LoadOrderExistsDal(orderid, transaction);
        }
        public DataTable LoadInvoiceSUbdeport(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            return aOrderInfoDal.LoadInvoiceSUbdeport(ComUnitId, ManufId, marketid, invDate);
        }




        public void LoadTerritory(DropDownList ddl, string userId)
        {
            aOrderInfoDal.LoadTerritory(ddl, userId);
        }
        public void LoadZone(DropDownList ddl, string userId)
        {
            aOrderInfoDal.LoadZone(ddl, userId);
        }
        public void LoadSCZoneWise(DropDownList ddl, string userId)
        {
            aOrderInfoDal.LoadSCZoneWise(ddl, userId);
        }
        public void LoadSCZoneWise(DropDownList ddl)
        {
            aOrderInfoDal.LoadSCZoneWise(ddl);
        }
    }
}
