using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Security.Cryptography;
using System.Security.Policy;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAL.MAIN_FUNCTION;
using Library.DAO.SInventory_Entities;
using Dapper;

namespace Library.DAL.SInventory_DAL
{
    public class SalesReturnDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        private DataAccessManager  accessManager = new DataAccessManager ();

        DB_Manager aDbManager = new DB_Manager();

        private static SqlParameter Parameter(string name, object value)
        {
            return new SqlParameter(name, SInventorySql.DbValue(value));
        }

        private static DataTable GetDataTable(string query, params SqlParameter[] parameters)
        {
            return SInventorySql.GetDataTable(query, parameters.ToList());
        }

        private static bool Execute(string query, params SqlParameter[] parameters)
        {
            return SInventorySql.Execute(query, parameters.ToList());
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

        private static string BuildInvoiceNoFilter(string rawParameter, string columnName, string parameterPrefix, List<SqlParameter> parameters)
        {
            if (string.IsNullOrWhiteSpace(rawParameter))
            {
                return "1=0";
            }

            string filter = rawParameter.Trim();
            int batchIndex = filter.IndexOf("BatchNo", StringComparison.OrdinalIgnoreCase);
            if (batchIndex >= 0)
            {
                int firstQuote = filter.IndexOf('\'', batchIndex);
                int secondQuote = firstQuote >= 0 ? filter.IndexOf('\'', firstQuote + 1) : -1;
                string batchNo = secondQuote > firstQuote ? filter.Substring(firstQuote + 1, secondQuote - firstQuote - 1) : filter;
                parameters.Add(Parameter("@InvoiceBatchNo", batchNo));
                return columnName + " IN (SELECT InvoiceNo FROM dbo.tblInvoiceBatch LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = tblInvoiceBatch.InvoiceId WHERE BatchNo = @InvoiceBatchNo)";
            }

            int openIndex = filter.IndexOf('(');
            int closeIndex = filter.LastIndexOf(')');
            if (openIndex >= 0 && closeIndex > openIndex)
            {
                filter = filter.Substring(openIndex + 1, closeIndex - openIndex - 1);
            }

            return BuildInClause(columnName, filter, parameterPrefix, parameters);
        }

        public DataTable MoneyReceiptInfo(string pram)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm", pram));

                DataTable dt = accessManager.GetDataTable("sp_Get_MoneyReceiptReportList", aSqlParameters);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
         

        public DataTable MoneyReceiptAfterPaymentInfo(string pram)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm", pram));

                DataTable dt = accessManager.GetDataTable("sp_Get_MoneyReceiptReportAfterPaymentList", aSqlParameters);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetNewReceiveableDAl(string districtId, string fromDate, string toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@districtId", districtId));
                aSqlParameterlist.Add(new SqlParameter("@fromDate", fromDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_Get_NewReceiveableList", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetNewReceiveableforInvoiceDAl(string districtId, string fromDate, string toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@districtId", districtId));
                aSqlParameterlist.Add(new SqlParameter("@fromDate", fromDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_Get_NewReceiveableListforInvoice", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetMonthlyInventoryReportDAl(string districtId, string fromDate, string toDate, string ProTypId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
               

                aSqlParameters.Add(new SqlParameter("@fromDate", fromDate));
                aSqlParameters.Add(new SqlParameter("@toDate", toDate));
                aSqlParameters.Add(new SqlParameter("@CiD", districtId));
                aSqlParameters.Add(new SqlParameter("@ProTypId", ProTypId));

                DataTable dt = accessManager.GetDataTable("sp_Get_MonthlyInventoryReport", aSqlParameters);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable GetPendingSalesConfirmationReportDAl(string districtId, string fromDate, string toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@districtId", districtId));
                //aSqlParameterlist.Add(new SqlParameter("@fromDate", fromDate));
                //aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_GET_PendingSalesConfirmationReport", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
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
            return aCommonInternalDal.RunStoreProcedure("sp_DeliveryConformationFull_New", aSqlParameterList, "SSIDB");
        }

        public int SavePaymentConformationFull(string InvoiceNo, string updateby, string updatedate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            return aCommonInternalDal.RunStoreProcedure("sp_PaymentConformationFull", aSqlParameterList, "SSIDB");
        }


        public int UP_LoadingSummaryInvoice(string InvoiceNo, string updateby, string status)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceId", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@LoadingSummaryStatus", status));
            return aCommonInternalDal.RunStoreProcedure("sp_UP_LoadingSummary", aSqlParameterList, "SSIDB");
        }


        public int UP_LoadingSummaryInvoice_Complete(string InvoiceNo, string updateby, string status)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceId", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@LoadingSummaryStatus", status));
            return aCommonInternalDal.RunStoreProcedure("sp_UP_LoadingSummaryFinal", aSqlParameterList, "SSIDB");
        }

        public int SaveFullInvoiceOldData(string InvoiceNo, string updateby, string updatedate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceNo", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UpdateBy", updateby));
            aSqlParameterList.Add(new SqlParameter("@UpdateDate", updatedate));
            return aCommonInternalDal.RunStoreProcedure("sp_DeliveryConformationFull_OldData", aSqlParameterList, "SSIDB");
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

        public int SaveProformaInvoice(string InvoiceNo, string updateby)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderCodeInPut", InvoiceNo));
            aSqlParameterList.Add(new SqlParameter("@UserId", updateby));

            return aCommonInternalDal.RunStoreProcedure("sp_AutoInvoiceGeneration", aSqlParameterList, "SSIDB");
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

        public bool SaveDataForInvoice(Invoice aInvoice)
        {
            const string insertQuery = @"INSERT INTO dbo.tblInvoice
                (InvoiceNo, CustomerType, AdjustInvoiceNo_ReturnInvoiceNo, CreateDate, AdjustAmount, IsAdjustInvoice,
                 ReceivableAmount, InvoiceDate, OrderNo, OrderDate, CustomerMasterId, ComUnitId, MiaId, PaymentTypeId,
                 TpTotal, TpDiscount, Types, TpVat, TpGrandTotal, UserId, OrderId, TotalSpecialAmount, OldTradePolicy,
                 ProductOffer, Inv_DANameId, Remarks, MIACode, MIAName, MarketCode, MarketName, AreaCode, DisCode,
                 FEName, RegionCode, DZSMName, FixedCustomer, DeliveryPersonName, DeliveryPersonPhNo)
                VALUES
                (@InvoiceNo, @CustomerType, @AdjustInvoiceNo_ReturnInvoiceNo, @CreateDate, @AdjustAmount, @IsAdjustInvoice,
                 @ReceivableAmount, @InvoiceDate, @OrderNo, @OrderDate, @CustomerMasterId, @ComUnitId, @MiaId, @PaymentTypeId,
                 @TpTotal, @TpDiscount, @Types, @TpVat, @TpGrandTotal, @UserId, @OrderId, @TotalSpecialAmount, @OldTradePolicy,
                 @ProductOffer, @Inv_DANameId, @Remarks, @MIACode, @MIAName, @MarketCode, @MarketName, @AreaCode, @DisCode,
                 @FEName, @RegionCode, @DZSMName, @FixedCustomer, @DeliveryPersonName, @DeliveryPersonPhNo)";

            return Execute(insertQuery,
                Parameter("@InvoiceNo", aInvoice.InvoiceNo),
                Parameter("@CustomerType", aInvoice.cusType),
                Parameter("@AdjustInvoiceNo_ReturnInvoiceNo", aInvoice.AdjustInvoiceNo_ReturnInvoiceNo),
                Parameter("@CreateDate", aInvoice.Createdate),
                Parameter("@AdjustAmount", aInvoice.AdjustAmount),
                Parameter("@IsAdjustInvoice", aInvoice.IsAdjustInvoice),
                Parameter("@ReceivableAmount", aInvoice.ReceivableAmount),
                Parameter("@InvoiceDate", aInvoice.InvoiceDate),
                Parameter("@OrderNo", aInvoice.OrderNo),
                Parameter("@OrderDate", aInvoice.OrderDate),
                Parameter("@CustomerMasterId", aInvoice.CustomerMasterId),
                Parameter("@ComUnitId", aInvoice.ComUnitId),
                Parameter("@MiaId", aInvoice.MiaId),
                Parameter("@PaymentTypeId", aInvoice.PaymentTypeId),
                Parameter("@TpTotal", aInvoice.TpTotal),
                Parameter("@TpDiscount", aInvoice.TpDiscount),
                Parameter("@Types", aInvoice.Type),
                Parameter("@TpVat", aInvoice.TpVat),
                Parameter("@TpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@UserId", aInvoice.UserId),
                Parameter("@OrderId", aInvoice.OrderId),
                Parameter("@TotalSpecialAmount", aInvoice.TotalSpecialAmount),
                Parameter("@OldTradePolicy", aInvoice.OldTradePolicy),
                Parameter("@ProductOffer", aInvoice.ProductOffer),
                Parameter("@Inv_DANameId", aInvoice.Inv_DANameId),
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
                Parameter("@DeliveryPersonPhNo", aInvoice.DpMob));
        }

        public bool SaveDataForInvoiceBatch(string invoiceid,string batchno)
        {
            const string insertQuery = @"INSERT INTO dbo.tblInvoiceBatch (BatchNo, Date, InvoiceId)
VALUES (@BatchNo, GETDATE(), @InvoiceId)";

            return Execute(insertQuery,
                Parameter("@BatchNo", batchno),
                Parameter("@InvoiceId", invoiceid));
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
            const string insertQuery = @"INSERT INTO dbo.tblInvoiceDetail
                (ProductCode, ProductName, PackSize, BatchNo, ReceiveDate, ExpDate, CostPrice, UnitPrice,
                 UnitVatAmount, Quantity, BonusQuantity, TotalQuantity, TotalPrice, TotalPriceVatAmount,
                 DiscountPercentage, DiscountAmount, NetAmount, InvoiceId, DCStoreId, OrderDetailsId,
                 Campaign, ISGiftProduct, IsCampaignProduct, SpecialAmount, AdjustmentAmount)
                VALUES
                (@ProductCode, @ProductName, @PackSize, @BatchNo, @ReceiveDate, @ExpDate, @CostPrice, @UnitPrice,
                 @UnitVatAmount, @Quantity, @BonusQuantity, @TotalQuantity, @TotalPrice, @TotalPriceVatAmount,
                 @DiscountPercentage, @DiscountAmount, @NetAmount, @InvoiceId, @DCStoreId, @OrderDetailsId,
                 'N', @ISGiftProduct, @IsCampaignProduct, @SpecialAmount, @AdjustmentAmount)";

            return Execute(insertQuery,
                InvoiceDetailParameters(aInvoiceDetail, includeReturnFields: false).ToArray());
        }

        public bool SaveDataForReturnInvoiceDetails(InvoiceDetail aInvoiceDetail)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnInvoiceDetail
                (ReuturnInvoiceDetailId, ProductCode, ProductName, PackSize, BatchNo, ReceiveDate, ExpDate,
                 CostPrice, UnitPrice, UnitVatAmount, Quantity, BonusQuantity, TotalQuantity, TotalPrice,
                 TotalPriceVatAmount, DiscountPercentage, DiscountAmount, NetAmount, ReturnInvoiceId, DCStoreId,
                 OrderDetailsId, InvoiceDetailId, SpecialAmount)
                VALUES
                (@ReuturnInvoiceDetailId, @ProductCode, @ProductName, @PackSize, @BatchNo, @ReceiveDate, @ExpDate,
                 @CostPrice, @UnitPrice, @UnitVatAmount, @Quantity, @BonusQuantity, @TotalQuantity, @TotalPrice,
                 @TotalPriceVatAmount, @DiscountPercentage, @DiscountAmount, @NetAmount, @InvoiceId, @DCStoreId,
                 @OrderDetailsId, @ReturnDetailsId, @SpecialAmount)";

            return Execute(insertQuery,
                InvoiceDetailParameters(aInvoiceDetail, includeReturnFields: true).ToArray());
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
       
        public DataTable LoadProduct(string productId)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT * FROM tblProduct where ProductCode = @ProductCode";
            aDataTableEmpInfo = GetDataTable(query, Parameter("@ProductCode", productId.Trim()));
            return aDataTableEmpInfo;
        }
        public DataTable LoadCustomerMaster(string OrderNO)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT   * FROM dbo.View_OrderCustomerInfo ord 
