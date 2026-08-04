using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class CustPaymentDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
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
        public bool SaveCustPayment(CustPayment aCustPayment)
        {
            string insertQuery = @"



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

            values (@CustPayId,@MarketId,@CustomerMasterId,@ComUnitId,@PaymentDate,@PaymentAmount,@PayType,@RefNo,@RefDate,@CreateBy,@CreateDate)";
            return SInventorySql.Execute(insertQuery, CustPaymentParameters(aCustPayment));
        }
        public bool SaveCustDetail(CustPaymentDetail aCustPaymentDetail)
        {
            string insertQuery = @"

 DECLARE @CountDataOrd INT
    SELECT @CountDataOrd = COUNT(*) FROM dbo.tblCustPayDetail WHERE InvoiceId=@InvoiceId AND CONVERT(DATE, custPaymentDate) = CONVERT(DATE, GETDATE()) AND ISNULL(PaymentAmount, 0) = ISNULL(@PaymentAmount, 0)

    IF (@CountDataOrd = 0)
    BEGIN
INSERT INTO dbo.tblCustPayDetail
        ( CustPayDetailId ,
          InvoiceId ,
          PaymentAmount ,
          CustPayId,TPAmount,VATAmount,CollectionBy ,DANameId,custPaymentDate
        )

          
        

            values (@CustPayDetailId,@InvoiceId,@PaymentAmount,@CustPayId,@TPAmount,@VATAmount,@CollectionBy,@DANameId,getdate())  end";
            return SInventorySql.Execute(insertQuery, CustPaymentDetailParameters(aCustPaymentDetail));
        }
        public bool SubdeportSaveCustDetail(CustPaymentDetail aCustPaymentDetail)
        {
            string insertQuery = @"INSERT INTO dbo.tblCustPayDetail
        ( CustPayDetailId ,
          SubDeportInvoiceId ,
          PaymentAmount ,
          CustPayId
        )

          
        

            values (@CustPayDetailId,@InvoiceId,@PaymentAmount,@CustPayId)";
            return SInventorySql.Execute(insertQuery, CustPaymentDetailParameters(aCustPaymentDetail));
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
                               " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr, SingleParameter("@UserId", userId == null ? null : userId.Trim()));
        }
        public void LoadManufac(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public bool UpdateInvoicePaymentAmount(string amount,string status,string id)
        {
            string query = @"UPDATE dbo.tblInvoice SET PaymentAmount=@PaymentAmount,PaymentStatus=@PaymentStatus WHERE InvoiceId=@InvoiceId";
            return SInventorySql.Execute(query, InvoicePaymentParameters(amount, status, id));
        }
        public bool SubdeportUpdateInvoicePaymentAmount(string amount, string status, string id)
        {
            string query = @"UPDATE dbo.tblSubInvoiceMaster SET PaymentAmount=@PaymentAmount,PaymentStatus=@PaymentStatus WHERE InvoiceId=@InvoiceId";
            return SInventorySql.Execute(query, InvoicePaymentParameters(amount, status, id));
        }
     
        public void LoadCustomerMaster(DropDownList ddl, string marketId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblCustMaster WHERE CustomerMasterId IN (SELECT DISTINCT CustomerMasterId FROM dbo.View_CustomerMaster WHERE MarketId=@MarketId)";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CustomerName", "CustomerMasterId", queryStr, SingleParameter("@MarketId", marketId));
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
                WHERE CU.ComUnitId=@ComUnitId";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr, SingleParameter("@ComUnitId", comunitId));
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
            WHERE  DeliveryTpGrandTotal > 0  AND dbo.tblInvoice.ComUnitId=@ComUnitId  AND (PaymentStatus IS NULL OR PaymentStatus='Partial') AND (DelivaryInvoiceNo IS NOT NULL) AND (DeliveryInvoiceStatus ='Partial' or DeliveryInvoiceStatus ='Full')";
            
            return SInventorySql.GetDataTable(query, SingleParameter("@ComUnitId", comUnitId));
        }
        public DataTable LoadSubDeportInvoice(string comUnitId, string marketId)
        {
            string query = @"SELECT ISNULL(PaymentAmount,0)PaymentAmount,*,(DeliveryTpGrandTotal-isnull(PaymentAmount,0)) AS Due FROM dbo.tblSubInvoiceMaster

            inner JOIN dbo.View_CustomerMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.View_CustomerMaster.CustomerMasterId
            WHERE  DeliveryTpGrandTotal > 0 AND MarketId=@MarketId AND dbo.tblSubInvoiceMaster.ComUnitId=@ComUnitId  AND (PaymentStatus IS NULL OR PaymentStatus='Partial') AND (DelivaryInvoiceNo IS NOT NULL) AND (DeliveryInvoiceStatus ='Partial' or DeliveryInvoiceStatus ='Full')";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId)),
                new SqlParameter("@MarketId", SInventorySql.DbValue(marketId))
            });
        }
        public DataTable GetPrevAmount(string invoiceId)
        {
            string query = @"SELECT PaymentAmount, 
         FROM dbo.tblInvoice WHERE InvoiceId=@InvoiceId";
            return SInventorySql.GetDataTable(query, SingleParameter("@InvoiceId", invoiceId));
        }

        public DataTable Existence(string invoiceId, string Amount)
        {
            string query = @"SELECT *
            FROM dbo.tblCustPayDetail
            WHERE  dbo.tblCustPayDetail.InvoiceId=@InvoiceId AND dbo.tblCustPayDetail.PaymentAmount=@PaymentAmount";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", SInventorySql.DbValue(invoiceId)),
                new SqlParameter("@PaymentAmount", SInventorySql.DbValue(Amount))
            });
        }


        public CustomerMaster CustomerLoad(string CustomerCode)
        {
            string query = @"SELECT CustomerMasterId FROM dbo.tblCustMaster WHERE CustomerCode=@CustomerCode";
            DataTable dataTable = SInventorySql.GetDataTable(query, SingleParameter("@CustomerCode", CustomerCode));
            CustomerMaster aCustomerMaster = new CustomerMaster();
            foreach (DataRow dataReader in dataTable.Rows)
            {
                aCustomerMaster.CustomerMasterId = Int32.Parse(dataReader["CustomerMasterId"].ToString());
                break;
            }
            return aCustomerMaster;
        }
        public CustomerMaster DetailCustomerLoad(string CustomerCode)
        {
            string query = @"SELECT * FROM dbo.tblCustMaster WHERE CustomerCode=@CustomerCode";

            DataTable dataTable = SInventorySql.GetDataTable(query, SingleParameter("@CustomerCode", CustomerCode));
            CustomerMaster aCustomerMaster = new CustomerMaster();
            foreach (DataRow dataReader in dataTable.Rows)
            {
                aCustomerMaster.CustomerMasterId = Int32.Parse(dataReader["CustomerMasterId"].ToString());
                aCustomerMaster.CustomerCode = (dataReader["CustomerCode"].ToString());
                aCustomerMaster.CustomerName = (dataReader["CustomerName"].ToString());
                break;
            }
            return aCustomerMaster;
        }
        public Product DetailProductLoad(string ProductCode)
        {
            string query = @"SELECT * FROM dbo.tblProduct WHERE ProductCode=@ProductCode";

            DataTable dataTable = SInventorySql.GetDataTable(query, SingleParameter("@ProductCode", ProductCode));
            Product aProduct = new Product();
            foreach (DataRow dataReader in dataTable.Rows)
            {
                aProduct.ProductId = Int32.Parse(dataReader["ProductId"].ToString());
                aProduct.ProductCode = (dataReader["ProductCode"].ToString());
                aProduct.ProductName = (dataReader["ProductName"].ToString());
                break;
            }
            return aProduct;
        }

        private List<SqlParameter> CustPaymentParameters(CustPayment p)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@CustPayId", p.CustPayId),
                new SqlParameter("@MarketId", SInventorySql.DbValue(p.MarketId)),
                new SqlParameter("@CustomerMasterId", p.CustomerMasterId),
                new SqlParameter("@ComUnitId", p.ComUnitId),
                new SqlParameter("@PaymentDate", p.PaymentDate),
                new SqlParameter("@PaymentAmount", p.PaymentAmount),
                new SqlParameter("@PayType", SInventorySql.DbValue(p.PayType)),
                new SqlParameter("@RefNo", SInventorySql.DbValue(p.RefNo)),
                new SqlParameter("@RefDate", SInventorySql.DbValue(p.RefDate)),
                new SqlParameter("@CreateBy", SInventorySql.DbValue(p.CreateBy)),
                new SqlParameter("@CreateDate", p.CreateDate)
            };
        }

        private List<SqlParameter> CustPaymentDetailParameters(CustPaymentDetail d)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@CustPayDetailId", d.CustPayDetailId),
                new SqlParameter("@InvoiceId", d.InvoiceId),
                new SqlParameter("@PaymentAmount", d.PaymentAmount),
                new SqlParameter("@CustPayId", d.CustPayId),
                new SqlParameter("@TPAmount", d.TPAmount),
                new SqlParameter("@VATAmount", d.VATAmount),
                new SqlParameter("@CollectionBy", SInventorySql.DbValue(d.CollectionBy)),
                new SqlParameter("@DANameId", SInventorySql.DbValue(d.DANameId))
            };
        }

        private List<SqlParameter> InvoicePaymentParameters(string amount, string status, string id)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@PaymentAmount", SInventorySql.DbValue(amount)),
                new SqlParameter("@PaymentStatus", SInventorySql.DbValue(status)),
                new SqlParameter("@InvoiceId", SInventorySql.DbValue(id))
            };
        }

        private List<SqlParameter> SingleParameter(string name, object value)
        {
            return new List<SqlParameter>
            {
                new SqlParameter(name, SInventorySql.DbValue(value))
            };
        }
    }
}
