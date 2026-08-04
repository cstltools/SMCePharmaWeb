using Library.DAL.DataManager;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;

namespace Library.DAL.DoctorModule_DAL
{
    public class DepotWiseAreaSetupDal
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public ResultInfo DepotWiseAreaInfo(DepotWiseAreaDao areaDao, int sessionUser, int dcId)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);


                if (dcId > 0)
                {
                    List<SqlParameter> aaSqlParameterlist = new List<SqlParameter>();
                    aaSqlParameterlist.Add(new SqlParameter("@DepotId", dcId));
                    DataTable aDataTable = accessManager.GetDataTable("sp_CHK_DCWiseArea", aaSqlParameterlist);


                    foreach (var item in areaDao.DepotList)
                    {
                        if (!AllocatedOrNot(item.AreaId, aDataTable))
                        {
                            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

                            aSqlParameterlist.Add(new SqlParameter("@DepotId", item.DepotId));
                            aSqlParameterlist.Add(new SqlParameter("@AreaId", item.AreaId));
                            aSqlParameterlist.Add(new SqlParameter("@EntryBy", sessionUser));

                            pk = accessManager.SaveDataReturnPrimaryKey("sp_I_DepotWiseArea", aSqlParameterlist);

                            if (pk > 0)
                            {
                                aInformation.isSuccess = true;
                            }
                        }
                    }

                    if (aDataTable.Rows.Count > 0)
                    {
                        for (int i = 0; i < aDataTable.Rows.Count; i++)
                        {
                            var isExist = 0;

                            foreach (var item in areaDao.DepotList)
                            {
                                if (aDataTable.Rows[i].Field<Int32>("AreaId") == item.AreaId)
                                {
                                    isExist = 1;
                                }

                                if (isExist == 1)
                                {
                                    break;
                                }
                            }

                            if (isExist == 0)
                            {

                                if (aDataTable.Rows[i].Field<Int32>("DcWiseAreaId") != 0)
                                {
                                    List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                                    gSqlParameterList.Add(new SqlParameter("@DepotWiseAreaId", aDataTable.Rows[i].Field<Int32>("DcWiseAreaId")));
                                    gSqlParameterList.Add(new SqlParameter("@UpdateBy", sessionUser));
                                    accessManager.UpdateData("sp_UD_DepotWiseArea", gSqlParameterList);
                                    aInformation.isSuccess = true;
                                }

                            }

                        }
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


        private bool AllocatedOrNot(int value, DataTable aDataTable)
        {

            if (aDataTable.Rows.Count > 0)
            {

                for (int i = 0; i < aDataTable.Rows.Count; i++)
                {
                    if (aDataTable.Rows[i].Field<Int32>("AreaId") == Convert.ToInt32(value))
                    {
                        return true;
                    }
                }

            }

            return false;
        }


        public DataTable GetAreaByDepotId(int depotId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@DepotId", depotId));
                DataTable dt = accessManager.GetDataTable("sp_GET_DCWiseArea", aSqlParameterlist);
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

        public DataTable GetCompanyList()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                DataTable dt = accessManager.GetDataTable("sp_GET_CompanyInfo");
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

        public DataTable GetDepotList(int companyId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@CompanyId", companyId));
                DataTable dt = accessManager.GetDataTable("sp_GET_DepotByCompanyId", aSqlParameterlist);
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



        public DataTable GetSubDepotList(string companyId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@ComUnitId", companyId));
                DataTable dt = accessManager.GetDataTable("sp_GET_SubDepotByComUnitId", aSqlParameterlist);
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