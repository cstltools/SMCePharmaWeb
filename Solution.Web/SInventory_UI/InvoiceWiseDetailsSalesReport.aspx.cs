using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_InvoiceWiseDetailsSalesReport : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
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
    }
    protected void OnRowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            if (e.Row.Cells[8].Text.Equals("0.00") && e.Row.Cells[9].Text.Equals("0.00") &&
             e.Row.Cells[10].Text.Equals("0.00"))
                e.Row.Visible = false;
        }

    }
    InvoicewisedetailssalesBLL aInvoicewisedetailssalesBll = new InvoicewisedetailssalesBLL();
    protected void SearchButton_Click(object sender, EventArgs e)
    {

       


        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
        {
            DataTable aDataTable = new DataTable();

            aDataTable = aInvoicewisedetailssalesBll.LoadSummaryProductcodewiseGyash(Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()),
                Convert.ToDateTime(todateTextBox.Text.Trim()), dcDropDownList1.SelectedValue);
            if (aDataTable.Rows.Count > 0)
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();



                //decimal total = aDataTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
                //loadGridView.FooterRow.Cells[1].Text = "Total";
                //loadGridView.FooterRow.Cells[1].HorizontalAlign = HorizontalAlign.Right;
                //loadGridView.FooterRow.Cells[2].Text = total.ToString();


                decimal total4 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("salesTP") == null ? 0 : row.Field<decimal>("salesTP"));

                loadGridView.FooterRow.Cells[10].Text = total4.ToString("N2");


                decimal total2 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesVat") == null ? 0 : row.Field<decimal>("SalesVat"));

                loadGridView.FooterRow.Cells[11].Text = total2.ToString("N2");


                decimal total3 = aDataTable.AsEnumerable().Sum(row => row.Field<decimal?>("SalesTotal") == null ? 0 : row.Field<decimal>("SalesTotal"));

                loadGridView.FooterRow.Cells[12].Text = total3.ToString("N2");

            }
            else
            {
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
        }













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

        //    string url = "../SInventory_RPTVIEW/InvoicewiseDetailssalesReport.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    int i = 1;
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string url = "../SInventory_RPTVIEW/InvoicewiseDetailssalesReport.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            dcDropDownList1.Enabled = false;
        }
        if (CheckBox1.Checked==false)
        {
            dcDropDownList1.Enabled = true;
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
        if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/ProformaReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {

        if (loadGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Invoice Wise Details Sales Report_" + DateTime.Now.ToString("dd_MM_yyyy") + ".xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);








            loadGridView.AllowPaging = false;
            //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "")
            //{
            //    DataTable aDataTable = new DataTable();

            //    aDataTable = aInvoicewisedetailssalesBll.LoadSummaryProductcodewiseGyash(Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()),
            //        Convert.ToDateTime(todateTextBox.Text.Trim()), dcDropDownList1.SelectedValue);
            //    if (aDataTable.Rows.Count > 0)
            //    {
            //        loadGridView.DataSource = aDataTable;
            //        loadGridView.DataBind();
            //    }
            //    else
            //    {
            //        loadGridView.DataSource = null;
            //        loadGridView.DataBind();
            //    }
            //}
            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            loadGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
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

            string SubTi = @"<span   style='text-align:center'>   <h3> Invoice Wise Details Sales Report List	</h3></span><span   style='text-align:center'>   <h6>  	Sales Center :" + dcDropDownList1.SelectedItem.Text + @"</h6></span><span   style='text-align:center'>   <h6>  	Invoice From Date: " + InvoiceDateTextBox.Text + @"</h6></span><span   style='text-align:center'>   <h6>  	Invoice To Date: " + todateTextBox.Text + @"</h6></span>";


            HttpContext.Current.Response.Write(SubTi);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
}