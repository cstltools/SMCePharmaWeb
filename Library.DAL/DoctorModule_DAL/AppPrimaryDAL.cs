

using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using Library.DAL.DataManager;
using SalesSolution.Models;

namespace SalesSolution.DataLayer
{
    public class AppPrimaryDAL
    {  
        private DataAccessManager  accessManager = new DataAccessManager ();


        public AppInfo GetActiveVersion()
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
   
                SqlDataReader dr = accessManager.GetSqlDataReader("sp_WebApi_GetVersion");
                AppInfo aInfo = new AppInfo();

                while (dr.Read())
                {

                    aInfo.Version = Convert.ToInt32(dr["Version"]);
                    aInfo.VersionName = dr["VersionName"].ToString();


                }

                return aInfo;

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


        public ImagePath GetImagePath(string type)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterList = new List<SqlParameter> { 
                    new SqlParameter("@type",type)
                };

                SqlDataReader dr = accessManager.GetSqlDataReader("sp_Webapi_Get_ImagePath", aSqlParameterList);
                ImagePath aInfo = new ImagePath();

                while (dr.Read())
                {

                    aInfo.ImagePreName = dr["ImagePreName"].ToString();
                    aInfo.ImagePathValue = dr["ImagePath"].ToString();


                }

                return aInfo;

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