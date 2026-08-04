using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class OrderStatusBll
    {
        OrderStatusDal aOrderStatusDal = new OrderStatusDal();

        public DataTable LoadOrderStatusInfo(string orderNumber)
        {
            return aOrderStatusDal.GetOrderStatusInfo(orderNumber);
        }
        public DataTable LoadOrderStatusInfoTesting(string orderNumber)
        {
            return aOrderStatusDal.LoadOrderStatusInfoTesting(orderNumber);
        }
        public DataTable CheckInvoiceExistOrNot(string orderNo)
        {
            return aOrderStatusDal.GetInvoiceExistOrNot(orderNo);
        }

        public DataTable LoadProformaInvoiceInfo(string orderNo)
        {
            return aOrderStatusDal.GetProformaInvoiceInfo(orderNo);
        }

        public DataTable CheckDeliveryInvoiceExistOrNot(string orderNo)
        {
            return aOrderStatusDal.GetCheckDeliveryInvoiceExistOrNot(orderNo);
        }

        public DataTable LoadDeliveryInvoiceInfo(string orderNo)
        {
            return aOrderStatusDal.GetDeliveryInvoiceInfo(orderNo);
        }

        public DataTable CheckPaymentStatus(string orderNo)
        {
            return aOrderStatusDal.GetCheckPaymentStatus(orderNo);
        }
    }
}

