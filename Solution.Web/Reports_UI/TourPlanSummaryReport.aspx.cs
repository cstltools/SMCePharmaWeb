using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;

public partial class Reports_TourPlanSummaryReport : System.Web.UI.Page
{
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static SetupDAL _setupDAL2 = new SetupDAL();
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    private static EmployeeInformationDaL _EmployeeInformationDaL = new EmployeeInformationDaL();

    static CommonDataLoad _dataLoad = new CommonDataLoad();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialInfo();

            //  LoadData();
            //BindEmployeeData();
        }
    }
    public void GetYearList(DropDownList ddl)
    {


        int i;

        for (i = 2015; i <= 2050; i++)
        {
            ddl.Items.Add(i.ToString());
            ddl.Items.FindByValue(System.DateTime.Now.Year.ToString());
        }
        string strYear = System.DateTime.Now.Year.ToString();

        ddl.SelectedValue = strYear;


    }
    public void GetMonthList(DropDownList ddl)
    {
        DateTime month = Convert.ToDateTime(DateTime.Now);
        for (int i = 0; i < 12; i++)
        {
            DateTime NextMont = month.AddMonths(i);
            ListItem list = new ListItem();
            list.Text = NextMont.ToString("MMMM");
            list.Value = NextMont.Month.ToString();
            ddl.Items.Add(list);
        }
        //ddl.Items.Insert(0, "Select Month");
        ddl.Items.FindByValue(DateTime.Now.Month.ToString()).Selected = true;
    }

    public class Employee
    {
        public int SL { get; set; }
        public string EmployeeCode { get; set; }
        public string TerritoryCode { get; set; }
        public string EmployeeName { get; set; }
        public string Role { get; set; }
        public string DayOfHQ { get; set; }
        public string NoOfExHQ { get; set; }        // Added this property
        public string NoOfOS { get; set; }          // Added this property
        public string NoOfOSDCC { get; set; }       // Added this property
        public string NoOfDaysWork { get; set; }    // Added this property
        public string NoOfDaysLeave { get; set; }   // Added this property
        public string DaysWorkTeamMate { get; set; } // Added this property
        public string ExampleForZonalHead { get; set; }
        public string ExampleForAM { get; set; }
    }

    private void BindEmployeeData()
    {
        // Replace with actual data retrieval logic
        var employeeData = new List<Employee>
    {
        new Employee
        {
            SL = 1,
            EmployeeCode = "51383",
            TerritoryCode = "KU-100",
            EmployeeName = "Md. Abul Kalam Azad",
            Role = "DSM",
            DayOfHQ = "1",
            NoOfExHQ = "0",             // Sample data for NoOfExHQ
            NoOfOS = "0",               // Sample data for NoOfOS
            NoOfOSDCC = "0",            // Sample data for NoOfOSDCC
            NoOfDaysWork = "22",        // Sample data for NoOfDaysWork
            NoOfDaysLeave = "2",        // Sample data for NoOfDaysLeave
            DaysWorkTeamMate = "20",    // Sample data for DaysWorkTeamMate
            ExampleForZonalHead = "KU-110: 1 D",
            ExampleForAM = "KU-111: 1 D"
        },
        // Add additional sample employee data here
    };
        loadGridView.DataSource = employeeData;
        loadGridView.DataBind();
    }
    private void LoadInitialInfo()
    {

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
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
        }

        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_All())
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

       


    }
        private void LoadData()
    {
        DataTable aDataTable = _EmployeeInformationDaL.GetTourPlanSummaryReportReport( ddlmonth.SelectedValue, ddlYear.SelectedValue, EmployeeIdSelect.SelectedValue, UserRoleSelect.SelectedValue);

       

        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
         
        //for (int i = 0; i < loadGridView.Rows.Count; i++)
        //{
        //    HiddenField EmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("EmpInfoId");

        //}
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    private bool Validation2()
    {
        Int32 count = 0;

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");

            if (chkBoxRows.Checked)
            {
                count++;
            }

            if (count > 0)
            {
                break;
            }
        }

        if (count == 0)
        {
           
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select at least one employee!" + "','Faild');", true);

            return false;
        }

        return true;
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (Validation2())
        {

            string MasterIncrementID = "";
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");




                if (chkBoxRows.Checked)
                {
                    HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");

                    string res2 = hfEmpInfoId.Value;
                    MasterIncrementID += res2 + ",";
                }

            }
            string mmm = MasterIncrementID.TrimEnd(',');
            PopUp(mmm, "Crys");
        }
    }
    private void PopUp(string EmpInfoId, string fType)
    {
        string Month = ddlmonth.SelectedValue;
        string Year = ddlYear.SelectedValue;
        string url = "../SInventory_RPTVIEW/EmployeeExpenseReportViewer.aspx?rptType=" + EmpInfoId + "&Month=" + Month + "&Year=" + Year + "&fType=" + fType;

        //string url = "../Report_UI/MemoPrintIncrementReportViwer.aspx?rptType=" + EmpInfoId + "&rt=MemoPIAll";
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
    private string param()
    {
         

        var param = "  ";

        //if (FromDate.Text != "" &&  ToDate.Text != "") {
        //    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        //}
        //if ( FromDate.Text != "" && ToDate.Text == "") {
        //    param = param + " AND CONVERT(date,mas.EntryDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        //}
        if (ddlEmployeeStatus.SelectedValue != "0")
        {

            param = param + "   and PM.EmployeeStatus ='" + ddlEmployeeStatus.SelectedValue + "'";

        }

        if (EmployeeIdSelect.SelectedValue != "" ) {

            param = param + " AND PM.EmpInfoId='" + EmployeeIdSelect.SelectedValue + "'";

        }

        //if (ddlmonth.SelectedValue != "")
        //{

        //    param = param + " AND tblDA.TadaDateMonth='" + ddlmonth.SelectedValue + "'";

        //}

        //if (ddlYear.SelectedValue != "")
        //{

        //    param = param + " AND tblDA.TadaDateYear='" + ddlYear.SelectedValue + "'";

        //}

        if (UserRoleSelect.SelectedValue != "")
        {

            param = param + " AND usR.UserRoleId='" + UserRoleSelect.SelectedValue + "'";

        }


        return param;
    }

    [WebMethod]
    public static string GetMileageClaimList(string param)
    {
        DataTable dt = _setupDAL.GetMileageClaimList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;

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

            Response.Redirect("../DoctorModule_UI/MileageClaim.aspx?id=" + unitPriceId);
        }

    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
         Response.Redirect("EmpMonthlyExpenseRpt.aspx");
    }

    protected void btnPrint_OnClick(object sender, EventArgs e)
    {
        if (Validation2())
        {

            string MasterIncrementID = "";
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");




                if (chkBoxRows.Checked)
                {
                    HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");

                    string res2 = hfEmpInfoId.Value;
                    MasterIncrementID += res2 + ",";
                }

            }
            string mmm = MasterIncrementID.TrimEnd(',');
            PopUp(mmm, "Print");
        }
    }
}