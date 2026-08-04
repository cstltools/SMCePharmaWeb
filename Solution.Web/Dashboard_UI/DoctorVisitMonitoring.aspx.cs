using DocumentFormat.OpenXml.VariantTypes;
using Library.DAL.Doctor_Monitoring_DAL;
using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Dashboard_UI_DoctorVisitMonitoring : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private static DoctorMonitoringDAL _DAL = new DoctorMonitoringDAL();
    private static EmployeeInformationDaL _EmployeeInformationDaL = new EmployeeInformationDaL();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

        }
        catch { }
        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {

            FromDate.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month, 1)
                     .ToString("dd MMMM, yyyy");

            ToDate.Text = new DateTime(DateTime.Now.Year, DateTime.Now.Month,
                            DateTime.DaysInMonth(DateTime.Now.Year, DateTime.Now.Month))
                                .ToString("dd MMMM, yyyy");

            LoadInitialInfo();
        }
    }
    protected void loadGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (ViewState["SelectedRowIndex"] != null)
            {
                int selectedIndex = Convert.ToInt32(ViewState["SelectedRowIndex"]);

                if (e.Row.RowIndex == selectedIndex)
                {
                    e.Row.BackColor = System.Drawing.Color.LightYellow; // হাইলাইট কালার
                }
                else
                {
                    e.Row.BackColor = System.Drawing.Color.White; // অন্যান্য রো
                }
            }
        }
    }

    private void LoadInitialInfo()
    {

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



        if (RoleTypeName == "DZSM")
        {
          
            F_ZoneSelect.Enabled = false;
            
        }
        if (RoleTypeName == "AM")
        {
                 F_ZoneSelect.Enabled = false;
            F_AreaSelect.Enabled = false;
            F_GroupSelect.Enabled = false;

             
        }


    }

    private void LoadData()
    {
        string param = "";

        string Area = ""; string Terr = "";
        string Type = "";
        string ZonId = "";
        string GroupId = "";
        GroupId = F_GroupSelect.SelectedValue;
        ZonId = F_ZoneSelect.SelectedValue;
        Area = F_AreaSelect.SelectedValue;
        Terr = F_TeritorySelect.SelectedValue;

        DataTable aDataTable = _DAL.GetDoctorVisitMonitoringApprovalList(param, FromDate.Text, ToDate.Text, GroupId, ZonId, Area, Terr);

        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();



        //for (int i = 0; i < loadGridView.Rows.Count; i++)
        //{

        //    HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");
        //    HiddenField hfRoleType = (HiddenField)loadGridView.Rows[i].FindControl("hfRoleType");
        //    Label hfTerritoryCode = (Label)loadGridView.Rows[i].FindControl("hfTerritoryCode");
        //    Label lblTerritory = (Label)loadGridView.Rows[i].FindControl("lblTerritory");

        //    DataTable dtTErriCode = _EmployeeInformationDaL.GetTerritoryCodeByRoleTypeEmpId(hfEmpInfoId.Value, hfRoleType.Value);

        //    try
        //    {
        //        hfTerritoryCode.Text = dtTErriCode.Rows[0]["TerritoryCode"].ToString();
        //        lblTerritory.Text = dtTErriCode.Rows[0]["TerritoryName"].ToString();
        //    }
        //    catch { }

        //}


    }

    private DataTable GetKPIByEmpId(string empId)
    {
        DataTable dt = new DataTable();
        dt.Columns.Add("KPIName");
        dt.Columns.Add("Score");
        dt.Columns.Add("Weight");

        dt.Rows.Add("KPI 1", "30", "10");
        dt.Rows.Add("KPI 2", "20", "15");

        return dt;
    }

    protected void btnClosePopup_Click(object sender, EventArgs e)
    {
        mpeCommonPopup.Hide();
    }




    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "ShowModal")
        {
            string[] args = e.CommandArgument.ToString().Split('|');
            string id = args[0];
            string type = args[1]; // DCP, DCR, RX etc.

            // Based on type, load data
            string data = GetDataByType(id, type);

            // Set modal content
            lblModalContent.Text = data;
            modalTitle.InnerText = type + " Details";

            // Show popup
            mpeCommonPopup.Show();
        }
    }
    private string GetDataByType(string id, string type)
    {
        string result = string.Empty;

        switch (type)
        {
            case "DCP":
                result = GetDCPData(id);
                break;

            case "DCR":
                result = GetDCRData(id);
                break;

            case "RX":
                result = GetRXData(id);
                break;

            case "CustomerCoverage":
                result = GetCustomerCoverageData(id);
                break;

            case "GPSales":
                result = GetGPSalesData(id);
                break;

            case "TSalesNetTP":
                result = GetTSalesNetTPData(id);
                break;

            default:
                result = "Invalid type.";
                break;
        }

        return result;
    }
    private string GetDCPData(string id)
    {
        return "DCP data for ID: " + id;
    }

    private string GetDCRData(string id)
    {
        return "DCR data for ID: " + id;
    }

    private string GetRXData(string id)
    {
        return "RX data for ID: " + id;
    }

    private string GetCustomerCoverageData(string id)
    {
        return "Customer Coverage data for ID: " + id;
    }

    private string GetGPSalesData(string id)
    {
        return "GP Sales data for ID: " + id;
    }

    private string GetTSalesNetTPData(string id)
    {
        return "T Sales (Net TP) data for ID: " + id;
    }


    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }
    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("DoctorVisitMonitoring.aspx");
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
}