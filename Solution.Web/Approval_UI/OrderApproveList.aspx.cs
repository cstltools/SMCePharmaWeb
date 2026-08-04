using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Approval_UI_OrderApproveList : System.Web.UI.Page
{

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    private static CustomerInfoDAL _DAL = new CustomerInfoDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    private CommonDataLoad _CmnLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

            if (!IsPostBack)
            {
                UserPersmissionValidation();
                try
                {
                    using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
                    {
                        ddlDistributionCenter.DataSource = dt;
                        ddlDistributionCenter.DataValueField = "ComUnitId";
                        ddlDistributionCenter.DataTextField = "ComUnitName";
                        ddlDistributionCenter.DataBind();
                        ddlDistributionCenter.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        ddlDistributionCenter.SelectedIndex = 0;

                        if (Session["RoleTypeName"].ToString() == "DIC")
                        {
                            ddlDistributionCenter.SelectedValue = Session["DICCompanyUnitId"].ToString();
                            ddlDistributionCenter.Enabled = false;
                        }
                    }


                }
                catch (Exception ex) { }
                LoadData();
            }
        }
        catch (Exception ex)
        {
            Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
        }
    }
    public void UserPersmissionValidation()
    {
        if (Session["UserRoleID"].ToString() != "2")
        {
            try
            {
                string filepath = Path.GetDirectoryName(Request.Path);
                filepath = filepath.TrimStart('\\');
                string text = Path.GetExtension(Request.Path);
                filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);
                DataTable dtuserpermission = _CmnLoad.GetPermissionForUserRole(filepath);
                if (dtuserpermission.Rows.Count > 0)
                {
                    if (Session["UserRoleID"].ToString() != "2")
                    {



                    }
                }
                else
                {
                    Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
            }
        }
    }
    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {

        if (e.CommandName == "EditData")
        {


            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();
            System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "openModal", "window.open('../MasterSetup_UI/CustomerEntry.aspx?MID=" + unitPriceId + "' ,'_blank');", true);

         //   Response.Redirect("CustomerEntry.aspx?MID=" + unitPriceId);
        }

        if (e.CommandName == "ApproveData")
        {
            if (ToRoleTypeId == "5")
            {
                ApprovalStatus = "Accepted";
            }
            else
            {
                ApprovalStatus = "Verified";
            }
            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField hfCustomerApprovalId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerApprovalId"));
            HiddenField hfToEmpId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfToEmpId"));
            HiddenField hfStep = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfStep"));
            HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerMasterId"));


            OrderSaveApprovalLogDAO aMaster = new OrderSaveApprovalLogDAO();
            aMaster.OrderApprovalId = hfCustomerApprovalId.Value == "" ? 0 : Convert.ToInt32(hfCustomerApprovalId.Value);

            aMaster.TableId = hfCustomerMasterId.Value == "" ? 0 : Convert.ToInt32(hfCustomerMasterId.Value);

            aMaster.GroupId = hfEmpGroupId.Value == "" ? 0 : Convert.ToInt32(hfEmpGroupId.Value);
            aMaster.RegionId = hfEmpRegionId.Value == "" ? 0 : Convert.ToInt32(hfEmpRegionId.Value);
            aMaster.AreaId = hfEmpAreaId.Value == "" ? 0 : Convert.ToInt32(hfEmpAreaId.Value);
            aMaster.TerritoryId = hfEmpTerrId.Value == "" ? 0 : Convert.ToInt32(hfEmpTerrId.Value);

            aMaster.FromEmpId = EmpInfoId == "" ? 0 : Convert.ToInt32(EmpInfoId);
            aMaster.ToEmpId = hfToEmpId.Value == "" ? 0 : Convert.ToInt32(hfToEmpId.Value);
            int InStep = hfStep.Value == "" ? 0 : Convert.ToInt32(hfStep.Value);
            aMaster.Step = InStep + 1;
            aMaster.Type = "Order";
            aMaster.Status = ApprovalStatus;
            aMaster.Date = DateTime.Now;
            aMaster.EntryDateS = DateTime.Now;
            aMaster.ApproveDateS = DateTime.Now;
            aMaster.EntryByS = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.EntryByApp = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.MenuId = 381;
            ResultInfo Res = _DAL.SaveOrder_ApplogDAL(aMaster);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                LoadData();

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }



        if (e.CommandName == "RejectData")
        {
            ApprovalStatus = "Rejected";

            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField hfCustomerApprovalId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerApprovalId"));
            HiddenField hfToEmpId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfToEmpId"));
            HiddenField hfStep = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfStep"));
            HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].Cells[1].FindControl("hfCustomerMasterId"));


            OrderSaveApprovalLogDAO aMaster = new OrderSaveApprovalLogDAO();
            aMaster.OrderApprovalId = hfCustomerApprovalId.Value == "" ? 0 : Convert.ToInt32(hfCustomerApprovalId.Value);
            aMaster.TableId = hfCustomerMasterId.Value == "" ? 0 : Convert.ToInt32(hfCustomerMasterId.Value);
            aMaster.GroupId = hfEmpGroupId.Value == "" ? 0 : Convert.ToInt32(hfEmpGroupId.Value);
            aMaster.RegionId = hfEmpRegionId.Value == "" ? 0 : Convert.ToInt32(hfEmpRegionId.Value);
            aMaster.AreaId = hfEmpAreaId.Value == "" ? 0 : Convert.ToInt32(hfEmpAreaId.Value);
            aMaster.TerritoryId = hfEmpTerrId.Value == "" ? 0 : Convert.ToInt32(hfEmpTerrId.Value);

            aMaster.FromEmpId = EmpInfoId == "" ? 0 : Convert.ToInt32(EmpInfoId);
            aMaster.ToEmpId = hfToEmpId.Value == "" ? 0 : Convert.ToInt32(hfToEmpId.Value);
            int InStep = hfStep.Value == "" ? 0 : Convert.ToInt32(hfStep.Value);
            aMaster.Step = InStep + 1;
            aMaster.Type = "Order";
            aMaster.Status = ApprovalStatus;
            aMaster.Date = DateTime.Now;
            aMaster.EntryDateS = DateTime.Now;
            aMaster.ApproveDateS = DateTime.Now;
            aMaster.EntryByS = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.EntryByApp = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.MenuId = 381;
            ResultInfo Res = _DAL.SaveOrder_ApplogDAL(aMaster);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                LoadData();

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }

    }
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("DoctorEntry.aspx");
    }

    private void LoadData()
    {

        string pram = "", Role = "";
        //   EmpMarketAccess( pram,  Role);

        if (EmpInfoId != "" || EmpInfoId != null)
        {
            DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active(EmpInfoId);
            try
            {
                hfEmpGroupId.Value = dtMarket.Rows[0]["EmpGroupId"].ToString();
            hfEmpRegionId.Value = dtMarket.Rows[0]["EmpRegionId"].ToString();
            hfEmpAreaId.Value = dtMarket.Rows[0]["EmpAreaId"].ToString();
            hfEmpTerrId.Value = dtMarket.Rows[0]["EmpTerrId"].ToString();
            }
            catch { }
            string FFID = "";
            switch (RoleTypeName)
            {
                case "AM":
                    FFID = dtMarket.Rows[0]["EmpAreaId"].ToString();
                    pram = " AND View_Webapi_EmployeeFieldForceInfo.EmpAreaId=" + FFID + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.EntryDate),CONVERT(DATE,GETDATE())))<=7   ";
                    Role = "AM";

                    break;
                case "DZSM":
                    FFID = dtMarket.Rows[0]["EmpRegionId"].ToString();
                    pram = " AND  View_Webapi_EmployeeFieldForceInfo.EmpRegionId=" + FFID + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.EntryDate),CONVERT(DATE,GETDATE())))<=7   ";
                    Role = "DZSM";
                    break;
                case "NSM":
                    FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                    pram = " AND  View_Webapi_EmployeeFieldForceInfo.EmpGroupId=" + FFID + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.EntryDate),CONVERT(DATE,GETDATE())))<=7   ";
                    Role = "NSM";
                    break;

                case "DIC":
                    FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                    pram = " AND  dcMas.DCId=" + ddlDistributionCenter.SelectedValue + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.EntryDate),CONVERT(DATE,GETDATE())))<=7   ";
                    Role = "DIC";
                    break;
                default:
                    pram = "";
                    Role = "";
                    break;
            }
        }
        pram = pram + " and mas.ActionStatus not in (2,3) ";
        string AppStatus = null;
        int? EmpId = null; ;
        DateTime? FromDt = null;
        DateTime? ToDt = null;

        DataTable aDataTable = _DAL.GetOrderList_ApplogDAL(pram, Role, AppStatus, FromDt, ToDt, EmpId);


        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        if (ToRoleTypeId == "5" || ToRoleTypeId == "4" || ToRoleTypeId == "14")
        {

        }
        else
        {
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                HiddenField hfToEmpId = (HiddenField)loadGridView.Rows[i].FindControl("hfToEmpId");
                LinkButton lbEdit = (LinkButton)loadGridView.Rows[i].FindControl("lbEdit");
                LinkButton lbApprove = (LinkButton)loadGridView.Rows[i].FindControl("lbApprove");
                LinkButton lbReject = (LinkButton)loadGridView.Rows[i].FindControl("lbReject");
                HiddenField hfToRoleTypeId = (HiddenField)loadGridView.Rows[i].FindControl("hfToRoleTypeId");
                Label lbMsg = (Label)loadGridView.Rows[i].FindControl("lbMsg");

                if (hfToRoleTypeId.Value == ToRoleTypeId)
                {

                }
                else
                {
                    lbEdit.Visible = false;
                    lbApprove.Visible = false;
                    lbReject.Visible = false;
                    lbMsg.Text = "Waiting for Another Approver";
                    lbMsg.CssClass = "badge bg-warning";
                }

            }
        }

        
    }

    private void EmpMarketAccess(string pram, string Role)
    {



    }
}