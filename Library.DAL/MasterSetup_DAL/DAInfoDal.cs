using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.DataManager;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.MasterSetup_DAL
{
    public class DAInfoDal
    {
        private DataAccessManager accessManager = new DataAccessManager();


        public int SaveDAInfo(DAInfoDao aDao)
        {
            int pk = 0;

            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();

                gSqlParameterList.Add(new SqlParameter("@NID", aDao.NID));
                gSqlParameterList.Add(new SqlParameter("@Name", aDao.Name));
                gSqlParameterList.Add(new SqlParameter("@Address", aDao.Address));
                gSqlParameterList.Add(new SqlParameter("@PhoneNo", aDao.PhoneNo));
                gSqlParameterList.Add(new SqlParameter("@EmergencyContactNo", aDao.EmergencyContactNo));
                gSqlParameterList.Add(new SqlParameter("@ReferenceName", aDao.ReferenceName));
                gSqlParameterList.Add(new SqlParameter("@ReferencePhone", aDao.ReferencePhone));
                gSqlParameterList.Add(new SqlParameter("@Remarks", aDao.Remarks));
                gSqlParameterList.Add(new SqlParameter("@ComUnitId", aDao.ComUnitId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@JoiningDate", aDao.JoiningDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@IsActive", aDao.IsActive));
                gSqlParameterList.Add(new SqlParameter("@ActiveDate", aDao.ActiveDate ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@InactiveDate", aDao.InactiveDate ?? (object)DBNull.Value));

                if (aDao.DAId > 0)
                {
                    gSqlParameterList.Add(new SqlParameter("@DAId", aDao.DAId));
                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", aDao.EntryBy));
                    gSqlParameterList.Add(new SqlParameter("@UpdateDate", aDao.EntryDate));

                    accessManager.UpdateData("sp_Update_DAInfo", gSqlParameterList);
                    pk = aDao.DAId;
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", aDao.EntryBy));
                    gSqlParameterList.Add(new SqlParameter("@EntryDate", aDao.EntryDate));

                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_DAInfo", gSqlParameterList);

                }
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

            return pk;
        }

        public DataTable GetDAInfo(int parameter)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@Parameter", parameter));
                DataTable dt = accessManager.GetDataTable("sp_GET_DAInfo", aSqlParameterlist);
                return dt;

            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetDAInfoById(int daId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                aSqlParameterlist.Add(new SqlParameter("@Parameter", daId));
                DataTable dt = accessManager.GetDataTable("sp_GET_DAInfoById", aSqlParameterlist);
                return dt;

            }
            catch (Exception e)
            {
                throw e;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

    }
}
