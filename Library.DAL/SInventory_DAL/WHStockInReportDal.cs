using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class WHStockInReportDal
    {
        ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

        public DataTable GetWarehouseStockInData(string stockInDate)
        {
            string query = @"SELECT * FROM dbo.tblWHStockInMaster AS WSHM WHERE WSHM.Status = 'Approved' AND WSHM.WHStockInDate = '" + stockInDate + "'";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetWarehouseStockInMasterData(string reqId)
        {
            string query = @"SELECT * FROM dbo.tblWHStockInMaster AS WHSM
            INNER JOIN dbo.tblManufacturer AS MNCF ON MNCF.ManufacId = WHSM.ManufacId
            INNER JOIN tblSupplierInformation AS S ON WHSM.SupplierId = S.SupplierId
            WHERE WHSM.WHStockInMasterID ='" + reqId + "'";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetWarehouseStockInDetailData(string reqId)
        {
            string query = @"SELECT StockUOMName,* FROM dbo.tblWHStockInDetail AS WHSD 
            INNER JOIN dbo.tblProduct AS PD ON PD.ProductId = WHSD.ProductId
			 INNER JOIN dbo.tblStockUOM AS S ON PD.StockUOMId = S.StockUOMId
            WHERE WHSD.WHStockInMasterID = '" + reqId + "'";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable CompanyInformation()
        {
            string query = @"SELECT CompanyName , Address ,ContactNo ,  FaxNo  FROM tblCompanyInfo WHERE CompanyId='1' ";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public void GetProductInformation(DropDownList ddl)
        {
            string queryStr = "SELECT * FROM dbo.tblProduct";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ProductName", "ProductCode", queryStr);
        }
    }
}
