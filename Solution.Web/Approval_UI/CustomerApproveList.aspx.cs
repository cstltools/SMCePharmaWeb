using Library.DAL.DataManager;
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

public partial class Approval_UI_CustomerApproveList : System.Web.UI.Page
{
    private CommonDataLoad _CmnLoad = new CommonDataLoad();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
    private static CustomerInfoDAL _DAL = new CustomerInfoDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
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
    private DataAccessManager accessManager = new DataAccessManager();

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
            ApprovalStatus = "Accepted";
            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField hfCustomerApprovalId = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfCustomerApprovalId"));
            HiddenField hfToEmpId = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfToEmpId"));
            HiddenField hfStep = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfStep"));
            HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfCustomerMasterId"));
             

            CustomerSaveAppLog_DAO aMaster = new CustomerSaveAppLog_DAO();
            aMaster.CustomerApprovalId = hfCustomerApprovalId.Value == "" ? 0 : Convert.ToInt32(hfCustomerApprovalId.Value);

            aMaster.TableId = hfCustomerMasterId.Value == "" ? 0 : Convert.ToInt32(hfCustomerMasterId.Value);

            aMaster.GroupId = hfEmpGroupId.Value == "" ? 0 : Convert.ToInt32(hfEmpGroupId.Value);
            aMaster.RegionId = hfEmpRegionId.Value == "" ? 0 : Convert.ToInt32(hfEmpRegionId.Value);
            aMaster.AreaId = hfEmpAreaId.Value == "" ? 0 : Convert.ToInt32(hfEmpAreaId.Value);
            aMaster.TerritoryId = hfEmpTerrId.Value == "" ? 0 : Convert.ToInt32(hfEmpTerrId.Value);

            aMaster.FromEmpId = EmpInfoId == "" ? 0 : Convert.ToInt32(EmpInfoId);
            aMaster.ToEmpId = hfToEmpId.Value == "" ? 0 : Convert.ToInt32(hfToEmpId.Value);
            int InStep = hfStep.Value == "" ? 0 : Convert.ToInt32(hfStep.Value);
            aMaster.Step = InStep + 1;
            aMaster.Type = "Customer";
            aMaster.Status = ApprovalStatus;
            aMaster.Date = DateTime.Now;
            aMaster.EntryDateS = DateTime.Now;
            aMaster.ApproveDateS = DateTime.Now;
            aMaster.EntryByS = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.EntryByApp = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.MenuId = 302;
            ResultInfo Res = _DAL.SaveCustomer_ApplogDAL(aMaster);

            if (Res.isSuccess == true)
            {
                 ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                LoadData();

            }
            else
            {
                try
                {
                    accessManager.SqlConnectionClose();
                }
                catch
                {

                }
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                // ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }



        if (e.CommandName == "RejectData")
        {
            ApprovalStatus = "Rejected";

            int rowindex = Convert.ToInt32(e.CommandArgument);

            HiddenField hfCustomerApprovalId = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfCustomerApprovalId"));
            HiddenField hfToEmpId = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfToEmpId"));
            HiddenField hfStep = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfStep"));
            HiddenField hfCustomerMasterId = ((HiddenField)loadGridView.Rows[rowindex].FindControl("hfCustomerMasterId"));


            CustomerSaveAppLog_DAO aMaster = new CustomerSaveAppLog_DAO();
            aMaster.CustomerApprovalId = hfCustomerApprovalId.Value == "" ? 0 : Convert.ToInt32(hfCustomerApprovalId.Value);
            aMaster.TableId = hfCustomerMasterId.Value == "" ? 0 : Convert.ToInt32(hfCustomerMasterId.Value);
            aMaster.GroupId = hfEmpGroupId.Value == "" ? 0 : Convert.ToInt32(hfEmpGroupId.Value);
            aMaster.RegionId = hfEmpRegionId.Value == "" ? 0 : Convert.ToInt32(hfEmpRegionId.Value);
            aMaster.AreaId = hfEmpAreaId.Value == "" ? 0 : Convert.ToInt32(hfEmpAreaId.Value);
            aMaster.TerritoryId = hfEmpTerrId.Value == "" ? 0 : Convert.ToInt32(hfEmpTerrId.Value);

            aMaster.FromEmpId = EmpInfoId == "" ? 0 : Convert.ToInt32(EmpInfoId);
            aMaster.ToEmpId = hfToEmpId.Value == "" ? 0 : Convert.ToInt32(hfToEmpId.Value);
            int InStep = hfStep.Value == "" ? 0 : Convert.ToInt32(hfStep.Value);
            aMaster.Step = InStep + 1;
            aMaster.Type = "Customer";
            aMaster.Status = ApprovalStatus;
            aMaster.Date = DateTime.Now;
            aMaster.EntryDateS = DateTime.Now;
            aMaster.ApproveDateS = DateTime.Now;
            aMaster.EntryByS = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.EntryByApp = Convert.ToInt32(Session["UserId"].ToString());
            aMaster.MenuId = 302;
            ResultInfo Res = _DAL.SaveCustomer_ApplogDAL(aMaster);
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);
                LoadData();
            }
            else
            {

                try
                {
                    accessManager.SqlConnectionClose();
                }
                catch
                {

                }

                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "ShowSuccesalert('" + "Operation successful!" + "','Success');", true);

