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
using SalesSolution.Web.Models;

public partial class Reports_UI_OrderPermission : System.Web.UI.Page
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

           // LoadData();
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
    private void LoadInitialInfo()
    {

       
        
        try
        {
            using (DataTable dt = _setupDAL.GetZoneListOrdPer())
            {
                ddlZone.DataSource = dt;
                ddlZone.DataValueField = "RegionId";
                ddlZone.DataTextField = "RegionName";
                ddlZone.DataBind();
                ddlZone.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlZone.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        //try
        //{
        //    GetMonthList(ddlmonth);
        //    GetYearList(ddlYear);
        //}

        //catch (Exception ex) { }

        //try
        //{
        //    using (DataTable dt = _dataLoad.GetEmployeeList_All())
        //    {
        //        EmployeeIdSelect.DataSource = dt;
        //        EmployeeIdSelect.DataValueField = "EmpInfoId";
        //        EmployeeIdSelect.DataTextField = "EmpName";
        //        EmployeeIdSelect.DataBind();
        //        EmployeeIdSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
        //        EmployeeIdSelect.SelectedIndex = 0;
        //    }


        //}
        //catch (Exception ex) { }

       


    }
        private void LoadData()
    {
        DataTable aDataTable = _EmployeeInformationDaL.GetEmployeeInfoOrdPermission(param());

       

        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {

            
            HiddenField hfTerritoryId = (HiddenField)loadGridView.Rows[i].FindControl("hfTerritoryId");
            
            
            HiddenField hfPermittedEmpId = (HiddenField)loadGridView.Rows[i].FindControl("hfPermittedEmpId");
            
             
            DropDownList ddlPermittedEmpId = (DropDownList)loadGridView.Rows[i].FindControl("ddlPermittedEmpId");
            
           

            try
            {
                using (DataTable dt = _EmployeeInformationDaL.GetAMDZSMListByTerritoryId(hfTerritoryId.Value))
                {
                    ddlPermittedEmpId.DataSource = dt;
                    ddlPermittedEmpId.DataValueField = "EmpInfoId";
                    ddlPermittedEmpId.DataTextField = "EmpName";
                    ddlPermittedEmpId.DataBind();
                    ddlPermittedEmpId.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlPermittedEmpId.SelectedIndex = 0;
                }


                if (hfPermittedEmpId.Value != null &&  hfPermittedEmpId.Value != "" && hfPermittedEmpId.Value != "0")
                {
                    var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
                    chkBoxRows.Checked = true;
                    ddlPermittedEmpId.SelectedValue = hfPermittedEmpId.Value;
                }

            }
            catch (Exception ex) { }

        }

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
            loadGridView.Rows[i].BackColor = System.Drawing.Color.Empty;
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

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            loadGridView.Rows[i].BackColor = System.Drawing.Color.Empty;
            if (chkBoxRows.Checked)
            {
                DropDownList ddlPermittedEmpId = (DropDownList)loadGridView.Rows[i].FindControl("ddlPermittedEmpId");
                TextBox txtFrmDate = (TextBox)loadGridView.Rows[i].FindControl("txtFrmDate");
                TextBox txtToDate = (TextBox)loadGridView.Rows[i].FindControl("txtToDate");
                
                if (ddlPermittedEmpId.SelectedValue == "")
                {
                    loadGridView.Rows[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#f0a8a8");
                    ddlPermittedEmpId.Focus();
                   
                }
                
                if (txtFrmDate.Text == "")
                {
                    loadGridView.Rows[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#f0a8a8");
                    txtFrmDate.Focus();

                }

                if (txtToDate.Text == "")
                {
                    loadGridView.Rows[i].BackColor = System.Drawing.ColorTranslator.FromHtml("#f0a8a8");
                    txtToDate.Focus();

                }
            }
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
        //if (ddlEmployeeStatus.SelectedValue != "0")
        //{

        //    param = param + "   and PM.EmployeeStatus ='" + ddlEmployeeStatus.SelectedValue + "'";

        //}

        if (ddlZone.SelectedValue != "" ) {

            param = param + " AND  ar.RegionId='" + ddlZone.SelectedValue + "'";

        }
           if (ddlArea.SelectedValue != "" ) {

            param = param + " AND ar.AreaId='" + ddlArea.SelectedValue + "'";

        }

        //if (ddlmonth.SelectedValue != "")
        //{

        //    param = param + " AND tblDA.TadaDateMonth='" + ddlmonth.SelectedValue + "'";

        //}

        //if (ddlYear.SelectedValue != "")
        //{

        //    param = param + " AND tblDA.TadaDateYear='" + ddlYear.SelectedValue + "'";

        //}

        //if (UserRoleSelect.SelectedValue != "")
        //{

        //    param = param + " AND usR.UserRoleId='" + UserRoleSelect.SelectedValue + "'";

        //}


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
         Response.Redirect("OrderPermission.aspx");
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

    protected void ddlZone_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            using (DataTable dt = _setupDAL.GetAreaListOrdPer(ddlZone.SelectedValue))
            {
                ddlArea.DataSource = dt;
                ddlArea.DataValueField = "AreaId";
                ddlArea.DataTextField = "AreaName";
                ddlArea.DataBind();
                ddlArea.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlArea.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validation2())
        { 
            ResultInfo Res = new ResultInfo();
            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");




                if (chkBoxRows.Checked)
                {
                    HiddenField hfTerritoryId = (HiddenField)loadGridView.Rows[i].FindControl("hfTerritoryId");

                    DropDownList ddlPermittedEmpId = (DropDownList)loadGridView.Rows[i].FindControl("ddlPermittedEmpId");
                    TextBox txtFrmDate = (TextBox)loadGridView.Rows[i].FindControl("txtFrmDate");
                    TextBox txtToDate = (TextBox)loadGridView.Rows[i].FindControl("txtToDate");
              DateTime? FrmDate=      string.IsNullOrEmpty(txtFrmDate.Text) ? (DateTime?)null : DateTime.Parse(txtFrmDate.Text);

                    DateTime? ToDate = string.IsNullOrEmpty(txtToDate.Text) ? (DateTime?)null : DateTime.Parse(txtToDate.Text);

                    Res = _setupDAL.Save_OrderPermission(hfTerritoryId.Value, ddlPermittedEmpId.SelectedValue, FrmDate, ToDate, Convert.ToString(HttpContext.Current.Session["LoginName"].ToString()));


                   
                }

            }
            if (Res.isSuccess)
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
}