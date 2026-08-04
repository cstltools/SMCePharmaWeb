using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.DWSP_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.DWSP_DAL
{
   public class NationalTargetSetupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        public ResultInfo SaveNationalTargetSetup(NationalTargetDao aTargetDao, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@NatargetSpId", aTargetDao.NatargetSpId));
                gSqlParameterList.Add(new SqlParameter("@GroupId", (object)aTargetDao.GroupId ?? DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Year ", (object)aTargetDao.Year ?? DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Month", (object)aTargetDao.Month ?? DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@Amount", (object)aTargetDao.Amount ?? DBNull.Value));
                if (aTargetDao.NatargetSpId > 0)
                {

                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    aInformation.isSuccess = accessManager.UpdateData("sp_Save_NationaltargetSetup", gSqlParameterList);

                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_NationaltargetSetup", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                    }
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

        public DataTable Get_Group_All()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_NTS_Group_Active");
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


        public DataTable Get_SaveDataAll()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_NTS_Group_Active");
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



        public DataTable Get_GroupTarget_All(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", param));
                DataTable dt = accessManager.GetDataTable("sp_Get_Group_List", aSqlParameterlist);
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
