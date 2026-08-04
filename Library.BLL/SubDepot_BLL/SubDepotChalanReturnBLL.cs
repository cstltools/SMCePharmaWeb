using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAL.SubDepotChalanDAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SubDepot_BLL
{
    public class SubDepotChalanReturnBLL
    {
        ChalanInfo aChalanInfo = new ChalanInfo();
        SubDepotChalanReturnDAL aChalanDal = new SubDepotChalanReturnDAL();
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
        public bool SaveDataForChalanInfo(ChalanInfo aChalanInfo, out int ChalanId)
        {
            ChalanId = aClsPrimaryKeyFind.PrimaryKeyMax("SChalanId", "tblSubDepotChalanReturnInfo");
            aChalanInfo.ChalanId = ChalanId;
            aChalanInfo.ChalanNo = ChalanNoGenerator(aChalanInfo.ChalanId);
            return aChalanDal.SaveDataForChalanInfo(aChalanInfo);            
        }
        public int DCStockIn2(DCStockNew aDcStockNew)
        {
            string msg = "Data Save Successfully!!";
            int SubDCStoreId = 0;

            SubDCStoreId = aDcStockNew.SubDCStoreId = aClsPrimaryKeyFind.PrimaryKeyMax("SubDCStoreId", "tblSubDepotChalanReturnInfo", "SSIDB");
            aChalanDal.DCStockInDALMain(aDcStockNew);
            aChalanDal.ChalanUpdate(aDcStockNew.ChalanId.ToString());

            return SubDCStoreId;
        }
        public string SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStockNew)
        {
            string msg = "Data Save Successfully!!";

            ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
            aDcStockNew.SDStoreFreezeId = aClsPrimaryKeyFind.PrimaryKeyMax("SDStoreFreezeId",
                "tblSubDepotStoreFreeze");
            aChalanDal.SaveDCStoreFreeze2(aDcStockNew);

            return msg;
        }
        public void UpdateDCStockQuantity(string stockId, string Quantity)
        {
            aChalanDal.UpdateDCStockQuantity(stockId,Quantity);
        }
        public void SubUpdateDCStockQuantity(string stockId, string Quantity)
        {
            aChalanDal.SubUpdateDCStockQuantity(stockId, Quantity);
        }
        public DataTable LoadChalanById(string id)
        {
            return aChalanDal.LoadChalanById(id);
        }
        public DataTable ChalanLoadInReceive(string comunitId)
        {
            return aChalanDal.ChalanLoadInReceive(comunitId);
        }

        public DataTable GetChalanReceieve(string id)
        {
            return aChalanDal.GetChalanReceieve(id);
        }

        public DataTable ChalanReport(string id)
        {
            return aChalanDal.ChalanReport(id);
        }
        public void LoadManufac(DropDownList aDropDownList)
        {
            aChalanDal.LoadManufac(aDropDownList);
        }

        public bool SaveDataForChalanDetail(List<ChalanDetail> aIChalanList)
        {
            foreach (var chalanDetail in aIChalanList)
            {
                chalanDetail.ChalanDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("SChalanDetailsId", "tblSubDepotChalanRetuenDetail");
                aChalanDal.SaveDataForChalanDetail(chalanDetail);

                DataTable dtdcinfo = SubDCInfoWithDCId(chalanDetail.DCStoreId.ToString());
                SubUpdateDCStockQuantity(chalanDetail.DCStoreId.ToString(), (Convert.ToDecimal(dtdcinfo.Rows[0]["StockQty"].ToString()) - chalanDetail.Quantity).ToString());
            }
            return true;
        }
        public DataTable DCStoreReport(string reqId)
        {
            return aChalanDal.DCStoreReport(reqId);
        }
        public DataTable LoadComunit(string comunitCode)
        {
            return aChalanDal.LoadComunit(comunitCode);
        }
        public bool DCStockInDAL(DCStockNew aDcStockNew)
        {
            return aChalanDal.DCStockInDAL(aDcStockNew);
        }
        public DataTable SubDCInfoWithDCId(string dcstoreId)
        {
            return aChalanDal.SubDCInfoWithDCId(dcstoreId);
        }
        public DataTable DCInfoWithDCId(string dcstoreId)
        {
            return aChalanDal.DCInfoWithDCId(dcstoreId);
        }
        public string ChalanNoForShow()
        {
            string ChalanNo = "";
            ChalanNo = ChalanNoGenerator(aClsPrimaryKeyFind.PrimaryKeyMax("SChalanId", "tblSubDepotChalanReturnInfo"));
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
            code = "SDC" + Id;
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
        public DataTable LoadSubDepot(string ComUnitId)
        {
            return aChalanDal.LoadSubDepot(ComUnitId);
        }
        public DataTable ProductInfo(string productId)
        {
            return aChalanDal.LoadProduct(productId);
        }

        public DataTable GetProductDcStore(string productCode, string comunitId)
        {
            return aChalanDal.GetProductDcStore(productCode, comunitId);
        }
        public DataTable GetProductDcStoreSubdeport(string productCode, string comunitId)
        {
            return aChalanDal.GetProductDcStoreSubdeport(productCode, comunitId);
        }
    }
}
