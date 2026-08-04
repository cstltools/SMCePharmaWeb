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
    public class ChalanBLL
    {
        ChalanInfo aChalanInfo = new ChalanInfo();
        ChalanDAL aChalanDal = new ChalanDAL();
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
        public bool SaveDataForChalanInfo(ChalanInfo aChalanInfo, out int ChalanId)
        {
            ChalanId = aClsPrimaryKeyFind.PrimaryKeyMax("ChalanId", "tblChalanInfo");
            aChalanInfo.ChalanId = ChalanId;
            aChalanInfo.ChalanNo = ChalanNoGenerator(aChalanInfo.ChalanId);
            return aChalanDal.SaveDataForChalanInfo(aChalanInfo);            
        }
        public int DCStockIn2(DCStockNew aDcStockNew)
        {
            string msg = "Data Save Successfully!!";
            int DCStoreId = 0;

            DCStoreId = aDcStockNew.DCStoreId = aClsPrimaryKeyFind.PrimaryKeyMax("DCStoreId", "tblDCStore", "SSIDB");
            aChalanDal.DCStockInDALMain(aDcStockNew);
            aChalanDal.ChalanUpdate(aDcStockNew.ChalanId.ToString());

            return DCStoreId;
        }
        public int DCStockInSub(DCStockNew aDcStockNew)
        {
            string msg = "Data Save Successfully!!";
            int DCStoreId = 0;

            DCStoreId = aDcStockNew.DCStoreId = aClsPrimaryKeyFind.PrimaryKeyMax("DCStoreId", "tblDCStore", "SSIDB");
            aChalanDal.DCStockInDALMainSub(aDcStockNew);
            aChalanDal.SubChalanUpdate(aDcStockNew.ChalanId.ToString());

            return DCStoreId;
        }
        public string SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStockNew)
        {
            string msg = "Data Save Successfully!!";

            ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
            aDcStockNew.DCStoreFreezeId = aClsPrimaryKeyFind.PrimaryKeyMax("DCStoreFreezeId",
                "tblDCStoreFreeze");
            aChalanDal.SaveDCStoreFreeze2(aDcStockNew);

            return msg;
        }
        public void UpdateDCStockQuantity(string stockId, string Quantity)
        {
            aChalanDal.UpdateDCStockQuantity(stockId,Quantity);
        }
        public DataTable LoadChalanById(string id)
        {
            return aChalanDal.LoadChalanById(id);
        }
        public DataTable ChalanLoadInReceive(string comunitId)
        {
            return aChalanDal.ChalanLoadInReceive(comunitId);
        }
        public DataTable SubdeportChalanLoadInReceive(string comunitId)
        {
            return aChalanDal.SubdeportChalanLoadInReceive(comunitId);
        }

        public DataTable GetChalanReceieve(string id)
        {
            return aChalanDal.GetChalanReceieve(id);
        }
        public DataTable SubGetChalanReceieve(string id)
        {
            return aChalanDal.SubChalanReceieve(id);
        }
        public DataTable ChalanReport(string id)
        {
            return aChalanDal.ChalanReport(id);
        }
        public DataTable SubDepotChalanReport(string id)
        {
            return aChalanDal.SubDepotChalanReport(id);
        }
        public void LoadManufac(DropDownList aDropDownList)
        {
            aChalanDal.LoadManufac(aDropDownList);
        }

        public bool SaveDataForChalanDetail(List<ChalanDetail> aIChalanList)
        {
            foreach (var chalanDetail in aIChalanList)
            {
                chalanDetail.ChalanDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("ChalanDetailsId", "tblChalanDetail");
                aChalanDal.SaveDataForChalanDetail(chalanDetail);

                DataTable dtdcinfo = DCInfoWithDCId(chalanDetail.DCStoreId.ToString());
                UpdateDCStockQuantity(chalanDetail.DCStoreId.ToString(), (Convert.ToDecimal(dtdcinfo.Rows[0]["StockQty"].ToString()) - chalanDetail.Quantity).ToString());
            }
            return true;
        }
        public DataTable DCStoreReport(string reqId, string TYpe)
        {
            return aChalanDal.DCStoreReport(reqId, TYpe);
        }
        public DataTable LoadComunit(string comunitCode)
        {
            return aChalanDal.LoadComunit(comunitCode);
        }
        public bool DCStockInDAL(DCStockNew aDcStockNew)
        {
            return aChalanDal.DCStockInDAL(aDcStockNew);
        }
        public DataTable DCInfoWithDCId(string dcstoreId)
        {
            return aChalanDal.DCInfoWithDCId(dcstoreId);
        }
        public string ChalanNoForShow()
        {
            string ChalanNo = "";
            ChalanNo = ChalanNoGenerator(aClsPrimaryKeyFind.PrimaryKeyMax("ChalanId", "tblChalanInfo"));
            return ChalanNo;
        }

        public string ChalanNoGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "000" + Id;
            }
            code = "IDT" + Id;
            return code;
        }
       
        //public bool UpdateDataForInvoice(ChalanInfo aInvoice)
        //{
        //    return aInvoiceDal.UpdateaInvoice(aInvoice);
        //}

        public DataTable LoadstockReceive()
        {
            return aChalanDal.LoadChalanView();
        }
        public DataTable ComUnit(string ComUnitId)
        {
            return aChalanDal.LoadComUnit(ComUnitId);
        }

        public DataTable ProductInfo(string productId)
        {
            return aChalanDal.LoadProduct(productId);
        }

        public DataTable GetProductDcStore(string productCode, string comunitId)
        {
            return aChalanDal.GetProductDcStore(productCode, comunitId);
        }
        public DataTable SubdeportDCStoreReport(string reqId)
        {
            return aChalanDal.SubdeportDCStoreReport(reqId);
        }
        public DataTable GetProductWhStore(string productCode)
        {
            return aChalanDal.GetProductWhStore(productCode);
        }
    }
}
