using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class dadtlsCustPaymentDAL
    {
        private DataAccessManager_daaw  accessManager = new DataAccessManager_daaw ();
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL(); 
        
        
        public bool UpdateAdjustment(int invoiceId)
        {
            bool status = false;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@InvoiceId", invoiceId));
                status = accessManager.UpdateData("sp_Campaign_SetIsAdjustedProbationDiscount", aSqlParameters);
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
        public bool UpdateInvoiceFinalPayment(int invoiceId, decimal PaymentAmount, string ptStatus, string PaymentBy)
        {
            bool status = false;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@InvoiceId", invoiceId));
                aSqlParameters.Add(new SqlParameter("@PaymentAmount", PaymentAmount));
                aSqlParameters.Add(new SqlParameter("@ptStatus", ptStatus));
                aSqlParameters.Add(new SqlParameter("@FinalPaymentBy", PaymentBy));
                status = accessManager.UpdateData("sp_Update_InvoiceFinalPayment", aSqlParameters);
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
        public bool SaveCustPayment(dadtlsCustPayment aCustPayment)
        {
            string insertQuery = BuildSaveCustPaymentQuery(aCustPayment);
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveCustPaymentWithRollback(dadtlsCustPayment aCustPayment, List<dadtlsCustPaymentDetail> paymentDetailList)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                accessManager.ExecuteTextNonQuery(BuildSaveCustPaymentQuery(aCustPayment), null);

                foreach (dadtlsCustPaymentDetail detail in paymentDetailList)
                {
                    List<SqlParameter> updateParameters = new List<SqlParameter>();
                    updateParameters.Add(new SqlParameter("@InvoiceId", detail.InvoiceId));
                    updateParameters.Add(new SqlParameter("@PaymentAmount", detail.PaymentAmount));
                    updateParameters.Add(new SqlParameter("@ptStatus", detail.PaymentStatus));
                    updateParameters.Add(new SqlParameter("@FinalPaymentBy", detail.PaymentBy));
                    accessManager.UpdateData("sp_Update_InvoiceFinalPayment", updateParameters);

                    accessManager.ExecuteTextNonQuery(BuildSaveCustDetailQuery(detail), null);
                }

                accessManager.SqlConnectionClose();
                return true;
            }
            catch
            {
                accessManager.SqlConnectionClose(true);
                throw;
            }
        }

        private string BuildSaveCustPaymentQuery(dadtlsCustPayment aCustPayment)
        {
            string refNo = (aCustPayment.RefNo ?? string.Empty).Replace("'", "''");
            string payType = (aCustPayment.PayType ?? string.Empty).Replace("'", "''");
            string createBy = (aCustPayment.CreateBy ?? string.Empty).Replace("'", "''");
            string refDate = aCustPayment.RefDate.HasValue
                ? "'" + aCustPayment.RefDate.Value.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + "'"
                : "NULL";

            return @"



INSERT INTO dbo.tblCustomerPay
        ( CustPayId ,
          MarketId ,
          CustomerMasterId ,
            ComUnitId,
          PaymentDate ,
          PaymentAmount ,
          PayType ,
          RefNo ,
          RefDate ,
          CreateBy ,
          CreateDate 
          
        )

            values (" + aCustPayment.CustPayId + "," +
                   "'" + aCustPayment.MarketId + "'," +
                    "" + aCustPayment.CustomerMasterId + "," +
                    "" + aCustPayment.ComUnitId + "," +
                    "'" + aCustPayment.PaymentDate.ToString("dd-MMM-yyyy", CultureInfo.InvariantCulture) + "'," +
                    "'" + aCustPayment.PaymentAmount.ToString(CultureInfo.InvariantCulture) + "'," +
                    "'" + payType + "'," +
                    "'" + refNo + "'," +
                    refDate + "," +
                    "'" + createBy + "'," +
                    "'" + aCustPayment.CreateDate.ToString("dd-MMM-yyyy HH:mm:ss", CultureInfo.InvariantCulture) + "'" +
                    //"'" + aCustPayment.UpdateBy + "'," +
                    //"'" + aCustPayment.UpdateDate + "'" +
                                 
                    ")";
        }
        public bool SaveCustDetail(dadtlsCustPaymentDetail aCustPaymentDetail)
        {
            string insertQuery = BuildSaveCustDetailQuery(aCustPaymentDetail);
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        private string BuildSaveCustDetailQuery(dadtlsCustPaymentDetail aCustPaymentDetail)
        {
            string paymentAmount = aCustPaymentDetail.PaymentAmount.ToString(CultureInfo.InvariantCulture);
            string collectionBy = (aCustPaymentDetail.CollectionBy ?? string.Empty).Replace("'", "''");
            string referenceNo = (aCustPaymentDetail.ReferenceNo ?? string.Empty).Replace("'", "''");
            string daNameId = aCustPaymentDetail.DANameId.HasValue
                ? aCustPaymentDetail.DANameId.Value.ToString(CultureInfo.InvariantCulture)
                : "NULL";

            return @"

 DECLARE @CountDataOrd INT
 DECLARE @PaymentAmount DECIMAL(18, 2) = " + paymentAmount + @"
 DECLARE @VatDue DECIMAL(18, 2) = 0
 DECLARE @VATAmount DECIMAL(18, 2) = 0
 DECLARE @TPAmount DECIMAL(18, 2) = 0

    SELECT @CountDataOrd = COUNT(*) FROM dbo.tblCustPayDetail WHERE InvoiceId =" + aCustPaymentDetail.InvoiceId + @" AND CONVERT(DATE, custPaymentDate) = CONVERT(DATE, GETDATE()) AND ISNULL(PaymentAmount, 0) = ISNULL(@PaymentAmount, 0)

    IF (@CountDataOrd = 0)
    BEGIN
    SELECT @VatDue = CASE
                         WHEN ISNULL(INV.DeliveryTpVat, 0) - ISNULL(Paid.PaidVATAmount, 0) < 0 THEN 0
                         ELSE ISNULL(INV.DeliveryTpVat, 0) - ISNULL(Paid.PaidVATAmount, 0)
                     END
    FROM dbo.tblInvoice INV WITH (NOLOCK)
    OUTER APPLY (
        SELECT SUM(ISNULL(VATAmount, 0)) AS PaidVATAmount
        FROM dbo.tblCustPayDetail WITH (NOLOCK)
        WHERE InvoiceId = INV.InvoiceId
    ) Paid
    WHERE INV.InvoiceId = " + aCustPaymentDetail.InvoiceId + @"

    SET @VATAmount = CASE
                         WHEN @PaymentAmount <= 0 THEN 0
                         WHEN @PaymentAmount <= @VatDue THEN @PaymentAmount
                         ELSE @VatDue
                     END
    SET @TPAmount = CASE
                        WHEN @PaymentAmount - @VATAmount < 0 THEN 0
                        ELSE @PaymentAmount - @VATAmount
                    END

INSERT INTO dbo.tblCustPayDetail
        ( CustPayDetailId ,
          InvoiceId ,
          PaymentAmount ,
          CustPayId,TPAmount,VATAmount,CollectionBy ,DANameId,custPaymentDate,ReferenceNo
        )

          
        

            values (" + aCustPaymentDetail.CustPayDetailId+ "," +
                   "'" + aCustPaymentDetail.InvoiceId + "'," +
                    "@PaymentAmount," +
                    "'" + aCustPaymentDetail.CustPayId + "'," +
                     "@TPAmount," +
                      "@VATAmount," + 
                      "'" + collectionBy + "'," +
                      daNameId + "," +
                    "getdate()," +
                      "'" + referenceNo + "'" +


                    @")
    END
    ELSE
    BEGIN
        RAISERROR('Duplicate customer payment detail found for this invoice/payment/date.', 16, 1)
    END";
        }
        public bool SubdeportSaveCustDetail(dadtlsCustPaymentDetail aCustPaymentDetail)
        {
            string insertQuery = @"INSERT INTO dbo.tblCustPayDetail
        ( CustPayDetailId ,
          SubDeportInvoiceId ,
          PaymentAmount ,
          CustPayId
        )

          
        

            values (" + aCustPaymentDetail.CustPayDetailId + "," +
                   "'" + aCustPaymentDetail.InvoiceId + "'," +
                    "" + aCustPaymentDetail.PaymentAmount + "," +
                    "'" + aCustPaymentDetail.CustPayId + "'" +


                    ")";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public void LoadSC(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public void LoadSC(DropDownList ddl, string userId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            //            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit
            //                                LEFT JOIN dbo.tblUserCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblUserCompanyUnit.CompanyUnitId
            //                                WHERE UserId='"+userId+"'";


            string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                               " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId='" + userId.Trim() + "')";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public void LoadManufac(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public bool UpdateInvoicePaymentAmount(string amount,string status,string id)
        {
            string query = @"UPDATE dbo.tblInvoice SET PaymentAmount='" + amount + "',PaymentStatus='"+status+"' WHERE InvoiceId='" + id + "'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
        public bool SubdeportUpdateInvoicePaymentAmount(string amount, string status, string id)
        {
            string query = @"UPDATE dbo.tblSubInvoiceMaster SET PaymentAmount='" + amount + "',PaymentStatus='" + status + "' WHERE InvoiceId='" + id + "'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
     
        public void LoadCustomerMaster(DropDownList ddl, string marketId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblCustMaster WHERE CustomerMasterId IN (SELECT DISTINCT CustomerMasterId FROM dbo.View_CustomerMaster WHERE MarketId='" + marketId + "')";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CustomerName", "CustomerMasterId", queryStr);
        }
        public void PaymentTypeLoad(DropDownList aDropDownList)
        {
            string query = @"select * from tblPaymentType";
            aCommonInternalDal.LoadDropDownValue(aDropDownList, "PaymentTypeName", "PaymentTypeId", query, "SSIDB");
        }

        public void LoadMarket(DropDownList ddl, string comunitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT DISTINCT CM.MarketId,CM.MarketCode,CM.MarketName FROM dbo.tblCompanyUnit Cu
                inner JOIN dbo.View_CustomerMaster CM ON CM.ComUnitCode = Cu.ComUnitCode
                inner JOIN dbo.tblMarket ON tblMarket.MarketCode = CM.MarketCode
                WHERE CU.ComUnitId='" + comunitId + "'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }

        public DataTable LoadInvoice(string comUnitId,string customerId,string marketId)
        {
            string query = @"SELECT top 10 INV.InvoiceId,InvoiceNo,InvoiceDate,DelivaryInvoiceNo,INV.UpdateDate,TotalDelivery,ISNULL(PP,0) PaymentAmount,(ISNULL(TotalDelivery,0) - ISNULL(PP,0)) AS Due,ISNULL(ReturnTotal,0) AdjustableAmount FROM tblInvoice AS INV WITH(NOLOCK)
LEFT JOIN (SELECT InvoiceId,SUM(PaymentAmount) AS PP FROM tblCustPayDetail GROUP BY InvoiceId) AS P ON INV.InvoiceId = P.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(DeliveryNetAmount) AS TotalDelivery FROM tblInvoiceDetail AS IVD WITH(NOLOCK) GROUP BY InvoiceId) AS TD ON INV.InvoiceId = TD.InvoiceId 
LEFT JOIN (SELECT InvoiceId,SUM(TPGrandTotal) ReturnTotal FROM tblReturnInvoice  GROUP BY InvoiceId) AS RTN ON INV.InvoiceId= RTN.InvoiceId
WHERE DelivaryInvoiceNo IS NOT NULL AND INV.DeliveryInvoiceStatus IN ('Full','Partial') 
AND (ISNULL(TotalDelivery,0) - (ISNULL(PP,0) + ISNULL(ReturnTotal,0))) > 0   ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadInvoice(string comUnitId, string marketId)
        {
//            string query = @"SELECT ISNULL(PaymentAmount,0)PaymentAmount,*,(DeliveryTpGrandTotal-(isnull(PaymentAmount,0)+ISNULL(AdjustAmount,0))) AS Due,ISNULL(AdjustAmount,0)AjAmt FROM dbo.tblInvoice
//            
//            inner JOIN dbo.View_CustomerMaster ON dbo.tblInvoice.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
//            WHERE  DeliveryTpGrandTotal > 0 AND MarketId='" + marketId + "' AND dbo.tblInvoice.ComUnitId='" + comUnitId + "'  AND (PaymentStatus IS NULL OR PaymentStatus='Partial') AND (DelivaryInvoiceNo IS NOT NULL) AND (DeliveryInvoiceStatus ='Partial' or DeliveryInvoiceStatus ='Full')";


            string query = @"SELECT ISNULL(PaymentAmount,0)PaymentAmount,*,(DeliveryTpGrandTotal-(isnull(PaymentAmount,0)+ISNULL(AdjustAmount,0))) AS Due,ISNULL(AdjustAmount,0)AjAmt FROM dbo.tblInvoice
            
            inner JOIN dbo.View_CustomerMaster ON dbo.tblInvoice.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
            WHERE  DeliveryTpGrandTotal > 0  AND dbo.tblInvoice.ComUnitId='" + comUnitId + "'  AND (PaymentStatus IS NULL OR PaymentStatus='Partial') AND (DelivaryInvoiceNo IS NOT NULL) AND (DeliveryInvoiceStatus ='Partial' or DeliveryInvoiceStatus ='Full')";
            
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadSubDeportInvoice(string comUnitId, string marketId)
        {
            string query = @"SELECT ISNULL(PaymentAmount,0)PaymentAmount,*,(DeliveryTpGrandTotal-isnull(PaymentAmount,0)) AS Due FROM dbo.tblSubInvoiceMaster

            inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
            WHERE  DeliveryTpGrandTotal > 0 AND MarketId='" + marketId + "' AND dbo.tblSubInvoiceMaster.ComUnitId='" + comUnitId + "'  AND (PaymentStatus IS NULL OR PaymentStatus='Partial') AND (DelivaryInvoiceNo IS NOT NULL) AND (DeliveryInvoiceStatus ='Partial' or DeliveryInvoiceStatus ='Full')";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetPrevAmount(string invoiceId)
        {
            string query = @"SELECT PaymentAmount, 
         FROM dbo.tblInvoice WHERE InvoiceId='" + invoiceId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable Existence(string invoiceId, string Amount)
        {
            string query = @"SELECT *
            FROM dbo.tblCustPayDetail
            WHERE  dbo.tblCustPayDetail.InvoiceId='" + invoiceId + "' AND dbo.tblCustPayDetail.PaymentAmount='" + Amount + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public CustomerMaster CustomerLoad(string CustomerCode)
        {
            string query = @"SELECT CustomerMasterId FROM dbo.tblCustMaster WHERE CustomerCode= '" + CustomerCode + "'";
                             
            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            CustomerMaster aCustomerMaster = new CustomerMaster();
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    aCustomerMaster.CustomerMasterId = Int32.Parse(dataReader["CustomerMasterId"].ToString());
                }
            }
            return aCustomerMaster;
        }
        public CustomerMaster DetailCustomerLoad(string CustomerCode)
        {
            string query = @"SELECT * FROM dbo.tblCustMaster WHERE CustomerCode= '" + CustomerCode + "'";

            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            CustomerMaster aCustomerMaster = new CustomerMaster();
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    aCustomerMaster.CustomerMasterId = Int32.Parse(dataReader["CustomerMasterId"].ToString());
                    aCustomerMaster.CustomerCode = (dataReader["CustomerCode"].ToString());
                    aCustomerMaster.CustomerName = (dataReader["CustomerName"].ToString());
                }
            }
            return aCustomerMaster;
        }
        public Product DetailProductLoad(string ProductCode)
        {
            string query = @"SELECT * FROM dbo.tblProduct WHERE ProductCode= '" + ProductCode + "'";

            IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
            Product aProduct = new Product();
            if (dataReader != null)
            {
                while (dataReader.Read())
                {
                    aProduct.ProductId = Int32.Parse(dataReader["ProductId"].ToString());
                    aProduct.ProductCode = (dataReader["ProductCode"].ToString());
                    aProduct.ProductName = (dataReader["ProductName"].ToString());
                }
            }
            return aProduct;
        }
    }
}

