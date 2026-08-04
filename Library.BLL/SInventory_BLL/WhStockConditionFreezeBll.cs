using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class WhStockConditionFreezeBll
    {
        WhStockConditionFreezeDal aConditionFreezeDal = new WhStockConditionFreezeDal();

        public void LoadWhInfoOnDropDownList(DropDownList ddl)
        {
            aConditionFreezeDal.GetWhInfoOnDropDownList(ddl);
        }

        public DataTable LoadWhStockInformation()
        {
            return aConditionFreezeDal.GetWhStockInformation();
        }

        public void LoadStockConditionBll(DropDownList aDownList, string userid)
        {
            aConditionFreezeDal.LoadStockConditionBll(aDownList, userid);
        }

        public DataTable LoadWHData(int id)
        {
            return aConditionFreezeDal.LoadWHData(id);
        }

        public int SaveforWh(WhStockConditionFreezeDao aConditionFreezeDao)
        {
            try
            {

                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                aConditionFreezeDao.WhStockConditionFreezeID = aClsPrimaryKeyFind.PrimaryKeyMax("WhStockConditionFreezeID", "tblWhStockConditionFreeze");
                aConditionFreezeDal.SaveforWh(aConditionFreezeDao);
                return aConditionFreezeDao.WhStockConditionFreezeID;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public int SaveWhStoreFreeze(WhStoreFreezeDao aWhStoreFreezeDao)
        {
            try
            {
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    aWhStoreFreezeDao.WhStoreFreezeId = aClsPrimaryKeyFind.PrimaryKeyMax("WhStoreFreezeId", "tblWhStoreFreeze");
                    aConditionFreezeDal.SaveWhStoreFreeze(aWhStoreFreezeDao);
                    return aWhStoreFreezeDao.WhStockConditionFreezeID;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public bool UpdateCentralStore(decimal StockQty, int ReceiveId)
        {
            return aConditionFreezeDal.UpdateCentralStore(StockQty, ReceiveId);
        }
    }
}
