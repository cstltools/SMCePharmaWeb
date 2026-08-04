using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class AccountSettingsBll
    {
        AccountSettingsDal aUserDal = new AccountSettingsDal();

        public UserInformation UserEditLoad(string userId)
        {
            return aUserDal.UserInformationEditLoad(userId);
        }

        public bool UpdateDataForUser(UserInformation aUserInformation)
        {
            return aUserDal.UpdateUserInfo(aUserInformation);
        }

        public void LoadUserOnDropDownList(DropDownList ddl)
        {
            aUserDal.GetUserOnDropDownList(ddl);
        }
    }
}
