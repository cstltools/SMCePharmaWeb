using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using Library.DAO.SubDepot_DAO;

namespace Library.BLL.SInventory_BLL
{
    public class SampleTypeConventionBLL
    {
        SampleTypeConventionDal aConventionDal = new SampleTypeConventionDal();

        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();


        public void ProductLoadBll(DropDownList aDownList)
        {
            aConventionDal.ProductLoadDal(aDownList);
        }

        public void SalesCenterLoadBll(DropDownList aDownList)
        {
            aConventionDal.SalesCenterLoadDal(aDownList);
        }

        public DataTable GetProductDcStore(string productCode,string Unit )
        {
            return aConventionDal.GetProductDcStore(productCode,Unit);
        }

        public bool SaveDataForSubDcStockOutMasterBll(SampleStockForDcMaster aMasterDao, out int SubDcStockOutMasterId)
        {
            SubDcStockOutMasterId = aClsPrimaryKeyFind.PrimaryKeyMax("SampleStockForDcMasterId", "tblSampleStockForDcMaster");
            aMasterDao.SampleStockForDcMasterId = SubDcStockOutMasterId;
            aMasterDao.SampleStockForDcMasterCode = SubStockOutMasterCodeGenerator(aMasterDao.SampleStockForDcMasterId);
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

        public bool SaveDataForSubStockOutDetailBll(List<SampleStockForDcDetails> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                stockOutDetail.SampleStockForDcDetailsId = aClsPrimaryKeyFind.PrimaryKeyMax("SampleStockForDcDetailsId", "tblSampleStockForDcDetails");
                aConventionDal.SaveDataForStockOutDetailDal(stockOutDetail);
            }
            return true;
        }

        public bool StockOut(List<SampleStockForDcDetails> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                aConventionDal.StockOuTCentral(stockOutDetail);
            }
            return true;
        }


        public bool StockIn(List<SampleStockForDcDetails> aStockOutDetailsDaos)
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

        public DataTable LoadSampleStock(string Id)
        {
            return aConventionDal.LoadSampleStock(Id);
        }

    }
}
