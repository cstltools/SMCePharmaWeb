using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class WHStockListBLL
    {
        WHStockListDAL aWhStockListDal=new WHStockListDAL();
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
        public DataTable LoadWHStock()
        {
            return aWhStockListDal.LoadWHStock();
        }

        public DataTable LoadWHStockwithDetail(string whId)
        {
            return aWhStockListDal.LoadWHStockwithDetail(whId);
        }

        //public bool UpdateCentralWH(string id)
        //{
        //    return aWhStockListDal.UpdateCentralWH(id);
        //}

        public bool SaveStockOutMasterInfo(WarehouseStockInMasterDao aStockInMasterDao, out Int32 maxRowId)
        {
            maxRowId = StockInId();
            aStockInMasterDao.WHStockOutMasterID = maxRowId;
            aStockInMasterDao.WHStockInCode = WHStockInCode();

            return aWhStockListDal.SaveStockOutMasterInformation(aStockInMasterDao);
        }
        private int StockInId()
        {
            int ReqId = 0;
            ReqId = aClsPrimaryKeyFind.PrimaryKeyMax("WHStockOutMasterID", "tblWHStockOutMaster", "SSIDB");
            return ReqId;
        }
        public string WHStockInCode()
        {
            string ordNo = string.Empty;
            ordNo = OrdnNoGenerator(aWhStockListDal.WarehouseStockInCodeId());
            return ordNo;
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
            code = "WHS-" + Id;
            return code;
        }

        public string SaveWarehouseStockOutDetail(List<WharehouseStockInDetailsDao> aDetailList)
        {
            foreach (WharehouseStockInDetailsDao aDetailDao in aDetailList)
            {
                aWhStockListDal.SaveWarehouseStockOutDetail(aDetailDao);
                aWhStockListDal.UpdateCentralWH(aDetailDao.WHStockInDetailID.ToString(), aDetailDao.Qty);
            }
            return "Data Saved Successfully";
        }
    }
}
