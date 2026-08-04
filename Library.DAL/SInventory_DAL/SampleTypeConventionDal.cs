using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;
using Library.DAO.SubDepot_DAO;

namespace Library.DAL.SInventory_DAL
{
   public class SampleTypeConventionDal
    {

        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();


        public void SalesCenterLoadDal(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitId", dc, "SSIDB");
        }

        public void ProductLoadDal(DropDownList aDownList)
        {
            string dc = "SELECT (ProductCode+':'+ProductName)Pro,* FROM dbo.tblProduct";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Pro", "ProductId", dc, "SSIDB");
        }


        public DataTable GetProductDcStore(string productCode,string ComUnit)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT *,
            tblProduct.ProductCode AS PCode , tblProduct.ProductName AS PName 
            FROM dbo.tblDCStore
            LEFT JOIN dbo.tblProduct ON dbo.tblDCStore.ProductCode = dbo.tblProduct.ProductCode    	    
            WHERE tblDCstore.ComUnitId=@ComUnitId And tblProduct.ProductId=@ProductId AND StockQty>0 order by tblProduct.ProductCode";
            aDataTableEmpInfo = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnit)),
                new SqlParameter("@ProductId", SInventorySql.DbValue(productCode))
            });
            return aDataTableEmpInfo;
        }

        public bool SaveDataForSubDcStockOutMaster(SampleStockForDcMaster aMasterDao)
        {
            string insertQuery =
                @"insert into tblSampleStockForDcMaster (SampleStockForDcMasterId,SampleStockForDcMasterCode,ComUnitId,Action,Date,EntryBy,EntryDate,Status) 
            values (@SampleStockForDcMasterId,@SampleStockForDcMasterCode,@ComUnitId,@Action,@Date,@EntryBy,@EntryDate,@Status)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForDcMasterId", aMasterDao.SampleStockForDcMasterId),
                new SqlParameter("@SampleStockForDcMasterCode", SInventorySql.DbValue(aMasterDao.SampleStockForDcMasterCode)),
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(aMasterDao.ComUnitId)),
                new SqlParameter("@Action", SInventorySql.DbValue(aMasterDao.Action)),
                new SqlParameter("@Date", SInventorySql.DbValue(aMasterDao.Date)),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(aMasterDao.EntryBy)),
                new SqlParameter("@EntryDate", SInventorySql.DbValue(aMasterDao.EntryDate)),
                new SqlParameter("@Status", SInventorySql.DbValue(aMasterDao.Status))
            });
        }

        public bool SaveDataForStockOutDetailDal(SampleStockForDcDetails aDetailsDao)
        {
            string insertQuery =
                @"insert into tblSampleStockForDcDetails (SampleStockForDcDetailsId,SampleStockForDcMasterId,DCStoreId,ProductCode,ProductName,BatchNo,ReceiveDate,ExpDate,SampleStock) 
            values (@SampleStockForDcDetailsId,@SampleStockForDcMasterId,@DCStoreId,@ProductCode,@ProductName,@BatchNo,@ReceiveDate,@ExpDate,@SampleStock)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForDcDetailsId", aDetailsDao.SampleStockForDcDetailsId),
                new SqlParameter("@SampleStockForDcMasterId", aDetailsDao.SampleStockForDcMasterId),
                new SqlParameter("@DCStoreId", aDetailsDao.DCStoreId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aDetailsDao.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(aDetailsDao.ProductName)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(aDetailsDao.BatchNo)),
                new SqlParameter("@ReceiveDate", SInventorySql.DbValue(aDetailsDao.ReceiveDate)),
                new SqlParameter("@ExpDate", SInventorySql.DbValue(aDetailsDao.ExpDate)),
                new SqlParameter("@SampleStock", aDetailsDao.SampleStock)
            });
        }

        public DataTable DcStockOutViewDal()
        {
            string query = @"Select SSFDM.SampleStockForDcMasterId,tblCompanyUnit.ComUnitName,SSFDM.Date,SSFDM.Action
                  from tblSampleStockForDcMaster SSFDM
                  Left join tblCompanyUnit ON tblCompanyUnit.ComUnitId = SSFDM.ComUnitId
                  where SSFDM.SampleStockForDcMasterId IS NOT NULL";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public bool DcStockOutMasterDeleteDal(string Id)
        {
            string query =
                @"Delete from tblSampleStockForDcMaster where tblSampleStockForDcMaster.SampleStockForDcMasterId = @SampleStockForDcMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForDcMasterId", SInventorySql.DbValue(Id))
            });
        }


        public bool DcStockOutDetailsDeleteDal(string Id)
        {
            string query =
                @"Delete from tblSampleStockForDcDetails where tblSampleStockForDcDetails.SampleStockForDcMasterId = @SampleStockForDcMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForDcMasterId", SInventorySql.DbValue(Id))
            });
        }


        public bool StockInCentral(SampleStockForDcDetails aDetails)
        {
            string query = @"Update tblDCStore Set StockQty = StockQty + @SampleStock Where DCStoreId=@DCStoreId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStock", aDetails.SampleStock),
                new SqlParameter("@DCStoreId", aDetails.DCStoreId)
            });
        }

        public bool StockOuTCentral(SampleStockForDcDetails aDetails)
        {
            string query = @"Update tblDCStore Set StockQty = StockQty - @SampleStock Where DCStoreId=@DCStoreId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStock", aDetails.SampleStock),
                new SqlParameter("@DCStoreId", aDetails.DCStoreId)
            });
        }

        public DataTable LoadSampleStock(string Id)
        {
            string query = @"Select DCStoreId, SampleStock from tblSampleStockForDcDetails where SampleStockForDcMasterId=@SampleStockForDcMasterId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SampleStockForDcMasterId", SInventorySql.DbValue(Id))
            });
        }
    }
}
