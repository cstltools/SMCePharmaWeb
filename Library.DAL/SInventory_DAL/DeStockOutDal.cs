using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class DeStockOutDal
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
                @"Select InvoiceId, InvoiceNo from tblInvoice  with (nolock)  where  InvoiceId Is NOT NULL  And cast( InvoiceDate as date) between '2020/07/01' and CURRENT_TIMESTAMP And ComUnitId=@ComUnitId   union all
Select top 1 0 InvoiceId, 'N/A' InvoiceNo from tblInvoice  with (nolock) ";
            LoadDropDownValue(ddl, "InvoiceNo", "InvoiceId", queryStr, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(companyId))
            });

        }


        public bool SaveDataForDcStockOutMaster(DcStockOutMasterDao aMasterDao)
        {
            string insertQuery =
                @"insert into tblDeStockOutMaster (DcStockOutMasterId,ComUnitId,InvoiceId,StockOutDate,Reason,EntryBy,EntryDate,CustomerCode,Status) 
            values (@DcStockOutMasterId,@ComUnitId,@InvoiceId,@StockOutDate,@Reason,@EntryBy,@EntryDate,@CustomerCode,@Status)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@DcStockOutMasterId", aMasterDao.DcStockOutMasterId),
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(aMasterDao.ComUnitId)),
                new SqlParameter("@InvoiceId", SInventorySql.DbValue(aMasterDao.InvoiceId)),
                new SqlParameter("@StockOutDate", SInventorySql.DbValue(aMasterDao.StockOutDate)),
                new SqlParameter("@Reason", SInventorySql.DbValue(aMasterDao.Reason)),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(aMasterDao.EntryBy)),
                new SqlParameter("@EntryDate", SInventorySql.DbValue(aMasterDao.EntryDate)),
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(aMasterDao.CustomerCode)),
                new SqlParameter("@Status", SInventorySql.DbValue(aMasterDao.Status))
            });
        }

        public bool SaveDataForStockOutDetailDal(DcStockOutDetailsDao aDetailsDao)
        {
            string insertQuery =
                @"insert into tblDeStockOutDetails (DcStockOutDetailsId,DcStockOutMasterId,DCStoreId,ProductCode,ProductName,StackOutQty,PackSize,BatchNo,ExpDate,ReceiveDate) 
            values (@DcStockOutDetailsId,@DcStockOutMasterId,@DCStoreId,@ProductCode,@ProductName,@StackOutQty,@PackSize,@BatchNo,@ExpDate,@ReceiveDate)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@DcStockOutDetailsId", aDetailsDao.DcStockOutDetailsId),
                new SqlParameter("@DcStockOutMasterId", aDetailsDao.DcStockOutMasterId),
                new SqlParameter("@DCStoreId", aDetailsDao.DcStoreId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aDetailsDao.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(aDetailsDao.ProductName)),
                new SqlParameter("@StackOutQty", aDetailsDao.StackOutQty),
                new SqlParameter("@PackSize", SInventorySql.DbValue(aDetailsDao.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(aDetailsDao.BatchNo)),
                new SqlParameter("@ExpDate", SInventorySql.DbValue(aDetailsDao.ExpDate)),
                new SqlParameter("@ReceiveDate", SInventorySql.DbValue(aDetailsDao.ReceiveDate))
            });
        }

        public DataTable DcStockOutViewDal()
        {
            string query =
                @"Select   tblDeStockOutMaster.DcStockOutMasterId,tblCompanyUnit.ComUnitName, case when tblDeStockOutMaster.InvoiceId=0 then 'N/A'  else   tblInvoice.InvoiceNo end InvoiceNo , tblDeStockOutMaster.Reason,tblDeStockOutMaster.StockOutDate,tblDeStockOutMaster.Status
from tblDeStockOutMaster  with (nolock)
Left join tblCompanyUnit   with (nolock) ON tblCompanyUnit.ComUnitId = tblDeStockOutMaster.ComUnitId
Left join tblInvoice   with (nolock) On tblInvoice.InvoiceId = tblDeStockOutMaster.InvoiceId
where tblDeStockOutMaster.DcStockOutMasterId IS NOT NULL Order by StockOutDate Desc";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool DcStockOutMasterDeleteDal(string Id)
        {
            string query =
                @"Delete from tblDeStockOutMaster where tblDeStockOutMaster.DcStockOutMasterId = @DcStockOutMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@DcStockOutMasterId", SInventorySql.DbValue(Id))
            });
        }


        public bool DcStockOutDetailsDeleteDal(string Id)
        {
            string query =
                @"Delete from tblDeStockOutDetails where tblDeStockOutDetails.DcStockOutMasterId = @DcStockOutMasterId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@DcStockOutMasterId", SInventorySql.DbValue(Id))
            });
        }

        //GetManu for approval 
        public DataTable GetMenuIdByMenuName(string menuname)
        {
            string query = @"SELECT * FROM tblMainMenu WHERE URL like @MenuName";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MenuName", SInventorySql.DbValue("%" + menuname + "%"))
            });
        }
        //GetAssignAppUser
        public DataTable GetAssignedAppUser(string menuid, string userId)
        {
            string query = @"SELECT * FROM tblAppSetup WHERE SL=@SL AND UserId=@UserId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SL", SInventorySql.DbValue(menuid)),
                new SqlParameter("@UserId", SInventorySql.DbValue(userId))
            });
        }

        //sUpdateApproval
        public void ApprovalUpdateDal(DcStockOutMasterDao aMasterDao)
        {
            string query = @"UPDATE tblDeStockOutMaster SET Status = @Status,ApprovedBy = @ApprovedBy,ApprovedDate = @ApprovedDate WHERE DcStockOutMasterId = @DcStockOutMasterId";
            SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@Status", SInventorySql.DbValue(aMasterDao.Status)),
                new SqlParameter("@ApprovedBy", SInventorySql.DbValue(aMasterDao.ApprovedBy)),
                new SqlParameter("@ApprovedDate", SInventorySql.DbValue(aMasterDao.ApprovedDate)),
                new SqlParameter("@DcStockOutMasterId", aMasterDao.DcStockOutMasterId)
            });
        }


        //GetStockOutApproval

        public DataTable DcStockOutAppDal()
        {
            string query =
                @"Select tblDeStockOutMaster.DcStockOutMasterId,tblCompanyUnit.ComUnitName,tblInvoice.InvoiceNo, tblDeStockOutMaster.Reason,
tblDeStockOutMaster.StockOutDate,tblDeStockOutMaster.Status from tblDeStockOutMaster 
Left join tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblDeStockOutMaster.ComUnitId
Left join tblInvoice On tblInvoice.InvoiceId = tblDeStockOutMaster.InvoiceId
where tblDeStockOutMaster.DcStockOutMasterId IS NOT NULL And  tblDeStockOutMaster.Status='Posted' ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable DcStockOutReportDal(string id)
        {
            string query =
                @"Select tblunitprice.UnitPrice*StackOutQty as Total,tblunitprice.VATAmountPerUnit,tblunitprice.UnitPrice,tblCustMaster.CustomerCode,tblCustMaster.CustomerName,tblCustMaster.Address,tblCompanyUnit.ComUnitName, case when tblDeStockOutMaster.InvoiceId=0 then 'N/A'  else   tblInvoice.InvoiceNo end  InvoiceNo, tblDeStockOutMaster.Reason,FORMAT(Cast(tblDeStockOutMaster.StockOutDate As date),'dd-MMM-yyyy') As StockOutDate,tblDeStockOutDetails.ProductCode,tblDeStockOutDetails.ProductName,
tblDeStockOutDetails.BatchNo,tblDeStockOutDetails.StackOutQty
from tblDeStockOutMaster 
Left join tblDeStockOutDetails On tblDeStockOutDetails.DcStockOutMasterId = tblDeStockOutMaster.DcStockOutMasterId
Left join tblCompanyUnit ON tblCompanyUnit.ComUnitId = tblDeStockOutMaster.ComUnitId
Left join tblInvoice On tblInvoice.InvoiceId = tblDeStockOutMaster.InvoiceId
left join tblCustMaster on tblCustMaster.CustomerCode =tblDeStockOutMaster.CustomerCode
left join tblunitprice on tblDeStockOutDetails.ProductCode= tblunitprice.ProductCode where tblDeStockOutMaster.DcStockOutMasterId=@DcStockOutMasterId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DcStockOutMasterId", SInventorySql.DbValue(id))
            });
        }

        //RND Update Approval

        public bool UpdateStockOutMasterDataForApprovalDal(DcStockOutMasterDao aMasterDao)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@DcStockOutMasterId", aMasterDao.DcStockOutMasterId));
            aSqlParameterlist.Add(new SqlParameter("@Status", aMasterDao.Status));
            aSqlParameterlist.Add(new SqlParameter("@ApprovedBy", aMasterDao.ApprovedBy));
            aSqlParameterlist.Add(new SqlParameter("@ApprovedDate", aMasterDao.ApprovedDate));
            return aCommonInternalDal.UpdateAction("sp_UD_DcStockOutApproval", aSqlParameterlist);
        }


        public DataTable GetDcStoreIdDal(string id)
        {
            string query = @"Select tblDeStockOutMaster.DcStockOutMasterId,tblDeStockOutDetails.DcStoreId from tblDeStockOutMaster 
Left join tblDeStockOutDetails ON tblDeStockOutDetails.DcStockOutMasterId = tblDeStockOutMaster.DcStockOutMasterId
where tblDeStockOutMaster.DcStockOutMasterId IS NOT NULL And  tblDeStockOutMaster.Status='Posted' And tblDeStockOutMaster.DcStockOutMasterId=@DcStockOutMasterId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DcStockOutMasterId", SInventorySql.DbValue(id))
            });
        }



        private static void LoadDropDownValue(DropDownList ddl, string displayField, string valueField, string queryString, List<SqlParameter> parameters)
        {
            DataTable dt = SInventorySql.GetDataTable(queryString, parameters);

            ddl.DataTextField = displayField;
            ddl.DataValueField = valueField;
            ddl.DataSource = dt;
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("--------Select---------", string.Empty));
            ddl.SelectedIndex = 0;
        }



    }
}
