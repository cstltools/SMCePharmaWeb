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
    public class AreaWiseMonthlyInventoryReportDal
    {
        private readonly ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

//        public DataTable GetAreaWiseMonthlyInventoryReport(string fromDate, string toDate, string branchId)
//        {

//            const string query = @"SELECT ProductCode ,ProductName ,StorageLocation AS BaseUnit,PackSize AS OpeningStock ,BatchNo AS ReceiveFromCentralWarehouse,
//                                  Quantity AS ReceiveFromAreaOfficeInterTransfer,ExpDate AS TotalReceived,ReceiveDate AS IssuedToSales,ChalanNo AS IssuedToProductBonus,
//ChalanDate AS IssuedToAreaOfficeInterTransfer,
//                                  InternalNoteNo AS IssuedToCentralWarehouse,StockInQty AS IssuedToDamageAndOthers,UnitPrice AS TotalIssued,MfgDate AS ClosingStock FROM dbo.tblCentralStore";

//            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
//        }


        public DataTable GetAreaWiseMonthlyInventoryReport(string fromDate, string toDate, string CiD)
        {
            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@fromDate", fromDate));
            aSqlParameters.Add(new SqlParameter("@toDate", toDate));
            aSqlParameters.Add(new SqlParameter("@CiD", CiD));

            return aCommonInternalDal.GetDataTableAction("sp_AreawiseDailyOpeningClosingStockDepowise", aSqlParameters, "SSIDB"); 
        }

        public DataTable GetAreaWiseMonthlyInventoryNationalReport(string fromDate, string toDate)
        {

            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@fromDate", fromDate));
            aSqlParameters.Add(new SqlParameter("@toDate", toDate));
      

            return aCommonInternalDal.GetDataTableAction("sp_AreawiseDailyOpeningClosingStockNational", aSqlParameters, "SSIDB"); 
        }
        public void GetBranchList(DropDownList ddl)
        {
            const string query = @"SELECT ComUnitId,ComUnitName FROM dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(ddl, "ComUnitName", "ComUnitId", query, "SSIDB");
        }


        public DataTable SubdeportGetAreaWiseMonthlyInventoryNationalReport(string fromDate, string toDate)
        {

            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@fromDate", fromDate));
            aSqlParameters.Add(new SqlParameter("@toDate", toDate));


            return aCommonInternalDal.GetDataTableAction("sp_SubdeportAreawiseDailyOpeningClosingStockNational", aSqlParameters, "SSIDB");
        }
    }
}
