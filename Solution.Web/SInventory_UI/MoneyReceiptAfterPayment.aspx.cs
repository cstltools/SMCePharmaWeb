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

public partial class SInventory_UI_MoneyReceiptAfterPayment : System.Web.UI.Page
{
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();
    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
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
        dcDropDownList1.SelectedIndex = 1;
        dcDropDownList1_SelectedIndexChanged(null, null);
    }
    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProformaReport.aspx");
    }
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

    private void LoadData()
    {
        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetMoneyReceiptAfterPaymentDAL(Parm());
        lblCount.Text = "Total Payment Amount : 0";
        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = comUnitDetailDataTable;
            loadGridView.DataBind();


            decimal total2 = comUnitDetailDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("PaymentAmount") == null ? 0 : row.Field<decimal>("PaymentAmount"));

           lblCount.Text = "Total Payment Amount :"+ total2.ToString("N2");

        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
    }

    private string Parm()
    {
        
        string param = "";
        
        if (dcDropDownList1.SelectedValue != "")
        {
            param = param + " AND INV.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
        }


        if (rootDropDownList.SelectedValue != "")
        {
            param = param + " and ord.DistributionRouteId='" + rootDropDownList.SelectedValue + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            param = param + " AND CONVERT(date,custPay.custPaymentDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + todateTextBox.Text + "' ";
        }

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text == "")
        {
            param = param + " AND CONVERT(date,custPay.custPaymentDate)  BETWEEN '" + InvoiceDateTextBox.Text + "' AND '" + DateTime.Now + "' ";
        }



        if (GroupSelect.SelectedValue != "")
        {
            param = param + " AND ord.GroupId='" + GroupSelect.SelectedValue + "' ";
        }

        if (ZoneSelect.SelectedValue != "")
        {
            param = param + " AND ord.RegionId='" + ZoneSelect.SelectedValue + "' ";
        }

        if (AreaSelect.SelectedValue != "")
        {
            param = param + " AND ord.AreaId='" + AreaSelect.SelectedValue + "' ";
        }

        if (TeritorySelect.SelectedValue != "")
        {
            param = param + " AND ord.TerritoryId='" + TeritorySelect.SelectedValue + "' ";
        }

        if (SubTeritory.SelectedValue != "")
        {
            param = param + " AND ord.SubTerritoryId='" + SubTeritory.SelectedValue + "' ";
        }

        if (MarketSelect.SelectedValue != "")
        {
            param = param + " AND ord.MarketId='" + MarketSelect.SelectedValue + "' ";
        }


        return param;
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        aOrderInfoBll.LoadDisRouteforInvoice(rootDropDownList, Convert.ToInt32(dcDropDownList1.SelectedValue));

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
            Response.AddHeader("content-disposition", "attachment;filename=MoneyReceipt_Report_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            loadGridView.AllowPaging = false;
            this.LoadData();

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
                    sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
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
        
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
       
        if (e.CommandName == "reportData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            var I = (loadGridView.DataKeys[rowindex][0].ToString());
            var hiddenField = (HiddenField)loadGridView.Rows[rowindex].Cells[0].FindControl("hfCustPayDetailId");
            string param = "";
            param = " AND custPay.CustPayDetailId IN (" + hiddenField.Value + ")";

            Session["InvoiceIds"] = "";
            Session["InvoiceIds"] = param;

            string url = "../SInventory_RPTVIEW/MoneyReceiptViewerForAfterPaymentr.aspx";
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" +
                             url +
                             "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
            }
            else
            {
                ChkBoxRows.Checked = false;
            }
        }
    }

    protected void btnPrint_Click(object sender, EventArgs e)
    {

        Session["InvoiceIds"] = "";
        string invoiceIds = GenerateParameter();
        if (string.IsNullOrEmpty(invoiceIds))
        {
            // Display a validation message or handle the case where no invoice IDs are available
           
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please select at least one invoice." + "','Faild');", true);

            return; // Exit the method if validation fails
        }

        // Set the session variable with the validated invoice IDs
        Session["InvoiceIds"] = invoiceIds;
         

        string url = "../SInventory_RPTVIEW/MoneyReceiptViewerForAfterPayment.aspx";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" +
                         url +
                         "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);

        
    }

    private string GenerateParameter()
    {
        string param = " AND custPay.CustPayDetailId IN (";

        int ccc = 0;
        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            var hiddenField = (HiddenField)loadGridView.Rows[i].Cells[0].FindControl("hfCustPayDetailId");

            if (chkBoxRows.Checked)
            {
                ccc++;
                if (dcDropDownList1.SelectedValue != "")
                {
                    //param = param + Convert.ToInt32(loadGridView.DataKeys[i][0].ToString()) + ",";
                    param = param + Convert.ToInt32(hiddenField.Value) + ",";
                }
            }
        }


        if (param == " AND custPay.CustPayDetailId IN (")
        {
            param = "";
        }
        else
        {
            param = param.Remove(param.Length - 1, 1) + ")";
        }

        //string cccc = ccc.ToString();
        return param + Parm();

    }
}