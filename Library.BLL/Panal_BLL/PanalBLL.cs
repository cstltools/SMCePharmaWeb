using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.PanalCls;
using Library.DAL.Panal_DAL;
using Library.DAO.Panal_Entities;

namespace Library.BLL.Panal_BLL
{
   public class PanalBLL
    {
       PanalClsDAL aPanalClsDal = new PanalClsDAL();
       PanalDAL aPanalDal = new PanalDAL();
       public bool MenuSaveBll(ObjPanal aObjPanal)
       {
           ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
           aObjPanal.SL = aClsPrimaryKeyFind.PrimaryKeyMax("SL", "tblMainMenu", "SSIDB");
           return aPanalDal.MenuSaveDal(aObjPanal);
       }

        public DataTable FinancialYearList()
        {
            return aPanalClsDal.FinancialYearList();
        }
        public bool LoginLog(string userId, string LoginName, DateTime loginTime)
       {
           return aPanalClsDal.LoginLog(userId, LoginName, loginTime);
       }

       public DataTable Login(string loginName,string password)
       {
           return aPanalClsDal.Login(loginName, password);
       }


       public bool SaveMenuBll(int sl, int userId)
       {
           string parantId = string.Empty;
           bool ok = aPanalDal.SaveMainMenu(sl, userId);
           for (int i = 0; i < 2; i++)
           {
               parantId = aPanalDal.GetParantId(sl);
               if (!string.IsNullOrEmpty(parantId))
               {
                   sl = Convert.ToInt32(parantId);
                   if (!aPanalDal.CheckMenuSl(Convert.ToInt32(parantId), userId))
                   {
                       bool ok1 = aPanalDal.SaveMainMenu(Convert.ToInt32(parantId), userId);
                   }
               }
               


           }



           return true;
       }



       public void MainMenuDropdown(DropDownList aDropDownList)
       {
           aPanalDal.MainMenuDropDown(aDropDownList);
       }
       public void MenuDropdown(DropDownList aDropDownList,string id)
       {
           aPanalDal.MenuDropDown(aDropDownList,id);
       }

       public void UserDdl(DropDownList userDropDownList)
       {
           aPanalDal.UserDdl(userDropDownList);
       }



       public bool MenuPermissionRemove(int sl, int userId)
       {
           return aPanalDal.MenuPermissionRemove(sl, userId);
       }


      public bool SaveMainMenu(int sl,int userId)
      {

       return   aPanalDal.SaveMainMenu(sl, userId);
      }

       public void MainMenu(DropDownList userDropDownList,string userId)
       {
           aPanalDal.MainMenu(userDropDownList, userId);
       }


       public DataTable MainMenuLoad(string userId)
       {

           return aPanalDal.MainMenuLoad(userId);
       }
        public DataTable OtherMenuLoad(string userId,string parantId)
        {

            return aPanalDal.OtherMenuLoad(userId, parantId);
        }
    }
}
