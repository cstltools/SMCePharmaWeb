using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class RegionSalesReportBLL
    {
        RegionSalesReportDAL aRegionSalesReportDal = new RegionSalesReportDAL();

        public void LoadRegion(DropDownList dropDownList)
        {
            aRegionSalesReportDal.LoadRegion(dropDownList);
        }
        public void LoadRegion(DropDownList dropDownList,string RegionId)
        {
            aRegionSalesReportDal.LoadRegion(dropDownList,RegionId);
        }

        public DataTable RegionSalesReportMainDataBLL(string RegionId, DateTime fromDate, DateTime toDate)
        {
            return aRegionSalesReportDal.RegionReportMainDataDAL(RegionId, fromDate, toDate);
        }
        public DataTable RegionSalesReportDetailDataBLL(string RegionId, DateTime fromDate, DateTime toDate)
        {
            return aRegionSalesReportDal.RegionReportDetailDataDAL(RegionId, fromDate, toDate);
        }
    }
}
