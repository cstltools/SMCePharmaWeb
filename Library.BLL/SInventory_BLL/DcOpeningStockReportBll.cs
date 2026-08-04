using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class DcOpeningStockReportBll
    {
        DcOpeningStockReportDal aOpeningStockReportDal = new DcOpeningStockReportDal();

        public void DCLoad(DropDownList aDownList)
        {
            aOpeningStockReportDal.DCLoad(aDownList);

        }

        public DataTable LoadAllDcOpeningStockReport(string date)
        {
            return aOpeningStockReportDal.GetAllDcOpeningStockReport(date);
        }

        public DataTable LoadDcOpeningStockReport(int dcId, string date)
        {
            return aOpeningStockReportDal.GetDcOpeningStockReport(dcId,date);
        }
    }
}
