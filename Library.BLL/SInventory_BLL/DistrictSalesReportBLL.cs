using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class DistrictSalesReportBLL
    {
        DistrictSalesReportDAL aDistrictSalesReportDal = new DistrictSalesReportDAL();

        public void LoadComUnit(DropDownList dropDownList)
        {
            aDistrictSalesReportDal.LoadComUnit(dropDownList);
        }
        public void LoadComUnit(DropDownList dropDownList, string comUnitId)
        {
            aDistrictSalesReportDal.LoadComUnit(dropDownList,comUnitId);
        }
        //public void LoadZone(DropDownList dropDownList, string comUnitId)
        //{
        //    aDistrictSalesReportDal.LoadZoneName(dropDownList, comUnitId);
        //}

        public void LoadDistrict(DropDownList dropDownList, string comUnitId)
        {
        aDistrictSalesReportDal.LoadDistrict(dropDownList, comUnitId);
        }

        public DataTable DistrictReportMainDataBLL(string districtId, DateTime fromDate, DateTime toDate)
        {

            return aDistrictSalesReportDal.DistrictReportMainDataDAL(districtId, fromDate, toDate);
        }


        public DataTable DistrictReportDetailDataBLL(string districtId, DateTime fromDate, DateTime toDate)
        {

            return aDistrictSalesReportDal.DistrictReportDetailDataDAL(districtId, fromDate, toDate);
        }
    }
}
