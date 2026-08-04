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
    public class WarehouseStockInApprovalBll
    {
        WarehouseStockInApprovalDal approvalDal = new WarehouseStockInApprovalDal();


        //public void LoadApprovalControlBLL(RadioButtonList rdl, string pageName, string userName)
        //{
        //    approvalDal.LoadApprovalControlDAL(rdl, pageName, userName);
        //}
        //public string LoadForApprovalConditionBLL(string pageName, string userName)
        //{
        //    return approvalDal.LoadForApprovalConditionDAL(pageName, userName);
        //}


        public DataTable LoadWarehouseStockInInformation()
        {
            return approvalDal.GetWarehouseStockInInformation();
        }
        public DataTable GetAssignedAppUser(string menuid, string userId)
        {
            return approvalDal.GetAssignedAppUser(menuid, userId);
        }
        public DataTable GetMenuIdByMenuName(string menuname)
        {
            return approvalDal.GetMenuIdByMenuName(menuname);
        }
        public string ApprovalUpdateBLL(WarehouseStockInMasterDao aMasterDao)
        {
            approvalDal.ApprovalUpdateDal(aMasterDao);
            return "Weldone! Stock In approved successfully!!!";
        }

        public void InsertDataIntoCenterlWarehouse(List<WHStockInToCenteralStore> aCenteralStoreList)
        {
            foreach (WHStockInToCenteralStore aCenteralStore in aCenteralStoreList)
            {
                approvalDal.SaveWHStockIntoCenterlWarehouse(aCenteralStore);
            }
        }

        public DataTable LoadWarehouseStockInInfo(Int32 stockInMasterId)
        {
            return approvalDal.GetLoadWarehouseStockInInfo(stockInMasterId);
        }
    }
}
