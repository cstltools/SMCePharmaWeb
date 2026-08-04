using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_PrescriptionView : System.Web.UI.Page
{
    public static SetupDAL _setupDAL = new SetupDAL();
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();

    static SetupDAL _setupDAL2 = new SetupDAL();
    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect;
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
            F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
            F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
            F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
            if (!IsPostBack)
        {
                FromDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
                ToDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
                LoadInitialInfo();

            LoadData();
        }
        }
        catch (Exception ex)
        {
        }
    }


    private void LoadData()
    {
        DataTable aDataTable = _setupDAL.Get_PrescriptionList(param());
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

      
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    private string param()
    {


        var param = " and  PM.PrescriptionId IS NOT NULL";

        if (FromDate.Text != "" && ToDate.Text != "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        }
        if (FromDate.Text != "" && ToDate.Text == "")
        {
            param = param + " AND CONVERT(date,PM.PrescriptionDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        }


        if (ApprovalStatusSelect.SelectedValue != "")
        {

            param = param + " AND PM.ApprovalStatus='" + ApprovalStatusSelect.SelectedValue + "'";


        }

        if (UserRoleSelect.SelectedValue != "")
        {

            param = param + " AND us.UserRoleID='" + UserRoleSelect.SelectedValue + "'";

        }

        if (EmployeeIdSelect.SelectedValue != "")
        {

            param = param + " AND em.EmpInfoId='" + EmployeeIdSelect.SelectedValue + "'";

        }
        if (ddlPharmaPlatform.SelectedValue != "")
        {

            param = param + " AND PM.SmcTypeId_RX='" + ddlPharmaPlatform.SelectedValue + "'";

        }

        if (F_ZoneSelect.SelectedValue != "")
        {

            param = param + " AND PM.RegionId='" + F_ZoneSelect.SelectedValue + "'";

        }

        if (F_AreaSelect.SelectedValue != "")
        {

            param = param + " AND PM.AreaId='" + F_AreaSelect.SelectedValue + "'";

        }

        if (F_TeritorySelect.SelectedValue != "")
        {

            param = param + " AND PM.TerritoryId='" + F_TeritorySelect.SelectedValue + "'";

        }


        string Role = "";
        DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active(EmpInfoId);

        string FFID = "";
        switch (RoleTypeName)
        {



            case "MIO":
                FFID = dtMarket.Rows[0]["MIOEmpId"].ToString();
                param = param + " AND View_Webapi_EmployeeFieldForceInfo.MIOEmpId=" + FFID;
                Role = "AM";

                break;

            case "AM":
                FFID = dtMarket.Rows[0]["ASMEMPId"].ToString();
                param = param + " AND View_Webapi_EmployeeFieldForceInfo.ASMEMPId=" + FFID;
                Role = "AM";

                break;
            case "DZSM":
                FFID = dtMarket.Rows[0]["RSMEMPId"].ToString();
                param = param + " AND  View_Webapi_EmployeeFieldForceInfo.RSMEMPId=" + FFID;
                Role = "DZSM";
                break;
            case "NSM":
                FFID = dtMarket.Rows[0]["NSMEMPId"].ToString();
                param = param + " AND  View_Webapi_EmployeeFieldForceInfo.NSMEMPId=" + FFID;
                Role = "NSM";
                break;


            default:

                Role = "";
                break;
        }


        return param;
    }

    private void LoadInitialInfo()
    {

        try
        {
            using (DataTable dt = _seedRepo.GetSMCTypeListParam(" and GRP.forDotor=1"))
            {
                ddlPharmaPlatform.DataSource = dt;
                ddlPharmaPlatform.DataValueField = "SMCTypeId";
                ddlPharmaPlatform.DataTextField = "SMCType";
                ddlPharmaPlatform.DataBind();
                ddlPharmaPlatform.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlPharmaPlatform.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_Active())
            {
                EmployeeIdSelect.DataSource = dt;
                EmployeeIdSelect.DataValueField = "EmpInfoId";
                EmployeeIdSelect.DataTextField = "EmpName";
                EmployeeIdSelect.DataBind();
                EmployeeIdSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                EmployeeIdSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _setupDAL.Get_UserRoleInfo())
            {
                UserRoleSelect.DataSource = dt;
                UserRoleSelect.DataValueField = "UserRoleID";
                UserRoleSelect.DataTextField = "RoleName";
                UserRoleSelect.DataBind();
                UserRoleSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                UserRoleSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _seedRepo.GetApprovalStatusList())
            {
                ApprovalStatusSelect.DataSource = dt;
                ApprovalStatusSelect.DataValueField = "SoftwareUseId";
                ApprovalStatusSelect.DataTextField = "WebShow";
                ApprovalStatusSelect.DataBind();
                ApprovalStatusSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ApprovalStatusSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


    }

    [WebMethod]
    public static string Get_PrescriptionList(string param)
    {
 
        DataTable dt = _setupDAL.Get_PrescriptionList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    


    protected void EmpCetegoryAddImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("Prescription.aspx");

    }
    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("PrescriptionView.aspx");
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

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

            Response.Redirect("Prescription.aspx?id=" + unitPriceId);
        }

    }

}