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


    public class PromoMITagDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        private DataAccessManager  accessManager = new DataAccessManager ();

        //public bool SaveMIOTagMaster(PromoMIOTagMaster aTargetDao)
        //{

        //    string insertQuery = @"INSERT INTO dbo.tblPromoMIOTagMaster
        //                        (
        //                            PromoGroupId,
        //                            EntryBy,
        //                            EntryDate
        //                        )
        //                        VALUES
        //                        ('" + aTargetDao.PromoGroupId + "'," +
        //                         "'" + HttpContext.Current.Session["UserId"].ToString() + "'," +
        //                         "'" + DateTime.Now + "')  SELECT SCOPE_IDENTITY() AS id";
        //    return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        //}
        public int SaveMIOTagMaster(PromoMIOTagMaster aTargetDao)
        {
            List<SqlParameter> aSqlParameters = new List<SqlParameter>();
            aSqlParameters.Add(new SqlParameter("@PromoGroupId", aTargetDao.PromoGroupId));
            aSqlParameters.Add(new SqlParameter("@EntryBy", HttpContext.Current.Session["UserId"].ToString()));
            aSqlParameters.Add(new SqlParameter("@EntryDate", DateTime.Now));
            string insertQuery = @"INSERT INTO dbo.tblPromoMIOTagMaster
                                (
                                    PromoGroupId,
                                    EntryBy,
                                    EntryDate
                                )
                                VALUES
                                (@PromoGroupId,
                                    @EntryBy,
                                    @EntryDate)";
            return aCommonInternalDal.SaveDataByInsertCommandWithIdentity(insertQuery,aSqlParameters, "SSIDB");
        }
        public bool SaveMIOTagDetail(PromoMIOTagDetail aTargetDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblPromoMIOTagDetail
                                (
                                    MIOTagMasterId,
                                    MIOId
                                )
                                VALUES
                                ('" + aTargetDao.MIOTagMasterId + "'," +
                                 "'" + aTargetDao.MIOId + "') ";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public ResultInfo SaveBonusCampaign(PromoMIOTagMaster master, List<PromoMIOTagDetail> _MarketDtls, string sessionUser)
        {
            int pk = 0;
            ResultInfo aInformation = new ResultInfo();
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> gSqlParameterList = new List<SqlParameter>();
                DateTime entryDtae = DateTime.Now;

                gSqlParameterList.Add(new SqlParameter("@MIOTagId", master.MIOTagId));
                gSqlParameterList.Add(new SqlParameter("@PromoGroupId", master.PromoGroupId ?? (object)DBNull.Value));
                gSqlParameterList.Add(new SqlParameter("@EntryBy", sessionUser));


                if (master.MIOTagId > 0)
                {
                    
                    aInformation.isSuccess = accessManager.UpdateData("sp_Update_PromoMIOTagMaster", gSqlParameterList);

                    pk = master.MIOTagId;

                }
                else
                {
               
                    pk = accessManager.SaveDataReturnPrimaryKey("sp_Save_PromoMIOTagMaster", gSqlParameterList);
                    if (pk > 0)
                    {
                        aInformation.isSuccess = true;
                    }
                    else
                    {
                        aInformation.isSuccess = false;

                    }
                }

                if (pk > 0)
                {
                    

                    foreach (var item in _MarketDtls)
                    {

                        List<SqlParameter> aSQL = new List<SqlParameter>();
                        aSQL.Add(new SqlParameter("@MIOTagId", pk));
                        aSQL.Add(new SqlParameter("@MIOId", item.MIOId ?? (object)DBNull.Value));
                        aSQL.Add(new SqlParameter("@EmpInfoId", item.EmpInfoId ?? (object)DBNull.Value));
                        

                        aInformation.isSuccess = accessManager.SaveData("sp_Save_PromoMIOTagDetail", aSQL);

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
        public bool DeleteData(string id)
        {
            string insertQuery = @"DELETE FROM tblPromoMIOTagDetail WHERE MIOTagMasterId='"+id+ "'  ";
            return aCommonInternalDal.DeleteDataByDeleteCommand(insertQuery, "SSIDB");
        }
        public DataTable LoadGroup()
        {
            string query = @"SELECT * FROM dbo.tblPromoGroup";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadProduct()
        {
            string query = @"SELECT ProductId, ProductCode+' : '+ProductName ProductName FROM dbo.tblProduct WITH (NOLOCK)
WHERE ProductGroupId IN (2,3)";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadMIOTag(string id)
        {
            string query = @"SELECT * FROM dbo.tblPromoMIOTagMaster where PromoGroupId='"+id+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadMIO(string groupId)
        {
            string query = @"SELECT * FROM (SELECT EmpMasterCode,EmpName,TerritoryCode+' : '+ TerritoryName TerritoryName,tblEmpGeneralInfo.EmpInfoId,MIOId,tblMIOInfo.TerritoryId,'False'CheckStatus,'0'MIOTagMasterId FROM dbo.tblMIOInfo
            LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblMIOInfo.EmployeeId
            LEFT JOIN dbo.tblTerritory ON dbo.tblTerritory.TerritoryId=dbo.tblMIOInfo.TerritoryId
            WHERE tblMIOInfo.IsActive=1 AND MIOId NOT IN (SELECT MIOId FROM tblPromoMIOTagDetail 
            LEFT JOIN tblPromoMIOTagMaster ON tblPromoMIOTagMaster.MIOTagId=tblPromoMIOTagDetail.MIOTagMasterId
            WHERE PromoGroupId='" + groupId+"')"+

            " UNION ALL " +
            " SELECT EmpMasterCode,EmpName,TerritoryCode+' : '+ TerritoryName TerritoryName,tblEmpGeneralInfo.EmpInfoId,tblMIOInfo.MIOId,tblMIOInfo.TerritoryId,'True'CheckStatus,MIOTagMasterId FROM " +
            " tblPromoMIOTagDetail " +
            " LEFT JOIN tblPromoMIOTagMaster ON tblPromoMIOTagMaster.MIOTagId=tblPromoMIOTagDetail.MIOTagMasterId " +
            " LEFT JOIN dbo.tblMIOInfo ON dbo.tblMIOInfo.MIOId=tblPromoMIOTagDetail.MIOId " +
            " LEFT JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblMIOInfo.EmployeeId " +
            " LEFT JOIN dbo.tblTerritory ON dbo.tblTerritory.TerritoryId=dbo.tblMIOInfo.TerritoryId " +
            " WHERE tblMIOInfo.IsActive=1 AND PromoGroupId='"+groupId+"') AS tblt ORDER BY tblt.EmpInfoId ASC";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable LoadMIOByGroupId(string groupId)
        {
            string query = @"SELECT '' Qty,tblMIOInfo.TerritoryId , EmpMasterCode,EmpName,TerritoryCode+' : '+ TerritoryName TerritoryName,tblEmpGeneralInfo.EmpInfoId,tblMIOInfo.MIOId,tblMIOInfo.TerritoryId,'False'CheckStatus,MIOTagMasterId FROM   tblPromoMIOTagDetail  
LEFT JOIN tblPromoMIOTagMaster ON tblPromoMIOTagMaster.MIOTagId=tblPromoMIOTagDetail.MIOTagMasterId  
 inner JOIN dbo.tblMIOInfo ON dbo.tblMIOInfo.EmployeeId=tblPromoMIOTagDetail.EmpInfoId  
  inner JOIN dbo.tblEmpGeneralInfo ON tblEmpGeneralInfo.EmpInfoId = tblPromoMIOTagDetail.EmpInfoId 
   LEFT JOIN dbo.tblTerritory ON dbo.tblTerritory.TerritoryId=dbo.tblMIOInfo.TerritoryId    WHERE   PromoGroupId='" + groupId + "'    ORDER BY EmpMasterCode asc ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
