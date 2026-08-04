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
    public class SampleStockForWHBll
    {

        SampleStockForWHDal aConventionDal = new SampleStockForWHDal();

        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();


        public void ProductLoadBll(DropDownList aDownList)
        {
            aConventionDal.ProductLoadDal(aDownList);
        }


        public void SalesCenterLoadBll(DropDownList aDownList)
        {
            aConventionDal.SalesCenterLoadDal(aDownList);
        }

        public DataTable GetProductDcStore(string productCode)
        {
            return aConventionDal.GetProductDcStore(productCode);
        }


        public bool SaveDataForSubDcStockOutMasterBll(SampleStockForWareHouseMaster aMasterDao, out int SubDcStockOutMasterId)
        {
            SubDcStockOutMasterId = aClsPrimaryKeyFind.PrimaryKeyMax("SampleStockForWHMasterId", "tblSampleStockForWareHouseMaster");
            aMasterDao.SampleStockForWareHouseMstId = SubDcStockOutMasterId;
            aMasterDao.SampleStockForWareHouseMstCode = SubStockOutMasterCodeGenerator(aMasterDao.SampleStockForWareHouseMstId);
            return aConventionDal.SaveDataForSubDcStockOutMaster(aMasterDao);
        }
        public string SubStockOutMasterCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();

            if (Id.Length == 1)
            {
                Id = "0000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 7)
            {
                Id = "0" + Id;
            }

            code = "SSD" + Id;
            return code;
        }

        public bool SaveDataForSubStockOutDetailBll(List<SampleStockForWHDetails> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                stockOutDetail.SampleStockForWHDetailsId = aClsPrimaryKeyFind.PrimaryKeyMax("SampleStockForWHDetailsId", "tblSampleStockForWareHouseDetails");
                aConventionDal.SaveDataForStockOutDetailDal(stockOutDetail);
            }
            return true;
        }


        public bool StockOutDetail(List<SampleStockForWHDetails> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                aConventionDal.StockOutCentral(stockOutDetail);
            }
            return true;
        }


        public bool StockIn(List<SampleStockForWHDetails> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                aConventionDal.StockInCentral(stockOutDetail);
            }
            return true;
        }


        public DataTable DcStockOutBll()
        {
            return aConventionDal.DcStockOutViewDal();
        }


        public bool DcStockOutDetailsDelete(string Id)
        {
            return aConventionDal.DcStockOutDetailsDeleteDal(Id);
        }

        public bool DcStockOutMasterDelete(string Id)
        {
            return aConventionDal.DcStockOutMasterDeleteDal(Id);
        }

        public DataTable GetStock(string Id)
        {
            return aConventionDal.GetStock(Id);
        }

    }
}
