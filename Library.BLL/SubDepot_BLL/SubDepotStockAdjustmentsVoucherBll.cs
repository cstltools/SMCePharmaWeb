using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAL.SubDepot_DAL;
using Library.DAO.SInventory_Entities;
using Library.DAO.SubDepot_DAO;

namespace Library.BLL.SubDepot_BLL
{
   public class SubDepotStockAdjustmentsVoucherBll
    {
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

  SubDepotStockAdjustmentsVoucherDal adal = new SubDepotStockAdjustmentsVoucherDal();


        public void ProductLoadBll(DropDownList aDownList)
        {
            adal.ProductLoadDal(aDownList);
        }


        public void DistributionCenterLoadBll(DropDownList aDownList)
        {
            adal.DistributionCenterLoadDal(aDownList);
        }


        public void ProformaInvoiceNumberBll(DropDownList ddl, string id)
        {
            adal.ProformaInvoiceNumberDal(ddl, id);
        }


        public bool SaveDataForSubDcStockOutMasterBll(SubdepotStockOutMasterDao aMasterDao, out int SubDcStockOutMasterId)
        {
            SubDcStockOutMasterId = aClsPrimaryKeyFind.PrimaryKeyMax("SubDcStockOutMasterId", "tblSubDepotStockOutMaster");
            aMasterDao.SubDcStockOutMasterId = SubDcStockOutMasterId;
            aMasterDao.SubDcStockOutMasterCode = SubStockOutMasterCodeGenerator(aMasterDao.SubDcStockOutMasterId);
            return adal.SaveDataForSubDcStockOutMaster(aMasterDao);
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

            code = "SAD" + Id;
            return code;
        }

        public bool SaveDataForSubStockOutDetailBll(List<SubdepotStockOutDetailsDao> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                stockOutDetail.SubDcStockOutDetailsId = aClsPrimaryKeyFind.PrimaryKeyMax("SubDcStockOutDetailsId", "tblSubDepotStockOutDetails");
                adal.SaveDataForStockOutDetailDal(stockOutDetail);
            }
            return true;
        }

        public DataTable SubDcStockOutBll()
        {
            return adal.SubDcStockOutViewDal();
        }

        public bool SubDcStockOutDetailsDelete(string Id)
        {
            return adal.SubDcStockOutDetailsDeleteDal(Id);
        }

        public bool SubDcStockOutMasterDelete(string Id)
        {
            return adal.SubDcStockOutMasterDeleteDal(Id);
        }

        //getManu
        public DataTable GetMenuIdByMenuName(string menuname)
        {
            return adal.GetMenuIdByMenuName(menuname);
        }

        //GetAssignAppuer
        public DataTable GetAssignedAppUser(string menuid, string userId)
        {
            return adal.GetAssignedAppUser(menuid, userId);
        }

        //UpdateApproVal

        public string ApprovalUpdateBLL(DcStockOutMasterDao aMasterDao)
        {
            adal.ApprovalUpdateDal(aMasterDao);
            return "Weldone! Stock In approved successfully!!!";
        }

        //GetDcStockOut for approval
        public DataTable SubDcStockOutApprovalViewBll()
        {
            return adal.SubDcStockOutApprovalViewDal();
        }

        //getdata for ReportView

        public DataTable SubDcStockOutReportViewBll(string id)
        {
            return adal.SubDcStockOutReportDal(id);
        }


        //RND update Approval
        public bool UpdateStockOutMasterDataForApprovalBll(SubdepotStockOutMasterDao aMasterDao)
        {
            return adal.UpdateStockOutMasterDataForApprovalDal(aMasterDao);

        }

        public DataTable GetDcStoreIdBll(string id)
        {
            return adal.GetDcStoreIdDal(id);
        }

        public DataTable GetProductDcStoreSubdeport(string productCode)
        {
            return adal.GetProductDcStoreSubdeport(productCode);
        }
    }
}
