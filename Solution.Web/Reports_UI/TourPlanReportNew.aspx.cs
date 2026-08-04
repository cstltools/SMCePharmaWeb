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
using DocumentFormat.OpenXml.Bibliography;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;

public partial class Reports_UI_TourPlanReportNew : System.Web.UI.Page
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
        loadGridView.DataSource = null;
        loadGridView.DataBind();
        lblName.Text = "";
        lblECode.Text = "";
        lblMonth.Text = "";
        lblDesig.Text = "";
        lblPostingPlace.Text = "";
        lblPostingPlaceCode.Text = "";
        lblZone.Text = "";
        if (EmployeeIdSelect.SelectedValue != "")
        {
            DataTable aDataTable = _EmployeeInformationDaL.GetTourPlanReport__(EmployeeIdSelect.SelectedValue, ddlmonth.SelectedValue, ddlYear.SelectedValue);
            if (aDataTable.Rows.Count > 0)
            {
                DataRow row = aDataTable.Rows[0];

                lblName.Text = row["EmpName"].ToString();
                lblECode.Text = row["EmpMasterCode"].ToString();
                lblMonth.Text = row["MonthYear"].ToString();
                lblDesig.Text = row["RoleName"].ToString();
                lblPostingPlace.Text = row["PostingPlace"].ToString();
                lblPostingPlaceCode.Text = row["PostingPlaceCode"].ToString();
                lblZone.Text = row["Zone"].ToString();
            }


            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();



            DataTable dtBal = _EmployeeInformationDaL.GetTourPlanReportBal(EmployeeIdSelect.SelectedValue, ddlmonth.SelectedValue, ddlYear.SelectedValue);
            if (dtBal.Rows.Count > 0)
            {
                DataRow row = dtBal.Rows[0];

                lblNoOfHQ.Text = row["HQ"].ToString();
                lblNoOfExHQ.Text = row["ExHQ"].ToString();
                lblNoOfOS.Text = row["OS"].ToString();
                lblOSDCC.Text = row["OSDCC"].ToString();
                lblTotal.Text = row["Total"].ToString();
                
            }


        }
        else
        {
            showMessageBox("Please select Required Field!!");
        }

        
    }


    protected void loadGridView_RowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            // Create a new header row for the first header
            GridViewRow headerRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            // Common style for the text
            string commonStyle = "font-weight:bold; text-align:center;";

            // Style for the Employee Info section
            string employeeInfoStyle = "font-weight:bold; text-align:center; background-color:#f2f2f2;";

            // Style for the Morning section
            string morningStyle = "font-weight:bold; text-align:center; background-color:#E0FFFF;";

            // Style for the Evening section
            string eveningStyle = "font-weight:bold; text-align:center; background-color:#FFE4E1;";

            // Style for the Other Visit section
            string otherVisitStyle = "font-weight:bold; text-align:center; background-color:#AFEEEE;";

            // Create cells for the first header row
            TableCell headerCell = new TableCell();
            headerCell.ColumnSpan = 2;
            headerCell.Text = "";
            headerCell.Attributes.Add("style", employeeInfoStyle);
            headerRow.Cells.Add(headerCell);

            headerCell = new TableCell();
            headerCell.ColumnSpan = 5;
            headerCell.Text = "Morning";
            headerCell.Attributes.Add("style", morningStyle);
            headerRow.Cells.Add(headerCell);

            headerCell = new TableCell();
            headerCell.ColumnSpan = 5;
            headerCell.Text = "Evening";
            headerCell.Attributes.Add("style", eveningStyle);
            headerRow.Cells.Add(headerCell);

             

            //headerCell = new TableCell();
            //headerCell.ColumnSpan = 2;
            //headerCell.Text = "";
            //headerCell.Attributes.Add("style", otherVisitStyle);
            //headerRow.Cells.Add(headerCell);

            // Add the custom header row before the current header
            ((GridView)sender).Controls[0].Controls.AddAt(0, headerRow);
        }
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

        string _EmployeeId = EmployeeIdSelect.SelectedValue;
        string month = ddlmonth.SelectedValue;
        string Year = ddlYear.SelectedValue;

        // Validate the input fields
        if (string.IsNullOrEmpty(_EmployeeId) || string.IsNullOrEmpty(month) || string.IsNullOrEmpty(Year))
        {
            // Display a validation message or handle the case where input fields are not selected
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('Please select all required fields', 'Faild');", true);
            return; // Exit the method if validation fails
        }

        // Construct the URL with query string using string concatenation
        string url = "../SInventory_RPTVIEW/TourPlanReportViwer.aspx" +
                     "?EmployeeId=" + _EmployeeId +
                     "&Month=" + month +
                     "&Year=" + Year;

        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" +
                         url +
                         "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

         //LoadData();
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
        try
        {
            string Type = "";
             
                Type = " ";

                string attachment = "attachment; filename=" + Type + " Tour Plan Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

            htw.Write("<div class='table-responsive'>");
            htw.Write("<table style='width: 100%; border-collapse: collapse; margin-bottom: 20px;'>");

            // Add your labels here
            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Name:</td>");
            htw.Write("<td style='border: 1px solid #ddd; padding: 4px;'>" + lblName.Text + "</td>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>E.Code:</td>");
            htw.Write("<td style='border: 1px solid #ddd; padding: 4px;'>" + lblECode.Text + "</td>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Month:</td>");
            htw.Write("<td style='border: 1px solid #ddd; padding: 4px;'>" + lblMonth.Text + "</td>");
            htw.Write("</tr>");

            // Add more rows as needed
            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Desig:</td>");
            htw.Write("<td style='border: 1px solid #ddd; padding: 4px;'>" + lblDesig.Text + "</td>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Posting Place:</td>");
            htw.Write("<td style='border: 1px solid #ddd; padding: 4px;'>" + lblPostingPlace.Text + "</td>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Posting Place Code:</td>");
            htw.Write("<td style='border: 1px solid #ddd; padding: 4px;'>" + lblPostingPlaceCode.Text + "</td>");
            htw.Write("</tr>");

            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Zone:</td>");
            htw.Write("<td colspan='5' style='border: 1px solid #ddd; padding: 4px;'>" + lblZone.Text + "</td>");
            htw.Write("</tr>");

            htw.Write("</table>");
            htw.Write("</div>");


            this.LoadData();

                // Create a form to contain the grid  
                HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(gv_DistributionCenter);
            //frm.RenderControl(htw);

            loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

                // Set background color of each cell of GridView1 header row
                foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
                {
                    tableCell.Style["background-color"] = "#E5EEF1";
                }

                // Set background color of each cell of each data row of GridView1
                foreach (GridViewRow gridViewRow in loadGridView.Rows)
                {
                    gridViewRow.BackColor = System.Drawing.Color.White;

                    foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                    {
                        gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                    }
                }


            loadGridView.RenderControl(htw);

            htw.Write("<div style='margin-top:40px;'>");
            htw.Write("<table style='width: 100%; border-collapse: collapse; border: 1px solid #ddd;'>");

            // HQ, Ex. HQ, OS details
            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>No of HQ</td>");
           
            htw.Write("<td style='text-align:right; border: 1px solid #ddd; padding: 4px;'>" + lblNoOfHQ.Text + "</td>");
            htw.Write("</tr>");

            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>No of Ex. HQ</td>");
           
            htw.Write("<td style='text-align:right; border: 1px solid #ddd; padding: 4px;'>" + lblNoOfExHQ.Text + "</td>");
            htw.Write("</tr>");

            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>No of OS</td>");
      
            htw.Write("<td style='text-align:right; border: 1px solid #ddd; padding: 4px;'>" + lblNoOfOS.Text + "</td>");
            htw.Write("</tr>");  
            
            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>No of OS-DCC</td>");
      
            htw.Write("<td style='text-align:right; border: 1px solid #ddd; padding: 4px;'>" + lblOSDCC.Text + "</td>");
            htw.Write("</tr>");

            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold; border: 1px solid #ddd; padding: 4px;'>Total</td>");
           
            htw.Write("<td style='text-align:right; border: 1px solid #ddd; padding: 4px;'>" + lblTotal.Text + "</td>");
            htw.Write("</tr>");

            htw.Write("</table>");
            htw.Write("</div>");


            // Submission, Update, Approval details
            htw.Write("<div style='margin-top:40px;'>");
            htw.Write("<table style='width: 100%; border-collapse: collapse;'>");

            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold;'>Tour Plan Submitted by:</td>");
            htw.Write("<td>__________________</td>");
            htw.Write("<td style='font-weight: bold;'>Tour Plan updated by:</td>");
            htw.Write("<td>__________________</td>");
            htw.Write("<td style='font-weight: bold;'>Tour Plan approved by:</td>");
            htw.Write("<td>__________________</td>");
            htw.Write("</tr>");

            htw.Write("<tr>");
            htw.Write("<td style='font-weight: bold;'>Submitted date & time:</td>");
            htw.Write("<td>__________________</td>");
            htw.Write("<td style='font-weight: bold;'>Updated date & time:</td>");
            htw.Write("<td>__________________</td>");
            htw.Write("<td style='font-weight: bold;'>Approved date & time:</td>");
            htw.Write("<td>__________________</td>");
            htw.Write("</tr>");

            htw.Write("</table>");
            htw.Write("</div>");
            string headerTable = @"";

                HttpContext.Current.Response.Write(headerTable);

                Response.Write(sw.ToString());
                Response.End();
            
        }
         catch{

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

            param = param + " AND dtl.EmpInfoId='" + EmployeeIdSelect.SelectedValue + "'";

        }

        if (ddlmonth.SelectedValue != "")
        {

            param = param + " AND month(dtlT.TourPlanDate)='" + ddlmonth.SelectedValue + "'";

        }

        if (ddlYear.SelectedValue != "")
        {

            param = param + " AND year(dtlT.TourPlanDate)='" + ddlYear.SelectedValue + "'";

        }

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