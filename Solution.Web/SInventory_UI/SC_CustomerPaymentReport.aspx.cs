using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using ClosedXML.Excel;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_SC_CustomerPaymentReport : System.Web.UI.Page
{
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {

            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            todateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            LoadDropDown();


            if (Session["RoleTypeId"].ToString() == "3" || Session["RoleTypeId"].ToString() == "2")
            {
                SalesCenter.Visible = false;
            }
            else
            {
                SalesCenter.Visible = true;
            }

        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);

        try
        {
            using (DataTable dt = _seedRepo.GetProgramTypeListAll())
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
            using (DataTable dt = _seedRepo.GetChemistTypeListALL())
            {
                ddlChemisType.DataSource = dt;
                ddlChemisType.DataValueField = "CustomerTypeId";
                ddlChemisType.DataTextField = "CustomerType";
                ddlChemisType.DataBind();
                ddlChemisType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlChemisType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("SC_PaymentReport.aspx");
    }

    private void LoadData()
    {


        comUnitDetailDataTable = _DAL.GetSC_CustomerFinalPaymentReportDAL_new(Parm(), Parm_2(), OldNewParm());
        //comUnitDetailDataTable = _DAL.GetSC_CustomerFinalPaymentReportDAL(Parm(), Parm_2());


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = comUnitDetailDataTable;
            loadGridView.DataBind();

            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalPay") == null ? 0 : row.Field<decimal>("TotalPay"));

            lblCount.Text = "Total Pay Amount (TP+Vat) : " + total2.ToString("N2");
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
            lblCount.Text = "Total Pay Amount (TP+Vat) : " + 0.ToString("N2");

        }


    }

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(InvoiceDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }


    DataTable comUnitDetailDataTable = new DataTable();
    protected void SearchButton_Click(object sender, EventArgs e)
    {



        LoadData();


        //Session["ProformaReport"] = "";
        //Session["ProformaReport"] = 0;

        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        //{
        //    if (todateTextBox.Text == "")
        //    {
        //        InvoiceDateTextBox.Text = todateTextBox.Text;
        //    }

        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string districtId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
    }



    private string OldNewParm()
    {

        string param = "";

        if (dcDropDownList1.SelectedValue != "")
        {
            param = param + " AND I.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        return param;
    }

        private string Parm()
    {
        
        string param = "";
       
       

       

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,custDtl.CustPaymentDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }


        if (ddlPaymentBy.SelectedValue != "")
        {
            param = param + " AND custDtl.CollectionBy='" + ddlPaymentBy.SelectedValue + "' ";
        }


        return param;
    }

     
private string Parm_2()
{
    var sb = new StringBuilder();

    // ----- independent filters (always apply if present) -----
    AppendEq(sb, "CU.ComUnitId", (dcDropDownList1 != null) ? dcDropDownList1.SelectedValue : null);
    AppendEq(sb, "mas.ProgramTypeId", (ddlProgramType != null) ? ddlProgramType.SelectedValue : null);
    AppendEq(sb, "mas.CusttypeId", (ddlChemisType != null) ? ddlChemisType.SelectedValue : null);

    // ----- hierarchical: Market > SubTerritory > Territory > Area > Region > Group -----
    int? market = ToInt((MarketSelect != null) ? MarketSelect.SelectedValue : null);
    int? subTer = ToInt((SubTeritory != null) ? SubTeritory.SelectedValue : null);
    int? ter = ToInt((TeritorySelect != null) ? TeritorySelect.SelectedValue : null);
    int? area = ToInt((AreaSelect != null) ? AreaSelect.SelectedValue : null);
    int? region = ToInt((ZoneSelect != null) ? ZoneSelect.SelectedValue : null);
    int? group = ToInt((GroupSelect != null) ? GroupSelect.SelectedValue : null);

    if (market.HasValue)
        sb.Append(" AND mas.MarketId = ").Append(market.Value);
    else if (subTer.HasValue)
        sb.Append(" AND mas.SubTerritoryId = ").Append(subTer.Value);
    else if (ter.HasValue)
        sb.Append(" AND mas.TerritoryId = ").Append(ter.Value);
    else if (area.HasValue)
        sb.Append(" AND mas.AreaId = ").Append(area.Value);
    else if (region.HasValue)
        sb.Append(" AND mas.RegionId = ").Append(region.Value);
    else if (group.HasValue)
        sb.Append(" AND mas.GroupId = ").Append(group.Value);

    return sb.ToString();
}

private static int? ToInt(string s)
{
    if (string.IsNullOrEmpty(s)) return null;
    int v;
    return int.TryParse(s, out v) ? (int?)v : null;
}

private static void AppendEq(StringBuilder sb, string column, string selectedValue)
{
    int? v = ToInt(selectedValue);
    if (v.HasValue)
    {
        sb.Append(" AND ").Append(column).Append(" = ").Append(v.Value);
    }
}

protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
      
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        Stopwatch stopwatch = new Stopwatch(); // Create a Stopwatch instance
        stopwatch.Start(); // Start measuring time

        if (loadGridView.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Customer_Payment_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;

            // To Export all pages.
            loadGridView.AllowPaging = false;
            this.LoadData();

            StringBuilder sb = new StringBuilder();

            // Append header row
            foreach (TableCell cell in loadGridView.HeaderRow.Cells)
            {
                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
            }
            sb.Append("\r\n");

            // Append data rows
            foreach (GridViewRow row in loadGridView.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    if (cell.Text.Contains(","))
                    {
                        sb.Append(String.Format("\"{0}\",", cell.Text));
                    }
                    else
                    {
                        sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
                    }
                }
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

        stopwatch.Stop(); // Stop measuring time

        // Log or display the execution time
        TimeSpan elapsedTime = stopwatch.Elapsed;
        string executionTimeMessage = "Execution Time: {elapsedTime.TotalMilliseconds} ms";
        // You can log this message or display it as needed
        System.Diagnostics.Debug.WriteLine(executionTimeMessage); // Example: Write to Debug output
    }
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
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

   
    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        Session["ProformaReport"] = "";
        Session["ProformaReport"] = 1;

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        {
            if (todateTextBox.Text == "")
            {
                InvoiceDateTextBox.Text = todateTextBox.Text;
            }

            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string districtId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
    }
}