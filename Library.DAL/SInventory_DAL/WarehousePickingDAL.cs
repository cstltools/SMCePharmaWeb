using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
  public class WarehousePickingDAL
    {
      ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
      public DataTable StockTransportPickingGridDataDAL(DateTime date)
      {
          string query = @"SELECT * FROM dbo.tblRequisition WHERE CreatePicking=@CreatePicking AND PickingDate=@PickingDate order by ReqId desc";
          return SInventorySql.GetDataTable(query, new List<SqlParameter>
          {
              new SqlParameter("@CreatePicking", "OK"),
              new SqlParameter("@PickingDate", date)
          });
      }
    }
}
