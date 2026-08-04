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

public partial class Reports_UI_TargetAChivementReport : System.Web.UI.Page
{
    public static SetupDAL _setupDAL = new SetupDAL();
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    private static Setup2DAL _setupDALss = new Setup2DAL();

    static SetupDAL _setupDAL2 = new SetupDAL();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
            string pram = "", Role = "";

            LoadInitialInfo();
            ddlmonth_SelectedIndexChanged(null, null);
     //       LoadData();
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


        string _Month = "";
        string _Year = "";
        string _FromDate = "";
        string _ToDate = "";
        string _Zone = "";
        string _Area = "";
        string _Tr = "";


        if (ddlmonth.SelectedValue != "")
        {
            _Month = ddlmonth.SelectedValue;
        }

        if (ddlYear.SelectedValue != "")
        {
            _Year = ddlYear.SelectedValue;
        }

        if (FromDate.Text != "" )
        {
            _FromDate = FromDate.Text;
        }

        if (ToDate.Text != "")
        {
            _ToDate = ToDate.Text;
        }

        if (ZoneSelect.SelectedValue != "")
        {
            _Zone = ZoneSelect.SelectedValue;
        }

        if (AreaSelect.SelectedValue != "")
        {
            _Area = AreaSelect.SelectedValue;
        }

        if (TeritorySelect.SelectedValue != "")
        {
            _Tr = TeritorySelect.SelectedValue;
        }

        DataTable aDataTable = _setupDALss.Get_TargetAChivementReport(_Month, _Year, _FromDate, _ToDate, _Zone, _Area, _Tr);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        

    }

    protected void ZoneSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetArea_ByZoneId_Rpt(Convert.ToInt32(ZoneSelect.SelectedValue)))
            {
                AreaSelect.DataSource = dt;
                AreaSelect.DataValueField = "AreaId";
                AreaSelect.DataTextField = "AreaName";
                AreaSelect.DataBind();
                AreaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                AreaSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


        TeritorySelect.Items.Clear();
        
    }




    protected void AreaSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_Rpt(Convert.ToInt32(AreaSelect.SelectedValue)))
            {
                TeritorySelect.DataSource = dt;
                TeritorySelect.DataValueField = "TerritoryId";
                TeritorySelect.DataTextField = "TerritoryName";
                TeritorySelect.DataBind();
                TeritorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                TeritorySelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }



       
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
            Response.AddHeader("content-disposition", "attachment;filename=Target Achievement Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            loadGridView.AllowPaging = false;
            LoadData();
            loadGridView.AllowPaging = false;
            StringBuilder sb = new StringBuilder();
            foreach (TableCell cell in loadGridView.HeaderRow.Cells)
            {
                //Append data with separator.
                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
            }
            //Append new line character.
            sb.Append("\r\n");

            foreach (GridViewRow row in loadGridView.Rows)
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
            GetMonthList(ddlmonth);
            GetYearList(ddlYear);
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

            using (DataTable dt = _dataLoad.GetZone_byGroupId_All(Convert.ToInt32(1)))
            {
                ZoneSelect.DataSource = dt;
                ZoneSelect.DataValueField = "RegionId";
                ZoneSelect.DataTextField = "RegionName";
                ZoneSelect.DataBind();
                ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ZoneSelect.SelectedIndex = 0;


                try
                {
                    if (EmpInfoId != "" || EmpInfoId != null)
                    {
                        if (ToRoleTypeId != "5")
                        {
                            if (RoleTypeName == "DZSM")
                            {
                                DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active_forReport(EmpInfoId, RoleTypeName);

                                string RegionId = dtMarket.Rows[0]["RegionId"].ToString();
                                ZoneSelect.SelectedValue = RegionId;
                                ZoneSelect_SelectedIndexChanged(null, null);
                                ZoneSelect.Enabled = false;
                            }
                        }
                    }
                }
                catch { }
                    }
        }
        catch (Exception ex)
        {

        }


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

    protected void ddlmonth_SelectedIndexChanged(object sender, EventArgs e)
    {

        try
        {
            int _Year = Convert.ToInt32(ddlYear.SelectedValue);
            int _Month = Convert.ToInt32(ddlmonth.SelectedValue);
            // Get the current date
            DateTime currentDate = DateTime.Now;

            // Get the first day of the current month
            DateTime firstDayOfMonth = new DateTime(_Year, _Month, 1);

            // Get the last day of the current month
            DateTime lastDayOfMonth = firstDayOfMonth.AddMonths(1).AddDays(-1);

            // Format and set the text values
            FromDate.Text = firstDayOfMonth.ToString("dd MMMM, yyyy");
            ToDate.Text = lastDayOfMonth.ToString("dd MMMM, yyyy");


            //FromDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            //ToDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
        }
        catch
        {

        }

    }
}