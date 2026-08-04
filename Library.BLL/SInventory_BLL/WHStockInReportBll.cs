using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class WHStockInReportBll
    {
        WHStockInReportDal aStockInReportDal = new WHStockInReportDal();

        public DataTable LoadWarehouseStockInData(string stockInDate)
        {
            return aStockInReportDal.GetWarehouseStockInData(stockInDate);
        }

        public DataTable LoadWarehouseStockInMasterData(string reqId)
        {
            return aStockInReportDal.GetWarehouseStockInMasterData(reqId);
        }

        public DataTable LoadWarehouseStockInDetailData(string reqId)
        {
            return aStockInReportDal.GetWarehouseStockInDetailData(reqId);
        }

        public DataTable CompanyInfoBLL()
        {
            return aStockInReportDal.CompanyInformation();
        }

        public void LoadProductInformation(DropDownList ddl)
        {
            aStockInReportDal.GetProductInformation(ddl);
        }
    }
}
