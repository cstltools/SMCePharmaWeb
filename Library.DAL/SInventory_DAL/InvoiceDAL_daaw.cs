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
    public class InvoiceDAL_daaw
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        private DataAccessManager_daaw  accessManager = new DataAccessManager_daaw ();

        DB_Manager aDbManager = new DB_Manager();

        public bool RejectInvoiceDASalesConfirmStatus(int invoiceId)
        {
            bool status = false;
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@InvoiceId", invoiceId));
                status = accessManager.UpdateData("sp_RejectInvoiceDASalesConfirmStatus", aSqlParameters);
                return status;
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

        public bool UpdateDICApprovalStatus(string salesConfirmationAppLogId, string dicApprovalStatus, string approvedBy)
        {
            if (string.IsNullOrWhiteSpace(salesConfirmationAppLogId) || salesConfirmationAppLogId == "0")
                return false;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@SalesConfirmationAppLogId", salesConfirmationAppLogId));
                aSqlParameters.Add(new SqlParameter("@DICApprovalStatus", dicApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@DICApproveDate", DateTime.Now));
                aSqlParameters.Add(new SqlParameter("@DICApproveBy", approvedBy));
                return accessManager.UpdateData("sp_UpdateDICApprovalStatus", aSqlParameters);
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// Same update as <see cref="UpdateDICApprovalStatus(string, string, string)"/> but run on the
        /// caller's connection/transaction so it commits or rolls back with the rest of the Submit
        /// instead of auto-committing on its own separate connection.
        public bool UpdateDICApprovalStatus(string salesConfirmationAppLogId, string dicApprovalStatus, string approvedBy, SqlTransaction transaction)
        {
            if (string.IsNullOrWhiteSpace(salesConfirmationAppLogId) || salesConfirmationAppLogId == "0")
                return false;

            return transaction.Connection.Execute(
                "sp_UpdateDICApprovalStatus",
                new
                {
                    SalesConfirmationAppLogId = salesConfirmationAppLogId,
                    DICApprovalStatus = dicApprovalStatus,
                    DICApproveDate = DateTime.Now,
                    DICApproveBy = approvedBy
                },
                transaction, commandType: CommandType.StoredProcedure) > 0;
        }



        public bool RejectInvoiceDASalesReturn(int invoiceId, string salesReturnAppLogId = "")
        {
            bool status = false;
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@InvoiceId", invoiceId));
                if (!string.IsNullOrEmpty(salesReturnAppLogId))
                {
                    int logId;
                    if (int.TryParse(salesReturnAppLogId, out logId))
                    {
                        aSqlParameters.Add(new SqlParameter("@SalesReturnAppLogId", logId));
                    }
                }
                status = accessManager.UpdateData("sp_RejectInvoiceDASalesReturn", aSqlParameters);
                return status;
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
         

        public bool UpdateDICApprovalStatus_SalesReturn(string salesReturnAppLogId, string dicApprovalStatus, string approvedBy)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@SalesReturnAppLogId", salesReturnAppLogId));
                aSqlParameters.Add(new SqlParameter("@DICApprovalStatus", dicApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@DICApproveDate", DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss")));
                aSqlParameters.Add(new SqlParameter("@DICApproveBy", approvedBy));

                bool isSuccess = accessManager.UpdateData("sp_UpdateDICApprovalStatus_SalesReturn", aSqlParameters);
                return isSuccess;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        /// Same update as <see cref="UpdateDICApprovalStatus_SalesReturn(string, string, string)"/> but
        /// run on the caller's connection/transaction so it commits or rolls back with the rest of the
        /// Submit instead of auto-committing on its own separate connection.
        public bool UpdateDICApprovalStatus_SalesReturn(string salesReturnAppLogId, string dicApprovalStatus, string approvedBy, SqlTransaction transaction)
        {
            return transaction.Connection.Execute(
                "sp_UpdateDICApprovalStatus_SalesReturn",
                new
                {
                    SalesReturnAppLogId = salesReturnAppLogId,
                    DICApprovalStatus = dicApprovalStatus,
                    DICApproveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss"),
                    DICApproveBy = approvedBy
                },
                transaction, commandType: CommandType.StoredProcedure) > 0;
        }

        public string GetSalesReturnAppLogIdByInvoiceId(int invoiceId)
        {
            try
            {
                // Assuming the table name is tblSalesReturn_appLog and it has InvoiceId
                string query = "SELECT TOP 1 SalesReturnAppLogId FROM tblSalesReturn_appLog WHERE InvoiceId = '" + invoiceId + "' ORDER BY SalesReturnAppLogId DESC";
                DataTable dt = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
                
                if (dt != null && dt.Rows.Count > 0)
                {
                    return dt.Rows[0]["SalesReturnAppLogId"].ToString();
                }
                return string.Empty;
            }
            catch (Exception ex)
            {
                return string.Empty;
            }
        }

        public DataTable LoadSalesReturnAppLogHeader(string invoiceId, string appLogId = "")
        {
            try
            {
                string query = @"SELECT TOP 1 
                    I.InvoiceId, I.InvoiceNo, I.InvoiceDate,
                    C.CustomerName, C.CustomerCode, C.Address,
                    ISNULL(I.MarketName, C.MarketName) AS MarketName,
                    COALESCE(NULLIF(RTRIM(I.DA_SalesConfirmBy), ''), NULLIF(RTRIM(I.DA_SalesReturnBy), ''), NULLIF(RTRIM(I.DeliveryPersonName), ''), NULLIF(RTRIM(SLog.DaId), ''), NULLIF(RTRIM(SLog.ApproveBy), ''), '') AS DA_SalesConfirmBy,
                    SLog.SalesReturnAppLogId,
                    ISNULL(SLog.CreatedOn, I.InvoiceDate) AS DA_SalesConfirmDate,
                    SLog.DICApprovalStatus
                FROM dbo.tblInvoice I WITH (NOLOCK)
                LEFT JOIN dbo.tblCustMaster C WITH (NOLOCK) ON I.CustomerMasterId = C.CustomerMasterId
                LEFT JOIN dbo.tblSalesReturn_appLog SLog WITH (NOLOCK) ON I.InvoiceId = SLog.InvoiceId
                WHERE I.InvoiceId = '" + invoiceId + "'";

                if (!string.IsNullOrEmpty(appLogId))
                {
                    query += " AND SLog.SalesReturnAppLogId = '" + appLogId + "'";
                }

                query += " ORDER BY SLog.SalesReturnAppLogId DESC";

                return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public DataTable LoadSalesReturnAppLogDetails(string invoiceId, string appLogId = "")
        {
            try
            {
                string query = @"SELECT 
                    D.InvoiceDetailId,
                    D.ProductCode,
                    D.ProductName,
                    ISNULL(D.TotalQty, D.OrderedQty) AS TotalQty,
                    D.ReturnQty,
                    D.UnitPrice,
                    D.ReasonCode,
                    D.ReasonLabel,
                    CASE 
                        WHEN ISNULL(D.NetPrice, 0) > 0 THEN D.NetPrice 
                        WHEN Inv.DeliveryInvoiceStatus = 'Partial' AND ISNULL(InvD.DeliveryNetAmount, 0) > 0 THEN InvD.DeliveryNetAmount
                        WHEN ISNULL(InvD.NetAmount, 0) > 0 THEN InvD.NetAmount
                        ELSE D.ReturnQty * (D.UnitPrice + ISNULL(D.UnitVat, 0) - ISNULL(D.DiscountAmount, 0))
                    END AS ReturnAmount,
                    CASE 
                        WHEN NULLIF(RTRIM(D.ReasonLabel), '') IS NOT NULL THEN D.ReasonLabel 
                        WHEN NULLIF(RTRIM(D.ReasonCode), '') IS NOT NULL THEN D.ReasonCode 
                        WHEN NULLIF(RTRIM(Log.Remarks), '') IS NOT NULL THEN Log.Remarks
                        WHEN NULLIF(RTRIM(Log.ReturnType), '') IS NOT NULL THEN Log.ReturnType
                        ELSE 'Sales Return' 
                    END AS Reason
                FROM dbo.tblSalesReturn_appLogDetail D WITH (NOLOCK)
                LEFT JOIN dbo.tblSalesReturn_appLog Log WITH (NOLOCK) ON D.SalesReturnAppLogId = Log.SalesReturnAppLogId
                LEFT JOIN dbo.tblInvoice Inv WITH (NOLOCK) ON D.InvoiceId = Inv.InvoiceId
                LEFT JOIN dbo.tblInvoiceDetail InvD WITH (NOLOCK) ON D.InvoiceId = InvD.InvoiceId AND D.ProductCode = InvD.ProductCode
                WHERE 1=1 ";

                if (!string.IsNullOrEmpty(appLogId))
                {
                    query += " AND D.SalesReturnAppLogId = '" + appLogId + "'";
                }
                else if (!string.IsNullOrEmpty(invoiceId))
                {
                    query += " AND D.InvoiceId = '" + invoiceId + "'";
                }

                return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            }
            catch (Exception ex)
            {
                throw ex;
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
        public DataTable MoneyReceiptAfterPaymentInfoForDALedger(string pram)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm", pram));

                DataTable dt = accessManager.GetDataTable("sp_Get_MoneyReceiptReportAfterPaymentListforDALedger", aSqlParameters);
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
        public DataTable GetNewReceiveableDAlWeb(string districtId, string fromDate, string toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@districtId", districtId));
                aSqlParameterlist.Add(new SqlParameter("@fromDate", fromDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));

                DataTable dt = accessManager.GetDataTable("sp_Get_NewReceiveableListWeb", aSqlParameterlist);
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
            string insertQuery = @" INSERT INTO dbo.tblInvoice " +
                " (    " +
     "     InvoiceNo , " +
       "     CustomerType , " +
          "     AdjustInvoiceNo_ReturnInvoiceNo , " +
       
      "     CreateDate , " +
       "     AdjustAmount , " +
         "     IsAdjustInvoice , " +
       "     ReceivableAmount , " +


       "    InvoiceDate , " +
       "    OrderNo , " +
       "    OrderDate , " +
       "    CustomerMasterId , " +
       "    ComUnitId , " +
        "   MiaId , " +
        "   PaymentTypeId , " +
        "   TpTotal , " +
        "   TpDiscount , " +
                "   Types , " +
        "   TpVat , " +
        "   TpGrandTotal , " +
        "   UserId, " +
        "   OrderId, " +
        "   TotalSpecialAmount, " +
         "   OldTradePolicy, " +
          "   ProductOffer, Inv_DANameId,Remarks,MIACode,MIAName,MarketCode,MarketName,AreaCode,DisCode,FEName,RegionCode,DZSMName,FixedCustomer,DeliveryPersonName,DeliveryPersonPhNo " +
      "   ) " +
      " VALUES  ( " +
       "    '" + aInvoice.InvoiceNo + "' , " +
         "    '" + aInvoice.cusType + "' , " +
           "    '" + aInvoice.AdjustInvoiceNo_ReturnInvoiceNo + "' , " +
         "    '" + aInvoice.Createdate + "' , " +
      "     '" + aInvoice.AdjustAmount + "' , " +
      "     '" + aInvoice.IsAdjustInvoice + "' , " +
      "     '" + aInvoice.ReceivableAmount + "' , " +


      "    '" + aInvoice.InvoiceDate + "' , " +
      "     '" + aInvoice.OrderNo + "' , " +
      "     '" + aInvoice.OrderDate + "' , " +
      "     '" + aInvoice.CustomerMasterId + "' , " +
       "    '" + aInvoice.ComUnitId + "' , " +
       "    '" + aInvoice.MiaId + "' , " +
      "     '" + aInvoice.PaymentTypeId + "' , " +
      "    '" + aInvoice.TpTotal + "' , " +
      "     '" + aInvoice.TpDiscount + "' , " +

         "     '" + aInvoice.Type + "' , " +


      "     '" + aInvoice.TpVat + "' , " +
       "    '" + aInvoice.TpGrandTotal + "' , " +
       "    '" + aInvoice.UserId + "' , " +
       "    '" + aInvoice.OrderId + "' , " +
        "    '" + aInvoice.TotalSpecialAmount + "' , " +
          "    '" + aInvoice.OldTradePolicy + "' , " +
       "    '" + aInvoice.ProductOffer + "','" + aInvoice.Inv_DANameId + "','" + aInvoice.Remarks + "','" + aInvoice.MIACode + "','" + aInvoice.MIAName + "','" + aInvoice.MarketCode + "','" + aInvoice.MarketName + "','" +
       aInvoice.AreaCode + "','" + aInvoice.DisCode + "','" + aInvoice.FEName + "','" + aInvoice.RegionCode + "'" +
                                 ",'" + aInvoice.DZSMName + "','" + aInvoice.FixedCustomer + "','" + aInvoice.DpNAme + "','" + aInvoice.DpMob + "'  " +
      "   ) ";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveDataForInvoiceBatch(string invoiceid,string batchno)
        {
            string insertQuery = @"INSERT INTO dbo.tblInvoiceBatch
	(
	    BatchNo,
	    Date,
	    InvoiceId
	)
	VALUES
	(   '"+batchno+"',GETDATE(),'"+ invoiceid + "') ";

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
            string insertQuery = @" INSERT INTO dbo.tblInvoiceDetail " +
     "   ( " +
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
        "     InvoiceId, " +
        "     DCStoreId, " +
        "     OrderDetailsId ," +
        "     Campaign ," +

           "     ISGiftProduct ," +
              "     IsCampaignProduct ," +


        "     SpecialAmount ,AdjustmentAmount" +
       "    ) " +
 "  VALUES  (  " +
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
       "      '" + "N" + "' , " +

           "      '" + aInvoiceDetail.ISGiftProductforInv + "' , " +
               "      '" + aInvoiceDetail.IsCampaignProductforInv + "' , " +

       "      '" + aInvoiceDetail.SpecialAmount + "',  " +
       "      '" + aInvoiceDetail.AdjustmentAmount + "'  " +

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

             string query = @"   SELECT P.ProductCode,(P.ProductName+':'+P.PackSize) as  ProductName,P.PackSize, " +
            " ISNULL(UP.UnitPrice,0) AS UnitPrice,ISNULL(VCS.TotalQty,0) AS StockQty, " +
            " (UP.VATAmountPerUnit) AS VAT, ISNULL(UP.CostPrice,0) AS CostPrice, " +
            " ISNULL(UP.VATPercentage,0)VATPercentage  FROM " +
            " dbo.tblProduct P  " +
            " LEFT JOIN dbo.tblUnitPrice UP ON P.ProductCode = UP.ProductCode  " +
            " LEFT JOIN (select ComUnitId,ProductCode, TotalQty from View_DCStoreCurrentStock WHERE ComUnitId='" + comUnitId.Trim() + "' AND ProductCode='" + productCode.Trim() + "') VCS  " +
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
        public DataTable LoadCustomerMaster(string OrderNO)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT   * FROM dbo.View_OrderCustomerInfo ord 
WHERE ord.OrderCode='" + OrderNO.Trim() + "'   ";
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
            string query = "SELECT * FROM dbo.tblDCStore WHERE DCStoreId='"+dcstoreId+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public void UpdateDCStoreQuantity(string dCStoreId, decimal Quantity)
        {
            string updateQuery = @"UPDATE tblDCStore SET StockQty='" + Quantity + "' WHERE DCStoreId='" + dCStoreId.Trim() + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }

        public DataTable Isgift(int dcstoreId)
        {
            string query = "select ISGiftProduct from tblOrderDetail where OrderDetailId='" + dcstoreId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
            string updateQuery = @"UPDATE tblInvoice SET DeliveryTpTotal='" + aInvoice.TpTotal + "',DeliveryTpDiscount='" + aInvoice.TpDiscount + "',DeliveryTpVat='" + aInvoice.TpVat  + "',UpdateDatetime='" + aInvoice.updatetime + "'," +
                                 "DeliveryTpGrandTotal='" + aInvoice.TpGrandTotal + "',DeliveryInvoiceStatus='" + aInvoice.DeliveryInvoiceStatus + "',DelivaryInvoiceNo='" + "DEL-"+ aInvoice.DelivaryInvoiceNo + "',DelivarySpecialAmount='" + aInvoice.TotalSpecialAmount + "',UpdateBy='" + aInvoice.UpdateBy + "',UpdateDate='" + aInvoice.InvoiceDate + "' WHERE InvoiceId='" + aInvoice.InvoiceId + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }


        public void PaymentUpdateInvoice(Invoice aInvoice)
        {
            string updateQuery = @"UPDATE tblInvoice SET PaymentTpTotal='" + aInvoice.TpTotal + "',PaymentTpDiscount='" + aInvoice.TpDiscount + "',PaymentTpVat='" + aInvoice.TpVat + "'," +
                                 "PaymentTpGrandTotal='" + aInvoice.TpGrandTotal + "',PaymentInvoiceStatus='" + aInvoice.DeliveryInvoiceStatus + "',PaymentInvoiceNo='" + "RTN-" + aInvoice.DelivaryInvoiceNo + "',PaymentBy='" + aInvoice.UpdateBy + "',PaymentDate='" + aInvoice.InvoiceDate + "' WHERE InvoiceId='" + aInvoice.InvoiceId + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }
        public void UpdateInvoiceDetail(InvoiceDetail  aInvoiceDetail)
        {
            string updateQuery = @"UPDATE tblInvoiceDetail SET DeliveryQuantity='" + aInvoiceDetail.Quantity + "',DeliveryBonusQuantity='" + aInvoiceDetail.BonusQuantity + "',DeliveryTotalQuantity='" + aInvoiceDetail.TotalQuantity+ "'," +
                                 "DeliveryTotalPrice='" + aInvoiceDetail.TotalPrice + "',DeliveryTotalPriceVatAmount='" + aInvoiceDetail.TotalPriceVatAmount + "',DeliveryDiscountPercentage='" + aInvoiceDetail.DiscountPercentage + "',DeliveryDiscountAmount='" + aInvoiceDetail.DiscountAmount + "',DeliveryNetAmount='" + aInvoiceDetail.NetAmount + "',DeliveryStatus='" + aInvoiceDetail.DeliveryStatus + "',DelivarySpecialAmount='" + aInvoiceDetail.SpecialAmount + "',ReturnReason='" + aInvoiceDetail.ReturnReason + "' WHERE InvoiceDetailId='" + aInvoiceDetail.InvoiceDetailId + "'  ";
            aCommonInternalDal.UpdateDataByUpdateCommand(updateQuery, "SSIDB");
        }


        public void PaymentUpdateInvoiceDetail(InvoiceDetail aInvoiceDetail)
        {
            string updateQuery = @"UPDATE tblInvoiceDetail SET PaymentQuantity='" + aInvoiceDetail.Quantity + "',PaymentBonusQuantity='" + aInvoiceDetail.BonusQuantity + "',PaymentTotalQuantity='" + aInvoiceDetail.TotalQuantity + "'," +
                                 "PaymentTotalPrice='" + aInvoiceDetail.TotalPrice + "',PaymentTotalPriceVatAmount='" + aInvoiceDetail.TotalPriceVatAmount + "',PaymentDiscountPercentage='" + aInvoiceDetail.DiscountPercentage + "',PaymentDiscountAmount='" + aInvoiceDetail.DiscountAmount + "',PaymentNetAmount='" + aInvoiceDetail.NetAmount + "',PaymentStatus='" + aInvoiceDetail.DeliveryStatus + "',PaymentReturnReason='" + aInvoiceDetail.ReturnReason + "' WHERE InvoiceDetailId='" + aInvoiceDetail.InvoiceDetailId + "'  ";
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
            string query = @"SELECT * FROM dbo.tblProductDiscount WHERE ProductCode='" + productCode.Trim() + "' AND ('" + qty.Trim() + "' BETWEEN MinQty AND MaxQty) AND Status='Active'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable BatchWiseProductQty(string productCode, string comUnitId)
        {
            string query = @"SELECT * FROM tblDCStore WHERE ProductCode='" + productCode.Trim() + "' AND ComUnitId='" + comUnitId.Trim() + "' AND StockQty>0 ORDER BY  ExpDate ASC,BatchNo ASC";
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
            string query = @"    SELECT  I.CustomerType, CellNo,(Addrees2 + '[' +  Address +']')		 as Address	,tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName ,* 				
FROM tblInvoice I
INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
            ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
 INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode  
  INNER JOIN tblArea A ON A.AreaCode = I.AreaCode   
where I.ComUnitId= '" + Dcid + "' and tblD.ManufacId='" + ManufId + "' and tblMarket.MarketId='" + marketid + "' and InvoiceDate='" + invDate + "' order by OrderNo";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
where I.ComUnitId= '" + Dcid + "' and tblD.ManufacId='" + ManufId + "' and I.AreaCode='" + tr + "' and InvoiceDate='" + invDate + "' order by OrderNo";


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
            string query = @"SELECT (isnull(MAX(InvoiceId),0)+1)CountNo FROM dbo.tblInvoice ";

            //string query = @"SELECT  (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,10,11)) AS INT)),0)+1) CountNo FROM dbo.tblInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";
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
        where CU.ComUnitId='" + districtId.Trim() + "' and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "' 		UNION ALL SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,CampaignType AS ProductOffer,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay ,I.MarketName,I.CustomerType as Type FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where CU.ComUnitId='" + districtId.Trim() + "' and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";

            
            
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
       where I.InvoiceDate between '" + fromDate + "' and '" + toDate + "' 	UNION ALL SELECT CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,I.FixedCustomer,CampaignType  AS ProductOffer, CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate,ID.ProductCode,ID.ProductName,ID.PackSize,ID.BatchNo,CONVERT(VARCHAR,DS.ExpDate,103) ExpDate,ID.Quantity,NetAmount,TotalPriceVatAmount,DiscountAmount,ID.SpecialAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode as DistrictCode,I.MarketCode,C.Type as IntransitDay ,I.MarketName,I.CustomerType as Type FROM dbo.tblSubInvoiceMaster I with(nolock) INNER JOIN dbo.tblSubInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId INNER JOIN dbo.tblSubDepotStore DS ON DS.SubDCStoreId = ID.SubDCStoreId where I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable InvoiceMainDataForReport(string invNo, string Code)
        {
            string query = @" SELECT '" + Code + @"'TopSheetGenCode,  ord.OrderSenderName as ReturnInvoiceId, ord.CustomerMasterId,IV.AdjustAmount,IV.ReceivableAmount,IV.FixedCustomer ,da.Name DeliveryPersonName,da.PhoneNo  DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,ct.CustomerType as TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount, tbIn. NetAmount TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName,  (CU.Address) AS CUAddress,  CM.CustomerCode,CM.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,ptt.ProgramTypeName as CategoryName,ord.PaymentType PaymentTypeName,  emp.EmpMasterCode MiaCode,emp.EmpName MiaName,CM.MarketName as UserName
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
                       " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") order by IV.InvoiceNo";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable InvoiceMainDataForReport2(string invNo)
        {
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
                       "  " + invNo.Trim() + "   order by IV.InvoiceNo asc ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable InvoiceMainDatainvNo(string invNo)
        {
            string query = @"SELECT IV.CustomerMasterId, tblOrder.OrderSenderName as ReturnInvoiceId,IV.AdjustAmount,IV.ReceivableAmount,IV.FixedCustomer ,IV.DeliveryPersonName,IV.DeliveryPersonPhNo,IV.InvoiceId,IV.InvoiceNo,IV.InvoiceDate,IV.OrderNo,IV.OrderDate,IV.CustomerType as TpTotal,IV.TpVat,(IV.TpDiscount+isnull(IV.TotalSpecialAmount,0))TpDiscount,tbIn.NetAmount TpGrandTotal,CU.ComUnitCode,CU.ComUnitName as CompanyName,  (CU.Address) AS CUAddress,  tblOrder.CustomerCode,tblOrder.CustomerName, (CM.Address) AS CMAddress,CM.Addrees2,IV.Types as CategoryName,tblOrder.PaymentType PaymentTypeName,  MIA.EmpMasterCode MiaCode,MIA.EmpName MiaName,tblOrder.MarketName_Ord as UserName  FROM tblInvoice IV   with (nolock)
left join (select InvoiceId, sum(tblInvoiceDetail.NetAmount) NetAmount from tblInvoiceDetail group by InvoiceId )tbIn on tbIn.InvoiceId=IV.InvoiceId
 LEFT JOIN tblCompanyUnit CU   with (nolock) ON IV.ComUnitId = CU.ComUnitId 
  LEFT JOIN tblCustMaster CM  with (nolock) ON IV.CustomerMasterId=CM.CustomerMasterId 
   LEFT JOIN tblPaymentType PT  with (nolock) ON IV.PaymentTypeId=PT.PaymentTypeId 
    LEFT JOIN tblUser U  with (nolock) ON IV.UserId=U.UserId  
	 
	 LEFT JOIN tblOrder  with (nolock) on tblOrder.OrderId =IV.OrderId 
    LEFT JOIN dbo.tblEmpGeneralInfo MIA  with (nolock) ON tblOrder.MIOId=MIA.EmpInfoId   where IV.InvoiceId in (" + invNo.Trim() + ")  order by IV.InvoiceNo";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable RInvoiceMainDataForReport(string invNo)
        {
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
                       " WHERE IV.ReturnInvoiceNo in (" + invNo.Trim() + ") ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable FindInvoiceCode(string invNo)
        {
            string query = @"select ReturnInvoiceNo from tblReturnInvoice where ReturnInvoiceId in (" + invNo.Trim() + ") ";
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
                            "   FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId " +
                    "   left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode   WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable InvoiceDetailDataForReport2(string invNo)
        {
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
                      " " + invNo.Trim() + "  order by IVD.ProductName asc";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }



        public DataTable InvoiceDetailDataInvoID(string invNo)
        {
            //string query = @"SELECT IVD.ProductCode,(IVD.ProductName+':'+IVD.PackSize) AS Product,IVD.BatchNo,IVD.BonusQuantity,IVD.Quantity,IVD.UnitPrice, "+
            //                " IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,IVD.DiscountPercentage,IVD.DiscountAmount,IVD.NetAmount,IV.InvoiceId " +
            //                 " FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
            //           //" WHERE IV.InvoiceNo='" + invNo.Trim() + "'";
            //           " WHERE IV.InvoiceNo in (" + invNo.Trim() + ") ";

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,dc.BatchNo,IVD.PackSize as BonusQuantity,IVD.Quantity,IVD.UnitPrice,   IVD.UnitVatAmount,IVD.TotalPrice,IVD.TotalPriceVatAmount,(IVD.DiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage,   (IVD.DiscountAmount+IVD.SpecialAmount)DiscountAmount,IVD.NetAmount,IV.InvoiceId     FROM dbo.tblInvoiceDetail IVD
 LEFT JOIN dbo.tblDCStore dc  ON dc.DCStoreId = IVD.DCStoreId  
 LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId 
   INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId  
   
     left JOIN dbo.tblProductDiscount PD ON PD.CustomerMasterId = I.CustomerMasterId AND PD.ProductCode = IVD.ProductCode   WHERE IVD.InvoiceId in (" + invNo.Trim() + ")  order by IVD.ProductName asc";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable RInvoiceDetailDataForReport(string invNo)
        {
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
                      " WHERE IV.ReturnInvoiceNo in (" + invNo.Trim() + ") ";

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
            string query = @" SELECT tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId   INNER JOIN tblArea A ON A.AreaCode = I.AreaCode  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId='" + SC + "' and p.ManufacId='" + ManufacID + "' and InvoiceDate='" + InvDate + "' and tblMarket.MarketId='" + MarketID + "' " + parameter + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,A.AreaName order by ProductName";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable MarketPickinReport(string SC, string t, int ManufacID, DateTime InvDate, string parameter)
        {
            string query = @" SELECT tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode  " +
                       " WHERE  I.ComUnitId='" + SC + "' and p.ManufacId='" + ManufacID + "' and InvoiceDate='" + InvDate + "' and I.AreaCode='" + t + "' " + parameter + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize order by ProductName";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable DelivaryInvoiceDetailDataForReport(string invNo)
        {

            string query = @"SELECT IVD.ProductCode,(IVD.ProductName) AS Product,IVD.BatchNo,IVD.PackSize as BonusQuantity,IVD.DeliveryQuantity as Quantity,IVD.UnitPrice, " +
                            "  IVD.UnitVatAmount,IVD.DeliveryTotalPrice as TotalPrice,IVD.DeliveryTotalPriceVatAmount as TotalPriceVatAmount,(IVD.DeliveryDiscountPercentage+ISNULL(PD.DiscountPercentage,0))DiscountPercentage, " +
                            "  (IVD.DeliveryDiscountAmount+IVD.DelivarySpecialAmount)DiscountAmount,IVD.DeliveryNetAmount as NetAmount,IV.InvoiceId  " +
                            "   FROM dbo.tblInvoiceDetail IVD LEFT JOIN dbo.tblInvoice IV ON IVD.InvoiceId = IV.InvoiceId " +
                     "  INNER JOIN dbo.tblInvoice I ON I.InvoiceId = IV.InvoiceId " +
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
                        " FROM tblInvoice IV " +
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
        public bool UpdateDCStock(decimal StockQty, int DCStoreId)
        {
            string query = @"UPDATE tblDCStore SET StockQty=StockQty+" + StockQty + " WHERE DCStoreId=" + DCStoreId + "";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
        public bool DCStockInDAL(DCStockNew aDcStockNew)
        {
            string query = @"INSERT INTO dbo.tblDCStoreFreeze " +
       "  ( DCStoreId , " +
         "    DCStoreFreezeId, " +
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
          "   ComUnitId , " +
         "    StockQty , " +
         "    DamageQty , " +
         "    StockRcvDate , " +
         "    ReqId , " +
         "    ReqChildId , " +
         "    StockInTransfarId, " +
         "    StockCondition,ChalanDetailsId " +
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
        public DataTable MArketwiseIntransitReportDAl(string districtId, DateTime fromDate, DateTime toDate, string market,string miacode)
        {
            string miacodea = string.IsNullOrEmpty(miacode) ? "NULL" : "'" + miacode + "'";
            string marketa = string.IsNullOrEmpty(market) ? "NULL" : "'" + market + "'";

            string query =
                       @"SELECT '" + fromDate + "' as fromdate ,'" + toDate + "' as todate ,C.Address as ComUnitCode,CU.ComUnitName," +
                       "C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, " +
                       "tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode," +
                       "I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE," +
                       "I.MIAName as MainMIONAME,C.Type as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) " +
                       "INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount " +
                       "from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId " +
                       "where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL and I.AreaCode=ISNULL(" + marketa + ",I.AreaCode)  and I.MiaCode=ISNULL(" + miacodea + ",I.MiaCode)  and CU.ComUnitId='" + districtId.Trim() + "' and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "' " +
                      
                       "UNION ALL SELECT '" + fromDate + "' as fromdate ,'" + toDate + "' as todate ," +
                       "C.Address as ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo," +
                       "CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal " +
                       "AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode," +
                       "I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) " +
                       "IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,C.Type as SpecialAmount " +
                       "FROM dbo.tblSubInvoiceMaster I WITH(nolock) " +
                       "INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId " +
                       "INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 " +
                       "AND I.DelivaryInvoiceNo IS NULL and  I.AreaCode=ISNULL(" + marketa + ",I.AreaCode) AND I.MiaCode=ISNULL(" + miacodea + ",I.MiaCode)  and CU.ComUnitId='" + districtId.Trim() + "'  " +
                       "and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "' ORDER BY DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) DESC";



            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
                       @"SELECT '" + fromDate + "' as fromdate ,'" + toDate + "' as todate ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo,CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, tblDetails.NetAmount AS NetAmount,tblDetails.UnitVatAmount AS TotalPriceVatAmount,tblDetails.TotalPriceVatAmount  AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as SpecialAmount FROM dbo.tblInvoice I WITH(nolock) INNER JOIN ( select InvoiceId,((Sum(TotalPrice)+Sum(TotalPriceVatAmount))-Sum(DiscountAmount))NetAmount,Sum(TotalPriceVatAmount)UnitVatAmount,(Sum(DiscountAmount))TotalPriceVatAmount from dbo.tblInvoiceDetail group by  InvoiceId) tblDetails ON I.InvoiceId = tblDetails.InvoiceId INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL    and I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'UNION ALL SELECT '" + fromDate + "' as fromdate ,'" + toDate + "' as todate ,CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) OrderDate,I.InvoiceNo, CONVERT(VARCHAR,I.InvoiceDate,103) InvoiceDate, I.TpGrandTotal AS NetAmount,I.TpVat AS TotalPriceVatAmount,I.TpDiscount AS DiscountAmount,I.AreaCode,I.RegionCode as MiaCode,I.DisCode AS DistrictCode ,I.MarketCode,I.MarketName,DATEDIFF(DAY,DATEADD(day, -1, InvoiceDate), GETDATE()) IntransitDay,I.MIACode as MainMIOCODE,I.MIAName as MainMIONAME,I.CustomerType as SpecialAmount FROM dbo.tblSubInvoiceMaster I WITH(nolock) INNER JOIN dbo.tblCompanyUnit CU ON CU.ComUnitId = I.ComUnitId INNER JOIN View_CustomerMaster C ON C.CustomerMasterId = I.CustomerMasterId where I.TpTotal>0 AND I.DelivaryInvoiceNo IS NULL  and  I.InvoiceDate between '" + fromDate + "' and '" + toDate + "'";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public int DeleteInvoice(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderID", Invoice));
            return aCommonInternalDal.RunStoreProcedure("sp_Deletenvoice", aSqlParameterList, "SSIDB");
        }
        public bool SaveDataForReturnAmount(ReturnAmountDAO amountDao)
        {
            string insertQuery = @" INSERT INTO dbo.tblReturnAmount " +
     "   ( CustomerId , " +
                "     InvoiceId , " +
     //"        ReturnInvoiceId , " +
      "       Amount  " +
       "    ) " +
 "  VALUES  ( '" + amountDao.CustomerId + "' , " +
                "   '" + amountDao.InvoiceId + "' , " +
         //"   '" + amountDao.ReturnInvoiceId + "' , " +
         "    '" + amountDao.Amount + "'  " +
      "     )";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        //Pulak

        public DataTable LoadInvoiceWithDetail(string invoiceId)
        {
            string query = @"SELECT '0'SL,ProductCode,OrderDetailsId,ProductName,'0'StockQty,UnitPrice,UnitVatAmount as UnitVAT,Quantity,TotalPrice,DiscountPercentage,DiscountAmount,''IsCampaignProduct,TpVat as VAT,NetAmount as NetPrice,''ISGiftProduct,TotalQuantity as TotalQty,*  FROM tblInvoice
            left join tblInvoiceDetail on tblInvoice.InvoiceId=tblInvoiceDetail.InvoiceId
            where tblInvoiceDetail.InvoiceId='" + invoiceId + "' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadInvoice(string invoicenNo)
        {
            string query = @"select * from tblInvoice where InvoiceNo='" + invoicenNo + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadInvoiceDetailData(string invoiceId)
        {
            string query = "select * from tblInvoiceDetail where InvoiceId='" + invoiceId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public void DeleteInvoice(string invoiceId, string invoicedetailId)
        {
            string updateQuery = @"delete from tblInvoice where InvoiceId='" + invoiceId + "'  delete from tblInvoiceDetail where InvoiceDetailId='" + invoicedetailId + "'";
            aCommonInternalDal.DeleteDataByDeleteCommand(updateQuery, "SSIDB");
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
where I.ComUnitId= '" + Dcid + "' and tblD.ManufacId='" + ManufId + "' and tblMarket.MarketId='" + market + "' and I.AreaCode='" + tr + "' and InvoiceDate='" + invDate + "' order by OrderNo";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable InvoiceDetailDataForReportNew_(string invNoid, string Route, string invDat, string Code)
        {
            string query = @"     SELECT  '"+ Code + @"' TopSheetGenCode,Ct.CustomerType CustomerType, CellNo,(C.Address + '[' +  Address +']')		 as Address	,'Route Name : ' + rt.RouteName as MarketName ,tblD.ManufacId as TpGrandTotal,* 				
FROM tblInvoice I  with (nolock)
INNER JOIN (SELECT DISTINCT D.InvoiceId,sum(NetAmount)ManufacId  FROM dbo.tblInvoice I  with (nolock)
            INNER JOIN dbo.tblInvoiceDetail D  with (nolock) ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P  with (nolock) ON D.ProductCode = P.ProductCode
             group by  D.InvoiceId  ) as tblD ON I.InvoiceId = tblD.InvoiceId  
 INNER JOIN dbo.tblCustMaster C  with (nolock) ON I.CustomerMasterId = C.CustomerMasterId
   INNER JOIN dbo.tblOrder ord  with (nolock) ON I.OrderId = ord.OrderId  
  left JOIN dbo.tblCustomerType Ct  with (nolock) ON ord.CustTypeId = Ct.CustomerTypeId
  
   INNER JOIN dbo.tblRouteInformationMaster rt  with (nolock) ON rt.RouteInformationMasterId = ord.DistributionRouteId 
where I.InvoiceId in (" + invNoid + ")   order by I.InvoiceNo asc";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable MarketPickinReportNew(string SC,int Mrk, string t, int ManufacID, DateTime InvDate, string parameter)
        {
            string query = @" SELECT tblMarket.MarketName + ', Territory Name : ' + A.AreaName as MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity " +
                        " FROM dbo.tblInvoice I " +
                           " INNER JOIN View_CustomerMaster C  ON I.CustomerMasterId = C.CustomerMasterId " +
                        " INNER JOIN dbo.tblMIAInfo M ON C.MiaId = M.MiaId " +
                        " INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId " +
                        " INNER JOIN dbo.tblMarket ON C.MarketId=dbo.tblMarket.MarketId  " +
                        " INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode   INNER JOIN tblArea A ON A.AreaCode = I.AreaCode " +
                       " WHERE  I.ComUnitId='" + SC + "' and p.ManufacId='" + ManufacID + "' and  tblMarket.MarketId='" + Mrk + "' and InvoiceDate='" + InvDate + "' and I.AreaCode='" + t + "' " + parameter + " GROUP BY tblMarket.MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo,D.PackSize,A.AreaName ";
            //  " I.ComUnitId= '2' AND p.ManufacId='1' AND tblMarket.MarketId='9' AND InvoiceDate='7/31/2017 12:00:00 AM'  ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable MarketPickinReportNew_(string invNoid, string Route, string InvDate)
        {
            string query = @"   select distinct * from (SELECT   'Route Name : ' +  rt.RouteName as MarketName,I.InvoiceDate,D.ProductCode,D.ProductName,D.BatchNo as BatchNo,D.PackSize,SUM(D.Quantity) AS Quantity  FROM dbo.tblInvoice I   with (nolock)
  INNER JOIN tblCustMaster C  with (nolock)  ON I.CustomerMasterId = C.CustomerMasterId  
						   
						 INNER JOIN dbo.tblInvoiceDetail D  with (nolock) ON I.InvoiceId = D.InvoiceId  
						INNER JOIN dbo.tblOrder ord  with (nolock) ON I.OrderId = ord.OrderId   
      INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode   
						  INNER JOIN dbo.tblRouteInformationMaster rt  with (nolock) ON rt.RouteInformationMasterId = ord.DistributionRouteId  
   where I.InvoiceId in (" + invNoid + @")   

                         GROUP BY rt.RouteName,I.InvoiceDate,D.ProductCode,D.ProductName , D.BatchNo , D.PackSize ,rt.RouteName ) tbl order by  ProductName asc";
        
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetTopSheetByBatchNo_daaw(string batchNo)
        {
            string query = "EXEC sp_GetTopSheetByBatchNo_daaw '" + batchNo.Replace("'", "''") + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetMarketwisePickingslipByBatchNo_daaw(string batchNo)
        {
            string query = "EXEC sp_GetMarketwisePickingslipByBatchNo_daaw '" + batchNo.Replace("'", "''") + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }

}
