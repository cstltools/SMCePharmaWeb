using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using OfficeOpenXml;
using System.IO;
using ClosedXML.Excel;
using System.Text;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_LoadingReport : System.Web.UI.Page
{
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        
        if (!IsPostBack)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            todateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            LoadDropDown();
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
        try
        {
            OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
            aOtherStockActionBLL.DCLoad(dcDropDownList1);
        }
        catch { }
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("LoadingReport.aspx");
    }
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        LoadData();
         
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {

        rootDropDownList.Items.Clear();
        ddlTerritory.Items.Clear();
        try
        {

            aOrderInfoBll.LoadDisRouteforInvoice(rootDropDownList, Convert.ToInt32(dcDropDownList1.SelectedValue));
            using (DataTable dt = _seedRepo.GetTerriToryByDCId(dcDropDownList1.SelectedValue))
            {
                ddlTerritory.DataSource = dt;
                ddlTerritory.DataValueField = "TerritoryId";
                ddlTerritory.DataTextField = "TerritoryName";
                ddlTerritory.DataBind();

                ddlTerritory.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlTerritory.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

    }
    private void LoadData()
    {
        if(dcDropDownList1.SelectedValue != "")
        {
            Session["prmReport"] = "";
            Session["prmReport"] = Parm();




            string url = "../SInventory_RPTVIEW/LoadingReportViewer.aspx?fromDate=" + InvoiceDateTextBox.Text + " - " + todateTextBox.Text;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select Sales Center!" + "','Faild');", true);
        }

       
        

        //DataTable dt = new DataTable();


        //dt = _DAL.GetLoadingReportDAL(Parm());


        //if (dt.Rows.Count > 0)
        //{
        //    loadGridView.DataSource = dt;
        //    loadGridView.DataBind();

        //    //decimal total2 = dt.AsEnumerable().Sum(row => row.Field<decimal?>("TotalNetPayable") == null ? 0 : row.Field<decimal>("TotalNetPayable"));

        //    //lblCount.Text = "Total Net Amount : " +   total2.ToString("N2");

        //}
        //else
        //{
        //    loadGridView.DataSource = null;
        //    loadGridView.DataBind();
        //    lblCount.Text = "Total Net Amount : " + 0.ToString("N2");

        //}
    }

    private string Parm()
    {
        
        string param = "";
        
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }


        if (ddlTerritory.SelectedValue != "")
        {
            param = param + " AND mas.TerritoryId='" + ddlTerritory.SelectedValue + "' ";
        }

        if (rootDropDownList.SelectedValue != "")
        {
            param = param + " AND  mas.DistributionRouteId='" + rootDropDownList.SelectedValue + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.InvoiceDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


        

        return param;
    }
    
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
         
    }


    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {




            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Loading_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            loadGridView.AllowPaging = false;
            this.LoadData();

            StringBuilder sb = new StringBuilder();

            sb.Append(string.Format("{0},{1},{2},{3}, {4},{5},{6},{7}", " ", " ", " ", " SMC ENTERPRISE LIMITED ", " ", " ", " ", " ") + Environment.NewLine);
            sb.Append(string.Format("{0},{1},{2},{3}, {4},{5},{6},{7}", " ", " ", "DEPOT Name: ", " Title2 ", " ", " ", " ", " ") + Environment.NewLine);

            sb.Append(string.Format("{0},{1},{2},{3}, {4},{5},{6},{7}", "Date", "Name", " ", " ", " ", " ", "Date", "Name") + Environment.NewLine);
            sb.Append(string.Format("{0},{1}", "Delivery Person:", "Name" ) + Environment.NewLine);
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

        //if (loadGridView.Rows.Count > 0)
        //{
        //    DataTable dt = new DataTable("GridView_Data");
        //    foreach (TableCell cell in loadGridView.HeaderRow.Cells)
        //    {
        //        dt.Columns.Add(cell.Text);
        //    }
        //    loadGridView.AllowPaging = false;
        //    this.LoadData();
        //    foreach (GridViewRow row in loadGridView.Rows)
        //    {
        //        dt.Rows.Add();
        //        for (int i = 0; i < row.Cells.Count; i++)
        //        {
        //            if (row.Cells[i].Controls.Count > 0)
        //            {
        //                dt.Rows[dt.Rows.Count - 1][i] = (row.Cells[i].Controls[1] as Label).Text;
        //            }
        //            else
        //            {
        //                dt.Rows[dt.Rows.Count - 1][i] = row.Cells[i].Text;
        //            }
        //        }
        //    }
        //    loadGridView.AllowPaging = false;
        //    using (XLWorkbook wb = new XLWorkbook())
        //    {
        //        wb.Worksheets.Add(dt);
        //        Response.Clear();
        //        Response.Buffer = true;
        //        Response.Charset = "";
        //        Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        //        Response.AddHeader("content-disposition", "attachment;filename=Invoice_Report_List (Date Range= " + InvoiceDateTextBox.Text + "-" + todateTextBox.Text + ").xlsx");
        //        using (MemoryStream MyMemoryStream = new MemoryStream())
        //        {
        //            wb.SaveAs(MyMemoryStream);
        //            MyMemoryStream.WriteTo(Response.OutputStream);
        //            Response.Flush();
        //            Response.End();
        //        }
        //    }
        //}

        //if (loadGridView.Rows.Count > 0)
        //{


        //    Response.ClearContent();
        //    Response.Buffer = true;
        //    Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "Invoice_Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls"));
        //    Response.ContentType = "application/ms-excel";
        //    StringWriter sw = new StringWriter();
        //    HtmlTextWriter htw = new HtmlTextWriter(sw);
        //    loadGridView.AllowPaging = false;

        //    this.LoadData();
        //    //Change the Header Row back to white color
        //    loadGridView.HeaderRow.Style.Add("background-color", "#FFFFFF");
        //    //Applying stlye to gridview header cells
        //    //for (int i = 0; i < loadGridView.HeaderRow.Cells.Count; i++)
        //    //{
        //    //    loadGridView.HeaderRow.Cells[i].Style.Add("background-color", "#8BA8E0");
        //    //}
        //    //int j = 1;
        //    ////This loop is used to apply stlye to cells based on particular row
        //    //foreach (GridViewRow gvrow in loadGridView.Rows)
        //    //{
        //    //    gvrow.BackColor = Color.White;
        //    //    if (j <= loadGridView.Rows.Count)
        //    //    {
        //    //        if (j % 2 != 0)
        //    //        {
        //    //            for (int k = 0; k < gvrow.Cells.Count; k++)
        //    //            {
        //    //                gvrow.Cells[k].Style.Add("background-color", "#EFF3FB");
        //    //            }
        //    //        }
        //    //    }
        //    //    j++;
        //    //}

        //    string headerTable = @"<span  style='text-align:center'><h3>  Invoice Report   (Date Range : " + InvoiceDateTextBox.Text + "- " + todateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

        //    HttpContext.Current.Response.Write(headerTable);

        //    loadGridView.RenderControl(htw);
        //    Response.Write(sw.ToString());
        //    Response.End();
        //}
        //else
        //{
        //    showMessageBox("No Data Found!!");
        //}
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

    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
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

    protected void fromDateTextBox_TextChanged(object sender, EventArgs e)
    {
        DateTime Fromd = Convert.ToDateTime("01-Apr-2022");
        DateTime inputDateTime = Convert.ToDateTime(InvoiceDateTextBox.Text);
        if (inputDateTime < Fromd)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("01 April, 2022");
        }
    }
}