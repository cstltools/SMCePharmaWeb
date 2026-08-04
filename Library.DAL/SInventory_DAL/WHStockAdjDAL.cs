using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class WHStockAdjDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public DataTable LoadWHStockAdjustment(string parm)
        {
            string query = @"SELECT tblWearhouse.WearhouseName,tblAdjustmentType.AdjustmentType as AdjustmentType1,* FROM dbo.tblWHStockAdjustment 
LEFT JOIN dbo.tblAdjustmentType ON tblWHStockAdjustment.AdjustmentType = tblAdjustmentType.AdjustmentTypeId
	LEFT JOIN dbo.tblWearhouse ON tblWHStockAdjustment.FromStore = tblWearhouse.WearhouseId
	where WHStockAdjId is not null 
" + parm;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }



        public DataTable GetWhStockAdjustmentListReportInformation(string Id)
        {
            string query = @"SELECT CSS.ProductName, CSS.ProductCode, dtl.Quantity, tblAdjustmentType.AdjustmentType as
AdjustmentType1,TransactionNo,TransactionDate,tblWHStockAdjustment.Remarks,(CSS.UnitPrice*dtl.Quantity)WearhouseName   FROM  dbo.tblWHStockAdjustment
LEFT JOIN dbo.tblAdjustmentType ON tblWHStockAdjustment.AdjustmentType = tblAdjustmentType.AdjustmentTypeId
	LEFT JOIN dbo.tblWearhouse ON tblWHStockAdjustment.FromStore = tblWearhouse.WearhouseId
	 left join tblWHAdjustmentDetail dtl on  dtl.WHStockAdjId=tblWHStockAdjustment.WHStockAdjId
	 left join tblCentralStore CSS on  CSS.ReceiveId=dtl.ReceiveId
	 where tblWHStockAdjustment.WHStockAdjId=" + Id;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public int SaveWHStockAdjMaster(WHStockAdjDAO adjDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@TransactionNo", adjDao.TransactionNo));
            aSqlParameterlist.Add(new SqlParameter("@TransactionDate", adjDao.TransactionDate));
            aSqlParameterlist.Add(new SqlParameter("@AdjustmentType", adjDao.AdjustmentType));
            aSqlParameterlist.Add(new SqlParameter("@StockEffect", adjDao.StockEffect));
            aSqlParameterlist.Add(new SqlParameter("@FromStore", adjDao.FromStore));
            aSqlParameterlist.Add(new SqlParameter("@toStore", adjDao.toStore));
            aSqlParameterlist.Add(new SqlParameter("@Remarks", adjDao.Remarks));
            aSqlParameterlist.Add(new SqlParameter("@EntryBy", adjDao.EntryBy));
            aSqlParameterlist.Add(new SqlParameter("@EntryDate", adjDao.EntryDate));
            aSqlParameterlist.Add(new SqlParameter("@ActionStatus", adjDao.ActionStatus));
            string insertQuery = @"INSERT INTO dbo.tblWHStockAdjustment
                                    (
                                        TransactionNo,
                                        TransactionDate,
                                        AdjustmentType,
                                        StockEffect,
                                        FromStore,toStore,
                                        Remarks,
                                        EntryBy,
                                        EntryDate,
                                        ActionStatus
                                    )
                                    VALUES  ( @TransactionNo,
                                        @TransactionDate,
                                        @AdjustmentType,
                                        @StockEffect,
                                        @FromStore,@toStore,
                                        @Remarks,
                                        @EntryBy,
                                        @EntryDate,
                                        
                                        @ActionStatus)";
            return aCommonInternalDal.SaveDataByInsertCommandWithIdentity(insertQuery,aSqlParameterlist, "SSIDB");
        }
        public int SaveWHStockAdjDetail(WhStockAdjDetailDAO adjDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@WHStockAdjId", adjDao.WHStockAdjId));
            aSqlParameterlist.Add(new SqlParameter("@Quantity", adjDao.Quantity));
            aSqlParameterlist.Add(new SqlParameter("@ReceiveId", adjDao.ReceiveId));
            
            string insertQuery = @"INSERT INTO dbo.tblWHAdjustmentDetail
                                    (
                                        WHStockAdjId,
                                        Quantity,
                                        ReceiveId
                                    )
                                    VALUES
                                    (   @WHStockAdjId,
                                        @Quantity,
                                        @ReceiveId
                                    )";
            return aCommonInternalDal.SaveDataByInsertCommandWithIdentity(insertQuery, aSqlParameterlist, "SSIDB");
        }
        private string OrdnNoGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "0" + Id;
            }
            code = "WHA-" + Id;
            return code;
        }
        public DataTable LoadProductFromWH(string productId)
        {
            string query = @"SELECT *,(ROW_NUMBER() OVER (ORDER BY dbo.tblCentralStore.ReceiveId))SL FROM dbo.tblCentralStore WHERE ProductId='" + productId + "' and Quantity>0 ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadWHStockAdjustment()
        {
            string query = @"SELECT tblWearhouse.WearhouseName,tblAdjustmentType.AdjustmentType as AdjustmentType1,* FROM dbo.tblWHStockAdjustment 
LEFT JOIN dbo.tblAdjustmentType ON tblWHStockAdjustment.AdjustmentType = tblAdjustmentType.AdjustmentTypeId
	LEFT JOIN dbo.tblWearhouse ON tblWHStockAdjustment.FromStore = tblWearhouse.WearhouseId
";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadWHStockAdjustmentById(string id)
        {
            string query = @"SELECT  tblAdjustmentType.AdjustmentType as AdjustmentType1,* FROM dbo.tblWHStockAdjustment
            LEFT JOIN dbo.tblWHAdjustmentDetail ON tblWHAdjustmentDetail.WHStockAdjId = tblWHStockAdjustment.WHStockAdjId
			LEFT JOIN dbo.tblCentralStore ON tblCentralStore.ReceiveId = tblWHAdjustmentDetail.ReceiveId
LEFT JOIN dbo.tblAdjustmentType ON tblWHStockAdjustment.AdjustmentType = tblAdjustmentType.AdjustmentTypeId
            WHERE tblWHStockAdjustment.WHStockAdjId='" + id + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetTransNo(string collDate)
        {
            string query = @"SELECT  ('WHA-'+(SUBSTRING(CONVERT(NVARCHAR(4),YEAR('" + collDate + "')),3,2)+(CASE WHEN LEN(CONVERT(NVARCHAR(4),MONTH('" + collDate + "')))=1 THEN '0'+ "+
                             " CONVERT(NVARCHAR(4),MONTH('" + collDate + "')) ELSE CONVERT(NVARCHAR(4),MONTH('" + collDate + "')) end)+(CONVERT(NVARCHAR(MAX),(ISNULL((MAX(CONVERT(INT,SUBSTRING(TransactionNo,9,11)))),10000)+1))))) AS TransNO  "+
                              " FROM dbo.tblWHStockAdjustment ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public void LoadProduct(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT ProductId,(ProductCode+':'+ProductName)Product FROM dbo.tblProduct";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "Product", "ProductId", queryStr);
        }
        public void LoadAdjustmentType(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblAdjustmentType";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AdjustmentType", "AdjustmentTypeId", queryStr);
        }
        public void LoadTostore(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public bool UpdateCentralStoreStock(string productId,decimal qty,string recvId,string sign)
        {
            string insertQuery = @"UPDATE dbo.tblCentralStore SET  Quantity=Quantity"+sign+""+qty+" WHERE ReceiveId='"+recvId+"' AND ProductId='"+productId+"'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }
        public bool DeleteStockWHAdjustment(string adjId)
        {
            string insertQuery = @"DELETE FROM dbo.tblWHAdjustmentDetail WHERE WHStockAdjId='"+adjId+"' DELETE FROM dbo.tblWHStockAdjustment WHERE WHStockAdjId='"+adjId+"'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }
    }
}
