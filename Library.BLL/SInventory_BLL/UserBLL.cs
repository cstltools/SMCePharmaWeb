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
    public class UserBLL
    {
        UserDAL aUserDal = new UserDAL();

        public string SaveDataForUser(UserInformation aUserInformation,UserCompanyUnit aCompanyUnit)
        {
            try
            {
                //if (!aUserDal.HasUserInformationName(aUserInformation))
                //{
                    //if (!aUserDal.HasLoginName(aUserInformation))
                    //{
                    //    if (!aUserDal.HasEmail(aUserInformation))
                    //    {
                            ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                            aUserInformation.UserId = aClsPrimaryKeyFind.PrimaryKeyMax("UserId", "tblUser");
                            aUserInformation.UserCode = UserCodeGenerator(aUserInformation.UserId);

                            
                            aUserDal.SaveUserInformation(aUserInformation);
                           
                                aCompanyUnit.UserId = aUserInformation.UserId;
                                aCompanyUnit.UserComId = aClsPrimaryKeyFind.PrimaryKeyMax("UserComId", "tblUserCompanyUnit");
                                aUserDal.SaveUserCompanyUnit(aCompanyUnit);
                         
                           
                            return "Data Save Successfully Username  is :" + aUserInformation.UserName +
                                   " And Login Name is : " + aUserInformation.LoginName + " And Password is : " +
                                   aUserInformation.Password + " And User Code is : " + aUserInformation.UserCode;
                    //    }
                    //    else
                    //    {
                    //        return "E-mail already exist";
                    //    }
                    //}
                    //else
                    //{
                    //    return "Login Name is already exist";
                    //}
               // }
                //else
                //{
                //    return "User name already exist";
                //}

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public DataTable LoadMenu(string userid, string UserRoleID)
        {
            return aUserDal.LoadMenu(userid, UserRoleID);
        }

        public string UserCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "0" + Id;
            }
            code = "USER-" + Id;
            return code;
        }


        public bool UpdateDataForUser(UserInformation aUserInformation)
        {
            return aUserDal.UpdateUserInfo(aUserInformation);
        }
        public bool DeleteUserInfo(string userId)
        {
            return aUserDal.DeleteUserInfo(userId);
        }

        public DataTable LoadUserInfo()
        {
            return aUserDal.LoadUserView();
        }

        public UserInformation UserEditLoad(string userId)
        {
            return aUserDal.UserInformationEditLoad(userId);
        }

        public void LoadUserType(DropDownList ddl)
        {
             aUserDal.LoadUserType(ddl);
        }

        public void LoadComUnit(DropDownList ddl)
        {
            aUserDal.LoadComUnit(ddl);
        }
    }
}
