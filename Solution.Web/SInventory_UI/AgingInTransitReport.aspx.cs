using System;
using System.Collections.Generic;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_AgingInTransitReport : System.Web.UI.Page
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
        aOtherStockActionBLL.DCLoad(dcDropDownList2);
       // aOtherStockActionBLL.LoadSC(dcDropDownList1, Session["UserId"].ToString());


        OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
        aOrderInfoBll.LoadDZSM(dcDropDownList1, Session["UserId"].ToString());
    }
    TotalSummaryBLL aSummaryBll = new TotalSummaryBLL();

    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void SearchButton_Click(object sender, EventArgs e)
    {
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList2.SelectedValue != "")
        {

             DataTable aDataTable = new DataTable();

             aDataTable = aSummaryBll.LoadSummaryProductcodewiseGyashNew(Convert.ToInt32(dcDropDownList2.SelectedValue),Convert.ToDateTime(InvoiceDateTextBox.Text.Trim()), Convert.ToDateTime(todateTextBox.Text.Trim()));
            if (aDataTable.Rows.Count > 0)
            {
                loadGridView.DataSource = aDataTable;
                loadGridView.DataBind();
            }
            else
            {
                loadGridView.DataSource = null;
                loadGridView.DataBind();
            }
            //if (todateTextBox.Text == "")
            //{
            //    InvoiceDateTextBox.Text = todateTextBox.Text;
            //}

            //Session["Excel"] = "";
            //Session["Excel"] = "N";

            //string fromDate = InvoiceDateTextBox.Text;
            //string toDate = todateTextBox.Text;
            //string districtId = dcDropDownList2.SelectedValue;

            //string url = "../SInventory_RPTVIEW/AgingInTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            //// string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            //string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            //ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);


        }
        if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            Session["Excel"] = "";
            Session["Excel"] = "N";

            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/AgingInTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
       
    }
    protected void dcDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }
    protected void CheckBox1_CheckedChanged(object sender, EventArgs e)
    {
        if (CheckBox1.Checked)
        {
            dcDropDownList1.Enabled = false;
            dcDropDownList1.SelectedValue = string.Empty;
        }
        if (CheckBox1.Checked==false)
        {
            dcDropDownList1.Enabled = true;

        }
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" )
        {
            if (loadGridView.Rows.Count > 0)
            {
                string attachment = "attachment; filename=AgingInTransitReport.xls";
                Response.ClearContent();
                Response.AddHeader("content-disposition", attachment);
                Response.ContentType = "application/ms-excel";
                StringWriter sw = new StringWriter();
                HtmlTextWriter htw = new HtmlTextWriter(sw);

                loadGridView.AllowPaging = false;



                //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
                //            false;
                //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
                //   false;
                //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
                //   false;
 

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
                string headerTable = @"<span  style='text-align:left'><h4>From Date : " + InvoiceDateTextBox.Text + "</h4> <h4> To Date : " + todateTextBox.Text + "</h4>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("dd/MMMM/yyyy") + "</h4></span>";

                string SubTi = @"<span   style='text-align:center'>
   <h3>Aging wise receivable report 	</h3>

</span>";

                HttpContext.Current.Response.Write(headerTable);
                HttpContext.Current.Response.Write(SubTi);
                Response.Write(sw.ToString());
                Response.End();
            }
            else
            {
                showMessageBox("No Data Found!!");
            }
        }
        if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            Session["Excel"] = "";
            Session["Excel"] = "Y";

            int i = 1;
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string url = "../SInventory_RPTVIEW/AgingInTransitReportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&NationalReport=" + 1;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }  

    protected void loadGridView_OnRowCreated(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.Header)
        {
            GridView HeaderGrid = (GridView) sender;
            GridViewRow HeaderGridRow = new GridViewRow(0, 0, DataControlRowType.Header, DataControlRowState.Insert);

            TableCell HeaderCell = new TableCell();

            HeaderCell = new TableCell();
            HeaderCell.Text = " ";
            HeaderCell.BackColor = Color.FromName("#F5F5F5");
            HeaderCell.BorderColor = Color.FromName("#F5F5F5");

            HeaderCell.ColumnSpan = 17;
            HeaderGridRow.Cells.Add(HeaderCell);

            //HeaderCell = new TableCell();
            //HeaderCell.Text = " ";
            //HeaderCell.BackColor = Color.FromName("#F5F5F5");
            //HeaderCell.BorderColor = Color.FromName("#F5F5F5");


            //HeaderCell.ColumnSpan = 1;

            //HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "1-10";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.LawnGreen;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "11-20";
            HeaderCell.ColumnSpan = 3;
            HeaderCell.BackColor = Color.LightBlue;
            HeaderGridRow.Cells.Add(HeaderCell);

            HeaderCell = new TableCell();
            HeaderCell.Text = "21-30";
            HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);



            HeaderCell = new TableCell();
            HeaderCell.Text = "31-40";
            HeaderCell.BackColor = Color.LawnGreen;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "41-50";

            HeaderCell.BackColor = Color.LightBlue;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);


            HeaderCell = new TableCell();
            HeaderCell.Text = "51+";
            HeaderCell.BackColor = Color.GreenYellow;
            HeaderCell.ColumnSpan = 3;
            HeaderGridRow.Cells.Add(HeaderCell);

          

            loadGridView.Controls[0].Controls.AddAt(0, HeaderGridRow);
        }
    }
}