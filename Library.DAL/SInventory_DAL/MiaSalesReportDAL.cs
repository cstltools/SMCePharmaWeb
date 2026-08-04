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
     
    public class MiaSalesReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public void LoadMiaByComUnit(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT DISTINCT View_CustomerMaster.MiaId,View_CustomerMaster.MiaName FROM dbo.tblMIAInfo
            LEFT JOIN dbo.View_CustomerMaster ON dbo.tblMIAInfo.MiaId = dbo.View_CustomerMaster.MiaId WHERE ComUnitId=@ComUnitId";
            dropDownList.DataSource = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId == null ? null : comUnitId.Trim()))
            });
            dropDownList.DataTextField = "MiaName";
            dropDownList.DataValueField = "MiaId";
            dropDownList.DataBind();
        }
        public void LoadComUnit(DropDownList dropDownList)
        {
            string query = @"SELECT * from tblCompanyUnit ";
            aCommonInternalDal.LoadDropDownValue(dropDownList, "ComUnitName", "ComUnitId", query, "SSIDB");
        }

        public void LoadComUnit(DropDownList dropDownList, string comUnitId)
        {
            string query = @"SELECT * from tblCompanyUnit where ComUnitId=@ComUnitId";
            dropDownList.DataSource = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId))
            });
            dropDownList.DataTextField = "ComUnitName";
            dropDownList.DataValueField = "ComUnitId";
            dropDownList.DataBind();
        }
        
        public DataTable MiaWiseReportMainDataDAL(string miaId,DateTime fromDate,DateTime toDate,string comunitId)
        {
            string query = @"SELECT DISTINCT MiaId, MiaCode+':'+MiaName AS MIA, DistrictCode+':'+DistrictName AS District, ComUnitCode+':'+ComUnitName AS CompanyUnit, 
@FromDate AS FromDate, @ToDate AS ToDate FROM dbo.View_CustomerMaster  WHERE MiaId=@MiaId AND MiaId IN (SELECT MiaId FROM dbo.tblMIAInfo WHERE MiaId=@MiaId) AND ComUnitId=@ComUnitId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate),
                new SqlParameter("@MiaId", SInventorySql.DbValue(miaId)),
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comunitId))
            });
        }

        public DataTable MiaWiseReportDetailDataDAL(string miaId,DateTime fromDate,DateTime toDate)
        {
            string query = @"select InvoiceDate, MiaId,ProductCode,Product,sum(TotalQuantity) as TotalQuantity,sum(Price) as Price from  View_MIAWiseSalesReport where MiaId = @MiaId and InvoiceDate between @FromDate and @ToDate group by InvoiceDate, MiaId,ProductCode,Product";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MiaId", SInventorySql.DbValue(miaId)),
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            });
        }

    }
}
