using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class WhFreezeStockReleaseBll
    {
        WhFreezeStockReleaseDal aFreezeStockReleaseDal = new WhFreezeStockReleaseDal();

        public DataTable LoadWhFreezeStockData()
        {
            return aFreezeStockReleaseDal.GetWhFreezeStockData();
        }

        public DataTable LoadStockReleaseData(int id)
        {
            return aFreezeStockReleaseDal.GetStockReleaseData(id);
        }

        public bool UpdateWhStoreFreezeInfo(WhStoreFreezeDao aConditionFreezeDao)
        {
            return aFreezeStockReleaseDal.UpdateWhStoreFreezeStockQuantity(aConditionFreezeDao);
        }

        public DataTable LoadCentralStoreData(int receiveId)
        {
            return aFreezeStockReleaseDal.GetCentralStoreDataByReceiveId(receiveId);
        }

        public bool UpdateCentalStoreInfo(decimal quantity, int receiveId)
        {
            return aFreezeStockReleaseDal.UpdateCentalStoreQuantity(quantity, receiveId);
        }

        public void LoadWhInfoOnDropDownList(DropDownList ddl)
        {
            aFreezeStockReleaseDal.GetWhInfoOnDropDownList(ddl);
        }
    }
}