                //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

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
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }


    protected void loadGridView_RowDataBound(object sender, GridViewRowEventArgs e)
{
    if (e.Row.RowType == DataControlRowType.DataRow)
    {
        // Find the index of the ExistenceStatus column (adjust the column index as needed)
        int existenceStatusIndex = GetColumnIndexByName(loadGridView, "ExistenceStatus");

        if (existenceStatusIndex >= 0)
        {
            // Get the cell value for the ExistenceStatus column in the current row
            string existenceStatus = e.Row.Cells[existenceStatusIndex].Text;

            // Check if the ExistenceStatus is "Already Exists" and set the row's CSS class accordingly
            if (existenceStatus == "Already Exists")
            {
                e.Row.CssClass = "bg-color-red"; // Replace "bg-color-red" with your CSS class for the red background
            }
        }
    }
}

// Helper function to get the column index by header text
private int GetColumnIndexByName(GridView gridView, string columnName)
{
    foreach (DataControlField field in gridView.Columns)
    {
        if (field.HeaderText == columnName)
        {
            return gridView.Columns.IndexOf(field);
        }
    }
    return -1;
}

    private void LoadData()
    {

        string pram = "", Role = "";
        //   EmpMarketAccess( pram,  Role);

        if (EmpInfoId != "" || EmpInfoId != null)
        {
            DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active(EmpInfoId);
            if (dtMarket != null && dtMarket.Rows.Count > 0)
            {
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
                        pram = " AND View_Webapi_EmployeeFieldForceInfo.EmpAreaId=" + FFID + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.CreateDate),CONVERT(DATE,GETDATE())))<=7   ";
                        Role = "AM";

                        break;
                    case "DZSM":
                        FFID = dtMarket.Rows[0]["EmpRegionId"].ToString();
                        pram = " AND  View_Webapi_EmployeeFieldForceInfo.EmpRegionId=" + FFID + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.CreateDate),CONVERT(DATE,GETDATE())))<=7   ";
                        Role = "DZSM";
                        break;
                    case "NSM":
                        FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                        pram = " AND  View_Webapi_EmployeeFieldForceInfo.EmpGroupId=" + FFID + "  and (DATEDIFF(DAY,CONVERT(DATE,mas.CreateDate),CONVERT(DATE,GETDATE())))<=7   ";
                        Role = "NSM";
                        break;

                    case "DIC":
                        FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                        pram = " AND  dcMas.DCId=" + ddlDistributionCenter.SelectedValue;
                        Role = "DIC";
                        break;
                    default:
                        pram = "";
                        Role = "";
                        break;
                }
            }
        }



        if (GroupSelect.SelectedValue != "")
        {
            pram = pram + " AND gr.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            pram = pram + " AND rg.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            pram = pram + " AND Ar.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            pram = pram + " AND Tr.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            pram = pram + " AND subTr.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (ddlProgramType.SelectedValue != "")
        {
            pram = pram + " AND mas.ProgramTypeId='" + ddlProgramType.SelectedValue + "' ";
        }
        if (ddlChemisType.SelectedValue != "")
        {
            pram = pram + " AND mas.CustomerTypeId='" + ddlChemisType.SelectedValue + "' ";
        }

        if (hfCustomerId.Value != "")
        {
            pram = pram + " AND mas.CustomerMasterId='" + hfCustomerId.Value + "' ";
        }

        if (ddlApprovalStatus.SelectedValue != "")
        {
            pram = pram + " AND mas.ActionStatus='" + ddlApprovalStatus.SelectedValue + "' ";
        }
        if (ddlStatus.SelectedValue != "")
        {
            pram = pram + " AND mas.IsActive=" + ddlStatus.SelectedValue + " ";
        }
        if (frmDate.Text != "" && toDate.Text != "")
        {
            pram = pram + " AND CONVERT(date,mas.CreateDate)  BETWEEN '" + frmDate.Text + "' AND '" + toDate.Text + "' ";
        }
        if (frmDate.Text != "" && toDate.Text == "")
        {
            pram = pram + " AND CONVERT(date,mas.CreateDate)  BETWEEN '" + frmDate.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (frmDate.Text != "" && toDate.Text == "")
        {
            pram = pram + " AND CONVERT(date,mas.CreateDate)  BETWEEN '" + frmDate.Text + "' AND '" + DateTime.Now + "' ";
        }


        string AppStatus = null;
        int? EmpId = null; ;
        DateTime? FromDt = null;
        DateTime? ToDt = null;

        DataTable aDataTable = _DAL.GetCustomer_ApplogDAL(pram, Role, AppStatus, FromDt, ToDt, EmpId);


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

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerApproveList.aspx");
    }

    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {

    }
}