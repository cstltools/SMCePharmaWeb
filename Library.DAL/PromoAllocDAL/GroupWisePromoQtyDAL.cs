using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAO.PromoAlloc_DAO;
using SalesSolution.Web.Models;

namespace Library.DAL.PromoAllocDAL
{
    public class GroupWisePromoQtyDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        private DataAccessManager  accessManager = new DataAccessManager ();

        public DataTable LoadCentralWearhouse(string productId)
        {
            string query = @"SELECT ProductId,isnull(SUM(Quantity),0)Qty FROM dbo.tblCentralStore WHERE ProductId='" + productId + "' GROUP BY ProductId";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetList(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_GroupWisePromoQtyList", aSqlParameterlist);
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


        public ResultInfo Update___Info(string unitPriceId, int? CountNo, int UpdateBy, DateTime UpdateDate)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

              
                List<SqlParameter> gSqlParameterUpdate = new List<SqlParameter>();

                 
 
                    gSqlParameterUpdate.Add(new SqlParameter("@TourSetupEmployeeId", unitPriceId));
                    gSqlParameterUpdate.Add(new SqlParameter("@UpdateBy",  UpdateBy));
                    gSqlParameterUpdate.Add(new SqlParameter("@UpdateDate",  UpdateDate));
                    gSqlParameterUpdate.Add(new SqlParameter("@CountNo", CountNo ?? (object)DBNull.Value));


                aInformation.isSuccess= accessManager.UpdateData("sp_Update_PromoEmployeeQty", gSqlParameterUpdate);
                   
                 

                
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

        public ResultInfo SaveDetail(List<GroupWisePromoQtyDAO> _MarketDtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                

                    foreach (var item in _MarketDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                  
                        aSQL.Add(new SqlParameter("@MIOId", item.MIOId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@EmpInfoId", item.EmpInfoId ?? (object)DBNull.Value));

                    aSQL.Add(new SqlParameter("@TerritoryId", item.TerritoryId ?? (object)DBNull.Value));


                    aSQL.Add(new SqlParameter("@ProductId", item.ProductId ?? (object)DBNull.Value));


                    aSQL.Add(new SqlParameter("@PromoGroupId", item.PromoGroupId ?? (object)DBNull.Value));

                    aSQL.Add(new SqlParameter("@Month", item.Month ?? (object)DBNull.Value));

                    aSQL.Add(new SqlParameter("@Year", item.Year ?? (object)DBNull.Value));

                    aSQL.Add(new SqlParameter("@Qty", item.Qty ?? (object)DBNull.Value));

                    aSQL.Add(new SqlParameter("@EntryBy", sessionUser));


                    pk= accessManager.SaveDataReturnPrimaryKey("sp_Save_GroupWisePromoQty", aSQL);
                    aInformation.isSuccess = true;
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
        public bool SaveGroupWiseQty(GroupWisePromoQtyDAO aTargetDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblGroupWisePromoQty
                                (
                                    Year,
                                    Month,
                                    PromoGroupId, ProductId,Qty,Date,

                                    EntryBy,
                                    EntryDate
                                )
                                VALUES
                                ('" + aTargetDao.Year + "'," +
                                 "'" + aTargetDao.Month + "'," +
                                 "'" + aTargetDao.PromoGroupId + "'," +
                                  "'" + aTargetDao.ProductId + "'," +
                                 "'" + aTargetDao.Qty + "'," +
                                 "'" + aTargetDao.Date + "'," +
                                 "'" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "'" + DateTime.Now + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool UpdateGroupWiseQty(GroupWisePromoQtyDAO aTargetDao)
        {
            string insertQuery = @"UPDATE dbo.tblGroupWisePromoQty SET " +
                                 "Year='" + aTargetDao.Year + "'," +
                                 "Month='" + aTargetDao.Month + "'," +
                                 "PromoGroupId='" + aTargetDao.PromoGroupId + "'," +
                                  "ProductId='" + aTargetDao.ProductId + "'," +
                                 "Qty='" + aTargetDao.Qty + "'," +
                                 "Date='" + aTargetDao.Date + "'," +
                                 "UpdateBy='" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "UpdateDate='" + DateTime.Now + "' WHERE GWPromoQtyId='" + aTargetDao.GWPromoQtyId + "'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }

        public DataTable LoadGroupWiseQty()
        {
            string query = @"SELECT   CASE WHEN mas.Month=1 THEN 'January' WHEN mas.Month=2 THEN 'February' WHEN mas.Month=3 THEN 'March' WHEN mas.Month=4 THEN 'April' WHEN mas.Month=5 THEN 'May' WHEN mas.Month=6 THEN 'June'  WHEN mas.Month=7 THEN 'July' WHEN mas.Month=8 THEN 'August' WHEN mas.Month=9 THEN 'September'  WHEN mas.Month=10 THEN 'October'  WHEN mas.Month=11 THEN 'November'  WHEN mas.Month=12 THEN 'December' ELSE '' END  [MonthName]   , pro.ProductCode+' : '+pro.ProductName  ProductName ,GWPromoQtyId,Year,Month,mas.PromoGroupId,PromoGroupName,PromoGroupCode,Qty		 FROM dbo.tblGroupWisePromoQty mas with (nolock)
LEFT JOIN dbo.tblPromoGroup  with (nolock) ON mas.PromoGroupId=dbo.tblPromoGroup.PromoGroupId


LEFT JOIN dbo.tblProduct pro  with (nolock) ON mas.ProductId=pro.ProductId";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadGroupWiseQtyById(string id)
        {
            string query = @"SELECT * FROM dbo.tblGroupWisePromoQty WHERE GWPromoQtyId='" + id + "' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
