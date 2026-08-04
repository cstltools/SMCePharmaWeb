using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.MAIN_FUNCTION;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SubDepot_DAL
{
    public class Sub_InvoiceDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        DB_Manager aDbManager = new DB_Manager();
        public void CreateConnection_DAL()
        {
            aDbManager.CreateConnection("SalesDisDB_New3");
        }
        public void CloseAllConnection_DAL()
        {
            aDbManager.CloseConnection();
        }
        public DataTable GetWarning(string CustID)
        {
            string query = @"Select TOP 1  InvoiceNo + '- Market Name: ' + MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal)  as Details,  DATEDIFF(DAY, UpdateDate, GETDATE()   ),* from tblSubInvoiceMaster with (nolock)
            where CustomerMasterId='" + CustID.Trim() + "' and  	InvoiceDate between '1-july-2021' and getdate() and   DelivaryInvoiceNo is null  and DATEDIFF(DAY, InvoiceDate, GETDATE()   ) >=30  and (InvoiceNo is not null)";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable Isgift(int dcstoreId)
        {
            string query = "select ISGiftProduct from tblOrderDetail where OrderDetailId='" + dcstoreId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public int SaveFullInvoice(string InvoiceNo, string updateby, string updatedate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            return aCommonInternalDal.RunStoreProcedure("sp_DeliveryConformationFull", aSqlParameterList, "SSIDB");
        }

        public int SaveFullProformaInvoice(string InvoiceNo, string updateby, string updatedate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            return aCommonInternalDal.RunStoreProcedure("sp_DeliveryConformationFull", aSqlParameterList, "SSIDB");
        }
        public int SaveRejectInvoice(string InvoiceNo, string updateby, string updatedate, string reason)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            aSqlParameterList.Add(new SqlParameter("@ReturnReason", reason));
            return aCommonInternalDal.RunStoreProcedure("sp_DeliveryConformationReject", aSqlParameterList, "SSIDB");
        }
        //public Int32 SaveDataForInvoice(Invoice aInvoice)
        //{
        //    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //    aSqlParameterlist.Add(new SqlParameter("@InvoiceId", aInvoice.InvoiceId));
        //    aSqlParameterlist.Add(new SqlParameter("@InvoiceNo", aInvoice.InvoiceNo));
        //    aSqlParameterlist.Add(new SqlParameter("@InvoiceDate", aInvoice.InvoiceDate));
        //    aSqlParameterlist.Add(new SqlParameter("@OrderNo", aInvoice.OrderNo));
        //    aSqlParameterlist.Add(new SqlParameter("@OrderDate", aInvoice.OrderDate));
        //    aSqlParameterlist.Add(new SqlParameter("@CustomerMasterId", aInvoice.CustomerMasterId));
        //    aSqlParameterlist.Add(new SqlParameter("@ComUnitId", aInvoice.ComUnitId));
        //    aSqlParameterlist.Add(new SqlParameter("@MiaId", aInvoice.MiaId));
        //    aSqlParameterlist.Add(new SqlParameter("@PaymentTypeId", aInvoice.PaymentTypeId));
        //    aSqlParameterlist.Add(new SqlParameter("@TpTotal", aInvoice.TpTotal));
        //    aSqlParameterlist.Add(new SqlParameter("@TpDiscount", aInvoice.TpDiscount));
        //    aSqlParameterlist.Add(new SqlParameter("@TpVat", aInvoice.TpVat));
        //    aSqlParameterlist.Add(new SqlParameter("@TpGrandTotal", aInvoice.TpGrandTotal));
        //    aSqlParameterlist.Add(new SqlParameter("@UserId", aInvoice.UserId));
        //    aSqlParameterlist.Add(new SqlParameter("@OrderId", aInvoice.OrderId));
        //    aSqlParameterlist.Add(new SqlParameter("@TotalSpecialAmount", aInvoice.TotalSpecialAmount));
        //    aSqlParameterlist.Add(new SqlParameter("@ProductOffer", aInvoice.ProductOffer));

        //    return aDbManager.SaveAction("sp_I_InvoiceMaster", aSqlParameterlist, "@InvoiceId");
        //}
        //public Int32 SaveDataForInvoiceDetails(InvoiceDetail aInvoiceDetail)
        //{
        //    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //    aSqlParameterlist.Add(new SqlParameter("@InvoiceId", aInvoice.InvoiceId));
        //    aSqlParameterlist.Add(new SqlParameter("@InvoiceNo", aInvoice.InvoiceNo));
        //    aSqlParameterlist.Add(new SqlParameter("@InvoiceDate", aInvoice.InvoiceDate));
        //    aSqlParameterlist.Add(new SqlParameter("@OrderNo", aInvoice.OrderNo));
        //    aSqlParameterlist.Add(new SqlParameter("@OrderDate", aInvoice.OrderDate));
        //    aSqlParameterlist.Add(new SqlParameter("@CustomerMasterId", aInvoice.CustomerMasterId));
        //    aSqlParameterlist.Add(new SqlParameter("@ComUnitId", aInvoice.ComUnitId));
        //    aSqlParameterlist.Add(new SqlParameter("@MiaId", aInvoice.MiaId));
        //    aSqlParameterlist.Add(new SqlParameter("@PaymentTypeId", aInvoice.PaymentTypeId));
        //    aSqlParameterlist.Add(new SqlParameter("@TpTotal", aInvoice.TpTotal));
        //    aSqlParameterlist.Add(new SqlParameter("@TpDiscount", aInvoice.TpDiscount));
        //    aSqlParameterlist.Add(new SqlParameter("@TpVat", aInvoice.TpVat));
        //    aSqlParameterlist.Add(new SqlParameter("@TpGrandTotal", aInvoice.TpGrandTotal));
        //    aSqlParameterlist.Add(new SqlParameter("@UserId", aInvoice.UserId));
        //    aSqlParameterlist.Add(new SqlParameter("@OrderId", aInvoice.OrderId));
        //    aSqlParameterlist.Add(new SqlParameter("@TotalSpecialAmount", aInvoice.TotalSpecialAmount));
        //    aSqlParameterlist.Add(new SqlParameter("@ProductOffer", aInvoice.ProductOffer));

        //    return aDbManager.SaveAction("sp_I_InvoiceMaster", aSqlParameterlist, "@InvoiceId");
        //}

        public bool SaveDataForInvoice(Invoice aInvoice)
        {
            string insertQuery = @" INSERT INTO tblSubInvoiceMaster " +
                " (    InvoiceId , " +
     "     InvoiceNo , " +
        "     CustomerType , " +
       "     SubDepotId , " +
          "     CreateDate , " +
       "    InvoiceDate , " +
       "    OrderNo , " +
       "    OrderDate , " +
       "    CustomerMasterId , " +
       "    ComUnitId , " +
        "   MiaId , " +
        "   PaymentTypeId , " +
        "   TpTotal , " +
        "   TpDiscount , " +
        "   TpVat , " +
        "   TpGrandTotal , " +
        "   UserId, " +
        "   OrderId, " +
        "   TotalSpecialAmount, " +
         "   OldTradePolicy, " +
          "   ProductOffer,Remarks,MIACode,MIAName,MarketCode,MarketName,AreaCode,DisCode,FEName,RegionCode,DZSMName,FixedCustomer,DeliveryPersonName,DeliveryPersonPhNo " +
      "   ) " +
      " VALUES  ( '" + aInvoice.InvoiceId + "' , " +
       "    '" + aInvoice.InvoiceNo + "' , " +
          "    '" + aInvoice.cusType + "' , " +
        "    '" + aInvoice.SubDepotId + "' , " +
               "    '" + aInvoice.Createdate + "' , " +
      "    '" + aInvoice.InvoiceDate + "' , " +
      "     '" + aInvoice.OrderNo + "' , " +
      "     '" + aInvoice.OrderDate + "' , " +
      "     '" + aInvoice.CustomerMasterId + "' , " +
       "    '" + aInvoice.ComUnitId + "' , " +
       "    '" + aInvoice.MiaId + "' , " +
      "     '" + aInvoice.PaymentTypeId + "' , " +
      "    '" + aInvoice.TpTotal + "' , " +
      "     '" + aInvoice.TpDiscount + "' , " +
      "     '" + aInvoice.TpVat + "' , " +
       "    '" + aInvoice.TpGrandTotal + "' , " +
       "    '" + aInvoice.UserId + "' , " +
       "    '" + aInvoice.OrderId + "' , " +
        "    '" + aInvoice.TotalSpecialAmount + "' , " +
          "    '" + aInvoice.OldTradePolicy + "' , " +
       "    '" + aInvoice.ProductOffer + "','" + aInvoice.Remarks + "','" + aInvoice.MIACode + "','" + aInvoice.MIAName + "','" + aInvoice.MarketCode + "','" + aInvoice.MarketName + "','" +
       aInvoice.AreaCode + "','" + aInvoice.DisCode + "','" + aInvoice.FEName + "','" + aInvoice.RegionCode + "'" +
                                 ",'" + aInvoice.DZSMName + "','" + aInvoice.FixedCustomer + "','" + aInvoice.DpNAme + "','" + aInvoice.DpMob + "'  " +
      "   ) ";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool SaveDataForReturnInvoice(Invoice aInvoice)
        {
            string insertQuery = @" INSERT INTO dbo.tblReturnInvoice " +
                " (    ReturnInvoiceId , " +
     "     ReturnInvoiceNo , " +
       "    ReturnInvoiceDate , " +
       "    OrderNo , " +
       "    OrderDate , " +
       "    CustomerMasterId , " +
       "    ComUnitId , " +
        "   MiaId , " +
        "   PaymentTypeId , " +
        "   TpTotal , " +
        "   TpDiscount , " +
        "   TpVat , " +
        "   TpGrandTotal , " +
        "   UserId, " +
        "   OrderId,InvoiceId,TotalSpecialAmount " +
      "   ) " +
      " VALUES  ( '" + aInvoice.InvoiceId + "' , " +
       "    '" + aInvoice.InvoiceNo + "' , " +
      "    '" + aInvoice.InvoiceDate + "' , " +
      "     '" + aInvoice.OrderNo + "' , " +
      "     '" + aInvoice.OrderDate + "' , " +
      "     '" + aInvoice.CustomerMasterId + "' , " +
       "    '" + aInvoice.ComUnitId + "' , " +
       "    '" + aInvoice.MiaId + "' , " +
      "     '" + aInvoice.PaymentTypeId + "' , " +
      "    '" + aInvoice.TpTotal + "' , " +
      "     '" + aInvoice.TpDiscount + "' , " +
      "     '" + aInvoice.TpVat + "' , " +
       "    '" + aInvoice.TpGrandTotal + "' , " +
       "    '" + aInvoice.UserId + "' , " +
       "    '" + aInvoice.OrderId + "',  " +
       "    '" + aInvoice.ReturnInvoiceid + "' , " +
       "    '" + aInvoice.TotalSpecialAmount + "'  " +
      "   ) ";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveDataForInvoiceDetails(InvoiceDetail aInvoiceDetail)
        {
            string insertQuery = @" INSERT INTO dbo.tblSubInvoiceDetail " +
     "   ( InvoiceDetailId , "+
        "     ProductCode , "+
     "        ProductName , "+
      "       PackSize , "+
       "      BatchNo , "+
        "     ReceiveDate , "+
        "     ExpDate , "+
         "    CostPrice , "+
         "    UnitPrice , "+
         "    UnitVatAmount , "+
         "    Quantity , "+
         "    BonusQuantity ,"+
         "    TotalQuantity ,"+
         "    TotalPrice , "+
        "     TotalPriceVatAmount , "+
        "     DiscountPercentage , "+
        "     DiscountAmount , "+
        "     NetAmount , "+
        "     InvoiceId, "+
        "     SubDCStoreId, " +
        "     OrderDetailsId ," +
        "     Campaign ," +
            "     ISGiftProduct ," +
              "     IsCampaignProduct ," +
                  "     CampaignType ," +
        "     SpecialAmount " +
       "    ) "+
 "  VALUES  ( '"+aInvoiceDetail.InvoiceDetailId+"' , " +
          "   '" + aInvoiceDetail.ProductCode + "' , " +
         "   '" + aInvoiceDetail.ProductName + "' , " +
         "    '" + aInvoiceDetail.PackSize + "' , " +
         "    '" + aInvoiceDetail.BatchNo + "' , " +
         "    '" + aInvoiceDetail.ReceiveDate + "' , " +
         "    '" + aInvoiceDetail.ExpDate + "' ,  " +
         "    '" + aInvoiceDetail.CostPrice + "' , " +
         "    '" + aInvoiceDetail.UnitPrice + "' , " +
         "    '" + aInvoiceDetail.UnitVatAmount + "' , " +
         "    '" + aInvoiceDetail.Quantity + "' , " +
         "    '" + aInvoiceDetail.BonusQuantity + "' , " +
         "    '" + aInvoiceDetail.TotalQuantity + "' , " +
         "    '" + aInvoiceDetail.TotalPrice + "' , " +
         "    '" + aInvoiceDetail.TotalPriceVatAmount + "' , " +
         "    '" + aInvoiceDetail.DiscountPercentage + "' , " +
         "    '" + aInvoiceDetail.DiscountAmount + "' , " +
       "      '" + aInvoiceDetail.NetAmount + "' , " +
       "      '" + aInvoiceDetail.InvoiceId + "' , " +
       "      '" + aInvoiceDetail.DCStoreId + "' , " +
       "      '" + aInvoiceDetail.OrderDetailsId + "' , " +
       "      '" + aInvoiceDetail.Campaign  + "' , " +
            "      '" + aInvoiceDetail.ISGiftProductforInv + "' , " +
               "      '" + aInvoiceDetail.IsCampaignProductforInv + "' , " +
                      "      '" + aInvoiceDetail.CampaignType + "' , " +
       "      '" + aInvoiceDetail.SpecialAmount + "'  " +
       
      "     )";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool SaveDataForReturnInvoiceDetails(InvoiceDetail aInvoiceDetail)
        {
            string insertQuery = @" INSERT INTO dbo.tblReturnInvoiceDetail " +
     "   ( ReuturnInvoiceDetailId , " +
        "     ProductCode , " +
     "        ProductName , " +
      "       PackSize , " +
       "      BatchNo , " +
        "     ReceiveDate , " +
        "     ExpDate , " +
         "    CostPrice , " +
         "    UnitPrice , " +
         "    UnitVatAmount , " +
         "    Quantity , " +
         "    BonusQuantity ," +
         "    TotalQuantity ," +
         "    TotalPrice , " +
        "     TotalPriceVatAmount , " +
        "     DiscountPercentage , " +
        "     DiscountAmount , " +
        "     NetAmount , " +
        "     ReturnInvoiceId, " +
        "     DCStoreId, " +
        "     OrderDetailsId,InvoiceDetailId,SpecialAmount " +
       "    ) " +
 "  VALUES  ( '" + aInvoiceDetail.InvoiceDetailId + "' , " +
          "   '" + aInvoiceDetail.ProductCode + "' , " +
         "   '" + aInvoiceDetail.ProductName + "' , " +
         "    '" + aInvoiceDetail.PackSize + "' , " +
         "    '" + aInvoiceDetail.BatchNo + "' , " +
         "    '" + aInvoiceDetail.ReceiveDate + "' , " +
         "    '" + aInvoiceDetail.ExpDate + "' ,  " +
         "    '" + aInvoiceDetail.CostPrice + "' , " +
         "    '" + aInvoiceDetail.UnitPrice + "' , " +
         "    '" + aInvoiceDetail.UnitVatAmount + "' , " +
         "    '" + aInvoiceDetail.Quantity + "' , " +
         "    '" + aInvoiceDetail.BonusQuantity + "' , " +
         "    '" + aInvoiceDetail.TotalQuantity + "' , " +
         "    '" + aInvoiceDetail.TotalPrice + "' , " +
         "    '" + aInvoiceDetail.TotalPriceVatAmount + "' , " +
         "    '" + aInvoiceDetail.DiscountPercentage + "' , " +
         "    '" + aInvoiceDetail.DiscountAmount + "' , " +
       "      '" + aInvoiceDetail.NetAmount + "' , " +
       "      '" + aInvoiceDetail.InvoiceId + "' , " +
       "      '" + aInvoiceDetail.DCStoreId + "' , " +
       "      '" + aInvoiceDetail.OrderDetailsId + "',  " +
       "      '" + aInvoiceDetail.ReturnDetailsId + "' , " +
       "      '" + aInvoiceDetail.SpecialAmount + "'  " +
      "     )";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool HasProductcode(DCStore aReceive)
        {
            string query = "select * from tblDCStock where ProductCode = '" + aReceive.ProductCode + "' and BatchNo='"+aReceive.BatchNo+"'";
            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    return true;
                }
            }
            return false;
        }

        public DataTable LoadInvoiceView()
        {
            string query = @"SELECT *  FROM tblInvoice ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable ProductInfoDAL(string comUnitId, string productCode)
        {

            string query = @"   SELECT P.ProductCode,(P.ProductName+':'+P.PackSize) as  ProductName,P.PackSize,
             ISNULL(UP.UnitPrice,0) AS UnitPrice,ISNULL(VCS.TotalQty,0) AS StockQty, 
            (UP.VATAmountPerUnit) AS VAT, ISNULL(UP.CostPrice,0) AS CostPrice, 
             ISNULL(UP.VATPercentage,0)VATPercentage  FROM 
            dbo.tblProduct P 
             LEFT JOIN dbo.tblUnitPrice UP ON P.ProductCode = UP.ProductCode  
             LEFT JOIN (select SubDepotId,ProductCode, TotalQty from VIew_SubDepotCurrentStock  WHERE SubDepotId='" + comUnitId.Trim() + "' AND ProductCode='" + productCode.Trim() + "') VCS  " +
            " ON P.ProductCode=VCS.ProductCode   where P.ProductCode='" + productCode.Trim() + "' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ProductFocBonusQtyDAL(string invoiceDate, string productCode,int Qty)
        {

            string query = @"select * from [dbo].[tblFocMaster] M " +
                           " inner join [dbo].[tblFocDetails] D on M.FocId=D.FocId " +
                           " where ProductCode='" + productCode.Trim() + "' and  ('" + invoiceDate.Trim() + "' between [FocFromDate] and [FocToDate]) " +
                           " and IsActive=1 and (" + Qty + " between [RangeFrom] and RangeTo) ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadProductQty(string orderid, string productCode)
        {
            string query = @"SELECT SUM(Quantity)Qty FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderDetail ON dbo.tblOrder.OrderId = dbo.tblOrderDetail.OrderId WHERE dbo.tblOrder.OrderId='" + orderid + "' AND ProductCode='" + productCode + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
       
        public DataTable LoadProduct(string productId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT * FROM tblProduct where ProductCode='" + productId.Trim() + "' ";
            aDataTableEmpInfo = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTableEmpInfo;
        }
        public DataTable LoadCustomerMaster(string CustomerMasterId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT * FROM dbo.View_CustomerMaster   WHERE CustomerCode='" + CustomerMasterId.Trim() + "' ";
            aDataTableEmpInfo = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTableEmpInfo;
        }
        public DataTable DCStockQuantity(DCStore aReceive)
        {
            string query = "select * from tblDCStock where ProductCode = '" + aReceive.ProductCode + "' and BatchNo='"+aReceive.BatchNo+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DCInfoWithDCId(string dcstoreId)
        {
            string query = "SELECT * FROM dbo.tblSubDepotStore WHERE SubDCStoreId='" + dcstoreId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public void UpdateDCStoreQuantity(string dCStoreId, decimal Quantity)
        {
            string updateQuery = @"UPDATE tblSubDepotStore SET StockQty='" + Quantity + "' WHERE SubDCStoreId='" + dCStoreId.Trim() + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }
      //  public bool DCStockInDAL(DCStockNew aDcStockNew)
      //  {
      //      string query = @"INSERT INTO dbo.tblDCStoreFreeze " +
      // "  ( DCStoreId , " +
      //   "    DCStoreFreezeId, " +
      //   "    InvoiceDetailId, " +
      //   "    StorageLocation , " +
      //   "    ProductCode , " +
      //   "    ProductName , " +
      //   "    PackSize , " +
      //   "    BatchNo , " +
      //   "    TotalQuantity , " +
      //   "    ExpDate , " +
      //   "    ReceiveDate , " +
      //   "    ChalanNo , " +
      //   "    ChalanDate , " +
      //    "   ComUnitId , " +
      //   "    StockQty , " +
      //   "    DamageQty , " +
      //   "    StockRcvDate , " +
      //   "    ReqId , " +
      //   "    ReqChildId , " +
      //   "    StockInTransfarId, " +
      //   "    StockCondition " +
      //  "   ) " +
      //  "   VALUES  ( '" + aDcStockNew.DCStoreId + "' , " +
      //  "     '" + aDcStockNew.DCStoreFreezeId + "' , " +
      //  "     '" + aDcStockNew.InvoiceDetailId + "' , " +
      //  "     '" + aDcStockNew.StorageLocation + "' , " +
      //  "     '" + aDcStockNew.ProductCode + "' ,  " +
      //  "    '" + aDcStockNew.ProductName + "' , " +
      //  "    '" + aDcStockNew.PackSize + "' , " +
      //  "    '" + aDcStockNew.BatchNo + "' , " +
      //   "    '" + aDcStockNew.TotalQuantity + "' ,  " +
      //   "    '" + aDcStockNew.ExpDate + "' ,  " +
      //  "     '" + aDcStockNew.ReceiveDate + "' , " +
      //  "    '" + aDcStockNew.ChalanNo + "' , " +
      //  "    '" + aDcStockNew.ChalanDate + "', " +
      //  "    '" + aDcStockNew.ComUnitId + "' , " +
      //   "    '" + aDcStockNew.StockQty + "', " +
      //   "    '" + aDcStockNew.DamageQty + "' , " +
      //   "   '" + aDcStockNew.StockRcvDate + "' , " +
      //   "   '" + aDcStockNew.ReqId + "' , " +
      //  "    '" + aDcStockNew.ReqChildId + "', " +
      // "      '" + aDcStockNew.StockInTransfarId + "',  " +
      // "      'ReturnStock'  " +
      //"     )";
      //      return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
      //  }

        public void UpdateInvoice(Invoice aInvoice)
        {
            string updateQuery = @"UPDATE tblSubInvoiceMaster SET DeliveryTpTotal='" + aInvoice.TpTotal + "',DeliveryTpDiscount='" + aInvoice.TpDiscount + "',DeliveryTpVat='" + aInvoice.TpVat + "',UpdateDatetime='" + aInvoice.updatetime + "'," +
                                 "DeliveryTpGrandTotal='" + aInvoice.TpGrandTotal + "',DeliveryInvoiceStatus='" + aInvoice.DeliveryInvoiceStatus + "',DelivaryInvoiceNo='" + aInvoice.DelivaryInvoiceNo + "',DelivarySpecialAmount='" + aInvoice.TotalSpecialAmount + "',UpdateBy='" + aInvoice.UpdateBy + "',UpdateDate='" + aInvoice.InvoiceDate + "' WHERE InvoiceId='" + aInvoice.InvoiceId + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }
        public void UpdateInvoiceDetail(InvoiceDetail  aInvoiceDetail)
        {
            string updateQuery = @"UPDATE tblSubInvoiceDetail SET DeliveryQuantity='" + aInvoiceDetail.Quantity + "',DeliveryBonusQuantity='" + aInvoiceDetail.BonusQuantity + "',DeliveryTotalQuantity='" + aInvoiceDetail.TotalQuantity + "'," +
                                 "DeliveryTotalPrice='" + aInvoiceDetail.TotalPrice + "',DeliveryTotalPriceVatAmount='" + aInvoiceDetail.TotalPriceVatAmount + "',DeliveryDiscountPercentage='" + aInvoiceDetail.DiscountPercentage + "',DeliveryDiscountAmount='" + aInvoiceDetail.DiscountAmount + "',DeliveryNetAmount='" + aInvoiceDetail.NetAmount + "',DeliveryStatus='" + aInvoiceDetail.DeliveryStatus + "',DelivarySpecialAmount='" + aInvoiceDetail.SpecialAmount + "',ReturnReason='" + aInvoiceDetail.ReturnReason + "' WHERE InvoiceDetailId='" + aInvoiceDetail.InvoiceDetailId + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }

        public void PaymentTypeLoad(DropDownList aDropDownList)
        {
            string query = @"select * from tblPaymentType";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "PaymentTypeName", "PaymentTypeId", query, "SSIDB");
        }
        public void ReturnReason(DropDownList aDropDownList)
        {
            string query = @"SELECT * FROM tblReturnReason";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "ReaturnReason", "ReturndReasonId", query, "SSIDB");
        }
        public DataTable GetReason()
        {
            string query = @"SELECT ReaturnReason,ReturndReasonId FROM tblReturnReason";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DiscountofProduct(string productCode,string qty)
        {
            string query = @"SELECT * FROM dbo.tblProductDiscount WHERE ProductCode='" + productCode.Trim() + "' AND ('" + qty.Trim() + "' BETWEEN MinQty AND MaxQty) AND Status='Active'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable BatchWiseProductQty(string productCode, string ScomUnitId)
        {
            string query = @"SELECT * FROM tblSubDepotStore WHERE ProductCode='" + productCode.Trim() + "' AND SubDepotId='" + ScomUnitId.Trim() + "' AND StockQty>0 ORDER BY ExpDate ASC";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        //public DataTable InvoiceMainDataForReport(string invNo)
        //{
        //    string query = @"SELECT IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName , " +
        //                 " (CU.Address +' ' +',M-'+CU.MobileNo+',P-'+CU.PhoneNo+',F-'+CU.FaxNo) AS CUAddress, "+
        //                " CM.CustomerCode,CM.CustomerName, (CM.Address+' '+CM.CellNo) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, "+
        //                " MIA.MiaCode,MIA.MiaName,U.UserName "+
        //                " FROM tblInvoice IV "+
        //                " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId "+
        //                " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId "+
        //                " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId "+
        //                " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId "+
        //                " LEFT JOIN tblUser U ON IV.UserId=U.UserId "+
        //                " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
        //                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //               " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";
        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
        //public DataTable InvoiceDetailDataForReport(string invNo)
        //{
        //    //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
        //    //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
        //    //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
        //    //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //    //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

        //    string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
        //                    "  IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
        //                    "  (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId  " +
        //                    "   FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
        //             "  INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId " +
        //            "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
        //        //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //              " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
        public DataTable InvoiceDetailDataForReport(int Dcid, int ManufId, int marketid, DateTime invDate)
        {
            string query = @"   SELECT  * 				
        FROM tblSubInvoiceMaster I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
                    INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode      
where I.ComUnitId= '" + Dcid + "' and tblD.ManufacId='" + ManufId + "' and tblMarket.MarketId='" + marketid + "' and InvoiceDate='" + invDate + "' order by OrderNo";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ReturnInvoiceMainDataForReport(string invNo)
        {
            string query = @"SELECT IV.InvoiceId,IV.ReturnInvoiceNo as InvoiceNo,ReturnInvoiceId as InvoiceId ,IV.ReturnInvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,IV.TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName , " +
                         " (CU.Address +' ' +',M-'+CU.MobileNo+',P-'+CU.PhoneNo+',F-'+CU.FaxNo) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address+' '+CM.CellNo) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,U.UserName " +
                        " FROM tblReturnInvoice IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE IV.ReturnInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ReturnInvoiceDetailDataForReport(string invNo)
        {
            string query = @"SELECT IV.ReturnInvoiceNo as InvoiceNo,IV.ReturnInvoiceId as InvoiceId,IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.ReturnInvoiceId " +
                             " FROM dbo.tblReturnInvoiceDetail IVD LEFT JOIN dbo.tblReturnInvoice IV ON IVD.ReturnInvoiceId = IV.ReturnInvoiceId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE IV.ReturnInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable AllInvoiceForPrintingDAL(string ComUnitId, DateTime InvoiceDate)
        {
            string query = @"SELECT * FROM dbo.tblInvoice I LEFT JOIN dbo.tblCustMaster C ON I.CustomerMasterId = C.CustomerMasterId "+
                            " WHERE I.ComUnitId='"+ComUnitId.Trim()+"' AND I.InvoiceDate='"+InvoiceDate+"' ORDER BY I.InvoiceId DESC" ;

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable InvoiceForDCPickingDAL(string ComUnitId, DateTime InvoiceDate)
        {
            string query = @"SELECT * FROM dbo.tblInvoice I LEFT JOIN dbo.tblCustMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
                            " WHERE I.ComUnitId='" + ComUnitId.Trim() + "' AND I.InvoiceDate='" + InvoiceDate + "' AND I.InvoiceNo NOT IN (SELECT InvoiceNo FROM dbo.tblDCPickingDetail)  ORDER BY I.InvoiceId DESC";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public bool DcPickingSaveDAL(DCPicking aDcPicking)
        {
            string insertQuery = @" INSERT INTO dbo.tblDCPicking "+
                          "  ( DCPicId , "+
                           "    DCPicNo , "+
                          "     DCPicDate , "+
                           "    ComUnitId ,"+
                           "    AreaId " +
                          "   ) "+
                   "  VALUES  ( '" + aDcPicking.DCPicId + "' ,  " +
                         "      '" + aDcPicking.DCPicNo + "' , " +
                        "       '" + aDcPicking.DCPicDate + "' , " +
                       "        '" + aDcPicking.ComUnitId + "'  ," +
                        "        '" + aDcPicking.AreaId + "'  " +
                        "     ) ";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool UpdateOrder(string  status,string id)
        {
            string insertQuery = @"UPDATE dbo.tblOrderDetail SET Status='"+status+"' WHERE OrderDetailId='"+id+"'";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool DcPickingDetailSaveDAL(DCPickingDetail aDcPickingDetail)
        {
            string insertQuery = @"INSERT INTO dbo.tblDCPickingDetail "+
                         "   ( DCPicDetailId, InvoiceNo, DCPicId ) "+
                   "    VALUES  ( '" + aDcPickingDetail.DCPicDetailId + "', " +
                         "       '" + aDcPickingDetail.InvoiceNo + "', " +
                         "        '" + aDcPickingDetail.DCPicId + "' " +
                         "        )";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }


        public DataTable AllPickingForReportList(string comUnitId,DateTime pickDate)
        {
            string query = @"select * from tblDCPicking where DCPicDate='" + pickDate + "' and ComUnitId='" + comUnitId.Trim() + "' order by DCPicId  desc ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable DCPickingReportMainDataDAL(string dcPickingNo)
        {
            string query = @"SELECT P.DCPicNo,P.DCPicDate,CU.ComUnitCode,CU.ComUnitName,CU.Address,A.AreaCode,A.AreaName FROM tblDCPicking P LEFT JOIN dbo.tblCompanyUnit CU ON P.ComUnitId = CU.ComUnitId LEFT JOIN dbo.tblArea A ON P.AreaId=A.AreaId " +
                            " WHERE P.DCPicNo='" + dcPickingNo.Trim() + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable  DCPickingReportDetailDataDAL(string dcPickingNo)
        {

            string query = @"SELECT IND.ProductCode,IND.ProductName,IND.BatchNo, SUM(TotalQuantity) AS TotalPickQty FROM dbo.tblInvoiceDetail IND LEFT JOIN dbo.tblInvoice I ON IND.InvoiceId = I.InvoiceId  "+
                            " WHERE I.InvoiceNo IN (SELECT InvoiceNo FROM dbo.tblDCPickingDetail LEFT JOIN dbo.tblDCPicking "+
                            " ON dbo.tblDCPickingDetail.DCPicId = dbo.tblDCPicking.DCPicId WHERE tblDCPicking.DCPicNo='" + dcPickingNo.Trim() + "')  " +
                            " GROUP BY IND.ProductCode,IND.ProductName,IND.BatchNo ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public void AreaDropDownLoad(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT A.* FROM dbo.tblArea A LEFT JOIN dbo.tblDistrict D ON A.DistrictId = D.DistrictId "+
                                " LEFT JOIN dbo.tblCompanyUnit C ON D.ComUnitId = C.ComUnitId "+
                                " WHERE C.ComUnitId='" + comUnitId.Trim() + "'";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "AreaName", "AreaId", query, "SSIDB");

        }
        public DataTable InvoiceNoCount(string comUnitId)
        {
            //string query = @"SELECT count(InvoiceNo) CountNo FROM dbo.tblInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";

            string query = @"SELECT  (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,12,13)) AS INT)),0)+1) CountNo FROM tblSubInvoiceMaster WHERE ComUnitId ='" + comUnitId.Trim() + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ReturnInvoiceNoCount(string comUnitId)
        {
            string query = @"SELECT count(ReturnInvoiceNo) CountNo FROM dbo.tblReturnInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DcPickingNoCount(string comUnitId)
        {
            string query = @"SELECT count(DCPicNo) CountNo FROM dbo.tblDCPicking WHERE ComUnitId ='" + comUnitId.Trim() + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable MarketPickinReport(string SC, int MarketID, int ManufacID, DateTime InvDate)
        {
            string query = @" SELECT tblMarket.MarketName,M.MiaName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId='" + SC + "' and p.ManufacId='" + ManufacID + "' and InvoiceDate='" + InvDate + "' and tblMarket.MarketId='" + MarketID + "' GROUP BY tblMarket.MarketName,M.MiaName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize ";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }




        public DataTable DeliveryInvoiceMainDataForReportDAL(string invNo)
        {
            string query = @"SELECT IV.InvoiceId,IV.DelivaryInvoiceNo AS InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.DeliveryTpTotal AS TpTotal,IV.DeliveryTpVat AS TpVat,(IV.DeliveryTpDiscount  +isnull(IV.DelivarySpecialAmount ,0))TpDiscount,IV.DeliveryTpGrandTotal AS TpGrandTotal,CU.ComUnitCode,CU.ComUnitName , " +
                         "        (CU.Address +' ' +',M-'+CU.MobileNo+',P-'+CU.PhoneNo+',F-'+CU.FaxNo) AS CUAddress,  " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address+' '+CM.CellNo) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,U.UserName  " +
                        " FROM tblInvoice IV  " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
               
                       " WHERE IV.DelivaryInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DeliveryInvoiceDetailDataForReportDAL(string invNo)
        {
            string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.DeliveryQuantity AS Quantity,IVD.UnitPrice, IVD.UnitVatAmount,IVD.DeliveryTotalPrice,IVD.DeliveryTotalPriceVatAmount,(IVD.DeliveryDiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount AS NetAmount,IV.InvoiceId   " +
                            " LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                            " WHERE IV.DelivaryInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ProformaReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {

            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,
CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,
CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode
,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay
,I.MarketName
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
        where CU.ComUnitId='" + districtId.Trim() + "' and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ProformaReportDAl( DateTime fromDate, DateTime toDate)
        {

            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,
CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,
CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode
,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay
,I.MarketName
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
       where I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable InvoiceMainDataForReport(string invNo)
        {
            string query = @"SELECT IV.FixedCustomer,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,IV.ProgramType as CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,IV.MarketName as UserName " +
                        " FROM tblSubInvoiceMaster IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable InvoiceMainDataForReport2(string invNo)
        {
            string query = @"SELECT IV.FixedCustomer,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,CM.Type as CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,CM.MarketName as UserName " +
                        " FROM tblSubInvoiceMaster IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       "  " + invNo.Trim() + " ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable InvoiceMainDataForReport2SubDepo(string invNo)
        {
            string query = @"SELECT IV.FixedCustomer,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,CM.Type as CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,CM.MarketName as UserName " +
                        " FROM tblSubInvoiceMaster IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                       //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       "  " + invNo.Trim() + " ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        //public DataTable DelivaryInvoiceMainDataForReport(string invNo)
        //{
        //    string query = @"SELECT IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
        //                 " (CU.Address) AS CUAddress, " +
        //                " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, " +
        //                " MIA.MiaCode,MIA.MiaName,U.UserName " +
        //                " FROM tblInvoice IV " +
        //                " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
        //                " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
        //                " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
        //                " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
        //                " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
        //                " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
        //        //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //               " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";
        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable InvoiceDetailDataForReport(string invNo)
        {
            //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
            //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
            //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
            //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
            //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,IVD.BatchNo,IVD.PackSize as BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId  " +
                            "   FROM dbo.tblSubInvoiceDetail IVD LEFT JOIN dbo.tblSubInvoiceMaster IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblSubInvoiceMaster I ON I.InvoiceId = IV.InvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                      " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable InvoiceDetailDataForReport2(string invNo)
        {
            //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
            //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
            //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
            //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
            //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,IVD.BatchNo,IVD.PackSize as BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId  " +
                            "   FROM dbo.tblSubInvoiceDetail IVD LEFT JOIN dbo.tblSubInvoiceMaster IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblSubInvoiceMaster I ON I.InvoiceId = IV.InvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                      " " + invNo.Trim() + " ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable ReturnReturnInvoiceMainDataForReport(string invNo)
        {
            string query = @"SELECT IV.ReturnInvoiceId as InvoiceId,IV.ReturnInvoiceNo as InvoiceNo,IV.ReturnInvoiceDate as InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName , " +
                         " (CU.Address ) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,U.UserName " +
                        " FROM tblReturnInvoice IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.ReturnInvoiceNo='" + invNo.Trim() + "'";
                       " WHERE IV.ReturnInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable ReturnReturnInvoiceDetailDataForReport(string invNo)
        {
            string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.ReturnInvoiceId as  InvoiceId  " +
                            "   FROM dbo.tblReturnInvoiceDetail IVD LEFT JOIN dbo.tblReturnInvoice IV ON IVD.ReturnInvoiceId = IV.ReturnInvoiceId " +
                     "  INNER JOIN dbo.tblReturnInvoice I ON I.ReturnInvoiceId = IV.ReturnInvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.ReturnInvoiceNo='" + invNo.Trim() + "'";
                      " WHERE IV.ReturnInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        ///////////////////////////////////////////////////////////////////////////////
        //public DataTable DelivaryInvoiceMainDataForReport(string invNo)
        //{
        //    string query = @"SELECT IV.InvoiceId,IV.DelivaryInvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.DeliveryTpTotal,IV.DeliveryTpVat,(IV.DeliveryTpDiscount+isnull(IV.DelivarySpecialAmount,0))TpDiscount,IV.DeliveryTpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
        //                 " (CU.Address) AS CUAddress, " +
        //                " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, " +
        //                " MIA.MiaCode,MIA.MiaName,U.UserName " +
        //                " FROM tblInvoice IV " +
        //                " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
        //                " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
        //                " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
        //                " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
        //                " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
        //                " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
        //        //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //               " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";
        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
        //public DataTable DelivaryInvoiceDetailDataForReport(string invNo)
        //{
        //    //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
        //    //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
        //    //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
        //    //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //    //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

        //    string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.DeliveryQuantity,IVD.UnitPrice, " +
        //                    "  IVD.UnitVatAmount,IVD.DeliveryTotalPrice,IVD.DeliveryTotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DeliveryDiscountPercentage,0))DiscountPercentage, " +
        //                    "  (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount,IV.InvoiceId  " +
        //                    "   FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
        //             "  INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId " +
        //            "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
        //        //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //              " WHERE IV.DelivaryInvoiceNo in (" + invNo.Trim() + ") ";

        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
        //public DataTable DelivaryInvoiceMainDataForReport(string invNo)
        //{
        //    string query = @"SELECT IV.InvoiceId,IV.DelivaryInvoiceNo as InvoiceNo,IV.UpdateDate as InvoiceDate,IV.OrderNo,IV.OrderDate,IV.DeliveryTpTotal,IV.DeliveryTpVat,(IV.DeliveryTpDiscount+isnull(IV.DelivarySpecialAmount,0))TpDiscount,IV.DeliveryTpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
        //                 " (CU.Address) AS CUAddress, " +
        //                " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CC.CategoryName,PT.PaymentTypeName, " +
        //                " MIA.MiaCode,MIA.MiaName,U.UserName " +
        //                " FROM tblInvoice IV " +
        //                " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
        //                " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
        //                " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
        //                " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
        //                " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
        //                " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
        //        //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
        //               " WHERE IV.DelivaryInvoiceNo in (" + invNo.Trim() + ")   ";
        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
        public DataTable MarketPickinReport(string SC, int MarketID, int ManufacID, DateTime InvDate, string parameter)
        {
            string query = @" SELECT tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblSubInvoiceMaster I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId='" + SC + "' and p.ManufacId='" + ManufacID + "' and InvoiceDate='" + InvDate + "' and tblMarket.MarketId='" + MarketID + "' " + parameter + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize ";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DelivaryInvoiceDetailDataForReport(string invNo)
        {

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,IVD.BatchNo,IVD.PackSize as BonusQuantity,IVD.DeliveryQuantity as Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.DeliveryTotalPrice as TotalPrice,IVD.DeliveryTotalPriceVatAmount as TotalPriceVatAmount,(IVD.DeliveryDiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount as NetAmount,IV.InvoiceId  " +
                            "   FROM dbo.tblSubInvoiceDetail IVD LEFT JOIN dbo.tblSubInvoiceMaster IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblSubInvoiceMaster I ON I.InvoiceId = IV.InvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                      " WHERE IV.DelivaryInvoiceNo in (" + invNo.Trim() + ") and IVD.DeliveryStatus IN ('Full','Partial') ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DelivaryInvoiceMainDataForReport(string invNo)
        {
            string query = @"SELECT IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.DelivaryInvoiceNo as InvoiceNo,IV.UpdateDate as InvoiceDate,IV.OrderNo,IV.OrderDate,IV.DeliveryTpTotal as TpTotal,IV.DeliveryTpVat as TpVat,(IV.DeliveryTpDiscount+isnull(IV.DelivarySpecialAmount,0))TpDiscount,IV.DeliveryTpGrandTotal as TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,CC.CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,CM.MarketName as UserName " +
                        " FROM tblSubInvoiceMaster IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE IV.DelivaryInvoiceNo in (" + invNo.Trim() + ")   ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public bool DCStockInDAL(DCStockNew aDcStockNew)
        {
            string query = @"INSERT INTO dbo.tblSubDepotStoreFreeze " +
       "  ( SubDCStoreId , " +
         "    SDStoreFreezeId, " +
         "    InvoiceDetailId, " +
         "    StorageLocation , " +
         "    ProductCode , " +
         "    ProductName , " +
         "    PackSize , " +
         "    BatchNo , " +
         "    TotalQuantity , " +
         "    ExpDate , " +
         "    ReceiveDate , " +
         "    ChalanNo , " +
         "    ChalanDate , " +
          "   SubDepotId , " +
         "    StockQty , " +
         "    DamageQty , " +
         "    StockRcvDate , " +
         "    ReqId , " +
         "    ReqChildId , " +
         "    StockInTransfarId, " +
         "    StockCondition,SChalanDetailsId " +
        "   ) " +
        "   VALUES  ( '" + aDcStockNew.DCStoreId + "' , " +
        "     '" + aDcStockNew.DCStoreFreezeId + "' , " +
        "     '" + aDcStockNew.InvoiceDetailId + "' , " +
        "     '" + aDcStockNew.StorageLocation + "' , " +
        "     '" + aDcStockNew.ProductCode + "' ,  " +
        "    '" + aDcStockNew.ProductName + "' , " +
        "    '" + aDcStockNew.PackSize + "' , " +
        "    '" + aDcStockNew.BatchNo + "' , " +
         "    '" + aDcStockNew.TotalQuantity + "' ,  " +
         "    '" + aDcStockNew.ExpDate + "' ,  " +
        "     '" + aDcStockNew.ReceiveDate + "' , " +
        "    '" + aDcStockNew.ChalanNo + "' , " +
        "    '" + aDcStockNew.ChalanDate + "', " +
        "    '" + aDcStockNew.ComUnitId + "' , " +
         "    '" + aDcStockNew.StockQty + "', " +
         "    '" + aDcStockNew.DamageQty + "' , " +
         "   '" + aDcStockNew.StockRcvDate + "' , " +
         "   '" + (aDcStockNew.ReqId ?? Convert.DBNull) + "' , " +
        "    '" + (aDcStockNew.ReqChildId ?? Convert.DBNull) + "', " +
       "      '" + (aDcStockNew.StockInTransfarId ?? Convert.DBNull) + "',  " +
       "      'ReturnStock','" + (aDcStockNew.ChalanDetailsId ?? Convert.DBNull) + "'  " +
      "     )";
            return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
        }
        public DataTable IntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,
CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,
I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode
,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount
FROM dbo.tblInvoice I WITH(nolock)
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL  and CU.ComUnitId='" + districtId.Trim() + "' and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable IntransitReportDAl(DateTime fromDate, DateTime toDate)
        {
            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,
CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,
I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode
,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount
FROM dbo.tblInvoice I WITH(nolock)
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL    and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public int DeleteInvoice(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderID", Invoice));
            return aCommonInternalDal.RunStoreProcedure("sp_Deletenvoice", aSqlParameterList, "SSIDB");
        }
        public DataTable LoadOrderExistsDal(string orderid)
        {
            string query = @"SELECT * FROM tblSubInvoiceMaster
            WHERE tblSubInvoiceMaster.OrderId='" + orderid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }

}
