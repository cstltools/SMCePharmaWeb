using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using Library.DAL.InternalCls;
using Library.DAO.PromoAlloc_DAO;
using Library.DAO.Target_DAO;

namespace Library.DAL.PromoAllocDAL
{
    public class PromoGroupDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SavePromoGroup(GroupDAO aTargetDao)
        {
            string insertQuery = @"
 
DECLARE @Code NVARCHAR(max)
SELECT @Code='PG-'+ CAST(1000+ISNULL(CAST(MAX(PromoGroupId) AS NVARCHAR(max)),0)+1 AS NVARCHAR(max))   FROM dbo.tblPromoGroup WITH (nolock)

PRINT @Code
INSERT INTO dbo.tblPromoGroup
                                (
                                    PromoGroupName,
                                    PromoGroupCode,
                                    EntryBy,
                                    EntryDate
                                )
                                VALUES
                                ('" + aTargetDao.PromoGroupName + "'," +
                                 "@Code," +
                                 
                                 "'" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "'" + DateTime.Now + @"')  	 ";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool UpdatePromoGroup(GroupDAO aTargetDao)
        {
            string insertQuery = @"UPDATE dbo.tblPromoGroup SET PromoGroupName='" + aTargetDao.PromoGroupName + "'," +
                                 
                                 "UpdateBy='" + HttpContext.Current.Session["UserId"].ToString() + "'," +
                                 "UpdateDate='" + DateTime.Now + "' WHERE PromoGroupId='"+aTargetDao.PromoGroupId+"'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }

        public DataTable LoadPromoGroup()
        {
            string query = @"SELECT * FROM dbo.tblPromoGroup";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadPromoGroupCode()
        {
            string query = @"SELECT 1000+ISNULL(MAX(PromoGroupId),0)+1 AS PromoGroupCode FROM dbo.tblPromoGroup";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadPromoGroupById(string id)
        {
            string query = @"SELECT * FROM dbo.tblPromoGroup WHERE PromoGroupId='" + id + "' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
