using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_TADAClaimView : System.Web.UI.Page
{
    public static SetupDAL _setupDAL = new SetupDAL();
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    private static Setup2DAL _setupDALss = new Setup2DAL();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    static SetupDAL _setupDAL2 = new SetupDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

            if (!IsPostBack)
        {
            FromDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            ToDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            LoadInitialInfo();

          //  LoadData();
        }
        }
        catch (Exception ex)
        {
            Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
        }
    }


    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

      

            System.Web.UI.ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "openModal", "window.open('TADAClaimEdit.aspx?MID=" + unitPriceId + "' ,'_blank');", true);

        }

    }


    private string param()
    {


        var param = "  ";



        string   Role = "";
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
                    param = " AND v.EmpAreaId=" + FFID;
                    Role = "AM";

                    break;
                case "DZSM":
                    FFID = dtMarket.Rows[0]["EmpRegionId"].ToString();
                    param = " AND  v.EmpRegionId=" + FFID;
                    Role = "DZSM";
                    break;
                case "NSM":
                    FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                    param = " AND  v.EmpGroupId=" + FFID;
                    Role = "NSM";
                    break;

                //case "DIC":
                //    FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                //    pram = " AND  dcMas.DCId=" + ddlDistributionCenter.SelectedValue;
                //    Role = "DIC";
                //    break;
                default:
                    param = "";
                    Role = "";
                    break;
            }
        }


        if (FromDate.Text != "" && ToDate.Text != "")
        {
            param = param + " AND CONVERT(date,mas.TadaDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        }
        if (FromDate.Text != "" && ToDate.Text == "")
        {
            param = param + " AND CONVERT(date,mas.TadaDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        }


        if (ApprovalStatusSelect.SelectedValue != "")
        {

            param = param + " AND mas.ApprovalStatus='" + ApprovalStatusSelect.SelectedValue + "'";


        }

        if (UserRoleSelect.SelectedValue != "")
        {

            param = param + " AND us.UserRoleID='" + UserRoleSelect.SelectedValue + "'";

        }

        if (EmployeeIdSelect.SelectedValue != "")
        {

            param = param + " AND mas.EmpInfoId='" + EmployeeIdSelect.SelectedValue + "'";

        }


        return param;
    }
    private void LoadData()
    {
        DataTable aDataTable = _setupDALss.Get_TADAList(param());
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

          }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {

        if (loadGridView.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=DA Information List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            gv_Export.AllowPaging = false;
            DataTable aDataTable = _setupDALss.Get_TADAList(param());
            gv_Export.DataSource = aDataTable;
            gv_Export.DataBind();

            StringBuilder sb = new StringBuilder();
            foreach (TableCell cell in gv_Export.HeaderRow.Cells)
            {
                //Append data with separator.
                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
            }
            //Append new line character.
            sb.Append("\r\n");

            foreach (GridViewRow row in gv_Export.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    //Append data with separator.
                    if (cell.Text.Contains(","))
                    {
                        sb.Append(String.Format("\"{0}\",", cell.Text));
                    }
                    else
                    { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                }
                //Append new line character.
                sb.Append("\r\n");
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        }
    }


    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    private void LoadInitialInfo()
    {


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


    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("TADAClaimView.aspx");
    }
}