using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Policy;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.MAIN_FUNCTION;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class ReturnInvoiceDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        DB_Manager aDbManager = new DB_Manager();

        private static SqlParameter Parameter(string name, object value)
        {
            return new SqlParameter(name, SInventorySql.DbValue(value));
        }

        private static string BuildInClause(string columnName, string rawValues, string parameterPrefix, List<SqlParameter> parameters)
        {
            var values = (rawValues ?? string.Empty)
                .Split(',')
                .Select(value => value.Trim().Trim('\'', '"'))
                .Where(value => value.Length > 0)
                .ToList();

            if (values.Count == 0)
            {
                return "1=0";
            }

            var parameterNames = new List<string>();
            for (int i = 0; i < values.Count; i++)
            {
                string parameterName = "@" + parameterPrefix + i;
                parameterNames.Add(parameterName);
                parameters.Add(Parameter(parameterName, values[i]));
            }

            return columnName + " IN (" + string.Join(",", parameterNames) + ")";
        }

        private static string BuildSelectedInvoiceFilter(string rawParameter, List<SqlParameter> parameters)
        {
            if (string.IsNullOrWhiteSpace(rawParameter))
            {
                return string.Empty;
            }

            int openIndex = rawParameter.IndexOf('(');
            int closeIndex = rawParameter.LastIndexOf(')');
            if (openIndex < 0 || closeIndex <= openIndex)
            {
                return string.Empty;
            }

            string rawValues = rawParameter.Substring(openIndex + 1, closeIndex - openIndex - 1);
            return " AND " + BuildInClause("I.InvoiceId", rawValues, "SelectedInvoiceId", parameters);
        }

        private static bool Execute(string query, params SqlParameter[] parameters)
        {
            return SInventorySql.Execute(query, parameters.ToList());
        }

        private static DataTable GetDataTable(string query, params SqlParameter[] parameters)
        {
            return SInventorySql.GetDataTable(query, parameters.ToList());
        }
        public void CreateConnection_DAL()
        {
            aDbManager.CreateConnection("SalesDisDB_New3");
        }
        public void CloseAllConnection_DAL()
        {
            aDbManager.CloseConnection();
        }
        public int SaveFullInvoice(string InvoiceNo, string updateby, string updatedate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            return aCommonInternalDal.RunStoreProcedure("sp_DeliveryConformationFull", aSqlParameterList, "SSIDB");
        }
        public int SubdeportSaveFullInvoice(string InvoiceNo, string updateby, string updatedate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            return aCommonInternalDal.RunStoreProcedure("sp_SubdeportDeliveryConformationFull", aSqlParameterList, "SSIDB");
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
        public int SubSaveRejectInvoice(string InvoiceNo, string updateby, string updatedate, string reason)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            aSqlParameterList.Add(new SqlParameter("@ReturnReason", reason));
            return aCommonInternalDal.RunStoreProcedure("sp_SubDeportDeliveryConformationReject", aSqlParameterList, "SSIDB");
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

        public bool SaveDataForInvoice(Invoice aInvoice,string invoiceid,string subinvoiceid)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnInvoice
                (ReturnInvoiceId, ReturnInvoiceNo, ReturnInvoiceDate, ISSubdeport, CreateBy, CreateDate,
                 OrderNo, OrderDate, CustomerMasterId, ComUnitId, MiaId, PaymentTypeId, TpTotal, TpDiscount,
                 Types, InvoiceNo, TpVat, TpGrandTotal, UserId, OrderId, TotalSpecialAmount, OldTradePolicy,
                 ProductOffer, Remarks, MIACode, MIAName, MarketCode, MarketName, AreaCode, DisCode, FEName,
                 RegionCode, DZSMName, FixedCustomer, DeliveryPersonName, DeliveryPersonPhNo, InvoiceId,
                 IsSalesReturnWithoutOrder, SubInvoiceId)
                VALUES
                (@ReturnInvoiceId, @ReturnInvoiceNo, @ReturnInvoiceDate, @ISSubdeport, @CreateBy, @CreateDate,
                 @OrderNo, @OrderDate, @CustomerMasterId, @ComUnitId, @MiaId, @PaymentTypeId, @TpTotal, @TpDiscount,
                 @Types, @InvoiceNo, @TpVat, @TpGrandTotal, @UserId, @OrderId, @TotalSpecialAmount, @OldTradePolicy,
                 @ProductOffer, @Remarks, @MIACode, @MIAName, @MarketCode, @MarketName, @AreaCode, @DisCode, @FEName,
                 @RegionCode, @DZSMName, @FixedCustomer, @DeliveryPersonName, @DeliveryPersonPhNo, @InvoiceId,
                 @IsSalesReturnWithoutOrder, @SubInvoiceId)";

            return Execute(insertQuery,
                Parameter("@ReturnInvoiceId", aInvoice.InvoiceId),
                Parameter("@ReturnInvoiceNo", aInvoice.InvoiceNo),
                Parameter("@ReturnInvoiceDate", aInvoice.InvoiceDate),
                Parameter("@ISSubdeport", aInvoice.Issubdeport),
                Parameter("@CreateBy", aInvoice.createBy),
                Parameter("@CreateDate", aInvoice.Createdate),
                Parameter("@OrderNo", aInvoice.OrderNo),
                Parameter("@OrderDate", aInvoice.OrderDate),
                Parameter("@CustomerMasterId", aInvoice.CustomerMasterId),
                Parameter("@ComUnitId", aInvoice.ComUnitId),
                Parameter("@MiaId", aInvoice.MiaId),
                Parameter("@PaymentTypeId", aInvoice.PaymentTypeId),
                Parameter("@TpTotal", aInvoice.TpTotal),
                Parameter("@TpDiscount", aInvoice.TpDiscount),
                Parameter("@Types", aInvoice.Type),
                Parameter("@InvoiceNo", aInvoice.DpMob),
                Parameter("@TpVat", aInvoice.TpVat),
                Parameter("@TpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@UserId", aInvoice.UserId),
                Parameter("@OrderId", aInvoice.OrderId),
                Parameter("@TotalSpecialAmount", aInvoice.TotalSpecialAmount),
                Parameter("@OldTradePolicy", aInvoice.OldTradePolicy),
                Parameter("@ProductOffer", aInvoice.ProductOffer),
                Parameter("@Remarks", aInvoice.Remarks),
                Parameter("@MIACode", aInvoice.MIACode),
                Parameter("@MIAName", aInvoice.MIAName),
                Parameter("@MarketCode", aInvoice.MarketCode),
                Parameter("@MarketName", aInvoice.MarketName),
                Parameter("@AreaCode", aInvoice.AreaCode),
                Parameter("@DisCode", aInvoice.DisCode),
                Parameter("@FEName", aInvoice.FEName),
                Parameter("@RegionCode", aInvoice.RegionCode),
                Parameter("@DZSMName", aInvoice.DZSMName),
                Parameter("@FixedCustomer", aInvoice.FixedCustomer),
                Parameter("@DeliveryPersonName", aInvoice.DpNAme),
                Parameter("@DeliveryPersonPhNo", aInvoice.DpMob),
                Parameter("@InvoiceId", invoiceid),
                Parameter("@IsSalesReturnWithoutOrder", aInvoice.IsSalesReturnWithoutOrder),
                Parameter("@SubInvoiceId", subinvoiceid));
        }
        public bool SaveDataForReturnInvoice(Invoice aInvoice)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnInvoice
                (ReturnInvoiceId, ReturnInvoiceNo, ReturnInvoiceDate, OrderNo, OrderDate, CustomerMasterId,
                 ComUnitId, MiaId, PaymentTypeId, TpTotal, TpDiscount, TpVat, TpGrandTotal, UserId, OrderId,
                 InvoiceId, TotalSpecialAmount)
                VALUES
                (@ReturnInvoiceId, @ReturnInvoiceNo, @ReturnInvoiceDate, @OrderNo, @OrderDate, @CustomerMasterId,
                 @ComUnitId, @MiaId, @PaymentTypeId, @TpTotal, @TpDiscount, @TpVat, @TpGrandTotal, @UserId, @OrderId,
                 @InvoiceId, @TotalSpecialAmount)";

            return Execute(insertQuery,
                Parameter("@ReturnInvoiceId", aInvoice.InvoiceId),
                Parameter("@ReturnInvoiceNo", aInvoice.InvoiceNo),
                Parameter("@ReturnInvoiceDate", aInvoice.InvoiceDate),
                Parameter("@OrderNo", aInvoice.OrderNo),
                Parameter("@OrderDate", aInvoice.OrderDate),
                Parameter("@CustomerMasterId", aInvoice.CustomerMasterId),
                Parameter("@ComUnitId", aInvoice.ComUnitId),
                Parameter("@MiaId", aInvoice.MiaId),
                Parameter("@PaymentTypeId", aInvoice.PaymentTypeId),
                Parameter("@TpTotal", aInvoice.TpTotal),
                Parameter("@TpDiscount", aInvoice.TpDiscount),
                Parameter("@TpVat", aInvoice.TpVat),
                Parameter("@TpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@UserId", aInvoice.UserId),
                Parameter("@OrderId", aInvoice.OrderId),
                Parameter("@InvoiceId", aInvoice.ReturnInvoiceid),
                Parameter("@TotalSpecialAmount", aInvoice.TotalSpecialAmount));
        }

        public bool SaveDataForInvoiceDetails(InvoiceDetail aInvoiceDetail)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnInvoiceDetail
                (ReturnInvoiceDetailId, ProductCode, ProductName, PackSize, BatchNo, ReceiveDate, ExpDate,
                 CostPrice, UnitPrice, UnitVatAmount, Quantity, BonusQuantity, TotalQuantity, TotalPrice,
                 TotalPriceVatAmount, DiscountPercentage, DiscountAmount, NetAmount, ReturnInvoiceId, DCStoreId,
                 OrderDetailsId, Campaign, SpecialAmount, InvoiceDetailId)
                VALUES
                (@ReturnInvoiceDetailId, @ProductCode, @ProductName, @PackSize, @BatchNo, @ReceiveDate, @ExpDate,
                 @CostPrice, @UnitPrice, @UnitVatAmount, @Quantity, @BonusQuantity, @TotalQuantity, @TotalPrice,
                 @TotalPriceVatAmount, @DiscountPercentage, @DiscountAmount, @NetAmount, @ReturnInvoiceId, @DCStoreId,
                 @OrderDetailsId, @Campaign, @SpecialAmount, @InvoiceDetailId)";

            return Execute(insertQuery, ReturnInvoiceDetailParameters(aInvoiceDetail).ToArray());
        }
        public bool SaveDataForReturnInvoiceDetails(InvoiceDetail aInvoiceDetail)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnInvoiceDetail
                (ReturnInvoiceDetailId, ProductCode, ProductName, PackSize, BatchNo, ReceiveDate, ExpDate,
                 CostPrice, UnitPrice, UnitVatAmount, Quantity, BonusQuantity, TotalQuantity, TotalPrice,
                 TotalPriceVatAmount, DiscountPercentage, DiscountAmount, NetAmount, ReturnInvoiceId, DCStoreId,
                 OrderDetailsId, InvoiceDetailId, SpecialAmount)
                VALUES
                (@ReturnInvoiceDetailId, @ProductCode, @ProductName, @PackSize, @BatchNo, @ReceiveDate, @ExpDate,
                 @CostPrice, @UnitPrice, @UnitVatAmount, @Quantity, @BonusQuantity, @TotalQuantity, @TotalPrice,
                 @TotalPriceVatAmount, @DiscountPercentage, @DiscountAmount, @NetAmount, @ReturnInvoiceId, @DCStoreId,
                 @OrderDetailsId, @InvoiceDetailId, @SpecialAmount)";

            return Execute(insertQuery, ReturnInvoiceDetailParameters(aInvoiceDetail).ToArray());
        }
        public bool SaveDataForReturnAmount(ReturnAmountDAO amountDao)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnAmount (CustomerId, ReturnInvoiceId, Amount)
                                        VALUES (@CustomerId, @ReturnInvoiceId, @Amount)";

            return Execute(insertQuery,
                Parameter("@CustomerId", amountDao.CustomerId),
                Parameter("@ReturnInvoiceId", amountDao.InvoiceId),
                Parameter("@Amount", amountDao.Amount));
        }
        public bool DeleteData(string  id)
        {
            const string deleteQuery = @"DELETE FROM dbo.tblReturnInvoice WHERE ReturnInvoiceId = @ReturnInvoiceId;
DELETE FROM dbo.tblReturnInvoiceDetail WHERE ReturnInvoiceId = @ReturnInvoiceId;
DELETE FROM dbo.tblReturnAmount WHERE ReturnInvoiceId = @ReturnInvoiceId;
DELETE FROM tblDCStoreFreeze
WHERE ReturnInvoiceDetailId IN (SELECT ReturnInvoiceDetailId FROM dbo.tblReturnInvoiceDetail WHERE ReturnInvoiceId = @ReturnInvoiceId);";

            return Execute(deleteQuery, Parameter("@ReturnInvoiceId", id));
        }
        public bool HasProductcode(DCStore aReceive)
        {
            const string query = "select * from tblDCStock where ProductCode = @ProductCode and BatchNo = @BatchNo";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                Parameter("@ProductCode", aReceive.ProductCode),
                Parameter("@BatchNo", aReceive.BatchNo)
            });
        }

        public DataTable LoadInvoiceView()
        {
            string query = @"SELECT *  FROM tblInvoice ";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }
        public DataTable LoadInvoicedetail(string invoicedetailId)
        {
            const string query = @"SELECT * FROM dbo.tblInvoiceDetail WHERE InvoiceDetailId = @InvoiceDetailId";
            return GetDataTable(query, Parameter("@InvoiceDetailId", invoicedetailId));
        }

        public DataTable ProductInfoDAL(string comUnitId, string productCode)
        {

             string query = @"   SELECT P.ProductCode,(P.ProductName+':'+P.PackSize) as  ProductName,P.PackSize, " +
            " ISNULL(UP.UnitPrice,0) AS UnitPrice,ISNULL(VCS.TotalQty,0) AS StockQty, " +
            " (UP.VATAmountPerUnit) AS VAT, ISNULL(UP.CostPrice,0) AS CostPrice, " +
            " ISNULL(UP.VATPercentage,0)VATPercentage  FROM " +
            " dbo.tblProduct P  " +
            " LEFT JOIN dbo.tblUnitPrice UP ON P.ProductCode = UP.ProductCode  " +
            " LEFT JOIN (select ComUnitId,ProductCode, TotalQty from View_DCStoreCurrentStock WHERE ComUnitId = @ComUnitId AND ProductCode = @ProductCode) VCS  " +
            " ON P.ProductCode=VCS.ProductCode   where P.ProductCode = @ProductCode ";
            return GetDataTable(query,
                Parameter("@ComUnitId", comUnitId.Trim()),
                Parameter("@ProductCode", productCode.Trim()));
        }

        public DataTable ProductInfoDAL_Old(string comUnitId, string productCode)
        {

            string query = @"   SELECT P.ProductCode,(P.ProductName+':'+P.PackSize) as  ProductName,P.PackSize, " +
           " ISNULL(UP.UnitPrice,0) AS UnitPrice,ISNULL(VCS.TotalQty,0) AS StockQty, " +
           " isnull( UP.VATPercentage,0) AS VAT, ISNULL(UP.CostPrice,0) AS CostPrice, " +
           " ISNULL(UP.VATPercentage,0)VATPercentage  FROM " +
           " dbo.tblProduct P  " +
           " inner JOIN dbo.tblUnitPrice_Old UP ON P.ProductCode = UP.ProductCode  " +
           " LEFT JOIN (select ComUnitId,ProductCode, TotalQty from View_DCStoreCurrentStock WHERE ComUnitId = @ComUnitId AND ProductCode = @ProductCode) VCS  " +
           " ON P.ProductCode=VCS.ProductCode   where P.ProductCode = @ProductCode ";
            return GetDataTable(query,
                Parameter("@ComUnitId", comUnitId.Trim()),
                Parameter("@ProductCode", productCode.Trim()));
        }
        public DataTable ProductFocBonusQtyDAL(string invoiceDate, string productCode,int Qty)
        {

            string query = @"select * from [dbo].[tblFocMaster] M " +
                           " inner join [dbo].[tblFocDetails] D on M.FocId=D.FocId " +
                           " where ProductCode = @ProductCode and (@InvoiceDate between [FocFromDate] and [FocToDate]) " +
                           " and IsActive=1 and (@Qty between [RangeFrom] and RangeTo) ";
            return GetDataTable(query,
                Parameter("@ProductCode", productCode.Trim()),
                Parameter("@InvoiceDate", invoiceDate.Trim()),
                Parameter("@Qty", Qty));
        }
        public DataTable LoadProductQty(string orderid, string productCode)
        {
            string query = @"SELECT SUM(Quantity)Qty FROM dbo.tblOrder
LEFT JOIN dbo.tblOrderDetail ON dbo.tblOrder.OrderId = dbo.tblOrderDetail.OrderId WHERE dbo.tblOrder.OrderId = @OrderId AND ProductCode = @ProductCode";

            return GetDataTable(query,
                Parameter("@OrderId", orderid),
                Parameter("@ProductCode", productCode));
        }
        public DataTable LoadReuturnInvoice(string fromdate, string todate,string dcid)
        {
            const string query = @"SELECT *,ReturnInvoiceNo,OrderNo,TpTotal FROM dbo.tblReturnInvoice WHERE (ReturnInvoiceDate BETWEEN @FromDate AND @ToDate) AND ComUnitId = @ComUnitId";
            return GetDataTable(query,
                Parameter("@FromDate", fromdate),
                Parameter("@ToDate", todate),
                Parameter("@ComUnitId", dcid));
        }

        public DataTable LoadSalesReuturnInvoice(string fromdate, string todate, string dcid)
        {
            string query = @"SELECT *,ReturnInvoiceNo,OrderNo,TpTotal FROM dbo.tblReturnInvoice
            LEFT JOIN dbo.tblCustMaster ON tblCustMaster.CustomerMasterId = tblReturnInvoice.CustomerMasterId
            WHERE (ReturnInvoiceDate BETWEEN @FromDate AND @ToDate) AND tblReturnInvoice.ComUnitId = @ComUnitId AND IsSalesReturnWithoutOrder ='No order' ";

            return GetDataTable(query,
                Parameter("@FromDate", fromdate),
                Parameter("@ToDate", todate),
                Parameter("@ComUnitId", dcid));
        }

        public DataTable LoadSalesReuturnInvoiceSub(string fromdate, string todate, string dcid)
        {
            string query = @"SELECT *,ReturnInvoiceNo,OrderNo,TpTotal FROM dbo.tblReturnInvoice
            LEFT JOIN dbo.tblCustMaster ON tblCustMaster.CustomerMasterId = tblReturnInvoice.CustomerMasterId
            WHERE ISSubdeport=1 and  (ReturnInvoiceDate BETWEEN @FromDate AND @ToDate) AND tblReturnInvoice.ComUnitId = @ComUnitId AND IsSalesReturnWithoutOrder ='No order' ";

            return GetDataTable(query,
                Parameter("@FromDate", fromdate),
                Parameter("@ToDate", todate),
                Parameter("@ComUnitId", dcid));
        }
       
        public DataTable LoadProduct(string productId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT * FROM tblProduct where ProductCode = @ProductCode";
            aDataTableEmpInfo = GetDataTable(query, Parameter("@ProductCode", productId.Trim()));
            return aDataTableEmpInfo;
        }
        public DataTable LoadCustomerMaster(string CustomerMasterId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"  SELECT  top 1 emp.EmpInfoId, mio.MioId,c.TerritoryId, mio.SAP_MIOCode, emp.empMasterCode +' : '+emp.EmpName EmpName,  REPLACE(c.AreaName, '''', '') AreaName,  c.* FROM dbo.View_CustomerMaster   c 
 left join tblMIOInfo mio on mio.TerritoryId=c.TerritoryId 
left join tblEmpGeneralInfo emp on emp.EmpInfoId=mio.EmployeeId
  where c.CustomerCode = @CustomerCode and mio.SAP_MIOCode is not null";
            aDataTableEmpInfo = GetDataTable(query, Parameter("@CustomerCode", CustomerMasterId.Trim()));
            return aDataTableEmpInfo;
        }


        public DataTable getInvo(string CustomerMasterId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT ReturnInvoiceNo FROM dbo.tblReturnInvoice WHERE ReturnInvoiceId = @ReturnInvoiceId";
            aDataTableEmpInfo = GetDataTable(query, Parameter("@ReturnInvoiceId", CustomerMasterId.Trim()));
            return aDataTableEmpInfo;
        }
        public DataTable DCStockQuantity(DCStore aReceive)
        {
            const string query = "select * from tblDCStock where ProductCode = @ProductCode and BatchNo = @BatchNo";
            return GetDataTable(query,
                Parameter("@ProductCode", aReceive.ProductCode),
                Parameter("@BatchNo", aReceive.BatchNo));
        }
        public DataTable DCInfoWithDCId(string dcstoreId)
        {
            const string query = "SELECT * FROM dbo.tblDCStore WHERE DCStoreId = @DCStoreId";
            return GetDataTable(query, Parameter("@DCStoreId", dcstoreId));
        }
        public DataTable SuvDCInfoWithDCId(string dcstoreId)
        {
            const string query = "SELECT * FROM dbo.tblSubDepotStoreFreeze WHERE SubDCStoreId = @SubDCStoreId";
            return GetDataTable(query, Parameter("@SubDCStoreId", dcstoreId));
        }
        public DataTable SuvDCInfoWithDCId2(string dcstoreId)
        {
            const string query = "SELECT * FROM dbo.tblSubDepotStore WHERE SubDCStoreId = @SubDCStoreId";
            return GetDataTable(query, Parameter("@SubDCStoreId", dcstoreId));
        }
        public void UpdateDCStoreQuantity(string dCStoreId, decimal Quantity)
        {
            const string updateQuery = @"UPDATE tblDCStore SET StockQty = @StockQty WHERE DCStoreId = @DCStoreId";
            Execute(updateQuery,
                Parameter("@StockQty", Quantity),
                Parameter("@DCStoreId", dCStoreId.Trim()));
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
            const string updateQuery = @"UPDATE tblReturnInvoice
SET DeliveryTpTotal = @DeliveryTpTotal,
    DeliveryTpDiscount = @DeliveryTpDiscount,
    DeliveryTpVat = @DeliveryTpVat,
    DeliveryTpGrandTotal = @DeliveryTpGrandTotal,
    DeliveryInvoiceStatus = @DeliveryInvoiceStatus,
    DelivaryInvoiceNo = @DelivaryInvoiceNo,
    DelivarySpecialAmount = @DelivarySpecialAmount,
    UpdateBy = @UpdateBy,
    UpdateDate = @UpdateDate
WHERE InvoiceId = @InvoiceId";
            Execute(updateQuery,
                Parameter("@DeliveryTpTotal", aInvoice.TpTotal),
                Parameter("@DeliveryTpDiscount", aInvoice.TpDiscount),
                Parameter("@DeliveryTpVat", aInvoice.TpVat),
                Parameter("@DeliveryTpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@DeliveryInvoiceStatus", aInvoice.DeliveryInvoiceStatus),
                Parameter("@DelivaryInvoiceNo", aInvoice.DelivaryInvoiceNo),
                Parameter("@DelivarySpecialAmount", aInvoice.TotalSpecialAmount),
                Parameter("@UpdateBy", aInvoice.UpdateBy),
                Parameter("@UpdateDate", aInvoice.InvoiceDate),
                Parameter("@InvoiceId", aInvoice.InvoiceId));
        }
        public void UpdateInvoiceDetail(InvoiceDetail  aInvoiceDetail)
        {
            const string updateQuery = @"UPDATE tblReturnInvoiceDetail
SET DeliveryQuantity = @DeliveryQuantity,
    DeliveryBonusQuantity = @DeliveryBonusQuantity,
    DeliveryTotalQuantity = @DeliveryTotalQuantity,
    DeliveryTotalPrice = @DeliveryTotalPrice,
    DeliveryTotalPriceVatAmount = @DeliveryTotalPriceVatAmount,
    DeliveryDiscountPercentage = @DeliveryDiscountPercentage,
    DeliveryDiscountAmount = @DeliveryDiscountAmount,
    DeliveryNetAmount = @DeliveryNetAmount,
    DeliveryStatus = @DeliveryStatus,
    DelivarySpecialAmount = @DelivarySpecialAmount,
    ReturnReason = @ReturnReason
WHERE InvoiceDetailId = @InvoiceDetailId";
            Execute(updateQuery,
                Parameter("@DeliveryQuantity", aInvoiceDetail.Quantity),
                Parameter("@DeliveryBonusQuantity", aInvoiceDetail.BonusQuantity),
                Parameter("@DeliveryTotalQuantity", aInvoiceDetail.TotalQuantity),
                Parameter("@DeliveryTotalPrice", aInvoiceDetail.TotalPrice),
                Parameter("@DeliveryTotalPriceVatAmount", aInvoiceDetail.TotalPriceVatAmount),
                Parameter("@DeliveryDiscountPercentage", aInvoiceDetail.DiscountPercentage),
                Parameter("@DeliveryDiscountAmount", aInvoiceDetail.DiscountAmount),
                Parameter("@DeliveryNetAmount", aInvoiceDetail.NetAmount),
                Parameter("@DeliveryStatus", aInvoiceDetail.DeliveryStatus),
                Parameter("@DelivarySpecialAmount", aInvoiceDetail.SpecialAmount),
                Parameter("@ReturnReason", aInvoiceDetail.ReturnReason),
                Parameter("@InvoiceDetailId", aInvoiceDetail.InvoiceDetailId));
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
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }
        public DataTable DiscountofProduct(string productCode,string qty)
        {
            const string query = @"SELECT * FROM dbo.tblProductDiscount WHERE ProductCode = @ProductCode AND (@Qty BETWEEN MinQty AND MaxQty) AND Status='Active'";
            return GetDataTable(query,
                Parameter("@ProductCode", productCode.Trim()),
                Parameter("@Qty", qty.Trim()));
        }
        public DataTable BatchWiseProductQty(string productCode, string comUnitId)
        {
            const string query = @"SELECT * FROM tblDCStore WHERE ProductCode = @ProductCode AND ComUnitId = @ComUnitId AND StockQty>0 ORDER BY ExpDate ASC";
            return GetDataTable(query,
                Parameter("@ProductCode", productCode.Trim()),
                Parameter("@ComUnitId", comUnitId.Trim()));
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
            string query = @"    SELECT   CellNo,(Addrees2 + '[' +  Address +']')		 as Address	,* 				
FROM tblInvoice I
INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
            ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
 INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode     
where I.ComUnitId = @ComUnitId and tblD.ManufacId = @ManufacId and tblMarket.MarketId = @MarketId and InvoiceDate = @InvoiceDate order by OrderNo";


            return GetDataTable(query,
                Parameter("@ComUnitId", Dcid),
                Parameter("@ManufacId", ManufId),
                Parameter("@MarketId", marketid),
                Parameter("@InvoiceDate", invDate));
        }
        public DataTable ReturnInvoiceMainDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
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
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable ReturnInvoiceDetailDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.ReturnInvoiceNo as InvoiceNo,IV.ReturnInvoiceId as InvoiceId,IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.ReturnInvoiceId " +
                             " FROM dbo.tblReturnInvoiceDetail IVD LEFT JOIN dbo.tblReturnInvoice IV ON IVD.ReturnInvoiceId = IV.ReturnInvoiceId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }


        public DataTable AllInvoiceForPrintingDAL(string ComUnitId, DateTime InvoiceDate)
        {
            string query = @"SELECT * FROM dbo.tblInvoice I LEFT JOIN dbo.tblCustMaster C ON I.CustomerMasterId = C.CustomerMasterId "+
                            " WHERE I.ComUnitId = @ComUnitId AND I.InvoiceDate = @InvoiceDate ORDER BY I.InvoiceId DESC" ;

            return GetDataTable(query,
                Parameter("@ComUnitId", ComUnitId.Trim()),
                Parameter("@InvoiceDate", InvoiceDate));
        }

        public DataTable InvoiceForDCPickingDAL(string ComUnitId, DateTime InvoiceDate)
        {
            string query = @"SELECT * FROM dbo.tblInvoice I LEFT JOIN dbo.tblCustMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
                            " WHERE I.ComUnitId = @ComUnitId AND I.InvoiceDate = @InvoiceDate AND I.InvoiceNo NOT IN (SELECT InvoiceNo FROM dbo.tblDCPickingDetail)  ORDER BY I.InvoiceId DESC";

            return GetDataTable(query,
                Parameter("@ComUnitId", ComUnitId.Trim()),
                Parameter("@InvoiceDate", InvoiceDate));
        }


        public bool DcPickingSaveDAL(DCPicking aDcPicking)
        {
            const string insertQuery = @"INSERT INTO dbo.tblDCPicking (DCPicId, DCPicNo, DCPicDate, ComUnitId, AreaId)
                                        VALUES (@DCPicId, @DCPicNo, @DCPicDate, @ComUnitId, @AreaId)";
            return Execute(insertQuery,
                Parameter("@DCPicId", aDcPicking.DCPicId),
                Parameter("@DCPicNo", aDcPicking.DCPicNo),
                Parameter("@DCPicDate", aDcPicking.DCPicDate),
                Parameter("@ComUnitId", aDcPicking.ComUnitId),
                Parameter("@AreaId", aDcPicking.AreaId));
        }
        public bool UpdateOrder(string  status,string id)
        {
            const string updateQuery = @"UPDATE dbo.tblOrderDetail SET Status = @Status WHERE OrderDetailId = @OrderDetailId";
            return Execute(updateQuery,
                Parameter("@Status", status),
                Parameter("@OrderDetailId", id));
        }

        public bool DcPickingDetailSaveDAL(DCPickingDetail aDcPickingDetail)
        {
            const string insertQuery = @"INSERT INTO dbo.tblDCPickingDetail (DCPicDetailId, InvoiceNo, DCPicId)
                                        VALUES (@DCPicDetailId, @InvoiceNo, @DCPicId)";

            return Execute(insertQuery,
                Parameter("@DCPicDetailId", aDcPickingDetail.DCPicDetailId),
                Parameter("@InvoiceNo", aDcPickingDetail.InvoiceNo),
                Parameter("@DCPicId", aDcPickingDetail.DCPicId));
        }


        public DataTable AllPickingForReportList(string comUnitId,DateTime pickDate)
        {
            const string query = @"select * from tblDCPicking where DCPicDate = @DCPicDate and ComUnitId = @ComUnitId order by DCPicId desc";
            return GetDataTable(query,
                Parameter("@DCPicDate", pickDate),
                Parameter("@ComUnitId", comUnitId.Trim()));
        }


        public DataTable DCPickingReportMainDataDAL(string dcPickingNo)
        {
            string query = @"SELECT P.DCPicNo,P.DCPicDate,CU.ComUnitCode,CU.ComUnitName,CU.Address,A.AreaCode,A.AreaName FROM tblDCPicking P LEFT JOIN dbo.tblCompanyUnit CU ON P.ComUnitId = CU.ComUnitId LEFT JOIN dbo.tblArea A ON P.AreaId=A.AreaId " +
                            " WHERE P.DCPicNo = @DCPicNo";
            return GetDataTable(query, Parameter("@DCPicNo", dcPickingNo.Trim()));
        }

        public DataTable  DCPickingReportDetailDataDAL(string dcPickingNo)
        {

            string query = @"SELECT IND.ProductCode,IND.ProductName,IND.BatchNo, SUM(TotalQuantity) AS TotalPickQty FROM dbo.tblInvoiceDetail IND LEFT JOIN dbo.tblInvoice I ON IND.InvoiceId = I.InvoiceId  "+
                            " WHERE I.InvoiceNo IN (SELECT InvoiceNo FROM dbo.tblDCPickingDetail LEFT JOIN dbo.tblDCPicking "+
                            " ON dbo.tblDCPickingDetail.DCPicId = dbo.tblDCPicking.DCPicId WHERE tblDCPicking.DCPicNo = @DCPicNo)  " +
                            " GROUP BY IND.ProductCode,IND.ProductName,IND.BatchNo ";
            return GetDataTable(query, Parameter("@DCPicNo", dcPickingNo.Trim()));
        }

        public void AreaDropDownLoad(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT A.* FROM dbo.tblArea A LEFT JOIN dbo.tblDistrict D ON A.DistrictId = D.DistrictId "+
                                " LEFT JOIN dbo.tblCompanyUnit C ON D.ComUnitId = C.ComUnitId "+
                                " WHERE C.ComUnitId = @ComUnitId";
            BindDropDown(dropDownList, GetDataTable(query, Parameter("@ComUnitId", comUnitId.Trim())), "AreaName", "AreaId");

        }
        public DataTable InvoiceNoCount(string comUnitId)
        {
            //string query = @"SELECT count(InvoiceNo) CountNo FROM dbo.tblInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";

            string query = @"SELECT  (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,10,11)) AS INT)),0)+1) CountNo FROM dbo.tblInvoice WHERE ComUnitId = @ComUnitId";
            return GetDataTable(query, Parameter("@ComUnitId", comUnitId.Trim()));
        }
        public DataTable ReturnInvoiceNoCount(string comUnitId)
        {
            string query = @"SELECT count(ReturnInvoiceNo) CountNo FROM dbo.tblReturnInvoice WHERE ComUnitId = @ComUnitId";
            return GetDataTable(query, Parameter("@ComUnitId", comUnitId.Trim()));
        }
        public DataTable DcPickingNoCount(string comUnitId)
        {
            string query = @"SELECT count(DCPicNo) CountNo FROM dbo.tblDCPicking WHERE ComUnitId = @ComUnitId";
            return GetDataTable(query, Parameter("@ComUnitId", comUnitId.Trim()));
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
                       " WHERE  I.ComUnitId = @ComUnitId and p.ManufacId = @ManufacId and InvoiceDate = @InvoiceDate and tblMarket.MarketId = @MarketId GROUP BY tblMarket.MarketName,M.MiaName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize ";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return GetDataTable(query,
                Parameter("@ComUnitId", SC),
                Parameter("@ManufacId", ManufacID),
                Parameter("@InvoiceDate", InvDate),
                Parameter("@MarketId", MarketID));
        }




        public DataTable DeliveryInvoiceMainDataForReportDAL(string invNo)
        {
            var parameters = new List<SqlParameter>();
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
               
                       " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DeliveryInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable DeliveryInvoiceDetailDataForReportDAL(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.DeliveryQuantity AS Quantity,IVD.UnitPrice, IVD.UnitVatAmount,IVD.DeliveryTotalPrice,IVD.DeliveryTotalPriceVatAmount,(IVD.DeliveryDiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount AS NetAmount,IV.InvoiceId   " +
                            " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                            " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DeliveryInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable ProformaReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {

            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,
CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode
,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,I.Types as IntransitDay
,I.MarketName
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
        where CU.ComUnitId = @ComUnitId and I.InvoiceDate between @FromDate and @ToDate 		UNION ALL SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,Campaign AS ProductOffer,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay ,I.MarketName FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where CU.ComUnitId = @ComUnitId and I.InvoiceDate between @FromDate and @ToDate";

            
            
            return GetDataTable(query,
                Parameter("@ComUnitId", districtId.Trim()),
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate));
        }
        public DataTable ProformaReportDAl( DateTime fromDate, DateTime toDate)
        {

            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,
CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode
,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,I.Types as IntransitDay
,I.MarketName
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
       where I.InvoiceDate between @FromDate and @ToDate 	UNION ALL SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,Campaign AS ProductOffer, CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay ,I.MarketName FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where I.InvoiceDate between @FromDate and @ToDate";


            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate));
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable InvoiceMainDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.FixedCustomer ,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,IV.Types as CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,CM.MarketName as UserName " +
                        " FROM tblInvoice IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInClause("IV.InvoiceNo", invNo, "InvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
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
            var parameters = new List<SqlParameter>();
            //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
            //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
            //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
            //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
            //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,IVD.BatchNo,IVD.PackSize as BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId  " +
                            "   FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                      " WHERE " + BuildInClause("IV.InvoiceNo", invNo, "InvNo", parameters);

            return SInventorySql.GetDataTable(query, parameters);
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable ReturnReturnInvoiceMainDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
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
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable ReturnReturnInvoiceDetailDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.ReturnInvoiceId as  InvoiceId  " +
                            "   FROM dbo.tblReturnInvoiceDetail IVD LEFT JOIN dbo.tblReturnInvoice IV ON IVD.ReturnInvoiceId = IV.ReturnInvoiceId " +
                     "  INNER JOIN dbo.tblReturnInvoice I ON I.ReturnInvoiceId = IV.ReturnInvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.ReturnInvoiceNo='" + invNo.Trim() + "'";
                      " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
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
            var parameters = new List<SqlParameter>
            {
                Parameter("@ComUnitId", SC),
                Parameter("@ManufacId", ManufacID),
                Parameter("@InvoiceDate", InvDate),
                Parameter("@MarketId", MarketID)
            };
            string invoiceFilter = BuildSelectedInvoiceFilter(parameter, parameters);
            string query = @" SELECT tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId = @ComUnitId and p.ManufacId = @ManufacId and InvoiceDate = @InvoiceDate and tblMarket.MarketId = @MarketId " + invoiceFilter + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize ";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable DelivaryInvoiceDetailDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,IVD.BatchNo,IVD.PackSize as BonusQuantity,IVD.DeliveryQuantity as Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.DeliveryTotalPrice as TotalPrice,IVD.DeliveryTotalPriceVatAmount as TotalPriceVatAmount,(IVD.DeliveryDiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount as NetAmount,IV.InvoiceId  " +
                            "   FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                      " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DeliveryInvNo", parameters) + " and IVD.DeliveryStatus IN ('Full','Partial') ";

            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable DelivaryInvoiceMainDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.DelivaryInvoiceNo as InvoiceNo,IV.UpdateDate as InvoiceDate,IV.OrderNo,IV.OrderDate,IV.DeliveryTpTotal as TpTotal,IV.DeliveryTpVat as TpVat,(IV.DeliveryTpDiscount+isnull(IV.DelivarySpecialAmount,0))TpDiscount,IV.DeliveryTpGrandTotal as TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,CC.CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,CM.MarketName as UserName " +
                        " FROM tblInvoice IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DeliveryInvNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public bool DCStockInDAL(DCStockNew aDcStockNew, string ReturnInvoiceDetailId)
        {
            const string query = @"INSERT INTO dbo.tblDCStoreFreeze
                (DCStoreId, DCStoreFreezeId, InvoiceDetailId, StorageLocation, ProductCode, ProductName, PackSize,
                 BatchNo, TotalQuantity, ExpDate, ReceiveDate, ChalanNo, ChalanDate, ComUnitId, StockQty, DamageQty,
                 StockRcvDate, ReqId, ReqChildId, StockInTransfarId, StockCondition, ChalanDetailsId, ReturnInvoiceDetailId)
                VALUES
                (@DCStoreId, @DCStoreFreezeId, @InvoiceDetailId, @StorageLocation, @ProductCode, @ProductName, @PackSize,
                 @BatchNo, @TotalQuantity, @ExpDate, @ReceiveDate, @ChalanNo, @ChalanDate, @ComUnitId, @StockQty, @DamageQty,
                 @StockRcvDate, @ReqId, @ReqChildId, @StockInTransfarId, 'ReturnStock', @ChalanDetailsId, @ReturnInvoiceDetailId)";
            var parameters = DcStockFreezeParameters(aDcStockNew);
            parameters.Add(Parameter("@ReturnInvoiceDetailId", ReturnInvoiceDetailId));
            return SInventorySql.Execute(query, parameters);
        }
        public bool SubDCStockInDAL(DCStockNew aDcStockNew, string ReturnInvoiceDetailId)
        {
            const string query = @"INSERT INTO dbo.tblSubDepotStoreFreeze
                (SubDCStoreId, SDStoreFreezeId, InvoiceDetailId, StorageLocation, ProductCode, ProductName, PackSize,
                 BatchNo, TotalQuantity, ExpDate, ReceiveDate, ChalanNo, ChalanDate, SubDepotId, StockQty, DamageQty,
                 StockRcvDate, ReqId, ReqChildId, StockInTransfarId, StockCondition, SChalanDetailsId, ReturnInvoiceDetailId)
                VALUES
                (@DCStoreId, @DCStoreFreezeId, @InvoiceDetailId, @StorageLocation, @ProductCode, @ProductName, @PackSize,
                 @BatchNo, @TotalQuantity, @ExpDate, @ReceiveDate, @ChalanNo, @ChalanDate, @ComUnitId, @StockQty, @DamageQty,
                 @StockRcvDate, @ReqId, @ReqChildId, @StockInTransfarId, 'ReturnStock', @ChalanDetailsId, @ReturnInvoiceDetailId)";
            var parameters = DcStockFreezeParameters(aDcStockNew);
            parameters.Add(Parameter("@ReturnInvoiceDetailId", ReturnInvoiceDetailId));
            return SInventorySql.Execute(query, parameters);
        }

        public DataTable MArketwiseIntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate, string market)
        {
            string query = @"SELECT @FromDate as fromdate, @ToDate as todate, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and I.AreaCode = @Market and CU.ComUnitId = @ComUnitId and I.InvoiceDate between @FromDate and @ToDate UNION ALL SELECT @FromDate as fromdate, @ToDate as todate, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblSubInvoiceMaster I WITH(nolock) INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and I.AreaCode = @Market and CU.ComUnitId = @ComUnitId and I.InvoiceDate between @FromDate and @ToDate ORDER BY DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) DESC";
            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate),
                Parameter("@Market", market),
                Parameter("@ComUnitId", districtId.Trim()));
        }
        public DataTable IntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            string query =
                       @"SELECT @FromDate as fromdate, @ToDate as todate, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and CU.ComUnitId = @ComUnitId and I.InvoiceDate between @FromDate and @ToDate UNION ALL SELECT @FromDate as fromdate, @ToDate as todate, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblSubInvoiceMaster I WITH(nolock) INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and CU.ComUnitId = @ComUnitId and I.InvoiceDate between @FromDate and @ToDate";
            
         

            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate),
                Parameter("@ComUnitId", districtId.Trim()));
        }
        public DataTable IntransitReportDAl(DateTime fromDate, DateTime toDate)
        {
            string query =
                       @"SELECT @FromDate as fromdate, @ToDate as todate, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and I.InvoiceDate between @FromDate and @ToDate UNION ALL SELECT @FromDate as fromdate, @ToDate as todate, CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblSubInvoiceMaster I WITH(nolock) INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and I.InvoiceDate between @FromDate and @ToDate";


            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate));
        }
        public DataTable LoadInvoicebyOrder(string orderno)
        {
            string query =
                       @"SELECT * FROM dbo.tblInvoice
                        LEFT JOIN dbo.tblOrder ON tblOrder.OrderId = tblInvoice.OrderId
                        WHERE InvoiceId NOT IN (SELECT InvoiceId FROM dbo.tblReturnInvoice) AND (DelivaryInvoiceNo IS NOT NULL) and InvoiceNo = @InvoiceNo";


            return GetDataTable(query, Parameter("@InvoiceNo", orderno));
        }
        public DataTable LoadSubInvoicebyOrder(string orderno)
        {
            string query =
                @"SELECT * FROM dbo.tblSubInvoiceMaster WHERE 
InvoiceId NOT IN (SELECT SubInvoiceId FROM dbo.tblReturnInvoice) AND (DelivaryInvoiceNo IS NOT NULL) and

InvoiceNo = @InvoiceNo";


            return GetDataTable(query, Parameter("@InvoiceNo", orderno));
        }
        public int DeleteInvoice(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderID", Invoice));
            return aCommonInternalDal.RunStoreProcedure("sp_Deletenvoice", aSqlParameterList, "SSIDB");
        }

        public DataTable GetProduct()
        {
            string query = @"SELECT PD.ProductId,PD.ProductCode,PD.ProductName,UnitPrice FROM tblProduct AS PD
                             LEFT JOIN tblUnitPrice on PD.ProductCode = tblUnitPrice.ProductCode
                             WHERE tblUnitPrice.IsActive = 1";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }
        public DataTable GetRectinProduct()
        {
            string query = @"SELECT PD.ProductId,PD.ProductCode,PD.ProductName,UnitPrice FROM tblProduct AS PD
                             LEFT JOIN tblUnitPrice on PD.ProductCode = tblUnitPrice.ProductCode
                       WHERE PD.GroupId=1     ";
            // WHERE PD.ProductCode='ARD01' 
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }

        public bool SaveOrderDetail(OrderInfoDetail aOrderListDetailDao)
        {
            const string insertQuery = @"INSERT INTO tblSalesReturnDetail
                (ProductId, ProductCode, ProductName, Quantity, TradePrice, TotalTradePrice, OrderId)
                VALUES (@ProductId, @ProductCode, @ProductName, @Quantity, @TradePrice, @TotalTradePrice, @OrderId)";
            return Execute(insertQuery,
                Parameter("@ProductId", aOrderListDetailDao.ProductId),
                Parameter("@ProductCode", aOrderListDetailDao.ProductCode),
                Parameter("@ProductName", aOrderListDetailDao.ProductName),
                Parameter("@Quantity", aOrderListDetailDao.Quantity),
                Parameter("@TradePrice", aOrderListDetailDao.TradePrice),
                Parameter("@TotalTradePrice", aOrderListDetailDao.TotalTradePrice),
                Parameter("@OrderId", aOrderListDetailDao.OrderId));
        }

        public bool DeleteTempSalesReturnInfo()
        {
            string query = @"truncate table tblSalesReturnDetail";
            aCommonInternalDal.DeleteDataByDeleteCommand(query, "SSIDB");

            string query2 = @"truncate table tblTempSalesReturnOrder";
            return aCommonInternalDal.DeleteDataByDeleteCommand(query2, "SSIDB");
        }

        public int OrderManualId()
        {
            DataTable aDataTable = new DataTable();
            string query = @"SELECT (isnull(MAX(SUBSTRING(OrderCode,5,15)),0)+1) as PKMaxNo FROM tblTempSalesReturnOrder WHERE IsManual='True'";
            return Convert.ToInt32(SInventorySql.GetDataTable(query, new List<SqlParameter>()).Rows[0][0].ToString());

        }

        public bool SaveOrderMaster(OrderInfoMaster aListMasterDao)
        {
            const string insertQuery = @"INSERT INTO tblTempSalesReturnOrder
                (OrderCode, TerritoryCode, ComUnitId, ComUnitCode, ComUnitName, MIOCode, MIOName, ManufacId,
                 CustomerCode, CustomerName, GrossValue, SubmissionDate, IsManual, IsInvoice)
                VALUES
                (@OrderCode, @TerritoryCode, @ComUnitId, @ComUnitCode, @ComUnitName, @MIOCode, @MIOName, @ManufacId,
                 @CustomerCode, @CustomerName, @GrossValue, @SubmissionDate, @IsManual, 'False')";
            return Execute(insertQuery,
                Parameter("@OrderCode", aListMasterDao.OrderCode),
                Parameter("@TerritoryCode", aListMasterDao.teritory),
                Parameter("@ComUnitId", aListMasterDao.ComUnitId),
                Parameter("@ComUnitCode", aListMasterDao.ComUnitCode),
                Parameter("@ComUnitName", aListMasterDao.ComUnitName),
                Parameter("@MIOCode", aListMasterDao.MIOCode),
                Parameter("@MIOName", aListMasterDao.MIOName),
                Parameter("@ManufacId", aListMasterDao.ManufacId),
                Parameter("@CustomerCode", aListMasterDao.CustomerCode),
                Parameter("@CustomerName", aListMasterDao.CustomerName),
                Parameter("@GrossValue", aListMasterDao.GrossValue),
                Parameter("@SubmissionDate", aListMasterDao.SubmissionDate),
                Parameter("@IsManual", aListMasterDao.IsManual));
        }


        public DataTable LoadOrderWithDetail(string orderid)
        {
            string query = @"SELECT * FROM tblTempSalesReturnOrder
            LEFT JOIN dbo.tblCustMaster ON tblTempSalesReturnOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON tblTempSalesReturnOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            LEFT JOIN dbo.tblMarket ON dbo.tblCustMaster.MarketId = dbo.tblMarket.MarketId
            LEFT JOIN tblSalesReturnDetail ON tblTempSalesReturnOrder.OrderId=tblSalesReturnDetail.OrderId
            inner JOIN dbo.tblProduct ON tblSalesReturnDetail.ProductId = dbo.tblProduct.ProductId            
            WHERE tblTempSalesReturnOrder.OrderId = @OrderId";

            return GetDataTable(query, Parameter("@OrderId", orderid));
        }

        private static List<SqlParameter> ReturnInvoiceDetailParameters(InvoiceDetail detail)
        {
            return new List<SqlParameter>
            {
                Parameter("@ReturnInvoiceDetailId", detail.InvoiceDetailId),
                Parameter("@ProductCode", detail.ProductCode),
                Parameter("@ProductName", detail.ProductName),
                Parameter("@PackSize", detail.PackSize),
                Parameter("@BatchNo", detail.BatchNo),
                Parameter("@ReceiveDate", detail.ReceiveDate),
                Parameter("@ExpDate", detail.ExpDate),
                Parameter("@CostPrice", detail.CostPrice),
                Parameter("@UnitPrice", detail.UnitPrice),
                Parameter("@UnitVatAmount", detail.UnitVatAmount),
                Parameter("@Quantity", detail.Quantity),
                Parameter("@BonusQuantity", detail.BonusQuantity),
                Parameter("@TotalQuantity", detail.TotalQuantity),
                Parameter("@TotalPrice", detail.TotalPrice),
                Parameter("@TotalPriceVatAmount", detail.TotalPriceVatAmount),
                Parameter("@DiscountPercentage", detail.DiscountPercentage),
                Parameter("@DiscountAmount", detail.DiscountAmount),
                Parameter("@NetAmount", detail.NetAmount),
                Parameter("@ReturnInvoiceId", detail.InvoiceId),
                Parameter("@DCStoreId", detail.DCStoreId),
                Parameter("@OrderDetailsId", detail.OrderDetailsId),
                Parameter("@Campaign", detail.Campaign),
                Parameter("@SpecialAmount", detail.SpecialAmount),
                Parameter("@InvoiceDetailId", detail.ReturnDetailsId)
            };
        }

        private static List<SqlParameter> DcStockFreezeParameters(DCStockNew stock)
        {
            return new List<SqlParameter>
            {
                Parameter("@DCStoreId", stock.DCStoreId),
                Parameter("@DCStoreFreezeId", stock.DCStoreFreezeId),
                Parameter("@InvoiceDetailId", stock.InvoiceDetailId),
                Parameter("@StorageLocation", stock.StorageLocation),
                Parameter("@ProductCode", stock.ProductCode),
                Parameter("@ProductName", stock.ProductName),
                Parameter("@PackSize", stock.PackSize),
                Parameter("@BatchNo", stock.BatchNo),
                Parameter("@TotalQuantity", stock.TotalQuantity),
                Parameter("@ExpDate", stock.ExpDate),
                Parameter("@ReceiveDate", stock.ReceiveDate),
                Parameter("@ChalanNo", stock.ChalanNo),
                Parameter("@ChalanDate", stock.ChalanDate),
                Parameter("@ComUnitId", stock.ComUnitId),
                Parameter("@StockQty", stock.StockQty),
                Parameter("@DamageQty", stock.DamageQty),
                Parameter("@StockRcvDate", stock.StockRcvDate),
                Parameter("@ReqId", stock.ReqId),
                Parameter("@ReqChildId", stock.ReqChildId),
                Parameter("@StockInTransfarId", stock.StockInTransfarId),
                Parameter("@ChalanDetailsId", stock.ChalanDetailsId)
            };
        }

        private static void BindDropDown(DropDownList dropDownList, DataTable dataTable, string textField, string valueField)
        {
            dropDownList.DataSource = dataTable;
            dropDownList.DataTextField = textField;
            dropDownList.DataValueField = valueField;
            dropDownList.DataBind();
        }
    }



}
