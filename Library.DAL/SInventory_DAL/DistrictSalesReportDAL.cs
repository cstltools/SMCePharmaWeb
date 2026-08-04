using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class DistrictSalesReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public void LoadComUnit(DropDownList dropDownList)
        {
            string query = @"SELECT * from tblCompanyUnit ";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "ComUnitName", "ComUnitId", query, "SSIDB");
        }
        public void LoadComUnit(DropDownList dropDownList,string comUnitId)
        {
            string query = @"SELECT * from tblCompanyUnit where ComUnitId='"+comUnitId+"'" ;
            aCommonInternalDal.LoadDropDownValue(dropDownList, "ComUnitName", "ComUnitId", query, "SSIDB");
        }
       
        //public void LoadZoneName(DropDownList dropDownList, string comunitId)
        //{
        //    string query = @"SELECT  * from tblZone WHERE ComUnitId='" + comunitId.Trim() + "'";
        //    aCommonInternalDal.LoadDropDownValue(dropDownList, "ZoneName", "ZoneId", query, "SSIDB");
        //}

        public void LoadDistrict(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT DISTINCT DistrictName,DistrictId FROM dbo.View_CustomerMaster WHERE DistrictId IN (SELECT DistrictId FROM dbo.tblDistrict) AND dbo.View_CustomerMaster.ComUnitId='" + comUnitId.Trim() + "'";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "DistrictName", "DistrictId", query, "SSIDB");
        }
        public DataTable DistrictReportMainDataDAL(string distId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select DISTINCT (DistrictCode+':'+DistrictName) as District , '" + fromDate + "' as Fromdate,'" + toDate + "' as Todate from View_CustomerMaster where DistrictId='" + distId + "' ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable DistrictReportDetailDataDAL(string districtId, DateTime fromDate, DateTime toDate)
        {
            string query =
                @"select ProductCode,Product, sum(TotalQuantity) as TotalQty ,sum(Price) as TotalAmount from View_MIAWiseSalesReport  where MiaId in (select MiaId from View_CustomerMaster where DistrictId='" + districtId.Trim() + "') and InvoiceDate between '" + fromDate + "' and '" + toDate + "' group by ProductCode,Product";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
    
}
