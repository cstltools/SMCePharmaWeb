
using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.DataLayer
{
    public class GenericGroupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo Save_GenericGroup(GenericGroup generic, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", generic.GenericGroupId));
                gSqlParameterList.Add(new SqlParameter("@GenericGroupName", generic.GenericGroupName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", generic.IsActive));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@InactiveDate", DateTime.Now));

                if (generic.GenericGroupId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", generic.GenericGroupId));
                    aSqlParameterlist.Add(new SqlParameter("@GenericGroupName", generic.GenericGroupName));
                    DataTable dt = accessManager.GetDataTable("sp_check_GenericGroup", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {

                        if (generic.IsActive == false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", generic.GenericGroupId));
                            aSqlprm.Add(new SqlParameter("@PageName", "GenericGroup"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {
                                gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                                aInformation.isSuccess = accessManager.UpdateData("sp_UD_GenericGroup", gSqlParameterList);
                                pk = generic.GenericGroupId;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;
                            }
                        }
                        else
                        {
                            gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                            aInformation.isSuccess = accessManager.UpdateData("sp_UD_GenericGroup", gSqlParameterList);
                            pk = generic.GenericGroupId;
                        }
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_GenericGroup", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isValiCheck = true;

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

        public DataTable GetGenericGroupList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_GenericGroup", aSqlParameterlist);
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

        public GenericGroup GetGenericGroupForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                GenericGroup master = new GenericGroup();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_GenericGroup_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.GenericGroupId = (int)dr["GenericGroupId"];
                    master.GenericGroupName = dr["GenericGroupName"].ToString();
                    master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                }
                return master;
            }
            catch (Exception exception)
            {
                throw exception;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }



    }
}