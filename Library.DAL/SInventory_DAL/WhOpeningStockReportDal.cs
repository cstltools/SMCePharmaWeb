using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class WhOpeningStockReportDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetWhOpeningStockReport(string date)
        {
            string query = @"SELECT [ProductCode],[ProductName],[PackSize],[BatchNo],[MfgDate],[ExpDate],[Quantity] FROM tblCentralStore_OpeninigBalance
                             WHERE  tblCentralStore_OpeninigBalance.CSOpeninigBalanceDate ='" + date.Trim() + "' ";
            DataTable aDataTableEmpInfo = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTableEmpInfo;
        }

        public DataTable CompanyInformation()
        {
            string query = @"SELECT CompanyName , Address ,ContactNo ,  FaxNo  FROM tblCompanyInfo WHERE CompanyId='1' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
