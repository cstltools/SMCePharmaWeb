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
    public class DCUserPermissionBll
    {
        DCUserPermissionDal aDcUserPermissionDal = new DCUserPermissionDal();

        public void LoadUserInfo(DropDownList ddl)
        {
            aDcUserPermissionDal.GetUserInfo(ddl);
        }

        public DataTable LoadDCList()
        {
            return aDcUserPermissionDal.GetDCList();
        }

        public bool LoadDCUserPermissionDataForSave(List<UserCompanyUnitDao> aPermissionDaoList, string userId)
        {
            bool status = false;

            aDcUserPermissionDal.DeletePermissionInfo(userId);

            foreach (UserCompanyUnitDao aUserCompanyUnitDao in aPermissionDaoList)
            {
                status = aDcUserPermissionDal.SaveDCUserPermissionInfo(aUserCompanyUnitDao);
            }

            return status;
        }

        //private bool CheckInfoAlreadyExistOrNot(UserCompanyUnitDao aUserCompanyUnitDao)
        //{
        //    DataTable aDataTable = aDcUserPermissionDal.CheckPermissionInfoAlreadyExistOrNot(aUserCompanyUnitDao);

        //    if (aDataTable.Rows.Count > 0)
        //    {
        //        aDcUserPermissionDal.DeletePermissionInfo(aUserCompanyUnitDao);
        //    }

        //    return true;
        //}

        public DataTable LoadDCUserPermissionById(string userId)
        {
            return aDcUserPermissionDal.GetDCUserPermissionById(userId);
        }
    }
}
