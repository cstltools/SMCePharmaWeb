using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class PaymentReverseDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetOrderInformationByOrderNo(string orderNo)
        {
            string query = @"SELECT INV.InvoiceId FROM dbo.tblOrder AS ODR 
                             LEFT JOIN dbo.tblInvoice AS INV ON ODR.OrderId = INV.OrderId
                             WHERE (INV.DeliveryInvoiceStatus IS NOT NULL AND INV.DeliveryInvoiceStatus NOT IN ('Reject')) AND ODR.OrderCode = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }

        public DataTable subdepoGetOrderInformationByOrderNo(string orderNo)
        {
            string query = @"SELECT INV.InvoiceId FROM dbo.tblOrder AS ODR 
                             LEFT JOIN dbo.tblSubInvoiceMaster AS INV ON ODR.OrderId = INV.OrderId
                             WHERE (INV.DeliveryInvoiceStatus IS NOT NULL AND INV.DeliveryInvoiceStatus NOT IN ('Reject')) AND ODR.OrderCode = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }


        public bool subResetInvoicePaymentStatus(int inoiceId)
        {
            string query = @"UPDATE dbo.tblSubInvoiceMaster SET PaymentStatus = NULL,PaymentAmount = NULL WHERE InvoiceId = @InvoiceId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", inoiceId)
            });
        }




        public bool ResetInvoicePaymentStatus(int inoiceId)
        {
            string query = @"UPDATE dbo.tblInvoice SET PaymentStatus = NULL,PaymentAmount = NULL WHERE InvoiceId = @InvoiceId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", inoiceId)
            });
        }

        public DataTable GetPaymentInfoByInvoiceId(int inoiceId)
        {
            string query = @"SELECT PD.CustPayDetailId,PD.CustPayId FROM dbo.tblCustPayDetail AS PD WHERE PD.InvoiceId = @InvoiceId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", inoiceId)
            });
        }

        public DataTable subdGetPaymentInfoByInvoiceId(int inoiceId)
        {
            string query = @"SELECT PD.CustPayDetailId,PD.CustPayId FROM dbo.tblCustPayDetail AS PD WHERE PD.SubDeportInvoiceId = @InvoiceId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", inoiceId)
            });
        }


        public DataTable SubdepoGetPaymentInfoByInvoiceId(int inoiceId)
        {
            string query = @"SELECT PD.CustPayDetailId,PD.CustPayId FROM dbo.tblCustPayDetail AS PD WHERE PD.InvoiceId = @InvoiceId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceId", inoiceId)
            });
        }
        public bool DeletePaymentDetail(int payId)
        {
            string query = @"DELETE FROM dbo.tblCustPayDetail WHERE CustPayId = @CustPayId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@CustPayId", payId)
            });
        }

        public bool DeletePaymentMaster(int payId)
        {
            string query = @"DELETE FROM dbo.tblCustomerPay WHERE CustPayId = @CustPayId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@CustPayId", payId)
            });
        }
    }
}
