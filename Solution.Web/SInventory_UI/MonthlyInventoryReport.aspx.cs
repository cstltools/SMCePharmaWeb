using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_MonthlyInventoryReport : System.Web.UI.Page
{
    ProductBLL aProductBLL = new ProductBLL();
    InvoiceDAL aInvoiceDal = new InvoiceDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            InvoiceDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            todateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");

            aProductBLL.LoadProductType_new(ddlProTypeNew);
            LoadDropDown();
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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=" + "Monthly_Inventory_Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            loadGridView.AllowPaging = false;




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


            string headerTable = @"<span  style='text-align:center'><h3>" + " Monthly Inventory Report  (Date Range : " + InvoiceDateTextBox.Text + "- " + todateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";

            HttpContext.Current.Response.Write(headerTable);

            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        }

        //if (loadGridView.Rows.Count > 0)
        //{
        //    string attachment = "attachment; filename= Receivable Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls";
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
        //    string headerTable = @"<span  style='text-align:center'><h3> Receivable Report List (Date Range : "+InvoiceDateTextBox.Text+ "- " + todateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";



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
    public override void VerifyRenderingInServerForm(System.Web.UI.Control control)
    {
        //confirms that an HtmlForm control is rendered for the
        //specified ASP.NET server control at run time.
    }
   
    public void LoadDropDown()
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
       // aOtherStockActionBLL.DCLoad(dcDropDownList1);
        aOtherStockActionBLL.LoadSC(dcDropDownList1, Session["UserId"].ToString());
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
            param = param + " AND CONVERT(date,I.LoadingSummaryUpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.LoadingSummaryUpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,I.LoadingSummaryUpdateDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }


        

        return param;
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    private void LoadData()
    {
        DataTable aDataTable = new DataTable();
         
            aDataTable = aInvoiceDal.GetMonthlyInventoryReportDAl(dcDropDownList1.SelectedValue, InvoiceDateTextBox.Text ,  todateTextBox.Text, ddlProTypeNew.SelectedValue);
        
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();


        //if (aDataTable.Rows.Count > 0)
        //{
        //    decimal NetAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("NetAmount") == null ? 0 : row.Field<decimal>("NetAmount"));


        //    decimal TotalPriceVatAmount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TotalPriceVatAmount") == null ? 0 : row.Field<decimal>("TotalPriceVatAmount"));



        //    decimal TradeDiscount = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("TradeDiscount") == null ? 0 : row.Field<decimal>("TradeDiscount"));
        //    loadGridView.FooterRow.Font.Bold = true;
        //    loadGridView.FooterRow.Cells[12].Text = "Total: ";
        //    loadGridView.FooterRow.Cells[13].Text = NetAmount.ToString();
        //    loadGridView.FooterRow.Cells[14].Text = TotalPriceVatAmount.ToString();

        //    loadGridView.FooterRow.Cells[15].Text = TradeDiscount.ToString();
        //}

    }

    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView)sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = "";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 5;
            HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            //HeaderCell.ColumnSpan = 1;

            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "Receive";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.DeepSkyBlue;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "Issue";
            HeaderCell.ColumnSpan = 4;
            HeaderCell.BackColor = Color.DarkSeaGreen;
            HeaderGridRow.Cells.Add(HeaderCell);




            //HeaderCell = new TableCell();
            //HeaderCell.Text = "Other";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            //HeaderCell.ColumnSpan = 3;
            //HeaderGridRow.Cells.Add(HeaderCell);


            loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);

        }
    }

    protected void SearchButton_Click(object sender, EventArgs e)
    {
        LoadData();

        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        //{
        //    if (todateTextBox.Text == "")
        //    {
        //        InvoiceDateTextBox.Text = todateTextBox.Text;
        //    }

        //    Session["Excel"] = "";
        //    Session["Excel"] = "N";

        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string districtId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    Session["Excel"] = "";
        //    Session["Excel"] = "N";

        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}

    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
   
    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        {
            if (todateTextBox.Text == "")
            {
                InvoiceDateTextBox.Text = todateTextBox.Text;
            }

            Session["Excel"] = "";
            Session["Excel"] = "Y";

            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string districtId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (  dcDropDownList1.SelectedValue == "" && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            Session["Excel"] = "";
            Session["Excel"] = "Y";

            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/InTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("InTransitReport.aspx");
    }
}