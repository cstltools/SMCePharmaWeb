using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class PendingOrderBll
    {
        PendingOrderDal aOrderDal = new PendingOrderDal();

        public DataTable LoadPendingOrderInformation(string SC, string fromdate, string todate)
        {
            return aOrderDal.GetPendingOrderInformation(SC,fromdate, todate);
        }

        public string LoadOrderExistOrNotInfo(string orderCode) 
        {
            string msg = "";

            DataTable aDataTable = new DataTable();
            aDataTable = aOrderDal.GetOrderExistOrNotInfo(orderCode);

            if (aDataTable.Rows.Count == 0)
            {
                aDataTable = aOrderDal.GetOrderDetailsInfo(orderCode);

                Int32 OrderMasterID = 0;
                String OrderCode = "";

                if(aDataTable.Rows.Count > 0)
                {
                    OrderMasterID = aDataTable.Rows[0].Field<Int32>("OrderMasterID");
                    OrderCode = aDataTable.Rows[0].Field<String>("OrderCode");

                    bool status=  aOrderDal.SaveOrderGenerationInfo(OrderMasterID, OrderCode);

                    if (status==true)
                    {
                        msg = "Order Processed";
                       // LoadPendingOrderInformation();
                    }
                    else
                    {
                        msg = "Order Processed";
                       // msg = "Error!!";
                    }
                }
              
            }

            return msg;
        }
    }
}
