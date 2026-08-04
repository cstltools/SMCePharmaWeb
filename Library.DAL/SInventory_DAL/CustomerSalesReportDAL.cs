
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class CustomerSalesReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public void LoadComUnit(DropDownList dropDownList)
        {
            string query = @"SELECT * from tblCompanyUnit ";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "ComUnitName", "ComUnitId", query, "SSIDB");
        }
        public void LoadComUnit(DropDownList dropDownList,string comUnitId)
        {
            string query = @"SELECT * from tblCompanyUnit where ComUnitId=@ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "ComUnitName", "ComUnitId", query, SingleParameter("@ComUnitId", comUnitId));
        }

        public void LoadDistrict(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT DISTINCT DistrictName,DistrictId FROM dbo.View_CustomerMaster WHERE DistrictId IN (SELECT DistrictId FROM dbo.tblDistrict) AND dbo.View_CustomerMaster.ComUnitId=@ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "DistrictName", "DistrictId", query, SingleParameter("@ComUnitId", comUnitId == null ? null : comUnitId.Trim()));
        }

        public void LoadArea(DropDownList dropDownList, string districtId)
        {
            string query = @"SELECT DISTINCT AreaId,AreaName FROM dbo.View_CustomerMaster WHERE AreaId IN (SELECT AreaId FROM dbo.tblArea) AND dbo.View_CustomerMaster.DistrictId=@DistrictId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "AreaName", "AreaId", query, SingleParameter("@DistrictId", districtId == null ? null : districtId.Trim()));
        }

        public void LoadMarket(DropDownList dropDownList, string areaId)
        {
            string query = @"SELECT DISTINCT MarketId,MarketName FROM dbo.View_CustomerMaster WHERE MarketId IN (SELECT MarketId FROM dbo.tblMarket) AND dbo.View_CustomerMaster.AreaId=@AreaId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "MarketName", "MarketId", query, SingleParameter("@AreaId", areaId == null ? null : areaId.Trim()));
        }

        public void LoadCustomer(DropDownList dropDownList, string areaId)
        {
            string query = @"SELECT DISTINCT CustomerMasterId,CustomerName FROM dbo.View_CustomerMaster WHERE CustomerMasterId IN (SELECT CustomerMasterId FROM dbo.tblCustMaster) AND dbo.View_CustomerMaster.MarketId=@MarketId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(dropDownList, "CustomerName", "CustomerMasterId", query, SingleParameter("@MarketId", areaId == null ? null : areaId.Trim()));
        }

        public DataTable CustomerReportMainDataDAL(string custId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select (CustomerCode+':'+CustomerName) as CustDetail,Address,MarketName,AreaName,DistrictName,ComUnitName,@FromDate as FromDate,@ToDate as ToDate
from View_CustomerMaster where CustomerMasterId=@CustomerMasterId";

            return SInventorySql.GetDataTable(query, CustomerReportParameters(custId, fromDate, toDate));
        }

        public DataTable CustomerReportDetailDataDAL(string custId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select ProductCode,Product,sum(TotalQuantity) as Total, sum(Price) as TotalPrice
from View_MIAWiseSalesReport
where CustomerMasterId=@CustomerMasterId and InvoiceDate between @FromDate and @ToDate
group by ProductCode,Product order by ProductCode";


            return SInventorySql.GetDataTable(query, CustomerReportParameters(custId, fromDate, toDate));
        }

        private List<SqlParameter> CustomerReportParameters(string custId, DateTime fromDate, DateTime toDate)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@CustomerMasterId", SInventorySql.DbValue(custId)),
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            };
        }

        private List<SqlParameter> SingleParameter(string name, object value)
        {
            return new List<SqlParameter>
            {
                new SqlParameter(name, SInventorySql.DbValue(value))
            };
        }
    }
}
