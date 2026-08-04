using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.DWSP_DAO;
using Library.DAO.SettingPanel_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.SettingPanel_DAL
{
   public class UserSettingPanelDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public ResultInfo SaveUserPanelSettting(List<UserSettingPanelDao> _ZoneTarget)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                foreach (var item in _ZoneTarget)
                {
                    List<SqlParameter> aSQL = new List<SqlParameter>();
                    aSQL.Add(new SqlParameter("@UserSettingPanelId", item.UserSettingPanelId));
                    aSQL.Add(new SqlParameter("@FromDate", item.FromDate ?? (object)DBNull.Value));
                    aSQL.Add(new SqlParameter("@Todate", item.Todate ?? (object)DBNull.Value));
                    aInformation.isSuccess = accessManager.UpdateData("sp_UpDate_UserSettingPanel", aSQL);
                }
            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);
                aInformation.isSuccess = false;
                aInformation.ErrorMessage = exception.Message;
                throw exception;
            }
            finally
            {

                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }

        public DataTable Get_UserSettingPanel()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                DataTable dt = accessManager.GetDataTable("sp_GET_UserSettingPanel");
                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
    }
}
