using SalesSolution.Web.Interface;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using Library.DAL.DataManager;

namespace SalesSolution.Web.DataLayer
{
    public class ZoneSetupDAL
    {
        private DataAccessManager  accessManager = new DataAccessManager ();
        //private DataAccessManagerAsync accessManager = new DataAccessManagerAsync();

        public Zone GetEditData(int id)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                Zone master = new Zone();
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@id", id));

                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Get_ZoneData_ByZoneId", aSqlParameters);

                while (dr.Read())
                {
                    master.RegionId = (int)dr["RegionId"];
                    master.RegionName = dr["RegionName"].ToString();
                    master.RegionCode = dr["RegionCode"].ToString();
                    master.DivisionId = dr["DivisionId"].ToString();
                    master.AcOrInAcDate = (DateTime)dr["AcOrInAcDate"];
                    master.GroupId = (int)dr["GroupId"];
                    master.IsActive = Convert.ToBoolean(dr["IsActive"]);
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



        public DataTable GetInstitutionList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB) ;
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_ZoneList");
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

        public DataTable GetZoneList()
        {
            try
            {
               accessManager.SqlConnectionOpen(DataBase.SalesDB) ;
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_Get_ZoneList");
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

        public ResultInfo SaveZoneInfo(Zone zone,string sessionUser)
        {
            int pk = 0;

            ResultInfo aInformation = new ResultInfo();
            try
            {
                aInformation.isValiCheck = false;

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@zoneId", zone.RegionId));
                gSqlParameterList.Add(new SqlParameter("@zoneName", zone.RegionName));
                gSqlParameterList.Add(new SqlParameter("@createdBy", sessionUser));
                gSqlParameterList.Add(new SqlParameter("@remarks", zone.Remarks));
                gSqlParameterList.Add(new SqlParameter("@isActive", zone.IsActive));
                gSqlParameterList.Add(new SqlParameter("@acInAcDate", zone.AcOrInAcDate));
                gSqlParameterList.Add(new SqlParameter("@CodeStr", zone.CodeStr));
                gSqlParameterList.Add(new SqlParameter("@GroupId", zone.GroupId));

                if (zone.RegionId > 0)
                {

                    aSqlParameterList.Add(new SqlParameter("@id", zone.RegionId));
                    aSqlParameterList.Add(new SqlParameter("@Name", zone.RegionName));
                    aSqlParameterList.Add(new SqlParameter("@GroupId", zone.GroupId));

                    DataTable dt = accessManager.GetDataTable("sp_check_ZoneInfo", aSqlParameterList);
                    if (dt.Rows.Count == 0)
                    {

                        if (zone.IsActive == false)
                        {
                            List<SqlParameter> aSqlprm = new List<SqlParameter>();
                            aSqlprm.Add(new SqlParameter("@MasterId", zone.RegionId));
                            aSqlprm.Add(new SqlParameter("@PageName", "Zone"));
                            DataTable dtMarket = accessManager.GetDataTable("sp_check_Vali_MarketStructure", aSqlprm);

                            if (dtMarket.Rows.Count == 0)
                            {

                                aInformation.isSuccess = accessManager.UpdateData("sp_Update_ZoneInfo", gSqlParameterList);
                                pk = zone.RegionId;
                            }
                            else
                            {
                                aInformation.isValiCheck = true;

                            }
                        }
                        else
                        {
                            aInformation.isSuccess = accessManager.UpdateData("sp_Update_ZoneInfo", gSqlParameterList);
                            pk = zone.RegionId;
                        }
                        }
                    else
                    {
                        aInformation.isDuplicateCheck = true;
                    }

                }
                else
                {
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_ZoneInfo", gSqlParameterList);
                }

                if (pk > 0)
                {
                    aInformation.isSuccess = true;

                    int[] divisionId = null;
                    try
                    {
                        divisionId = zone.DivisionId.Split(',').Select(Int32.Parse).ToArray();
                    }
                     
                    catch(Exception ex)
                    {

                    }
                    //for (int i = 0; i < divisionId.Length; i++)
                    //{

                    //    int divId = divisionId[i];
                    //    List<SqlParameter> aSQL = new List<SqlParameter>();
                    //    aSQL.Add(new SqlParameter("@zoneId", pk));
                    //    aSQL.Add(new SqlParameter("@divisionId", divId));
                    //    aInformation.isSuccess = accessManager.SaveData("sp_Save_DivisionZoneRelation", aSQL);

                    //}

                    zone.DivisionId = " ";

                }
                else
                {
                    aInformation.isDuplicateCheck = true;

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

        public ResultInfo UpdateActiveStatus(int zoneId, DateTime acDate, string reason, string loginUser, bool isActive)
        {

            ResultInfo aInformation = new ResultInfo();
            try
            {

                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;
                gSqlParameterList.Add(new SqlParameter("@zoneId", acDate));
                gSqlParameterList.Add(new SqlParameter("@acDate", acDate));
                gSqlParameterList.Add(new SqlParameter("@reason", reason));
                gSqlParameterList.Add(new SqlParameter("@loginUser", loginUser));
                gSqlParameterList.Add(new SqlParameter("@isActive", isActive));
                //aInformation.isSuccess = accessManager.UpdateData("sp_Save_ZoneInfo", gSqlParameterList);


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

        public ResultInfo UpdateZoneInfo(Zone zone)
        {
            throw new NotImplementedException();
        }

 
    }
}