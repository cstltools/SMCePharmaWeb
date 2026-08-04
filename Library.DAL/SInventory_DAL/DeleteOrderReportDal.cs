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
    public class DeleteOrderReportDal
    {
        ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

        public void GetSalesCenter(DropDownList ddl)
        {
            string queryStr = "SELECT DISTINCT ComUnitId,ComUnitCode,ComUnitName +':'+ ComUnitCode as ComUnitName FROM dbo.tblCompanyUnit  WHERE ComUnitId IN (SELECT ComUnitId FROM dbo.tblCompanyUnit) ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitCode", queryStr);
        }

        public void GetCustomer(DropDownList ddl)
        {
            string queryStr = "SELECT CustomerMasterId ,CustomerCode FROM dbo.tblCustMaster";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CustomerCode", "CustomerMasterId", queryStr); ;
        }

        public DataTable GetDeleteOrderReport(string comUnitCode, string fromDate, string toDate)
        {
            string queryStr = "SELECT OD.OrderCode, OD.ComUnitCode AS SalesCenterCode, OD.ComUnitName AS SalesCenterName, OD.MIOCode, OD.MIOName, VC.AreaName AS TeritoryName,VC.AreaCode AS TeritoryCode ,VC.DistrictCode AS FECode, VC.DistrictName AS FEName, VC.RegionCode AS DZSMCode, VC.RegionName AS DZSMName,OD.CustomerCode, OD.CustomerName,OD.GrossValue, OD.SubmissionDate, OD.DeleteBy, OD.DeleteDate FROM tblOrderDel AS OD WITH(NOLOCK) INNER JOIN  dbo.View_CustomerMaster AS VC ON VC.CustomerCode = OD.CustomerCode WHERE 1=1";
            List<SqlParameter> parameters = ReportParameters(ref queryStr, comUnitCode, fromDate, toDate);
            return SInventorySql.GetDataTable(queryStr, parameters);
        }

        public DataTable GetDeleteOrderNationalReport(string comUnitCode, string fromDate, string toDate)
        {
            string queryStr = "SELECT OD.OrderCode, OD.ComUnitCode AS SalesCenterCode, OD.ComUnitName AS SalesCenterName, OD.MIOCode, OD.MIOName, VC.AreaName AS TeritoryName,VC.AreaCode AS TeritoryCode ,VC.DistrictCode AS FECode, VC.DistrictName AS FEName, VC.RegionCode AS DZSMCode, VC.RegionName AS DZSMName,OD.CustomerCode, OD.CustomerName,OD.GrossValue, OD.SubmissionDate, OD.DeleteBy, OD.DeleteDate FROM tblOrderDel AS OD WITH(NOLOCK) INNER JOIN  dbo.View_CustomerMaster AS VC ON VC.CustomerCode = OD.CustomerCode WHERE 1=1";
            List<SqlParameter> parameters = ReportParameters(ref queryStr, comUnitCode, fromDate, toDate);
            return SInventorySql.GetDataTable(queryStr, parameters);
        }

        private List<SqlParameter> ReportParameters(ref string queryStr, string comUnitCode, string fromDate, string toDate)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();

            if (!string.IsNullOrWhiteSpace(comUnitCode))
            {
                queryStr += " AND OD.ComUnitCode = @ComUnitCode";
                parameters.Add(new SqlParameter("@ComUnitCode", SInventorySql.DbValue(comUnitCode.Trim())));
            }

            if (!string.IsNullOrWhiteSpace(fromDate) && !string.IsNullOrWhiteSpace(toDate))
            {
                queryStr += " AND OD.DeleteDate BETWEEN @FromDate AND @ToDate";
                parameters.Add(new SqlParameter("@FromDate", SInventorySql.DbValue(fromDate.Trim())));
                parameters.Add(new SqlParameter("@ToDate", SInventorySql.DbValue(toDate.Trim())));
            }

            return parameters;
        }
    }
}
