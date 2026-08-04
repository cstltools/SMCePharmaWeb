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
    public class WhStockConditionFreezeDal
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

         public void GetWhInfoOnDropDownList(DropDownList ddl)
        {
            string query = @"SELECT WearhouseId, WearhouseCode + ':' + WearhouseName AS WearhouseName  FROM tblWearhouse";
            aCommonInternalDal.LoadDropDownValue(ddl, "WearhouseName", "WearhouseId", query, "SSIDB");
        }

        public DataTable GetWhStockInformation()
        {
            string query = @"SELECT tblCentralStore.*,ReceiveId AS nomanslandID,tblCentralStore.ProductCode,tblCentralStore.ProductName,tblCentralStore.BatchNo,ExpDate,ReceiveDate,StockInQty AS TotalQuantity,Quantity AS StockQty,tblUnitPrice.UnitPrice*Quantity AS Amount,StockCondition
                           FROM dbo.tblCentralStore INNER JOIN dbo.tblUnitPrice ON tblCentralStore.ProductCode = tblUnitPrice.ProductCode        
                           where StockCondition = 'Available'  and  Quantity>0 ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable LoadWHData(int ReceiveId)
        {
            string query = @"SELECT  tblCentralStore.*,ReceiveId AS nomanslandID,tblCentralStore.ProductCode,tblCentralStore.ProductName,tblCentralStore.BatchNo,ExpDate,ReceiveDate,StockInQty AS TotalQuantity,Quantity AS StockQty,tblUnitPrice.UnitPrice*Quantity AS Amount,StockCondition
                           FROM dbo.tblCentralStore INNER JOIN dbo.tblUnitPrice ON tblCentralStore.ProductCode = tblUnitPrice.ProductCode        
                           where StockCondition = 'Available' AND ReceiveId= '" + ReceiveId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public void LoadStockConditionBll(DropDownList aDownList, string userid)
        {
            string StockCondition = "select * from tblStockCondition WHERE StockCondition<>'Available' AND StockConId IN (SELECT StockConId FROM tblStockConditionPermission where Permission=1 AND UserId='" + userid + "')";
            aCommonInternalDal.LoadDropDownValue(aDownList, "StockCondition", "StockConId", StockCondition, "SSIDB");
        }

        public bool SaveforWh(WhStockConditionFreezeDao aConditionFreezeDao)
        {
            string insertQuery = @"insert into tblWhStockConditionFreeze (WhStockConditionFreezeID,ReceiveId,ManufacId,FreezeQty,EntryBy,EntryDate) 
            values (" + aConditionFreezeDao.WhStockConditionFreezeID + "," + aConditionFreezeDao.ReceiveId + ",'" + aConditionFreezeDao.ManufacId + "','" + aConditionFreezeDao.FreezeQty + "','" + aConditionFreezeDao.EntryBy + "','" + aConditionFreezeDao.EntryDate + "')";

            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveWhStoreFreeze(WhStoreFreezeDao aWhStoreFreezeDao)
        {
            string insertQuery = @"insert into tblWhStoreFreeze (TotalQuantity,ProductId,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,StockQty,DamageQty,StockRcvDate,StockCondition,Remarks,ReceiveId,WhStockConditionFreezeID) 
            values (" + "'" + aWhStoreFreezeDao.TotalQuantity + "','" + aWhStoreFreezeDao.ProductId + "','" + aWhStoreFreezeDao.ProductName + "','" + aWhStoreFreezeDao.PackSize + "','" + aWhStoreFreezeDao.BatchNo + "','" + aWhStoreFreezeDao.ExpDate + "','" + aWhStoreFreezeDao.ReceiveDate  + "','" + aWhStoreFreezeDao.StockQty + "','" + aWhStoreFreezeDao.DamageQty + "','" + aWhStoreFreezeDao.StockRcvDate + "','" + aWhStoreFreezeDao.StockCondition + "','" + aWhStoreFreezeDao.Remarks + "','" + aWhStoreFreezeDao.ReceiveId + "','" + aWhStoreFreezeDao.WhStockConditionFreezeID + "'" + ")";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool UpdateCentralStore(decimal StockQty, int ReceiveId)
        {
            string query = @"UPDATE tblCentralStore SET Quantity='" + StockQty + "' WHERE ReceiveId=" + ReceiveId + "";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
    }
}
