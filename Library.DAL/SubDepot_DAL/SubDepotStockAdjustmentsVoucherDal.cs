using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;
using Library.DAO.SubDepot_DAO;

namespace Library.DAL.SubDepot_DAL
{
  public  class SubDepotStockAdjustmentsVoucherDal
    {

        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void ProductLoadDal(DropDownList aDownList)
        {
            string dc = "SELECT (ProductCode+':'+ProductName)Pro,* FROM dbo.tblProduct";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Pro", "ProductId", dc, "SSIDB");
        }

        public void DistributionCenterLoadDal(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitId", dc, "SSIDB");
        }


        public void ProformaInvoiceNumberDal(DropDownList ddl, string companyId)
        {
            string queryStr =
                @"Select InvoiceId, InvoiceNo from tblSubInvoiceMaster where  InvoiceId Is NOT NULL  And cast( InvoiceDate as date) between '2020/07/01' and CURRENT_TIMESTAMP And ComUnitId=" + companyId;
            aCommonInternalDal.LoadDropDownValue(ddl, "InvoiceNo", "InvoiceId", queryStr, "SSIDB");

        }


        public bool SaveDataForSubDcStockOutMaster(SubdepotStockOutMasterDao aMasterDao)
        {
            string insertQuery =
                @"insert into tblSubDepotStockOutMaster (SubDcStockOutMasterId,SubDcStockOutMasterCode,ComUnitId,InvoiceId,StockOutDate,Reason,EntryBy,EntryDate,Status) 
            values (" + aMasterDao.SubDcStockOutMasterId + ",'"+aMasterDao.SubDcStockOutMasterCode+"','" + aMasterDao.ComUnitId + "','" + aMasterDao.InvoiceId +
                "','" + aMasterDao.StockOutDate + "','" + aMasterDao.Reason + "','" + aMasterDao.EntryBy + "','" +
                aMasterDao.EntryDate + "','" + aMasterDao.Status + "')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public bool SaveDataForStockOutDetailDal(SubdepotStockOutDetailsDao aDetailsDao)
        {
            string insertQuery =
                @"insert into tblSubDepotStockOutDetails (SubDcStockOutDetailsId,SubDcStockOutMasterId,SubDCStoreId,ProductCode,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,StockOutQty) 
            values (" + aDetailsDao.SubDcStockOutDetailsId + ",'" + aDetailsDao.SubDcStockOutMasterId + "','" +
                aDetailsDao.SubDCStoreId + "','" + aDetailsDao.ProductCode + "','" + aDetailsDao.ProductName + "','" + aDetailsDao.PackSize + "','" + aDetailsDao.BatchNo + "','" +
                aDetailsDao.ExpDate + "','" + aDetailsDao.ReceiveDate + "','"+aDetailsDao.StockOutQty+"')";
            return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
        }

        public DataTable SubDcStockOutViewDal()
        {
            string query =
                @"Select tblSubDepotStockOutMaster.SubDcStockOutMasterId,tblCompanyUnit.ComUnitName,tblSubInvoiceMaster.InvoiceNo, tblSubDepotStockOutMaster.Reason,tblSubDepotStockOutMaster.StockOutDate,tblSubDepotStockOutMaster.Status
from tblSubDepotStockOutMaster 
Left join tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblSubDepotStockOutMaster.ComUnitId
Left join tblSubInvoiceMaster On tblSubInvoiceMaster.InvoiceId = tblSubDepotStockOutMaster.InvoiceId
where tblSubDepotStockOutMaster.SubDcStockOutMasterId IS NOT NULL";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool SubDcStockOutMasterDeleteDal(string Id)
        {
            string query =
                @"Delete from tblSubDepotStockOutMaster where tblSubDepotStockOutMaster.SubDcStockOutMasterId =" + Id;
            return aCommonInternalDal.DeleteDataByDeleteCommand(query, "SSIDB");
        }


        public bool SubDcStockOutDetailsDeleteDal(string Id)
        {
            string query =
                @"Delete from tblSubDepotStockOutDetails where tblSubDepotStockOutDetails.SubDcStockOutMasterId =" + Id;
            return aCommonInternalDal.DeleteDataByDeleteCommand(query, "SSIDB");
        }


        //GetManu for approval 
        public DataTable GetMenuIdByMenuName(string menuname)
        {
            string query = @"SELECT * FROM tblMainMenu WHERE URL like '%" + menuname + "%' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        //GetAssignAppUser
        public DataTable GetAssignedAppUser(string menuid, string userId)
        {
            string query = @"SELECT * FROM tblAppSetup WHERE SL='" + menuid + "' AND UserId='" + userId + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        //sUpdateApproval
        public void ApprovalUpdateDal(DcStockOutMasterDao aMasterDao)
        {
            string query = @"UPDATE tblDeStockOutMaster SET Status = '" + aMasterDao.Status + "',ApprovedBy = '"
                           + aMasterDao.ApprovedBy + "',ApprovedDate = '" + aMasterDao.ApprovedDate +
                           "' WHERE DcStockOutMasterId = " + aMasterDao.DcStockOutMasterId + "";
            aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }


        //GetStockOutApproval

        public DataTable SubDcStockOutApprovalViewDal()
        {
            string query =
                @"Select tblSubDepotStockOutMaster.SubDcStockOutMasterId,tblCompanyUnit.ComUnitName,tblInvoice.InvoiceNo, tblSubDepotStockOutMaster.Reason,
tblSubDepotStockOutMaster.StockOutDate,tblSubDepotStockOutMaster.Status from tblSubDepotStockOutMaster 
Left join tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblSubDepotStockOutMaster.ComUnitId
Left join tblInvoice On tblInvoice.InvoiceId = tblSubDepotStockOutMaster.InvoiceId
where tblSubDepotStockOutMaster.SubDcStockOutMasterId IS NOT NULL And  tblSubDepotStockOutMaster.Status='Posted' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable SubDcStockOutReportDal(string id)
        {
            string query =
                @"Select tblCompanyUnit.ComUnitName,tblSubInvoiceMaster.InvoiceNo, tblSubDepotStockOutMaster.Reason,Cast(tblSubDepotStockOutMaster.StockOutDate As date)As StockOutDate,tblSubDepotStockOutDetails.ProductCode,tblSubDepotStockOutDetails.ProductName,
tblSubDepotStockOutDetails.BatchNo,tblSubDepotStockOutDetails.StockOutQty As StackOutQty
from tblSubDepotStockOutMaster 
Left join tblSubDepotStockOutDetails On tblSubDepotStockOutDetails.SubDcStockOutMasterId = tblSubDepotStockOutMaster.SubDcStockOutMasterId
Left join tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblSubDepotStockOutMaster.ComUnitId
Left join tblSubInvoiceMaster On tblSubInvoiceMaster.InvoiceId = tblSubDepotStockOutMaster.InvoiceId
where tblSubDepotStockOutMaster.SubDcStockOutMasterId IS NOT NULL And tblSubDepotStockOutMaster.SubDcStockOutMasterId=" + id;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        //RND Update Approval

        public bool UpdateStockOutMasterDataForApprovalDal(SubdepotStockOutMasterDao aMasterDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@SubDcStockOutMasterId", aMasterDao.SubDcStockOutMasterId));
            aSqlParameterlist.Add(new SqlParameter("@Status", aMasterDao.Status));
            aSqlParameterlist.Add(new SqlParameter("@ApprovedBy", aMasterDao.ApprovedBy));
            aSqlParameterlist.Add(new SqlParameter("@ApprovedDate", aMasterDao.ApprovedDate));
            return aCommonInternalDal.UpdateAction("sp_UD_SubDcStockOutApproval", aSqlParameterlist);
        }


        public DataTable GetDcStoreIdDal(string id)
        {
            string query = @"Select tblDeStockOutMaster.DcStockOutMasterId,tblDeStockOutDetails.DcStoreId from tblDeStockOutMaster 
Left join tblDeStockOutDetails ON tblDeStockOutDetails.DcStockOutMasterId = tblDeStockOutMaster.DcStockOutMasterId
where tblDeStockOutMaster.DcStockOutMasterId IS NOT NULL And  tblDeStockOutMaster.Status='Posted' And tblDeStockOutMaster.DcStockOutMasterId=" + id;
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable GetProductDcStoreSubdeport(string productCode)
        {
            DataTable aDataTableEmpInfo = new DataTable();
            string query = @"SELECT *,
            tblProduct.ProductCode AS PCode , tblProduct.ProductName AS PName 
            FROM dbo. tblSubDepotStore
            LEFT JOIN dbo.tblProduct ON dbo.tblSubDepotStore.ProductCode = dbo.tblProduct.ProductCode         
            WHERE tblProduct.ProductId='" + productCode + "'   AND StockQty>0 order by tblProduct.ProductCode";
            //tblDCStore.StockInTransfarId is not null AND
            aDataTableEmpInfo = aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
            return aDataTableEmpInfo;
        }




        public DataTable InvoiceNoCount(string comUnitId)
        {
            //string query = @"SELECT count(InvoiceNo) CountNo FROM dbo.tblInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";

            string query = @"SELECT  (ISNULL(MAX(CAST((SUBSTRING(InvoiceNo,10,11)) AS INT)),0)+1) CountNo FROM dbo.tblInvoice WHERE ComUnitId ='" + comUnitId.Trim() + "'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

    }
}
