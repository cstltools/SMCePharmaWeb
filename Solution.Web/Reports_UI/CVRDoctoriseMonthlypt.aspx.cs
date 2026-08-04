using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;

public partial class Reports_UI_CVRDoctoriseMonthlypt : System.Web.UI.Page
{
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static SetupDAL _setupDAL2 = new SetupDAL();
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();

    static CommonDataLoad _dataLoad = new CommonDataLoad();

    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = ""; string areaId = "";
    string masArea = "";
    string strRole = "";
    private static CommonDataLoad _CommonDataLoad = new CommonDataLoad();

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

            try
            {
                ProductBLL aProductBLL = new ProductBLL();

                aProductBLL.LoadProductSQ(ddlBrand);
            }
            catch (Exception ex)
            {

            }
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
            DateTime now = DateTime.Now;
            var startDate = new DateTime(now.Year, now.Month, 1);
            var endDate = startDate.AddMonths(1).AddDays(-1);
            fromDateTextBox.Text = startDate.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = endDate.ToString("dd MMMM, yyyy");


            //GetMonthList(ddlmonth);
            //GetYearList(ddlYear);
        }

        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _CommonDataLoad.GetDoctorType_Active())
            {
                DoctorTypeSelect.DataSource = dt;
                DoctorTypeSelect.DataValueField = "DoctorTypeId";
                DoctorTypeSelect.DataTextField = "DoctorTypeName";
                DoctorTypeSelect.DataBind();
                DoctorTypeSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                DoctorTypeSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        try
        {
            using (DataTable dt = _seedRepo.GetApprovalStatusList())
            {
                ddlApprovalStatus.DataSource = dt;
                ddlApprovalStatus.DataValueField = "SoftwareUseId";
                ddlApprovalStatus.DataTextField = "WebShow";
                ddlApprovalStatus.DataBind();
                ddlApprovalStatus.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlApprovalStatus.SelectedIndex = 0;
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
            using (DataTable dt = _seedRepo.GetProgramTypeListParam(" and GRP.IsDoctor=1"))
            {
                ddlProgramType.DataSource = dt;
                ddlProgramType.DataValueField = "ProgramTypeId";
                ddlProgramType.DataTextField = "ProgramTypeName";
                ddlProgramType.DataBind();
                ddlProgramType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlProgramType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


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




    }
        private void LoadData()
    {
        string Type = "";
        if (rbType.Items[0].Selected)
        {
            Type = "DCR";
        }
        else
        {
            Type = "RX";
        }

            data.InnerHtml = "";
        string aPP = "";

        if (ddlApprovalStatus.SelectedValue == "")
        {
            aPP = "Select";
        }
        else
        {
            aPP = ddlApprovalStatus.SelectedValue;
        }

        string ProviderType="";
        string PharmaPlatform = "";
        string Zone = "";
        string Area = "";
        string Teritory = "";
        string EmpID = "";
        string DCType = "";
        string Brand = "";

        if (F_ZoneSelect.SelectedValue != "")
        {
            Zone = F_ZoneSelect.SelectedValue;
        }




        if (F_AreaSelect.SelectedValue != "")
        {
            Area = F_AreaSelect.SelectedValue;
        }



        if (F_AreaSelect.SelectedValue != "")
        {
            Teritory = F_TeritorySelect.SelectedValue;
        }




        if (ddlProgramType.SelectedValue != "")
        {
            ProviderType = ddlProgramType.SelectedItem.Text;
        }

        if (ddlPharmaPlatform.SelectedValue != "")
        {
            PharmaPlatform = ddlPharmaPlatform.SelectedItem.Text;
        }


        if (ddlMIO.SelectedValue != "")
        {
            EmpID = ddlMIO.SelectedValue;
        }

        if (DoctorTypeSelect.SelectedValue != "")
        {
            DCType = DoctorTypeSelect.SelectedValue;
        }

        if (ddlBrand.SelectedValue != "")
        {
            Brand = ddlBrand.SelectedValue;
        }

        DataTable dtDate = _DAL.GetDynamicDateByDateRange(fromDateTextBox.Text, toDateTextBox.Text);


        if (rbReportTypeName.Items[0].Selected)
        {
             


            string mainDate = dtDate.Rows[0]["mainDate"].ToString();
            DataTable aDataTable = _DAL.GetCVRDoctorWiseDayList(mainDate, fromDateTextBox.Text, toDateTextBox.Text, aPP, ProviderType, PharmaPlatform, Zone, Area, Teritory);
            StringBuilder html = new StringBuilder();
            html.Append("<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead'>");
            html.Append("<thead><tr>");

            foreach (DataColumn column in aDataTable.Columns)
            {
                html.Append("<th>").Append(column.ColumnName).Append("</th>");
            }

            html.Append("</tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in aDataTable.Rows)
            {
                html.Append("<tr>");
                foreach (object cell in row.ItemArray)
                {
                    html.Append("<td>").Append(cell.ToString()).Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody>");
            html.Append("</table>");
            data.InnerHtml = html.ToString();

        }


        if (rbReportTypeName.Items[1].Selected)
        {


            if (ddlProgramType.SelectedValue != "")
            {
                ProviderType = ddlProgramType.SelectedValue;
            }

            if (ddlPharmaPlatform.SelectedValue != "")
            {
                PharmaPlatform = ddlPharmaPlatform.SelectedValue;
            }

             

            string mainDate = dtDate.Rows[0]["mainDate"].ToString();
            DataTable aDataTable = _DAL.GetDoctorBrandWiseList(mainDate, fromDateTextBox.Text, toDateTextBox.Text, aPP, ProviderType, PharmaPlatform, Zone, Area, Teritory);
            StringBuilder html = new StringBuilder();
            html.Append("<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead'>");
            html.Append("<thead><tr>");

            foreach (DataColumn column in aDataTable.Columns)
            {
                html.Append("<th>").Append(column.ColumnName).Append("</th>");
            }

            html.Append("</tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in aDataTable.Rows)
            {
                html.Append("<tr>");
                foreach (object cell in row.ItemArray)
                {
                    html.Append("<td>").Append(cell.ToString()).Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody>");
            html.Append("</table>");
            data.InnerHtml = html.ToString();
        }

        if (rbReportTypeName.Items[2].Selected)
        {
            if (ddlProgramType.SelectedValue != "")
            {
                ProviderType = ddlProgramType.SelectedValue;
            }

            if (ddlPharmaPlatform.SelectedValue != "")
            {
                PharmaPlatform = ddlPharmaPlatform.SelectedValue;
            }

           
            string mainDate = dtDate.Rows[0]["mainDate"].ToString();
            DataTable aDataTable = _DAL.GetDoctorProductWiseList(mainDate, fromDateTextBox.Text, toDateTextBox.Text, aPP, ProviderType, PharmaPlatform, Zone, Area, Teritory);
            StringBuilder html = new StringBuilder();
            html.Append("<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead'>");
            html.Append("<thead><tr>");

            foreach (DataColumn column in aDataTable.Columns)
            {
                html.Append("<th>").Append(column.ColumnName).Append("</th>");
            }

            html.Append("</tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in aDataTable.Rows)
            {
                html.Append("<tr>");
                foreach (object cell in row.ItemArray)
                {
                    html.Append("<td>").Append(cell.ToString()).Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody>");
            html.Append("</table>");
            data.InnerHtml = html.ToString();
        }



        if (rbReportTypeName.Items[3].Selected)
        {

            if (ddlProgramType.SelectedValue != "")
            {
                ProviderType = ddlProgramType.SelectedValue;
            }

            if (ddlPharmaPlatform.SelectedValue != "")
            {
                PharmaPlatform = ddlPharmaPlatform.SelectedValue;
            }

         

            string mainDate = dtDate.Rows[0]["mainDate"].ToString(); DataTable aDataTable = _DAL.GetDCRUserWiseList(mainDate, fromDateTextBox.Text, toDateTextBox.Text, aPP, ProviderType, PharmaPlatform, Zone, Area, Teritory);
            StringBuilder html = new StringBuilder();
            html.Append("<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead'>");
            html.Append("<thead><tr>");

            foreach (DataColumn column in aDataTable.Columns)
            {
                html.Append("<th>").Append(column.ColumnName).Append("</th>");
            }

            html.Append("</tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in aDataTable.Rows)
            {
                html.Append("<tr>");
                foreach (object cell in row.ItemArray)
                {
                    html.Append("<td>").Append(cell.ToString()).Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody>");
            html.Append("</table>");
            data.InnerHtml = html.ToString();
        }


        if (rbReportTypeName.Items[4].Selected)
        {

            

            string mainDate = dtDate.Rows[0]["mainDate"].ToString();
            DataTable aDataTable =new DataTable(); //_DAL.GetDCPDoctorWiseDayList(mainDate, ddlmonth.SelectedValue, ddlYear.SelectedItem.Text, aPP, ProviderType, PharmaPlatform);


            StringBuilder html = new StringBuilder();
            html.Append("<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead'>");
            html.Append("<thead><tr>");

            foreach (DataColumn column in aDataTable.Columns)
            {
                html.Append("<th>").Append(column.ColumnName).Append("</th>");
            }

            html.Append("</tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in aDataTable.Rows)
            {
                html.Append("<tr>");
                foreach (object cell in row.ItemArray)
                {
                    html.Append("<td>").Append(cell.ToString()).Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody>");
            html.Append("</table>");
            data.InnerHtml = html.ToString();

        }


        if (rbReportTypeName.Items[5].Selected)
        {



            string mainDate = dtDate.Rows[0]["mainDate"].ToString();
            DataTable aDataTable = _DAL.GetDynamicVisitStatusReport(mainDate, fromDateTextBox.Text, toDateTextBox.Text, aPP, ProviderType, PharmaPlatform, Zone, Area, Teritory, EmpID, DCType, Brand);

            StringBuilder html = new StringBuilder();
            html.Append("<table id='tblTable' style='height:200px;' class='table table-bordered text-center thead-dark table-hover table-striped tableFixHead'>");
            html.Append("<thead><tr>");

            foreach (DataColumn column in aDataTable.Columns)
            {
                html.Append("<th>").Append(column.ColumnName).Append("</th>");
            }

            html.Append("</tr></thead>");
            html.Append("<tbody>");

            foreach (DataRow row in aDataTable.Rows)
            {
                html.Append("<tr>");
                foreach (object cell in row.ItemArray)
                {
                    html.Append("<td>").Append(cell.ToString()).Append("</td>");
                }
                html.Append("</tr>");
            }

            html.Append("</tbody>");
            html.Append("</table>");
            data.InnerHtml = html.ToString();

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
        
        try
        {
            if (Validatea())
            {
                LoadData();
            }
            else
            {
                data.InnerHtml = "";
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
        }
        catch (Exception ex)
        { }

    }

    private bool Validatea()
    {

        bool cc = true;
        if (RoleTypeName == "AM")
        {
            if (F_AreaSelect.SelectedValue == "")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Please Select Area!" + "','Faild');", true); return cc = false;
            }


        }

        if (RoleTypeName == "DZSM")
        {
            if (F_ZoneSelect.SelectedValue == "")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Please Select Zone!" + "','Faild');", true);
                cc = false;
            }


        }

        return cc;
    }
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {

        //if (loadGridView.Rows.Count > 0)
        //{
        //    string Type = "";
        //    if (rbType.Items[0].Selected)
        //    {
        //        Type = "DCR";
        //    }
        //    else
        //    {
        //        Type = "RX";
        //    }

        //    string attachment = "attachment; filename="+ Type + "_Doctor_Wise_" + DateTime.Now.ToLongDateString()+".xls";
        //    Response.ClearContent();
        //    Response.AddHeader("content-disposition", attachment);
        //    Response.ContentType = "application/ms-excel";
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter htw = new HtmlTextWriter(sw);

        //    loadGridView.AllowPaging = false;



        //    //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
        //    //            false;
        //    //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
        //    //   false;
        //    //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
        //    //   false;

         
        //    // Create a form to contain the grid  
        //    HtmlForm frm = new HtmlForm();
        //    loadGridView.Parent.Controls.Add(frm);
        //    //frm.Attributes["runat"] = "server";
        //    //frm.Controls.Add(loadGridView);
        //    //frm.RenderControl(htw);

        //    loadGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

        //    // Set background color of each cell of GridView1 header row
        //    foreach (TableCell tableCell in loadGridView.HeaderRow.Cells)
        //    {
        //        tableCell.Style["background-color"] = "#E5EEF1";
        //    }

        //    // Set background color of each cell of each data row of GridView1
        //    foreach (GridViewRow gridViewRow in loadGridView.Rows)
        //    {
        //        gridViewRow.BackColor = System.Drawing.Color.White;

        //        foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
        //        {
        //            gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

        //        }
        //    }

        //    loadGridView.RenderControl(htw);
        //    string headerTable = @"<span  style='text-align:left'><h3> "+ Type + " Doctor Wise List of Month: " + ddlmonth.SelectedItem.Text +
        //                         ", Year: "+ddlYear.SelectedValue+"</h3>  ";



        //    HttpContext.Current.Response.Write(headerTable);

        //    string style = @"<style> .text { mso-number-format:\@; } </style> ";
        //    Response.Write(style);
        //    Response.Write(sw.ToString());
        //    Response.End();
        //}
        //else
        //{
        //    showMessageBox("No Data Found!!");
        //}
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

      

        if (EmployeeIdSelect.SelectedValue != "" ) {

            param = param + " AND mas.EmpInfoId='" + EmployeeIdSelect.SelectedValue + "'";

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
        //if (e.CommandName == "EditData")
        //{
        //    int rowindex = Convert.ToInt32(e.CommandArgument);
        //    string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

        //    Response.Redirect("../DoctorModule_UI/MileageClaim.aspx?id=" + unitPriceId);
        //}

    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("DcrDoctoriseMonthlypt.aspx");
    }

    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {
        //loadGridView.DataSource = null;
        //loadGridView.DataBind();
    }

    protected void rbReportTypeName_SelectedIndexChanged(object sender, EventArgs e)
    {
        loadGridView.DataSource = null;
        loadGridView.DataBind();
        data.InnerHtml = "";

        divBrand.Visible = false;
        divUser.Visible = false;
        divDCType.Visible = false;

        
    }
}