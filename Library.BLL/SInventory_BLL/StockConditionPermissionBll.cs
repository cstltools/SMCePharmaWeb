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
    public class StockConditionPermissionBll
    {
        StockConditionPermissionDal aConditionPermissionDal = new StockConditionPermissionDal();

        public void LoadUserInfo(DropDownList ddl)
        {
            aConditionPermissionDal.GetUserInfoOnDropdownList(ddl);
        }

        public DataTable LoadStockConditionList()
        {
            return aConditionPermissionDal.GetStockConditionList();
        }

        public DataTable LoadStockConditionByUserId(string userId)
        {
            return aConditionPermissionDal.GetStockConditionByUserId(userId);
        }

        public bool LoadStockPermissionDataForSave(IEnumerable<StockConditionPermissionDao> aPermissionDaoList)
        {
            bool status = false;

            foreach (var stockConditionPermissionDao in aPermissionDaoList)
            {
                if (CheckInfoAlreadyExistOrNot(stockConditionPermissionDao))
                {
                    status = aConditionPermissionDal.SaveStockConditionPermissionInfo(stockConditionPermissionDao);
                } 
            }

            return status;
        }

        private bool CheckInfoAlreadyExistOrNot(StockConditionPermissionDao stockConditionPermissionDao)
        {         
           DataTable aDataTable = aConditionPermissionDal.CheckPermissionInfoAlreadyExistOrNot(stockConditionPermissionDao); 

            if (aDataTable.Rows.Count > 0)
            {
                aConditionPermissionDal.DeletePermissionInfo(stockConditionPermissionDao);
            }

            return true;
        }
    }
}
