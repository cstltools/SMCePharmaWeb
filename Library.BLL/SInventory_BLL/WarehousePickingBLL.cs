using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
   public class WarehousePickingBLL
    {
       WarehousePickingDAL aWarehousePickingDal = new WarehousePickingDAL();
       public DataTable StockTransportPickingGridDataBLL(DateTime date)
       {
           return aWarehousePickingDal.StockTransportPickingGridDataDAL(date);
       }
    }
}
