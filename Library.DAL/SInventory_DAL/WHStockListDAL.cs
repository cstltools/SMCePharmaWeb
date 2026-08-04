using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class WHStockListDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public DataTable LoadWHStock()
        {
            string query = @"SELECT * FROM dbo.tblWHStockInMaster WHERE Status='Approved'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadWHStockwithDetail(string whId)
        {
            string query = @"SELECT ROW_NUMBER() OVER (Order by dbo.tblWHStockInDetail.WHStockInDetailID) AS SL,REPLACE(CONVERT(NVARCHAR,tblWHStockInDetail.MfgDate, 106), ' ', '-')MfgDate,REPLACE(CONVERT(NVARCHAR,tblWHStockInDetail.ExpDate, 106), ' ', '-')ExpDate,*,Qty as Quantity,VAT as Vat,Quantity AS CStock,ReceiveId  FROM dbo.tblWHStockInMaster
            LEFT JOIN dbo.tblWHStockInDetail ON dbo.tblWHStockInMaster.WHStockInMasterID = dbo.tblWHStockInDetail.WHStockInMasterID
            LEFT JOIN dbo.tblProduct ON dbo.tblWHStockInDetail.ProductId = dbo.tblProduct.ProductId
            LEFT JOIN dbo.tblCentralStore ON dbo.tblCentralStore.MigoDetailID=dbo.tblWHStockInDetail.WHStockInDetailID
            WHERE dbo.tblWHStockInDetail.WHStockInMasterID='" + whId+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public Int32 WarehouseStockInCodeId()
        {
            DataTable aDataTable = new DataTable();
            string query = @"SELECT (isnull(MAX(SUBSTRING(WHStockOutCode,5,15)),0)+1) as PKMaxNo FROM dbo.tblWHStockOutMaster ";
            return Convert.ToInt32(aCommonInternalDal.DataContainerDataTable(query, "SSIDB").Rows[0][0].ToString());
        }

        public bool SaveStockOutMasterInformation(WarehouseStockInMasterDao aStockInMasterDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblWHStockOutMaster
        ( WHStockOutMasterID,
          WHStockOutCode,
          ManufacId ,
          WHStockOutDate ,
          EntryBy ,
          EntryDate,
          WHStockInMasterID,
          Reason
        )
        VALUES  (   
                                 '" + aStockInMasterDao.WHStockOutMasterID + "'," +
                                 "'" + aStockInMasterDao.WHStockInCode + "'," +
                                 "'" + aStockInMasterDao.ManufacId + "'," +
                                 "'" + aStockInMasterDao.WHStockInDate + "'," +
                                 
                                 //"'" + aStockInMasterDao.Status + "'," +
                                 "'" + aStockInMasterDao.EntryBy + "'," +
                                 "'" + aStockInMasterDao.EntryDate + "', " +
                                 "'" + aStockInMasterDao.WHStockInMasterID + "',"+
                                 "'" + aStockInMasterDao.Reason + "')";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveWarehouseStockOutDetail(WharehouseStockInDetailsDao aDetailDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblWHStockOutDetail
        ( 
          WHStockOutMasterID,ProductId, Qty,WHStockInDetailID,ReceiveId
        )
        VALUES  ('" + aDetailDao.WHStockInMasterID + "'," +
                                 "'" + aDetailDao.ProductId + "'," +
                                 //"'" + aDetailDao.Batch + "'," +
                                 //"'" + aDetailDao.ExpDate + "'," +
                                 //"'" + aDetailDao.MfgDate + "'," +
                                 "'" + aDetailDao.Qty + "'," +
                                 //"'" + aDetailDao.Price + "'," +
                                 //"'" + aDetailDao.VAT + "'," +
                                 //"'" + aDetailDao.TotalAmount + "' ,"
                                  "'" + aDetailDao.WHStockInDetailID + "',  "+
                                  "'" + aDetailDao.ReceiveId + "'  )";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }
        public bool UpdateCentralWH(string id,decimal qty)
        {
            string insertQuery = @"UPDATE dbo.tblCentralStore SET Quantity=Quantity-"+qty+" WHERE MigoDetailID='"+id+"'";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }


    }
}
