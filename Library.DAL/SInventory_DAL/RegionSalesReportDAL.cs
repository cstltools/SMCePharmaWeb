using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;

namespace Library.DAL.SInventory_DAL
{
    public class RegionSalesReportDAL
    {
        public void LoadRegion(DropDownList dropDownList)
        {
            string query = @"SELECT * from tblRegion ";
            BindRegionDropDown(dropDownList, SInventorySql.GetDataTable(query, new List<SqlParameter>()));
        }

        public void LoadRegion(DropDownList dropDownList, string RegionId)
        {
            string query = @"SELECT * from tblRegion where RegionId=@RegionId";
            BindRegionDropDown(dropDownList, SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@RegionId", SInventorySql.DbValue(RegionId))
            }));
        }
        
        public DataTable RegionReportMainDataDAL(string RegionId, DateTime fromDate, DateTime toDate)
        {
            string query = @"select (RegionCode+':'+RegionName) as RegionDetail,@FromDate as FromDate, @ToDate as ToDate from tblRegion where RegionId=@RegionId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate),
                new SqlParameter("@RegionId", SInventorySql.DbValue(RegionId.Trim()))
            });
        }

        public DataTable RegionReportDetailDataDAL(string RegionId, DateTime fromDate, DateTime toDate)
        {
            string query =
                @"select ProductCode,Product, sum(TotalQuantity) as TotalQty ,sum(Price) as TotalAmount from View_MIAWiseSalesReport  where MiaId in (select MiaId from View_CustomerMaster where RegionId=@RegionId) and InvoiceDate between @FromDate and @ToDate group by ProductCode,Product";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@RegionId", SInventorySql.DbValue(RegionId.Trim())),
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            });
        }

        private static void BindRegionDropDown(DropDownList dropDownList, DataTable dataTable)
        {
            dropDownList.DataSource = dataTable;
            dropDownList.DataTextField = "RegionName";
            dropDownList.DataValueField = "RegionId";
            dropDownList.DataBind();
            dropDownList.Items.Insert(0, new ListItem("--------Select---------", string.Empty));
        }
    }
}
