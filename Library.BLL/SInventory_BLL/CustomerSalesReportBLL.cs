using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class CustomerSalesReportBLL
    {
        CustomerSalesReportDAL aCustomerSalesReportDal = new CustomerSalesReportDAL();

        public void LoadComUnit(DropDownList dropDownList)
        {
            aCustomerSalesReportDal.LoadComUnit(dropDownList);
        }
        public void LoadComUnit(DropDownList dropDownList,string comUnitId)
        {
            aCustomerSalesReportDal.LoadComUnit(dropDownList,comUnitId);
        }

        public void LoadDistrictByComUnit(DropDownList dropDownList,string comUnitId)
        {
            aCustomerSalesReportDal.LoadDistrict(dropDownList,comUnitId);
        }

        public void LoadAreaByDistrict(DropDownList dropDownList, string districtId)
        {
            aCustomerSalesReportDal.LoadArea(dropDownList,districtId);
        }

        public void LoadMarketByArea(DropDownList dropDownList, string areaId)
        {
            aCustomerSalesReportDal.LoadMarket(dropDownList, areaId);
        }

        public void LoadCustomerByMarket(DropDownList dropDownList, string marketId)
        {
            aCustomerSalesReportDal.LoadCustomer(dropDownList, marketId);
        }
        
        public DataTable CustomerReportMainDataBLL(string custId, DateTime fromDate, DateTime toDate)
        {

            return aCustomerSalesReportDal.CustomerReportMainDataDAL(custId, fromDate, toDate);
        }


        public DataTable CustomerReportDetailDataBLL(string custId, DateTime fromDate, DateTime toDate)
        {

            return aCustomerSalesReportDal.CustomerReportDetailDataDAL(custId, fromDate, toDate);
        }
    }
}
