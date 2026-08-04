using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class OtherStockActionBLL
    {
        OtherStockActionDAL aOtherStockActionDAL =new OtherStockActionDAL();

        public DataTable LoadData(int DCID,int ManuID)
        {
            return aOtherStockActionDAL.LoadData(DCID, ManuID);
        }
        public void LoadmanufacturerName(DropDownList ddl)
        {
            aOtherStockActionDAL.LoadmanufacturerName(ddl);
        }
        public void LoadTerritory(DropDownList ddl)
        {
            aOtherStockActionDAL.LoadTerritory(ddl);
        }
        public void DCLoad(DropDownList aDownList, string userId)
        {
            aOtherStockActionDAL.DCLoad(aDownList, userId);

        }
        public void LoadSC(DropDownList ddl, string userId)
        {
            aOtherStockActionDAL.LoadSC(ddl, userId);
        }

        public void LoadMIO(DropDownList ddl)
        {
            aOtherStockActionDAL.LoadMIO(ddl);
        }
        public void LoadMIOMIOreceivable(DropDownList ddl)
        {
            aOtherStockActionDAL.LoadMIOMIOreceivable(ddl);
        }

        public void DCLoad(DropDownList aDownList)
        {
            aOtherStockActionDAL.DCLoad(aDownList);

        }
        public void MarketLoad(DropDownList aDownList)
        {
            aOtherStockActionDAL.MarketLoad(aDownList);

        }
        public bool UpdateDCStoreFreezeStock(decimal StockQty, int DCStoreFreezeId)
        {
            return aOtherStockActionDAL.UpdateDCStoreFreezeStock(StockQty, DCStoreFreezeId);
        }
        public DataTable LoadStockData(int DCStoreFreezeId)
        {
            return aOtherStockActionDAL.LoadStockData(DCStoreFreezeId);
        }
        public DataTable LoadStockDCStockData(int DCStoreId)
        {
            return aOtherStockActionDAL.LoadStockDCStockData(DCStoreId);
        }

        public bool UpdateDCStock(decimal StockQty, int DCStoreId)
        {
            return aOtherStockActionDAL.UpdateDCStock(StockQty, DCStoreId);
        }

        // Subdeport

        public DataTable SubDeportLoadData(int DCID, int ManuID)
        {
            return aOtherStockActionDAL.SubDeportLoadData(DCID, ManuID);
        }
        public DataTable LoadSubdeportStockData(int DCStoreFreezeId)
        {
            return aOtherStockActionDAL.LoadSubdeportStockData(DCStoreFreezeId);
        }
        public bool SubdeportUpdateDCStoreFreezeStock(decimal StockQty, int DCStoreFreezeId)
        {
            return aOtherStockActionDAL.SubdeportUpdateDCStoreFreezeStock(StockQty, DCStoreFreezeId);
        }

        public DataTable SubdeportLoadStockDCStockData(int DCStoreId)
        {
            return aOtherStockActionDAL.SubdeportLoadStockDCStockData(DCStoreId);
        }

        public bool SubdeportUpdateDCStock(decimal StockQty, int DCStoreId)
        {
            return aOtherStockActionDAL.SubdeportUpdateDCStock(StockQty, DCStoreId);
        }
    }
}
