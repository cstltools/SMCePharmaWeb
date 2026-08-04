using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class ShortExpProductDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public DataTable ShortExpProduct(DateTime fromdate,DateTime todate)
        {
            string query = @"select (ProductCode+':'+ProductName) as Product,ExpDate  from tblDCStore where ExpDate between '"+fromdate+"' and '"+todate+"' order by ExpDate";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

    }
}
