
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
    public class TherapueticGroupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo Save_TherapueticGroup(TherapeuticGroup therapeutic, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", therapeutic.TherapeuticGroupId));
                gSqlParameterList.Add(new SqlParameter("@TherapeuticGroupName", therapeutic.TherapeuticGroupName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", therapeutic.IsActive));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@InactiveDate", DateTime.Now));

                if (therapeutic.TherapeuticGroupId > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", therapeutic.TherapeuticGroupId));
                    aSqlParameterlist.Add(new SqlParameter("@TherapeuticGroupName", therapeutic.TherapeuticGroupName));
                    DataTable dt = accessManager.GetDataTable("sp_check_TherapeuticGroup", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_TherapeuticGroup", gSqlParameterList);
                        pk = therapeutic.TherapeuticGroupId;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                        aInformation.isValiCheck = true;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_TherapeuticGroup", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
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


        public ResultInfo Save_ProductLine(ProductLineDAO therapeutic, int sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@id", therapeutic.ProductLineID));
                gSqlParameterList.Add(new SqlParameter("@LineName", therapeutic.LineName));
                gSqlParameterList.Add(new SqlParameter("@IsActive", therapeutic.IsActive));
                gSqlParameterList.Add(new SqlParameter("@InactiveBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@InactiveDate", DateTime.Now));

                if (therapeutic.ProductLineID > 0)
                {
                    aSqlParameterlist.Add(new SqlParameter("@id", therapeutic.ProductLineID));
                    aSqlParameterlist.Add(new SqlParameter("@LineName", therapeutic.LineName));
                    DataTable dt = accessManager.GetDataTable("sp_check_ProductLine", aSqlParameterlist);
                    if (dt.Rows.Count == 0)
                    {
                        gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                        aInformation.isSuccess = accessManager.UpdateData("sp_UD_ProductLine", gSqlParameterList);
                        pk = therapeutic.ProductLineID;
                    }
                    else
                    {
                        aInformation.isSuccess = false;
                        aInformation.isValiCheck = true;
                    }
                }
                else
                {
                    gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ProductLine", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
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

        public DataTable GetTherapueticGroupList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_TherapueticGroup", aSqlParameterlist);
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

        public DataTable GetProductLineList(string Param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parameter", Param));
                DataTable dt = accessManager.GetDataTable("sp_GET_ProductLineList", aSqlParameterlist);
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

        public TherapeuticGroup GetTherapueticGroupForEdit(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                TherapeuticGroup master = new TherapeuticGroup();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_TherapeuticGroup_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.TherapeuticGroupId = (int)dr["TherapeuticGroupId"];
                    master.TherapeuticGroupName = dr["TherapeuticGroupName"].ToString();
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

        public ProductLineDAO GetProductLineEditData(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                ProductLineDAO master = new ProductLineDAO();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_GET_ProductLine_ById", aSqlParameters);
                while (dr.Read())
                {
                    master.ProductLineID = (int)dr["ProductLineID"];
                    master.LineName = dr["LineName"].ToString();
                    try
                    {
                        master.IsActive = Convert.ToBoolean(dr["IsActive"].ToString());
                    }
                    catch (Exception exception)
                    {
                        
                    }
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