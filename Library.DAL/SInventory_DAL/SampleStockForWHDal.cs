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
    public class SampleStockForWHDal
    {

        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();



        public void SalesCenterLoadDal(DropDownList aDownList)
        {
            string dc = @"select WearhouseId, (WearhouseCode+':'+WearhouseName) as Com from dbo.tblWearhouse";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "WearhouseId", dc, "SSIDB");
        }

        public void ProductLoadDal(DropDownList aDownList)
        {
            string dc = "SELECT (ProductCode+':'+ProductName)Pro,* FROM dbo.tblProduct";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Pro", "ProductId", dc, "SSIDB");
        }

        public DataTable GetProductDcStore(string productCode)
        {
            string query = @"SELECT *,
            tblProduct.ProductCode AS PCode , tblProduct.ProductName AS PName 
            FROM dbo.tblCentralStore
            LEFT JOIN dbo.tblProduct ON dbo.tblCentralStore.ProductCode = dbo.tblProduct.ProductCode    	    
            WHERE tblProduct.ProductId=@ProductId AND StockInQty>0 order by tblProduct.ProductCode";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ProductId", SInventorySql.DbValue(productCode))
            });
        }

        public bool SaveDataForSubDcStockOutMaster(SampleStockForWareHouseMaster aMasterDao)
        {
            string insertQuery =
                @"insert into tblSampleStockForWareHouseMaster (SampleStockForWHMasterId,SampleStockForWareHouseMstCode,WareHouseId,Action,Date,EntryBy,EntryDate,Status) 
            values (@SampleStockForWHMasterId,@SampleStockForWareHouseMstCode,@WareHouseId,@Action,@Date,@EntryBy,@EntryDate,@Status)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForWHMasterId", aMasterDao.SampleStockForWareHouseMstId),
                new SqlParameter("@SampleStockForWareHouseMstCode", SInventorySql.DbValue(aMasterDao.SampleStockForWareHouseMstCode)),
                new SqlParameter("@WareHouseId", SInventorySql.DbValue(aMasterDao.WareHouseId)),
                new SqlParameter("@Action", SInventorySql.DbValue(aMasterDao.Action)),
                new SqlParameter("@Date", SInventorySql.DbValue(aMasterDao.Date)),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(aMasterDao.EntryBy)),
                new SqlParameter("@EntryDate", SInventorySql.DbValue(aMasterDao.EntryDate)),
                new SqlParameter("@Status", SInventorySql.DbValue(aMasterDao.Status))
            });
        }

        public bool SaveDataForStockOutDetailDal(SampleStockForWHDetails aDetailsDao)
        {
            string insertQuery =
                @"insert into tblSampleStockForWareHouseDetails (SampleStockForWHDetailsId,SampleStockForWHMasterId,ReceiveId,ProductCode,ProductName,BatchNo,ReceiveDate,ExpDate,SampleStock) 
            values (@SampleStockForWHDetailsId,@SampleStockForWHMasterId,@ReceiveId,@ProductCode,@ProductName,@BatchNo,@ReceiveDate,@ExpDate,@SampleStock)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForWHDetailsId", aDetailsDao.SampleStockForWHDetailsId),
                new SqlParameter("@SampleStockForWHMasterId", aDetailsDao.SampleStockForWHMasterId),
                new SqlParameter("@ReceiveId", aDetailsDao.ReceiveId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aDetailsDao.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(aDetailsDao.ProductName)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(aDetailsDao.BatchNo)),
                new SqlParameter("@ReceiveDate", SInventorySql.DbValue(aDetailsDao.ReceiveDate)),
                new SqlParameter("@ExpDate", SInventorySql.DbValue(aDetailsDao.ExpDate)),
                new SqlParameter("@SampleStock", aDetailsDao.SampleStock)
            });

        }

        public bool StockOutCentral(SampleStockForWHDetails aDetails)
        {
            string query = @"Update tblCentralStore Set StockInQty = StockInQty - @SampleStock where ReceiveId=@ReceiveId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStock", aDetails.SampleStock),
                new SqlParameter("@ReceiveId", aDetails.ReceiveId)
            });
        }

        public bool StockInCentral(SampleStockForWHDetails aDetails)
        {
            string query = @"Update tblCentralStore Set StockInQty = StockInQty + @SampleStock where ReceiveId=@ReceiveId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStock", aDetails.SampleStock),
                new SqlParameter("@ReceiveId", aDetails.ReceiveId)
            });
        }


        public DataTable DcStockOutViewDal()
        {
            string query = @"Select SSFDM.SampleStockForWHMasterId,tblWearhouse.WearhouseName,SSFDM.Date,SSFDM.Action
                           from tblSampleStockForWareHouseMaster  SSFDM
                           Left join tblWearhouse ON tblWearhouse.WearhouseId = SSFDM.WareHouseId
                           where SSFDM.SampleStockForWHMasterId IS NOT NULL";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public bool DcStockOutMasterDeleteDal(string Id)
        {
            string query =
                @"Delete from tblSampleStockForWareHouseMaster where SampleStockForWHMasterId = @SampleStockForWHMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForWHMasterId", SInventorySql.DbValue(Id))
            });
        }


        public bool DcStockOutDetailsDeleteDal(string Id)
        {
            string query =
                @"Delete from tblSampleStockForWareHouseDetails where SampleStockForWHMasterId = @SampleStockForWHMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForWHMasterId", SInventorySql.DbValue(Id))
            });
        }

        public DataTable GetStock(string Id)
        {
            string query = @"Select ReceiveId,SampleStock from tblSampleStockForWareHouseDetails where SampleStockForWHMasterId=@SampleStockForWHMasterId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForWHMasterId", SInventorySql.DbValue(Id))
            });
        }
    }
}