WHERE ord.OrderCode = @OrderCode";
            aDataTableEmpInfo = GetDataTable(query, Parameter("@OrderCode", OrderNO.Trim()));
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

        public DataTable DCInfoWithDCId(string dcstoreId, SqlTransaction transaction)
        {
            const string query = "SELECT * FROM dbo.tblDCStore WHERE DCStoreId = @DCStoreId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter> { Parameter("@DCStoreId", dcstoreId) }, transaction);
        }
        public void UpdateDCStoreQuantity(string dCStoreId, decimal Quantity)
        {
            const string updateQuery = @"UPDATE tblDCStore SET StockQty = @StockQty WHERE DCStoreId = @DCStoreId";
            Execute(updateQuery,
                Parameter("@StockQty", Quantity),
                Parameter("@DCStoreId", dCStoreId.Trim()));
        }

        public DataTable Isgift(int dcstoreId)
        {
            const string query = "select ISGiftProduct from tblOrderDetail where OrderDetailId = @OrderDetailId";
            return GetDataTable(query, Parameter("@OrderDetailId", dcstoreId));
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
            const string updateQuery = @"UPDATE tblInvoice SET DeliveryTpTotal = @DeliveryTpTotal, DeliveryTpDiscount = @DeliveryTpDiscount, DeliveryTpVat = @DeliveryTpVat, UpdateDatetime = @UpdateDatetime,
DeliveryTpGrandTotal = @DeliveryTpGrandTotal, DeliveryInvoiceStatus = @DeliveryInvoiceStatus, DelivaryInvoiceNo = @DelivaryInvoiceNo, DelivarySpecialAmount = @DelivarySpecialAmount, UpdateBy = @UpdateBy, UpdateDate = @UpdateDate
WHERE InvoiceId = @InvoiceId";
            Execute(updateQuery,
                Parameter("@DeliveryTpTotal", aInvoice.TpTotal),
                Parameter("@DeliveryTpDiscount", aInvoice.TpDiscount),
                Parameter("@DeliveryTpVat", aInvoice.TpVat),
                Parameter("@UpdateDatetime", aInvoice.updatetime),
                Parameter("@DeliveryTpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@DeliveryInvoiceStatus", aInvoice.DeliveryInvoiceStatus),
                Parameter("@DelivaryInvoiceNo", "DEL-" + aInvoice.DelivaryInvoiceNo),
                Parameter("@DelivarySpecialAmount", aInvoice.TotalSpecialAmount),
                Parameter("@UpdateBy", aInvoice.UpdateBy),
                Parameter("@UpdateDate", aInvoice.InvoiceDate),
                Parameter("@InvoiceId", aInvoice.InvoiceId));
        }


        public void PaymentUpdateInvoice(Invoice aInvoice)
        {
            const string updateQuery = @"UPDATE tblInvoice SET sndReturnTpTotal = @TpTotal, sndReturnTpDiscount = @TpDiscount, sndReturnTpVat = @TpVat,
sndReturnTpGrandTotal = @TpGrandTotal, sndReturnInvoiceStatus = @InvoiceStatus, SndReturnInvoiceNo = @SndReturnInvoiceNo, SndReturnPaymentBy = @PaymentBy, SndReturnPaymentDate = @PaymentDate
WHERE InvoiceId = @InvoiceId";
            Execute(updateQuery,
                Parameter("@TpTotal", aInvoice.TpTotal),
                Parameter("@TpDiscount", aInvoice.TpDiscount),
                Parameter("@TpVat", aInvoice.TpVat),
                Parameter("@TpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@InvoiceStatus", aInvoice.DeliveryInvoiceStatus),
                Parameter("@SndReturnInvoiceNo", "SRN-" + aInvoice.DelivaryInvoiceNo),
                Parameter("@PaymentBy", aInvoice.UpdateBy),
                Parameter("@PaymentDate", aInvoice.InvoiceDate),
                Parameter("@InvoiceId", aInvoice.InvoiceId));
        }

        public void PaymentUpdateInvoice(Invoice aInvoice, SqlTransaction transaction)
        {
            const string updateQuery = @"UPDATE tblInvoice SET sndReturnTpTotal = @TpTotal, sndReturnTpDiscount = @TpDiscount, sndReturnTpVat = @TpVat,
sndReturnTpGrandTotal = @TpGrandTotal, sndReturnInvoiceStatus = @InvoiceStatus, SndReturnInvoiceNo = @SndReturnInvoiceNo, SndReturnPaymentBy = @PaymentBy, SndReturnPaymentDate = @PaymentDate
WHERE InvoiceId = @InvoiceId";
            SInventorySql.Execute(updateQuery, new List<SqlParameter>
            {
                Parameter("@TpTotal", aInvoice.TpTotal),
                Parameter("@TpDiscount", aInvoice.TpDiscount),
                Parameter("@TpVat", aInvoice.TpVat),
                Parameter("@TpGrandTotal", aInvoice.TpGrandTotal),
                Parameter("@InvoiceStatus", aInvoice.DeliveryInvoiceStatus),
                Parameter("@SndReturnInvoiceNo", "SRN-" + aInvoice.DelivaryInvoiceNo),
                Parameter("@PaymentBy", aInvoice.UpdateBy),
                Parameter("@PaymentDate", aInvoice.InvoiceDate),
                Parameter("@InvoiceId", aInvoice.InvoiceId)
            }, transaction);
        }
        public void UpdateInvoiceDetail(InvoiceDetail  aInvoiceDetail)
        {
            const string updateQuery = @"UPDATE tblInvoiceDetail SET DeliveryQuantity = @Quantity, DeliveryBonusQuantity = @BonusQuantity, DeliveryTotalQuantity = @TotalQuantity,
DeliveryTotalPrice = @TotalPrice, DeliveryTotalPriceVatAmount = @TotalPriceVatAmount, DeliveryDiscountPercentage = @DiscountPercentage, DeliveryDiscountAmount = @DiscountAmount, DeliveryNetAmount = @NetAmount,
DeliveryStatus = @DeliveryStatus, DelivarySpecialAmount = @SpecialAmount, ReturnReason = @ReturnReason WHERE InvoiceDetailId = @InvoiceDetailId";
            Execute(updateQuery,
                Parameter("@Quantity", aInvoiceDetail.Quantity),
                Parameter("@BonusQuantity", aInvoiceDetail.BonusQuantity),
                Parameter("@TotalQuantity", aInvoiceDetail.TotalQuantity),
                Parameter("@TotalPrice", aInvoiceDetail.TotalPrice),
                Parameter("@TotalPriceVatAmount", aInvoiceDetail.TotalPriceVatAmount),
                Parameter("@DiscountPercentage", aInvoiceDetail.DiscountPercentage),
                Parameter("@DiscountAmount", aInvoiceDetail.DiscountAmount),
                Parameter("@NetAmount", aInvoiceDetail.NetAmount),
                Parameter("@DeliveryStatus", aInvoiceDetail.DeliveryStatus),
                Parameter("@SpecialAmount", aInvoiceDetail.SpecialAmount),
                Parameter("@ReturnReason", aInvoiceDetail.ReturnReason),
                Parameter("@InvoiceDetailId", aInvoiceDetail.InvoiceDetailId));
        }


        public void PaymentUpdateInvoiceDetail(InvoiceDetail aInvoiceDetail)
        {
            const string updateQuery = @"UPDATE tblInvoiceDetail SET PaymentQuantity = @Quantity, PaymentBonusQuantity = @BonusQuantity, PaymentTotalQuantity = @TotalQuantity,
PaymentTotalPrice = @TotalPrice, PaymentTotalPriceVatAmount = @TotalPriceVatAmount, PaymentDiscountPercentage = @DiscountPercentage, PaymentDiscountAmount = @DiscountAmount,
PaymentNetAmount = @NetAmount, PaymentStatus = @PaymentStatus, PaymentReturnReason = @PaymentReturnReason WHERE InvoiceDetailId = @InvoiceDetailId";
            Execute(updateQuery,
                Parameter("@Quantity", aInvoiceDetail.Quantity),
                Parameter("@BonusQuantity", aInvoiceDetail.BonusQuantity),
                Parameter("@TotalQuantity", aInvoiceDetail.TotalQuantity),
                Parameter("@TotalPrice", aInvoiceDetail.TotalPrice),
                Parameter("@TotalPriceVatAmount", aInvoiceDetail.TotalPriceVatAmount),
                Parameter("@DiscountPercentage", aInvoiceDetail.DiscountPercentage),
                Parameter("@DiscountAmount", aInvoiceDetail.DiscountAmount),
                Parameter("@NetAmount", aInvoiceDetail.NetAmount),
                Parameter("@PaymentStatus", aInvoiceDetail.DeliveryStatus),
                Parameter("@PaymentReturnReason", aInvoiceDetail.ReturnReason),
                Parameter("@InvoiceDetailId", aInvoiceDetail.InvoiceDetailId));
        }
        //public void InsertInvoiceDetailReturn(InvoiceDetail aInvoiceDetail)
        //{
        //    string insertQuery = @"
        //INSERT INTO tblInvoiceDetailReturn (
        //    InvoiceId,
        //    InvoiceDetailId,
        //    sndReturnQuantity,
        //    sndReturnBonusQuantity,
        //    sndReturnTotalQuantity,
        //    sndReturnTotalPrice,
        //    sndReturnTotalPriceVatAmount,
        //    sndReturnDiscountPercentage,
        //    sndReturnDiscountAmount,
        //    sndReturnNetAmount,
        //    sndReturnStatus,
        //    sndReturnReason
        //)
        //VALUES (
        //    '" + aInvoiceDetail.InvoiceId + @"',
        //    '" + aInvoiceDetail.InvoiceDetailId + @"',
        //    '" + aInvoiceDetail.Quantity + @"',
        //    '" + aInvoiceDetail.BonusQuantity + @"',
        //    '" + aInvoiceDetail.TotalQuantity + @"',
        //    '" + aInvoiceDetail.TotalPrice + @"',
        //    '" + aInvoiceDetail.TotalPriceVatAmount + @"',
        //    '" + aInvoiceDetail.DiscountPercentage + @"',
        //    '" + aInvoiceDetail.DiscountAmount + @"',
        //    '" + aInvoiceDetail.NetAmount + @"',
        //    '" + aInvoiceDetail.DeliveryStatus + @"',
        //    '" + aInvoiceDetail.ReturnReason + @"'
        //)";

        //    aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        //}


        public void InsertInvoiceDetailReturn(InvoiceDetail aInvoiceDetail, int invoiceId)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();

            aSqlParameterList.Add(new SqlParameter("@InvoiceId", invoiceId));
            aSqlParameterList.Add(new SqlParameter("@InvoiceDetailId", aInvoiceDetail.InvoiceDetailId));
            aSqlParameterList.Add(new SqlParameter("@Quantity", aInvoiceDetail.Quantity));
            aSqlParameterList.Add(new SqlParameter("@PreviousQuantity", aInvoiceDetail.PreviousQuantity));
            aSqlParameterList.Add(new SqlParameter("@BonusQuantity", aInvoiceDetail.BonusQuantity));
            aSqlParameterList.Add(new SqlParameter("@TotalQuantity", aInvoiceDetail.TotalQuantity));
            aSqlParameterList.Add(new SqlParameter("@TotalPrice", aInvoiceDetail.TotalPrice));
            aSqlParameterList.Add(new SqlParameter("@TotalPriceVatAmount", aInvoiceDetail.TotalPriceVatAmount));
            aSqlParameterList.Add(new SqlParameter("@DiscountPercentage", aInvoiceDetail.DiscountPercentage));
            aSqlParameterList.Add(new SqlParameter("@DiscountAmount", aInvoiceDetail.DiscountAmount));
            aSqlParameterList.Add(new SqlParameter("@NetAmount", aInvoiceDetail.NetAmount));
            aSqlParameterList.Add(new SqlParameter("@DeliveryStatus", aInvoiceDetail.DeliveryStatus));
            aSqlParameterList.Add(new SqlParameter("@ReturnReason", aInvoiceDetail.ReturnReason));

            aCommonInternalDal.SaveAction("sp_UpdateAndInsertInvoiceDetailSalesReturn", aSqlParameterList, "@InvoiceDetailReturnId");

        }

        /// Same insert/update as <see cref="InsertInvoiceDetailReturn(InvoiceDetail, int)"/> but run on
        /// the caller's connection/transaction so it commits or rolls back with the rest of the Submit.
        public void InsertInvoiceDetailReturn(InvoiceDetail aInvoiceDetail, int invoiceId, SqlTransaction transaction)
        {
            var dp = new DynamicParameters();
            dp.Add("@InvoiceId", invoiceId);
            dp.Add("@InvoiceDetailId", aInvoiceDetail.InvoiceDetailId);
            dp.Add("@Quantity", aInvoiceDetail.Quantity);
            dp.Add("@PreviousQuantity", aInvoiceDetail.PreviousQuantity);
            dp.Add("@BonusQuantity", aInvoiceDetail.BonusQuantity);
            dp.Add("@TotalQuantity", aInvoiceDetail.TotalQuantity);
            dp.Add("@TotalPrice", aInvoiceDetail.TotalPrice);
            dp.Add("@TotalPriceVatAmount", aInvoiceDetail.TotalPriceVatAmount);
            dp.Add("@DiscountPercentage", aInvoiceDetail.DiscountPercentage);
            dp.Add("@DiscountAmount", aInvoiceDetail.DiscountAmount);
            dp.Add("@NetAmount", aInvoiceDetail.NetAmount);
            dp.Add("@DeliveryStatus", (object)aInvoiceDetail.DeliveryStatus ?? DBNull.Value);
            dp.Add("@ReturnReason", (object)aInvoiceDetail.ReturnReason ?? DBNull.Value);
            dp.Add("@InvoiceDetailReturnId", dbType: DbType.Int32, direction: ParameterDirection.Output);

            transaction.Connection.Execute(
                "sp_UpdateAndInsertInvoiceDetailSalesReturn", dp, transaction, commandType: CommandType.StoredProcedure);
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
            return GetDataTable(query);
        }

        //public DataTable GetWarning(string CustID, string CustCode)
        //{
        //    string query = @"Select TOP 1  InvoiceNo + '- Market Name: ' + MarketName+ '- Amount: ' + CONVERT(varchar, TpGrandTotal)  as Details,  DATEDIFF(DAY, UpdateDate, GETDATE()   ),* from tblInvoice with (nolock)
        //    where CustomerMasterId='" + CustID.Trim() + "' and  	InvoiceDate between '1-july-2021' and getdate() and   DelivaryInvoiceNo is null  and DATEDIFF(DAY, InvoiceDate, GETDATE()   ) >=30  and (InvoiceNo is not null)";
        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}


        public DataTable GetWarning(string CustID, string CustCode)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@CustID", CustID));
                aSqlParameterlist.Add(new SqlParameter("@CustCode", CustCode));
                DataTable dt = accessManager.GetDataTable("sp_GetWarningForCustomerPayment_new", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
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
            const string query = @"SELECT * FROM tblDCStore WHERE ProductCode = @ProductCode AND ComUnitId = @ComUnitId AND StockQty>0 ORDER BY ExpDate ASC,BatchNo ASC";
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
            string query = @"    SELECT  I.CustomerType, CellNo,(Addrees2 + '[' +  Address +']')		 as Address	,tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName ,* 				
FROM tblInvoice I
INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
            ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
 INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode  
  INNER JOIN tblArea A ON A.AreaCode = I.AreaCode   
where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and tblMarket.MarketId=@MarketId and InvoiceDate=@InvoiceDate order by OrderNo";


            return GetDataTable(query,
                Parameter("@ComUnitId", Dcid),
                Parameter("@ManufacId", ManufId),
                Parameter("@MarketId", marketid),
                Parameter("@InvoiceDate", invDate));
        }
        public DataTable InvoiceDetailDataForReport(int Dcid, int ManufId, string tr, DateTime invDate)
        {
            string query = @"    SELECT  I.CustomerType, CellNo,(Addrees2 + '[' +  Address +']')		 as Address	,* 				
FROM tblInvoice I
INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
            ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
 INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode     
where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and I.AreaCode=@AreaCode and InvoiceDate=@InvoiceDate order by OrderNo";


            return GetDataTable(query,
                Parameter("@ComUnitId", Dcid),
                Parameter("@ManufacId", ManufId),
                Parameter("@AreaCode", tr),
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
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvoiceNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable ReturnInvoiceDetailDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.ReturnInvoiceNo as InvoiceNo,IV.ReturnInvoiceId as InvoiceId,IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, " +
                            " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.ReturnInvoiceId " +
                             " FROM dbo.tblReturnInvoiceDetail IVD LEFT JOIN dbo.tblReturnInvoice IV ON IVD.ReturnInvoiceId = IV.ReturnInvoiceId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvoiceNo", parameters);
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
            string query = @"SELECT (isnull(MAX(InvoiceId),0)+1)CountNo FROM dbo.tblInvoice ";

            //string query = @"SELECT  (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,10,11)) AS INT)),0)+1) CountNo FROM dbo.tblInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
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
                       " WHERE  I.ComUnitId=@ComUnitId and p.ManufacId=@ManufacId and InvoiceDate=@InvoiceDate and tblMarket.MarketId=@MarketId GROUP BY tblMarket.MarketName,M.MiaName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize ";
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
               
                       " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DelivaryInvoiceNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable DeliveryInvoiceDetailDataForReportDAL(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.DeliveryQuantity AS Quantity,IVD.UnitPrice, IVD.UnitVatAmount,IVD.DeliveryTotalPrice,IVD.DeliveryTotalPriceVatAmount,(IVD.DeliveryDiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount AS NetAmount,IV.InvoiceId   " +
                            " LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                            " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DelivaryInvoiceNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable ProformaReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {

            string query =
                       @"SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,Campaign AS ProductOffer,
CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,
CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode
,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,I.Types as IntransitDay
,I.MarketName,I.CustomerType as Type
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
        where CU.ComUnitId=@ComUnitId and I.InvoiceDate between @FromDate and @ToDate 		UNION ALL SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,CampaignType AS ProductOffer,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay ,I.MarketName,I.CustomerType as Type FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where CU.ComUnitId=@ComUnitId and I.InvoiceDate between @FromDate and @ToDate";

            
            
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
,I.MarketName,I.CustomerType as Type
FROM dbo.tblInvoice I with(nolock)
INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId
INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId
INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId
INNER JOIN dbo.tblDCStore DS ON DS.DCStoreId = ID.DCStoreId
       where I.InvoiceDate between @FromDate and @ToDate 	UNION ALL SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,CampaignType  AS ProductOffer, CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay ,I.MarketName,I.CustomerType as Type FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where I.InvoiceDate between @FromDate and @ToDate";


            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate));
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable InvoiceMainDataForReport(string invNo, string Code)
        {
            var parameters = new List<SqlParameter> { Parameter("@TopSheetGenCode", Code) };
            string query = @" SELECT @TopSheetGenCode TopSheetGenCode,  ord.OrderSenderName as ReturnInvoiceId, ord.CustomerMasterId,IV.AdjustAmount,IV.ReceivableAmount,IV.FixedCustomer ,da.Name DeliveryPersonName,da.PhoneNo  DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,ct.CustomerType as TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount, tbIn. NetAmount TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName,  (CU.Address) AS CUAddress,  CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,ptt.ProgramTypeName as CategoryName,ord.PaymentType PaymentTypeName,  emp.EmpMasterCode MiaCode,emp.EmpName MiaName,CM.MarketName as UserName
   FROM tblInvoice IV
left join (select InvoiceId, sum(tblInvoiceDetail.NetAmount) NetAmount from tblInvoiceDetail group by InvoiceId )tbIn on tbIn.InvoiceId=IV.InvoiceId
    INNER JOIN dbo.tblOrder ord ON IV.OrderId = ord.OrderId
    LEFT JOIN tblProgramType ptt ON ord.ProgramTypeId = ptt.ProgramTypeId
    LEFT JOIN tblCustomertype ct ON ord.CusttypeId = ct.CustomerTypeId

    LEFT JOIN tblCompanyUnit CU ON ord.ComUnitId = CU.ComUnitId
  LEFT JOIN tblDAInfo da ON IV.Inv_DANameId = da.DAId
     LEFT JOIN tblCustMaster CM ON ord.CustomerMasterId = CM.CustomerMasterId

      LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId = PT.PaymentTypeId
       --LEFT JOIN dbo.tblMIOInfo MIA ON ord.MIOId = MIA.EmployeeId

       LEFT JOIN dbo.tblEmpGeneralInfo emp ON ord.MIOId = emp.EmpInfoId


        LEFT JOIN tblUser U ON IV.UserId = U.UserId
         " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInClause("IV.InvoiceNo", invNo, "InvoiceNo", parameters) + " order by IV.InvoiceNo";
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable InvoiceMainDataForReport2(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.CustomerMasterId, tblOrder.OrderSenderName as ReturnInvoiceId,IV.AdjustAmount,IV.ReceivableAmount,IV.FixedCustomer ,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.CustomerType as TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,tbIn.NetAmount TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName,  (CU.Address) AS CUAddress,  tblOrder.CustomerCode,tblOrder.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,IV.Types as CategoryName, tblOrder.PaymentType   PaymentTypeName,  MIA.EmpMasterCode MiaCode,MIA.EmpName MiaName,tblOrder.MarketName_Ord as UserName  FROM tblInvoice IV   with (nolock)


left join (select InvoiceId, sum(tblInvoiceDetail.NetAmount) NetAmount from tblInvoiceDetail group by InvoiceId )tbIn on tbIn.InvoiceId=IV.InvoiceId
 LEFT JOIN tblCompanyUnit CU   with (nolock) ON IV.ComUnitId = CU.ComUnitId 
  LEFT JOIN tblCustMaster CM  with (nolock) ON IV.CustomerMasterId=CM.CustomerMasterId 
   LEFT JOIN tblPaymentType PT  with (nolock) ON IV.PaymentTypeId=PT.PaymentTypeId 
    LEFT JOIN tblUser U  with (nolock) ON IV.UserId=U.UserId  
	 
	 LEFT JOIN tblOrder  with (nolock) on tblOrder.OrderId =IV.OrderId 
    LEFT JOIN dbo.tblEmpGeneralInfo MIA  with (nolock) ON tblOrder.MIOId=MIA.EmpInfoId  
              " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInvoiceNoFilter(invNo, "IV.InvoiceNo", "InvoiceNo", parameters) + "   order by IV.InvoiceNo asc ";
            return SInventorySql.GetDataTable(query, parameters);
        }


        public DataTable InvoiceMainDatainvNo(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.CustomerMasterId, tblOrder.OrderSenderName as ReturnInvoiceId,IV.AdjustAmount,IV.ReceivableAmount,IV.FixedCustomer ,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.CustomerType as TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,tbIn.NetAmount TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName,  (CU.Address) AS CUAddress,  tblOrder.CustomerCode,tblOrder.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,IV.Types as CategoryName,tblOrder.PaymentType PaymentTypeName,  MIA.EmpMasterCode MiaCode,MIA.EmpName MiaName,tblOrder.MarketName_Ord as UserName  FROM tblInvoice IV   with (nolock)
left join (select InvoiceId, sum(tblInvoiceDetail.NetAmount) NetAmount from tblInvoiceDetail group by InvoiceId )tbIn on tbIn.InvoiceId=IV.InvoiceId
 LEFT JOIN tblCompanyUnit CU   with (nolock) ON IV.ComUnitId = CU.ComUnitId 
  LEFT JOIN tblCustMaster CM  with (nolock) ON IV.CustomerMasterId=CM.CustomerMasterId 
   LEFT JOIN tblPaymentType PT  with (nolock) ON IV.PaymentTypeId=PT.PaymentTypeId 
    LEFT JOIN tblUser U  with (nolock) ON IV.UserId=U.UserId  
	 
	 LEFT JOIN tblOrder  with (nolock) on tblOrder.OrderId =IV.OrderId 
    LEFT JOIN dbo.tblEmpGeneralInfo MIA  with (nolock) ON tblOrder.MIOId=MIA.EmpInfoId   where " + BuildInClause("IV.InvoiceId", invNo, "InvoiceId", parameters) + "  order by IV.InvoiceNo";
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable RInvoiceMainDataForReport(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"SELECT IV.FixedCustomer ,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.ReturnInvoiceNo as InvoiceNo,IV.CreateDate,IV.OrderNo,IV.OrderDate,IV.TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,IV.TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName, " +
                         " (CU.Address) AS CUAddress, " +
                        " CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,IV.Types as CategoryName,PT.PaymentTypeName, " +
                        " MIA.MiaCode,MIA.MiaName,CM.MarketName as UserName " +
                        " FROM tblReturnInvoice IV " +
                        " LEFT JOIN tblCompanyUnit CU ON IV.ComUnitId = CU.ComUnitId " +
                        " LEFT JOIN tblCustMaster CM ON IV.CustomerMasterId=CM.CustomerMasterId " +
                        " LEFT JOIN tblPaymentType PT ON IV.PaymentTypeId=PT.PaymentTypeId " +
                        " LEFT JOIN tblMIAInfo MIA ON IV.MiaId=MIA.MiaId " +
                        " LEFT JOIN tblUser U ON IV.UserId=U.UserId " +
                        " LEFT JOIN dbo.tblCustCategory CC ON CM.CategoryId=CC.CategoryId " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvoiceNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable FindInvoiceCode(string invNo)
        {
            var parameters = new List<SqlParameter>();
            string query = @"select ReturnInvoiceNo from tblReturnInvoice where " + BuildInClause("ReturnInvoiceId", invNo, "ReturnInvoiceId", parameters);
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
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode   WHERE " + BuildInClause("IV.InvoiceNo", invNo, "InvoiceNo", parameters);

            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable InvoiceDetailDataForReport2(string invNo)
        {
            var parameters = new List<SqlParameter>();
            //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
            //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
            //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
            //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
            //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,dc.BatchNo,IVD.PackSize as BonusQuantity,IVD.Quantity,IVD.UnitPrice,   IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage,   (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId     FROM dbo.tblInvoiceDetail IVD
 LEFT JOIN dbo.tblDCStore dc  ON dc.DCStoreId = IVD.DCStoreId  
 LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId 
   INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId  
   
     left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                      " WHERE " + BuildInvoiceNoFilter(invNo, "IV.InvoiceNo", "InvoiceNo", parameters) + "  order by IVD.ProductName asc";

            return SInventorySql.GetDataTable(query, parameters);
        }



        public DataTable InvoiceDetailDataInvoID(string invNo)
        {
            var parameters = new List<SqlParameter>();
            //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
            //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
            //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
            //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
            //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,dc.BatchNo,IVD.PackSize as BonusQuantity,IVD.Quantity,IVD.UnitPrice,   IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage,   (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId     FROM dbo.tblInvoiceDetail IVD
 LEFT JOIN dbo.tblDCStore dc  ON dc.DCStoreId = IVD.DCStoreId  
 LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId 
   INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId  
   
     left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode   WHERE " + BuildInClause("IVD.InvoiceId", invNo, "InvoiceId", parameters) + "  order by IVD.ProductName asc";

            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable RInvoiceDetailDataForReport(string invNo)
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
                            "   FROM dbo.tblReturnInvoiceDetail IVD  LEFT JOIN dbo.tblReturnInvoice IV ON IVD.ReturnInvoiceId = IV.ReturnInvoiceId  " +
                     " INNER JOIN dbo.tblReturnInvoice I ON I.ReturnInvoiceId = IV.ReturnInvoiceId  " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode " +
                //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
                      " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvoiceNo", parameters);

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
                       " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvoiceNo", parameters);
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
                      " WHERE " + BuildInClause("IV.ReturnInvoiceNo", invNo, "ReturnInvoiceNo", parameters);
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
            var parameters = new List<SqlParameter>();
            string query = @" SELECT tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId   INNER JOIN tblArea A ON A.AreaCode = I.AreaCode  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId=@ComUnitId and p.ManufacId=@ManufacId and InvoiceDate=@InvoiceDate and tblMarket.MarketId=@MarketId " + BuildSelectedInvoiceFilter(parameter, parameters) + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,A.AreaName order by ProductName";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            parameters.Add(Parameter("@ComUnitId", SC));
            parameters.Add(Parameter("@ManufacId", ManufacID));
            parameters.Add(Parameter("@InvoiceDate", InvDate));
            parameters.Add(Parameter("@MarketId", MarketID));
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable MarketPickinReport(string SC, string t, int ManufacID, DateTime InvDate, string parameter)
        {
            var parameters = new List<SqlParameter>();
            string query = @" SELECT tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId=@ComUnitId and p.ManufacId=@ManufacId and InvoiceDate=@InvoiceDate and I.AreaCode=@AreaCode " + BuildSelectedInvoiceFilter(parameter, parameters) + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize order by ProductName";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            parameters.Add(Parameter("@ComUnitId", SC));
            parameters.Add(Parameter("@ManufacId", ManufacID));
            parameters.Add(Parameter("@InvoiceDate", InvDate));
            parameters.Add(Parameter("@AreaCode", t));
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
                      " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DelivaryInvoiceNo", parameters) + " and IVD.DeliveryStatus IN ('Full','Partial') ";

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
                       " WHERE " + BuildInClause("IV.DelivaryInvoiceNo", invNo, "DelivaryInvoiceNo", parameters);
            return SInventorySql.GetDataTable(query, parameters);
        }
        public bool UpdateDCStock(decimal StockQty, int DCStoreId)
        {
            const string query = @"UPDATE tblDCStore SET StockQty=StockQty+@StockQty WHERE DCStoreId=@DCStoreId";
            return Execute(query,
                Parameter("@StockQty", StockQty),
                Parameter("@DCStoreId", DCStoreId));
        }

        public bool UpdateDCStock(decimal StockQty, int DCStoreId, SqlTransaction transaction)
        {
            const string query = @"UPDATE tblDCStore SET StockQty=StockQty+@StockQty WHERE DCStoreId=@DCStoreId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@StockQty", StockQty),
                Parameter("@DCStoreId", DCStoreId)
            }, transaction);
        }
        public bool DCStockInDAL(DCStockNew aDcStockNew)
        {
            const string query = @"INSERT INTO dbo.tblDCStoreFreeze
(DCStoreId, DCStoreFreezeId, InvoiceDetailId, StorageLocation, ProductCode, ProductName, PackSize, BatchNo,
TotalQuantity, ExpDate, ReceiveDate, ChalanNo, ChalanDate, ComUnitId, StockQty, DamageQty, StockRcvDate,
ReqId, ReqChildId, StockInTransfarId, StockCondition, ChalanDetailsId)
VALUES
(@DCStoreId, @DCStoreFreezeId, @InvoiceDetailId, @StorageLocation, @ProductCode, @ProductName, @PackSize, @BatchNo,
@TotalQuantity, @ExpDate, @ReceiveDate, @ChalanNo, @ChalanDate, @ComUnitId, @StockQty, @DamageQty, @StockRcvDate,
@ReqId, @ReqChildId, @StockInTransfarId, @StockCondition, @ChalanDetailsId)";
            return Execute(query,
                Parameter("@DCStoreId", aDcStockNew.DCStoreId),
                Parameter("@DCStoreFreezeId", aDcStockNew.DCStoreFreezeId),
                Parameter("@InvoiceDetailId", aDcStockNew.InvoiceDetailId),
                Parameter("@StorageLocation", aDcStockNew.StorageLocation),
                Parameter("@ProductCode", aDcStockNew.ProductCode),
                Parameter("@ProductName", aDcStockNew.ProductName),
                Parameter("@PackSize", aDcStockNew.PackSize),
                Parameter("@BatchNo", aDcStockNew.BatchNo),
                Parameter("@TotalQuantity", aDcStockNew.TotalQuantity),
                Parameter("@ExpDate", aDcStockNew.ExpDate),
                Parameter("@ReceiveDate", aDcStockNew.ReceiveDate),
                Parameter("@ChalanNo", aDcStockNew.ChalanNo),
                Parameter("@ChalanDate", aDcStockNew.ChalanDate),
                Parameter("@ComUnitId", aDcStockNew.ComUnitId),
                Parameter("@StockQty", aDcStockNew.StockQty),
                Parameter("@DamageQty", aDcStockNew.DamageQty),
                Parameter("@StockRcvDate", aDcStockNew.StockRcvDate),
                Parameter("@ReqId", aDcStockNew.ReqId),
                Parameter("@ReqChildId", aDcStockNew.ReqChildId),
                Parameter("@StockInTransfarId", aDcStockNew.StockInTransfarId),
                Parameter("@StockCondition", "ReturnStock"),
                Parameter("@ChalanDetailsId", aDcStockNew.ChalanDetailsId));
        }
        public DataTable MArketwiseIntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate, string market,string miacode)
        {
            string query =
                       @"SELECT @FromDate as fromdate ,@ToDate as todate ,C.Address as ComUnitCode,CU.ComUnitName," +
                       "C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, " +
                       "tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode," +
                       "I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE," +
                       "I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) " +
                       "INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount " +
                       "from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId " +
                       "where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and I.AreaCode=ISNULL(@Market,I.AreaCode)  and I.MiaCode=ISNULL(@MiaCode,I.MiaCode)  and CU.ComUnitId=@ComUnitId and I.InvoiceDate between @FromDate and @ToDate " +
                       
                       "UNION ALL SELECT @FromDate as fromdate ,@ToDate as todate ," +
                       "C.Address as ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo," +
                       "CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal " +
                       "AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode," +
                       "I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) " +
                       "IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount " +
                       "FROM dbo.tblSubInvoiceMaster I WITH(nolock) " +
                       "INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId " +
                       "INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 " +
                       "AND I.DelivaryInvoiceNo IS NULL and  I.AreaCode=ISNULL(@Market,I.AreaCode) AND I.MiaCode=ISNULL(@MiaCode,I.MiaCode)  and CU.ComUnitId=@ComUnitId  " +
                       "and I.InvoiceDate between @FromDate and @ToDate ORDER BY DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) DESC";



            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate),
                Parameter("@Market", string.IsNullOrEmpty(market) ? null : market),
                Parameter("@MiaCode", string.IsNullOrEmpty(miacode) ? null : miacode),
                Parameter("@ComUnitId", districtId.Trim()));
        }
        //public DataTable IntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        //{
        //    string query =
        //               @"SELECT '" + fromDate + "' as fromdate ,'" + toDate + "' as todate ,tblDetails.DeliveryNetAmount AS  ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,((Sum(DeliveryTotalPrice)+Sum(DeliveryTotalPriceVatAmount))-Sum(DeliveryDiscountAmount))DeliveryNetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0   and CU.ComUnitId='" + districtId.Trim() + "' and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'" +
        //               " UNION ALL SELECT '" + fromDate + "' as fromdate ,'" + toDate + "' as todate ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as SpecialAmount FROM dbo.tblSubInvoiceMaster I WITH(nolock) INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN tblCustMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0   and CU.ComUnitId='" + districtId.Trim() + "'  and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";
            
         

        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}



        public DataTable IntransitReportDAl(string districtId, string fromDate, string toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@districtId", districtId));
                aSqlParameterlist.Add(new SqlParameter("@fromDate", fromDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_Get_IntransitReportList", aSqlParameterlist);
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable AgingIntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();

            aSqlParameterList.Add(new SqlParameter("@districtId", districtId));
            aSqlParameterList.Add(new SqlParameter("@fromDate", fromDate));
            aSqlParameterList.Add(new SqlParameter("@toDate", toDate));


            return aCommonInternalDal.GetDataTableAction("sp_Get_AgingReceivableReport", aSqlParameterList, "SSIDB");
        }
        public DataTable IntransitReportDAl(DateTime fromDate, DateTime toDate)
        {
            string query =
                       @"SELECT @FromDate as fromdate ,@ToDate as todate ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL    and I.InvoiceDate between @FromDate and @ToDate UNION ALL SELECT @FromDate as fromdate ,@ToDate as todate ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as SpecialAmount FROM dbo.tblSubInvoiceMaster I WITH(nolock) INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL  and  I.InvoiceDate between @FromDate and @ToDate";


            return GetDataTable(query,
                Parameter("@FromDate", fromDate),
                Parameter("@ToDate", toDate));
        }
        public int DeleteInvoice(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderID", Invoice));
            return aCommonInternalDal.RunStoreProcedure("sp_Deletenvoice", aSqlParameterList, "SSIDB");
        }
        public bool SaveDataForReturnAmount(ReturnAmountDAO amountDao)
        {
            const string insertQuery = @"INSERT INTO dbo.tblReturnAmount (CustomerId, InvoiceId, Amount)
VALUES (@CustomerId, @InvoiceId, @Amount)";
            return Execute(insertQuery,
                Parameter("@CustomerId", amountDao.CustomerId),
                Parameter("@InvoiceId", amountDao.InvoiceId),
                Parameter("@Amount", amountDao.Amount));
        }

        //Pulak

        public DataTable LoadInvoiceWithDetail(string invoiceId)
        {
            string query = @"SELECT '0'SL,ProductCode,OrderDetailsId,ProductName,'0'StockQty,UnitPrice,UnitVatAmount as UnitVAT,Quantity,TotalPrice,DiscountPercentage,DiscountAmount,''IsCampaignProduct,TpVat as VAT,NetAmount as NetPrice,''ISGiftProduct,TotalQuantity as TotalQty,*  FROM tblInvoice
            left join tblInvoiceDetail on tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId
            where tblInvoiceDetail.InvoiceId=@InvoiceId ";
            return GetDataTable(query, Parameter("@InvoiceId", invoiceId));
        }
        public DataTable LoadInvoice(string invoicenNo)
        {
            const string query = @"select * from tblInvoice where InvoiceNo=@InvoiceNo";
            return GetDataTable(query, Parameter("@InvoiceNo", invoicenNo));
        }
        public DataTable LoadInvoiceDetailData(string invoiceId)
        {
            const string query = "select * from tblInvoiceDetail where InvoiceId=@InvoiceId";
            return GetDataTable(query, Parameter("@InvoiceId", invoiceId));
        }
        public void DeleteInvoice(string invoiceId, string invoicedetailId)
        {
            const string updateQuery = @"delete from tblInvoice where InvoiceId=@InvoiceId; delete from tblInvoiceDetail where InvoiceDetailId=@InvoiceDetailId";
            Execute(updateQuery,
                Parameter("@InvoiceId", invoiceId),
                Parameter("@InvoiceDetailId", invoicedetailId));
        }
        //public void UpdateDCStoreQuantity(string dCStoreId, decimal Quantity)
        //{
        //    string updateQuery = @"UPDATE tblDCStore SET StockQty='" + Quantity + "' WHERE DCStoreId='" + dCStoreId.Trim() + "'  ";
        //    aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        //}
        public DataTable InvoiceDetailDataForReportNew(int Dcid, int ManufId, int market,string tr, DateTime invDate)
        {
            string query = @"    SELECT  I.CustomerType, CellNo,(Addrees2 + '[' +  Address +']')		 as Address	,tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName ,* 				
FROM tblInvoice I
INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
            ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
 INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode    INNER JOIN tblArea A ON A.AreaCode = I.AreaCode   
where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and tblMarket.MarketId=@MarketId and I.AreaCode=@AreaCode and InvoiceDate=@InvoiceDate order by OrderNo";


            return GetDataTable(query,
                Parameter("@ComUnitId", Dcid),
                Parameter("@ManufacId", ManufId),
                Parameter("@MarketId", market),
                Parameter("@AreaCode", tr),
                Parameter("@InvoiceDate", invDate));
        }


        public DataTable InvoiceDetailDataForReportNew_(string invNoid, string Route, string invDat, string Code)
        {
            var parameters = new List<SqlParameter> { Parameter("@TopSheetGenCode", Code) };
            string query = @"     SELECT  @TopSheetGenCode TopSheetGenCode,Ct.CustomerType CustomerType, CellNo,(C.Address + '[' +  Address +']')		 as Address	,'Route Name : ' + rt.RouteName as MarketName ,tblD.ManufacId as TpGrandTotal,* 				
FROM tblInvoice I  with (nolock)
INNER JOIN (SELECT DISTINCT D.InvoiceId,sum(NetAmount)ManufacId  FROM dbo.tblInvoice I  with (nolock)
            INNER JOIN dbo.tblInvoiceDetail D  with (nolock) ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P  with (nolock) ON D.ProductCode = P.ProductCode
             group by  D.InvoiceId  ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.tblCustMaster C  with (nolock) ON I.CustomerMasterId = C.CustomerMasterId
   INNER JOIN dbo.tblOrder ord  with (nolock) ON I.OrderId = ord.OrderId  
  left JOIN dbo.tblCustomerType Ct  with (nolock) ON ord.CustTypeId = Ct.CustomerTypeId
  
   INNER JOIN dbo.tblRouteInformationMaster rt  with (nolock) ON rt.RouteInformationMasterId = ord.DistributionRouteId 
where " + BuildInClause("I.InvoiceId", invNoid, "InvoiceId", parameters) + "   order by I.InvoiceNo asc";


            return SInventorySql.GetDataTable(query, parameters);
        }

        public DataTable MarketPickinReportNew(string SC,int Mrk, string t, int ManufacID, DateTime InvDate, string parameter)
        {
            var parameters = new List<SqlParameter>();
            string query = @" SELECT tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode   INNER JOIN tblArea A ON A.AreaCode = I.AreaCode " +
                       " WHERE  I.ComUnitId=@ComUnitId and p.ManufacId=@ManufacId and  tblMarket.MarketId=@MarketId and InvoiceDate=@InvoiceDate and I.AreaCode=@AreaCode " + BuildSelectedInvoiceFilter(parameter, parameters) + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,A.AreaName ";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            parameters.Add(Parameter("@ComUnitId", SC));
            parameters.Add(Parameter("@ManufacId", ManufacID));
            parameters.Add(Parameter("@MarketId", Mrk));
            parameters.Add(Parameter("@InvoiceDate", InvDate));
            parameters.Add(Parameter("@AreaCode", t));
            return SInventorySql.GetDataTable(query, parameters);
        }

        public DataTable MarketPickinReportNew_(string invNoid, string Route, string InvDate)
        {
            var parameters = new List<SqlParameter>();
            string query = @"   select distinct * from (SELECT   'Route Name : ' +  rt.RouteName as MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo as BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity  FROM dbo.tblInvoice I   with (nolock)
  INNER JOIN tblCustMaster C  with (nolock)  ON I.CustomerMasterId = C.CustomerMasterId  
						   
						 INNER JOIN dbo.tblInvoiceDetail D  with (nolock) ON I.InvoiceId = D.InvoiceId  
						INNER JOIN dbo.tblOrder ord  with (nolock) ON I.OrderId = ord.OrderId   
      INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode   
						  INNER JOIN dbo.tblRouteInformationMaster rt  with (nolock) ON rt.RouteInformationMasterId = ord.DistributionRouteId  
   where " + BuildInClause("I.InvoiceId", invNoid, "InvoiceId", parameters) + @"   

                         GROUP BY rt.RouteName,I.InvoiceDate,D.ProductCode,D.ProductName , D.BatchNo , D.PackSize ,rt.RouteName ) tbl order by  ProductName asc";
        
            return SInventorySql.GetDataTable(query, parameters);
        }

        private static List<SqlParameter> InvoiceDetailParameters(InvoiceDetail detail, bool includeReturnFields)
        {
            var parameters = new List<SqlParameter>
            {
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
                Parameter("@InvoiceId", detail.InvoiceId),
                Parameter("@DCStoreId", detail.DCStoreId),
                Parameter("@OrderDetailsId", detail.OrderDetailsId),
                Parameter("@SpecialAmount", detail.SpecialAmount)
            };

            if (includeReturnFields)
            {
                parameters.Add(Parameter("@ReuturnInvoiceDetailId", detail.InvoiceDetailId));
                parameters.Add(Parameter("@ReturnDetailsId", detail.ReturnDetailsId));
            }
            else
            {
                parameters.Add(Parameter("@ISGiftProduct", detail.ISGiftProductforInv));
                parameters.Add(Parameter("@IsCampaignProduct", detail.IsCampaignProductforInv));
                parameters.Add(Parameter("@AdjustmentAmount", detail.AdjustmentAmount));
            }

            return parameters;
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
