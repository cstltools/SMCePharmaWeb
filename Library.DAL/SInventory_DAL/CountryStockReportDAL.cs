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
    public class CountryStockReportDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable CountryReportMainDataDAL(string productCode)
        {
            string query = @"select @ProductCode as ProductCode";

            return SInventorySql.GetDataTable(query, ProductCodeParameters(productCode));
        }

        public DataTable CountryReportDetailDataDAL(string productCode)
        {
            string query =
                @"select * from  View_TotalCurrentStockofCompanyWithStockInTransfar where ProductCode=@ProductCode";


            return SInventorySql.GetDataTable(query, ProductCodeParameters(productCode));
        }
        public DataTable CountryReportWithoutProductCodeDetailDataDAL()
        {
            string query =
                @"select * from View_CentralStoreCurrentStock";


            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        private List<SqlParameter> ProductCodeParameters(string productCode)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(productCode == null ? null : productCode.Trim()))
            };
        }
    }
}
