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

    public class DeStockOutBLL
    {
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

        DeStockOutDal aDeStockOutDal = new DeStockOutDal();
        
        public void ProductLoadBll(DropDownList aDownList)
        {
            aDeStockOutDal.ProductLoadDal(aDownList);
        }


        public void DistributionCenterLoadBll(DropDownList aDownList)
        {
            aDeStockOutDal.DistributionCenterLoadDal(aDownList);
        }


        public void ProformaInvoiceNumberBll(DropDownList ddl, string id)
        {
            aDeStockOutDal.ProformaInvoiceNumberDal(ddl, id);
        }


        public bool SaveDataForDcStockOutMasterBll(DcStockOutMasterDao aMasterDao, out int DcStockOutMasterId)
        {
            DcStockOutMasterId = aClsPrimaryKeyFind.PrimaryKeyMax("DcStockOutMasterId", "tblDeStockOutMaster");
            aMasterDao.DcStockOutMasterId = DcStockOutMasterId;
            return aDeStockOutDal.SaveDataForDcStockOutMaster(aMasterDao);
        }


        public bool SaveDataForStockOutDetailBll(List<DcStockOutDetailsDao> aStockOutDetailsDaos)
        {
            foreach (var stockOutDetail in aStockOutDetailsDaos)
            {
                stockOutDetail.DcStockOutDetailsId = aClsPrimaryKeyFind.PrimaryKeyMax("DcStockOutDetailsId", "tblDeStockOutDetails");
                aDeStockOutDal.SaveDataForStockOutDetailDal(stockOutDetail);
            }
            return true;
        }

        public DataTable DcStockOutBll()
        {
            return aDeStockOutDal.DcStockOutViewDal();
        }
       
        public bool DcStockOutDetailsDelete(string Id )
        {
            return aDeStockOutDal.DcStockOutDetailsDeleteDal(Id);
        }

        public bool DcStockOutMasterDelete(string Id)
        {
            return aDeStockOutDal.DcStockOutMasterDeleteDal(Id);
        }

        //getManu
        public DataTable GetMenuIdByMenuName(string menuname)
        {
            return aDeStockOutDal.GetMenuIdByMenuName(menuname);
        }

        //GetAssignAppuer
        public DataTable GetAssignedAppUser(string menuid, string userId)
        {
            return aDeStockOutDal.GetAssignedAppUser(menuid, userId);
        }

        //UpdateApproVal

        public string ApprovalUpdateBLL(DcStockOutMasterDao aMasterDao)
        {
            aDeStockOutDal.ApprovalUpdateDal(aMasterDao);
            return "Weldone! Stock In approved successfully!!!";
        }

        //GetDcStockOut for approval
        public DataTable DcStockOutAppBll()
        {
            return aDeStockOutDal.DcStockOutAppDal();
        }

        //getdata for ReportView

        public DataTable DcStockOutReportViewBll(string id)
        {
            return aDeStockOutDal.DcStockOutReportDal(id);
        }


        //RND update Approval
        public bool UpdateStockOutMasterDataForApprovalBll( DcStockOutMasterDao aMasterDao)
        {
            return aDeStockOutDal.UpdateStockOutMasterDataForApprovalDal(aMasterDao);
           
        }

        public DataTable StockOutReportBll(DateTime fromDate, DateTime toDate, int comUnitId)
        {
            return aDeStockOutDal.StockOutReportDal(fromDate, toDate, comUnitId);
        }

        public DataTable NCPReportBll(DateTime fromDate, DateTime toDate, int comUnitId)
        {
            return aDeStockOutDal.NCPReportDal(fromDate, toDate, comUnitId);
        }

        public DataTable GetDcStoreIdBll(string id)
        {
            return aDeStockOutDal.GetDcStoreIdDal(id);
        }


      

 
        
    }
}