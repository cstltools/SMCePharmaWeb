using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.SInventory_DAL
{
    public class OrderStatusDal
    {
        public DataTable GetOrderStatusInfo(string orderNumber)
        {
            string query = @"SELECT *, ORDRD.CampaignName as CampaignName2 from tblOrder AS ORDR WITH(NOLOCK)
                            INNER JOIN tblOrderDetail AS ORDRD ON ORDR.OrderId = ORDRD.OrderId
                            WHERE ORDR.OrderCode = @OrderNumber";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNumber", SInventorySql.DbValue(orderNumber))
            });
        }
        public DataTable LoadOrderStatusInfoTesting(string orderNumber)
        {
            string query = @"SELECT *, (GrossValue*DiscountPercent)/100 as DisAmt from SystemTest_Testing..OrderListDetail O
                            WHERE O.OrderCode = @OrderNumber";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNumber", SInventorySql.DbValue(orderNumber))
            });
        }
        public DataTable GetInvoiceExistOrNot(string orderNo)
        {
            string query = @"SELECT * FROM tblInvoice AS INV WITH(NOLOCK)
                            WHERE INV.OrderNo = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }

        public DataTable GetProformaInvoiceInfo(string orderNo)
        {
            string query = @"SELECT * FROM tblInvoice AS INV WITH(NOLOCK)
                           INNER JOIN tblInvoiceDetail INVD ON INV.InvoiceId = INVD.InvoiceId
                           WHERE INV.OrderNo = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }

        public DataTable GetCheckDeliveryInvoiceExistOrNot(string orderNo)
        {
            string query = @"SELECT * FROM tblInvoice AS INV WITH(NOLOCK)
                            INNER JOIN tblInvoiceDetail INVD ON INV.InvoiceId = INVD.InvoiceId
                            WHERE INV.DeliveryInvoiceStatus IS NOT NULL AND
                            INV.OrderNo = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }

        public DataTable GetDeliveryInvoiceInfo(string orderNo)
        {
            string query = @"SELECT * FROM tblInvoice AS INV WITH(NOLOCK)
                           INNER JOIN tblInvoiceDetail INVD ON INV.InvoiceId = INVD.InvoiceId
                           WHERE INV.OrderNo = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }

        public DataTable GetCheckPaymentStatus(string orderNo)
        {
            string query = @"SELECT  [PaymentAmount],[PaymentStatus] FROM tblInvoice AS INV WITH(NOLOCK)
                             WHERE INV.PaymentAmount IS NOT NULL AND INV.PaymentStatus IS NOT NULL AND INV.OrderNo = @OrderNo";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderNo", SInventorySql.DbValue(orderNo))
            });
        }
    }
}
