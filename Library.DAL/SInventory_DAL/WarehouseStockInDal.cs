using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class WarehouseStockInDal
    {
        ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

        public void LoadmanufacturerName(DropDownList ddl)
        { 
            string queryStr = "select * from tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        public void LoadSupplier(DropDownList ddl)
        {
            string queryStr = "SELECT * FROM dbo.tblSupplierInformation";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "SupplierName", "SupplierId", queryStr);
        }
        public DataTable LoadProductCode(string productId)
        {
            DataTable aDataTable = new DataTable();
            string query = @"SELECT * FROM tblProduct  with (nolock) left join tblUnitPrice  with (nolock) on tblProduct.ProductId=tblUnitPrice.ProductId
LEFT JOIN dbo.tblStockUOM  with (nolock) ON tblStockUOM.StockUOMId = tblProduct.StockUOMId where  LTRIM(RTRIM(tblProduct.ProductCode))='" + productId.Trim() + "' ";
            aDataTable = aInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTable;
        }

        public bool SaveStockInMasterInformation(WarehouseStockInMasterDao aStockInMasterDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblWHStockInMaster
        ( WHStockInMasterID,
          WHStockInCode,
          ManufacId ,
            SupplierId,
          WHStockInDate ,
          TotalQuantity ,
          TotalVat ,
          TotalValue ,
          ChallanNo,
          ChallanDate,
          ReferenceNo,
          ReferenceDate,
          Remarks ,
          Status ,   
          EntryBy ,
          EntryDate
        )
        VALUES  (   
                                 '" + aStockInMasterDao.WHStockInMasterID + "'," + 
                                 "'" + aStockInMasterDao.WHStockInCode + "'," +
                                 "'" + aStockInMasterDao.ManufacId + "'," +
                                 "'" + aStockInMasterDao.SupplierId + "'," + 
                                 "'" + aStockInMasterDao.WHStockInDate + "'," +
                                 "'" + aStockInMasterDao.TotalQuantity + "'," +
                                 "'" + aStockInMasterDao.TotalVat + "'," +
                                 "'" + aStockInMasterDao.TotalValue + "'," +
                                 "'" + aStockInMasterDao.ChallanNo + "'," +
                                 "'" + aStockInMasterDao.ChallanDate + "'," +
                                 "'" + aStockInMasterDao.ReferenceNo + "'," +
                                 "'" + aStockInMasterDao.ReferenceDate + "'," +
                                 "'" + aStockInMasterDao.Remarks + "'," +
                                 "'" + aStockInMasterDao.Status + "'," +
                                 "'" + aStockInMasterDao.EntryBy + "'," +
                                 "'" + aStockInMasterDao.EntryDate +  "' " + ")";

            return aInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveWarehouseStockInDetail(WharehouseStockInDetailsDao aDetailDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblWHStockInDetail
        ( 
          WHStockInMasterID,ProductId,Batch, ExpDate, MfgDate, Qty, Price, VAT, TotalAmount 
        )
        VALUES  ('" + aDetailDao.WHStockInMasterID + "'," + 
                                 "'" + aDetailDao.ProductId + "'," +
                                 "'" + aDetailDao.Batch + "'," +
                                 "'" + aDetailDao.ExpDate + "'," +
                                 "'" + aDetailDao.MfgDate + "'," +
                                 "'" + aDetailDao.Qty + "'," +
                                 "'" + aDetailDao.Price + "'," +
                                 "'" + aDetailDao.VAT + "'," +
                                 "'" + aDetailDao.TotalAmount + "' " + ")";

            return aInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public Int32 WarehouseStockInCodeId()
        {
            DataTable aDataTable = new DataTable();
            string query = @"SELECT (isnull(MAX(SUBSTRING(WHStockInCode,5,15)),0)+1) as PKMaxNo FROM dbo.tblWHStockInMaster";
            return Convert.ToInt32(aInternalDal.DataContainerDataTable(query, "SSIDB").Rows[0][0].ToString());
        }

        public DataTable GetWarehouseStockInData()
        {
            string query = @"SELECT * FROM dbo.tblWHStockInMaster AS WSHM 
            WHERE WSHM.Status = 'Posted' OR WSHM.Status = 'Reject'";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetWarehouseStockInMasterInfo(string stockInId)
        {
            string query = @"SELECT * FROM dbo.tblWHStockInMaster AS MGM 
            WHERE MGM.WHStockInMasterID = '" + stockInId + "'";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetWarehouseStockInDetailInfo(string stockInId)
        {
            string query = @"
SELECT WHSD.WHStockInDetailID ,
       WHSD.WHStockInMasterID ,
       WHSD.ProductId ,
       WHSD.Batch ,
       WHSD.ExpDate ,
       WHSD.MfgDate ,
       WHSD.Qty AS Quantity ,
       WHSD.Price ,
       WHSD.VAT ,
       WHSD.TotalAmount ,
       PD.ProductId ,
       PD.ProductCode ,
       PD.ProductName ,
       PD.Description ,
       PD.ProductBrandId ,
       PD.PackSizeId ,
       PD.PackSize ,
       PD.ProTypeId ,
       PD.CategoryId ,
       PD.ManufacId ,
       PD.StockUOMId ,
       PD.CaseId,SU.StockUOMName AS UOM FROM dbo.tblWHStockInDetail AS WHSD
            INNER JOIN dbo.tblProduct AS PD ON PD.ProductId = WHSD.ProductId
			LEFT JOIN dbo.tblStockUOM AS SU ON SU.StockUOMId = PD.StockUOMId
            WHERE WHSD.WHStockInMasterID =  '" + stockInId + "'";
            return aInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool UpdateStockInMasterInfo(WarehouseStockInMasterDao aStockInMasterDao)
        {
            string insertQuery = @"UPDATE dbo.tblWHStockInMaster SET ManufacId ='"
                + aStockInMasterDao.ManufacId + "',WHStockInDate = '" + aStockInMasterDao.WHStockInDate
                + "' ,ChallanNo = '" + aStockInMasterDao.ChallanNo
                + "' ,SupplierId = '" + aStockInMasterDao.SupplierId
                + "' ,ChallanDate = '" + aStockInMasterDao.ChallanDate
                + "' ,ReferenceNo = '" + aStockInMasterDao.ReferenceNo
                + "' ,ReferenceDate = '" + aStockInMasterDao.ReferenceDate
                + "' ,TotalQuantity = '" + aStockInMasterDao.TotalQuantity
                + "' ,TotalValue = '" + aStockInMasterDao.TotalValue
                + "' ,TotalVat = '" + aStockInMasterDao.TotalVat
                + "' ,Status = '" + aStockInMasterDao.Status 
                + "',UpdateBy ='" + aStockInMasterDao.UpdateBy 
                + "',UpdateDate ='" + aStockInMasterDao.UpdateDate
                + "',Remarks ='" + aStockInMasterDao.Remarks
                + "' WHERE WHStockInMasterID = '" + aStockInMasterDao.WHStockInMasterID + "'";

            return aInternalDal.UpdateDataByUpdateCommand(insertQuery, "SSIDB");
        }


        public void DeleteWhStockInDetailById(int stockInId)
        {
            string insertQuery = @"DELETE FROM dbo.tblWHStockInDetail WHERE WHStockInMasterID = '" + stockInId + "'";
            
            aInternalDal.DeleteDataByDeleteCommand(insertQuery, "SSIDB");
        }

        public void DeleteWhStockInInfoById(string stockInId)
        {
            string insertQuery1 = @"DELETE FROM dbo.tblWHStockInMaster WHERE WHStockInMasterID = '" + stockInId + "'";
            aInternalDal.DeleteDataByDeleteCommand(insertQuery1, "SSIDB");

            string insertQuery2 = @"DELETE FROM dbo.tblWHStockInDetail WHERE WHStockInMasterID = '" + stockInId + "'";
            aInternalDal.DeleteDataByDeleteCommand(insertQuery2, "SSIDB");
        }
    }
}
