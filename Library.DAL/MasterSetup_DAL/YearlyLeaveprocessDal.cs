using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.MasterSetup_DAL
{
 public   class YearlyLeaveprocessDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();


        public ResultInfo SaveYearlyleave(int sessionUser)
        {

            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@ProcessBy", sessionUser));
                aInformation.isSuccess = accessManager.SaveData("sp_Process_YearlyLeaveBalance", gSqlParameterList);

            }
            catch (Exception exception)
            {
                accessManager.SqlConnectionClose(true);

                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            return aInformation;
        }
    }
}