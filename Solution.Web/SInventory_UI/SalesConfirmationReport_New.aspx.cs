using ClosedXML.Excel;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_SalesConfirmationReport_New : System.Web.UI.Page
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
        Response.Redirect("DeliveryPaymentReport.aspx");
    }

    private void LoadData()
    {


        DataTable dt = new DataTable();


        dt = _DAL_GetSalesConfirmationDAL();

        if (dt != null && dt.Rows.Count > 0)
        {
            // Cache এ রাখুন (Absolute Expiration = 10 মিনিট)
            Cache.Insert(GetCacheKey(), dt, null,
                DateTime.Now.AddMinutes(10),
                System.Web.Caching.Cache.NoSlidingExpiration);
        }


        if (dt != null && dt.Rows.Count > 0)
        {
           

       
            loadGridView.DataSource = dt;
            loadGridView.DataBind();

            decimal total2 = dt.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

            lblCount.Text = "Total Net Amount : " + total2.ToString("N2");
            
            
            decimal GrossValue = dt.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));

            lblTP.Text = "Total TP : " + GrossValue.ToString("N2");
            
            decimal TotalVat = dt.AsEnumerable().Sum(row => row.Field<decimal?>("TotalVat") == null ? 0 : row.Field<decimal>("TotalVat"));

            lblVat.Text = "Total Vat : " + TotalVat.ToString("N2");
            
            decimal TotalDiscount = dt.AsEnumerable().Sum(row => row.Field<decimal?>("TotalDiscount") == null ? 0 : row.Field<decimal>("TotalDiscount"));

            lblDiscount.Text = "Total Discount : " + TotalDiscount.ToString("N2");
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
            lblCount.Text = "Total Net Amount : " + 0.ToString("N2");

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
    protected void SearchButton_Click(object sender, EventArgs e)
    {

        LoadData();

         
    }

    private string Parm()
    {
        
        string param = "";
       
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }
       

       

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.UpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        return param;
    }


    private string Parm_2()
    {

        string param = "";

        

        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND mas.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND mas.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND mas.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            param = param + " AND mas.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND mas.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND mas.MarketId='" + MarketSelect.SelectedValue + "' ";
        }


        if (ddlProgramType.SelectedValue != "")
        {
            param = param + " AND mas.ProgramTypeId='" + ddlProgramType.SelectedValue + "' ";
        }


        if (ddlChemisType.SelectedValue != "")
        {
            param = param + " AND mas.CustTypeId='" + ddlChemisType.SelectedValue + "' ";
        }


        return param;
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
      
    }
    // === Wrapper for DAL ===
    private DataTable _DAL_GetSalesConfirmationDAL()
    {
        try
        {
            return _DAL.GetSalesConfirmationReport_newDAL(Parm(), Parm_2());
        }
        catch
        {
            return new DataTable();
        }
    }
    private string GetCacheKey()
    {
        // আপনার system অনুযায়ী userId নিন
        string userId = Session["UserId"].ToString(); // অথবা Session["UserID"].ToString()
        return "SalesConfirmationData_" + userId;
    }
    protected void btnExport_Click(object sender, EventArgs e)
    {

        DataTable src = Cache[GetCacheKey()] as DataTable;
        if (src == null || src.Rows.Count == 0)
        {
            src = _DAL_GetSalesConfirmationDAL();
            if (src != null && src.Rows.Count > 0)
            {
                Cache.Insert(GetCacheKey(), src, null,
                    DateTime.Now.AddMinutes(10),
                    System.Web.Caching.Cache.NoSlidingExpiration);
            }
        }
        if (src == null || src.Rows.Count == 0)
        {
            // সতর্কতা: এটা CSV লেখার আগেই হবে; CSV লেখার পরে আর কোনো UI কাজ করবেন না
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup",
                "faildalert('No Data Found!','Failed');", true);
            return;
        }

        var dtExport = BuildExportTable(src);
        WriteCsvAndEnd(dtExport, "Delivery_Payment_Report_" + DateTime.Now.ToString("yyyyMMdd_HHmmss") + ".csv");
        return; // ⚠️ খুব জরুরি — আর কিছু চালাবেন না

        
    }

    private static string CsvEscape(string s)
    {
        if (string.IsNullOrEmpty(s)) return "";
        s = s.Replace("\"", "\"\"");
        bool mustQuote = s.IndexOfAny(new[] { ',', '"', '\n', '\r' }) >= 0;
        return mustQuote ? "\"" + s + "\"" : s;
    }

    private static void WriteCsvAndEnd(DataTable dt, string fileName)
    {
        var resp = HttpContext.Current.Response;
        resp.Clear();
        resp.ClearHeaders();
        resp.Buffer = true;
        resp.ContentType = "text/csv";
        resp.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
        resp.Cache.SetCacheability(HttpCacheability.NoCache);

        var utf8BOM = new UTF8Encoding(true);
        var sb = new StringBuilder();

        // header
        for (int i = 0; i < dt.Columns.Count; i++)
        {
            if (i > 0) sb.Append(',');
            sb.Append(CsvEscape(dt.Columns[i].ColumnName));
        }
        sb.Append("\r\n");

        // rows
        foreach (DataRow r in dt.Rows)
        {
            for (int i = 0; i < dt.Columns.Count; i++)
            {
                if (i > 0) sb.Append(',');
                var cell = r[i] == null ? "" : Convert.ToString(r[i]);
                sb.Append(CsvEscape(cell));
            }
            sb.Append("\r\n");
        }

        byte[] bytes = utf8BOM.GetBytes(sb.ToString());
        resp.BinaryWrite(bytes);

        // 👉 এই ৩টা লাইন HTML/Script অ্যাপেন্ড হওয়া ঠেকায়
        resp.Flush();
        resp.SuppressContent = true;
        HttpContext.Current.ApplicationInstance.CompleteRequest();
    }
    // === BuildExportTable (projection + formatting) ===
    public DataTable BuildExportTable(DataTable src)
    {
        DataTable dtExport = new DataTable("Full_Payment");

        for (int i = 0; i < ExportColumns.Length; i++)
            dtExport.Columns.Add(ExportColumns[i].Item2, typeof(string));

        foreach (DataRow r in src.Rows)
        {
            DataRow n = dtExport.NewRow();
            for (int i = 0; i < ExportColumns.Length; i++)
            {
                string dataField = ExportColumns[i].Item1;
                object val = src.Columns.Contains(dataField) ? r[dataField] : null;
                string s = "";

                if (val != null && val != DBNull.Value)
                {
                      if (dataField == "GrossValue" || dataField == "TotalVat" ||
                             dataField == "TotalDiscount" || dataField == "AdjustmentAmount" ||
                             dataField == "TotalNetPayable")
                    {
                        decimal dec;
                        if (decimal.TryParse(Convert.ToString(val, CultureInfo.InvariantCulture),
                            NumberStyles.Any, CultureInfo.InvariantCulture, out dec))
                            s = dec.ToString("0.00", CultureInfo.InvariantCulture);
                        else
                            s = Convert.ToString(val);
                    }
                    else
                    {
                        s = Convert.ToString(val);
                    }
                }

                n[i] = s;
            }
            dtExport.Rows.Add(n);
        }

        return dtExport;
    }
    // DataField -> HeaderText (GridView-এর মতো)
    static readonly Tuple<string, string>[] ExportColumns = new Tuple<string, string>[] {
    Tuple.Create("ComUnitCode", "Sales Center "),
    Tuple.Create("ComUnitName", "Sales Center Name"),
    Tuple.Create("CustomerCode", "Customer ID"),
    Tuple.Create("CustomerName", "Customer Name"),
    Tuple.Create("Type", "Provider Type"),
    Tuple.Create("SMCType_Ord", "Pharma Platform"),
    Tuple.Create("NewType", "Customer Type"),
    Tuple.Create("OrderNo", "Order Code"),
    Tuple.Create("OrderDate", "Order / Submission Date"),
    Tuple.Create("InvoiceNo", "Invoice Number"),
    Tuple.Create("InvoiceDate", "Invoice Date"),
    Tuple.Create("DelivaryInvoiceNo", "Confirmation Number"),
    Tuple.Create("UpdateDate", "Confirmation Date"),
    Tuple.Create("ProductCode", "Product Code"),
    Tuple.Create("ProductName", "Product Name"),
    Tuple.Create("PackSize", "Pack Size"),
    Tuple.Create("BatchNo", "Batch No"),
    Tuple.Create("ExpDate", "Exp Date"),
    Tuple.Create("soldQty", "Sold Qty"),
    Tuple.Create("GrossValue", "TP"),
    Tuple.Create("TotalVat", "VAT"),
    Tuple.Create("TotalDiscount", "Discount"),
    Tuple.Create("AdjustmentAmount", "Exp. Adjustment"),
    Tuple.Create("TotalNetPayable", " Net Payment"),
    Tuple.Create("MarketCode", "Market Code"),
    Tuple.Create("MarketName", "Market Name"),
    Tuple.Create("TerritoryCode", "Territory Code"),
    Tuple.Create("MIOEmpCode", "MIO  Emp Code"),
    Tuple.Create("MIOEmpName", "MIO Emp Name"),
    Tuple.Create("AMEmpCode", "AM Emp Code"),
    Tuple.Create("AMEmpName", "AM Emp Name"),
    Tuple.Create("RegionName", "Zone Code"),
    Tuple.Create("AreaName", "Area Code"),
    Tuple.Create("Brand", "Brand"),
    Tuple.Create("ProductOffer", "Campaign Name"),
    Tuple.Create("CampaignCategory", "Campaign Category"),
    Tuple.Create("paymenttype", "Payment Type"),
};

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