using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class ComUnitSalesReportBLL
    {
        ComUnitSalesReportDAL aComUnitSalesReportDAL = new ComUnitSalesReportDAL();

        public void LoadComUnit(DropDownList dropDownList)
        {
            aComUnitSalesReportDAL.LoadComUnit(dropDownList);
        }
        public void LoadComUnit(DropDownList dropDownList,string comUnitId)
        {
            aComUnitSalesReportDAL.LoadComUnit(dropDownList,comUnitId);
        }

        public DataTable ComUnitSalesReportMainDataBLL(string ComUnitId, DateTime fromDate, DateTime toDate)
        {
            return aComUnitSalesReportDAL.ComUnitReportMainDataDAL(ComUnitId, fromDate, toDate);
        }
        public DataTable ComUnitSalesReportDetailDataBLL(string ComUnitId, DateTime fromDate, DateTime toDate)
        {
            return aComUnitSalesReportDAL.ComUnitReportDetailDataDAL(ComUnitId, fromDate, toDate);
        }
    }
}
