using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class WarehouseStockInBll
    {
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
        WarehouseStockInDal aWarehouseStockInDal = new WarehouseStockInDal();

        public void LoadmanufacturerName(DropDownList ddl)
        {
            aWarehouseStockInDal.LoadmanufacturerName(ddl);
        }
        public void LoadSupplier(DropDownList ddl)
        {
            aWarehouseStockInDal.LoadSupplier(ddl);
        }

        public DataTable ProductInfo(string productId)
        {
            return aWarehouseStockInDal.LoadProductCode(productId);
        }

        public bool SaveStockInMasterInfo(WarehouseStockInMasterDao aStockInMasterDao, out Int32 maxRowId)
        {
            maxRowId = StockInId();
            aStockInMasterDao.WHStockInMasterID = maxRowId;
            aStockInMasterDao.WHStockInCode = WHStockInCode();

            return aWarehouseStockInDal.SaveStockInMasterInformation(aStockInMasterDao);
        }

        private int StockInId()
        {
            int ReqId = 0;
            ReqId = aClsPrimaryKeyFind.PrimaryKeyMax("WHStockInMasterID", "tblWHStockInMaster", "SSIDB");
            return ReqId;
        }
        public string WHStockInCode()
        {
            string ordNo = string.Empty;
            ordNo = OrdnNoGenerator(aWarehouseStockInDal.WarehouseStockInCodeId());
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

        public string SaveWarehouseStockInDetail(List<WharehouseStockInDetailsDao> aDetailList)
        {
            foreach (WharehouseStockInDetailsDao aDetailDao in aDetailList)
            {
                aWarehouseStockInDal.SaveWarehouseStockInDetail(aDetailDao);
            }
            return "Data Saved Successfully";
        }

        public DataTable LoadWarehouseStockInData()
        {
            return aWarehouseStockInDal.GetWarehouseStockInData();
        }

        public DataTable LoadWarehouseStockInMasterInfo(string stockInId)
        {
            return aWarehouseStockInDal.GetWarehouseStockInMasterInfo(stockInId);
        }


        public DataTable LoadWarehouseStockInDetailInfo(string stockInId)
        {
            return aWarehouseStockInDal.GetWarehouseStockInDetailInfo(stockInId);
        }

        public bool UpdateStockInMasterInfo(WarehouseStockInMasterDao aStockInMasterDao)
        {
            return aWarehouseStockInDal.UpdateStockInMasterInfo(aStockInMasterDao);
        }

        public string UpdateWarehouseStockInDetail(List<WharehouseStockInDetailsDao> aDetailList)
        {
            foreach (var aDetailDao in aDetailList)
            {
                aWarehouseStockInDal.SaveWarehouseStockInDetail(aDetailDao);
            }
            return "Data Updated Successfully";
        }

        public void DeleteWhStockInDetailById(int stockInId)
        {
            aWarehouseStockInDal.DeleteWhStockInDetailById(stockInId);
        }

        public void DeleteWhStockInInfoById(string stockInId)
        {
            aWarehouseStockInDal.DeleteWhStockInInfoById(stockInId);
        }
    }
}
