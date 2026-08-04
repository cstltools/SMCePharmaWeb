using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class AreaWiseMonthlyInventoryReportBll
    {
        AreaWiseMonthlyInventoryReportDal aAreaDal = new AreaWiseMonthlyInventoryReportDal();

        public DataTable LoadAreaWiseMonthlyInventoryReport(string fromDate, string toDate, string branchId)
        {
            return aAreaDal.GetAreaWiseMonthlyInventoryReport(fromDate, toDate, branchId);
        }
        public DataTable LoadAreaWiseMonthlyInventoryNationalReport(string fromDate, string toDate)
        {
            return aAreaDal.GetAreaWiseMonthlyInventoryNationalReport(fromDate, toDate);
        }
        public void LoadBranchList(DropDownList ddl)
        {
            aAreaDal.GetBranchList(ddl);
        }
        public DataTable SubdeportGetAreaWiseMonthlyInventoryNationalReport(string fromDate, string toDate)
        {
            return aAreaDal.SubdeportGetAreaWiseMonthlyInventoryNationalReport(fromDate, toDate);
        }
    }
}
