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

public partial class SInventory_UI_AllSalesReport : System.Web.UI.Page
{
    private static CmnCrystaltoView _DAL = new CmnCrystaltoView();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            try
            {
                LoadDropDown();
            }
            catch (Exception)
            {
                
                //throw;
            }
        }
    }

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ProformaReport.aspx");
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
    protected void SearchButton_Click(object sender, EventArgs e)
    {



        DataTable comUnitDetailDataTable = new DataTable();


        comUnitDetailDataTable = _DAL.GetAllSalesListDAL(Parm());


        if (comUnitDetailDataTable.Rows.Count > 0)
        {
            loadGridView.DataSource = comUnitDetailDataTable;
            loadGridView.DataBind();
        }
        else
        {
            loadGridView.DataSource = null;
            loadGridView.DataBind();
        }
        //Session["SalesReport"] = "";
        //Session["SalesReport"] = 0;

        //if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        //{
        //    if (todateTextBox.Text == "")
        //    {
        //        InvoiceDateTextBox.Text = todateTextBox.Text;
        //    }

        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    string districtId = dcDropDownList1.SelectedValue;

        //    string url = "../SInventory_RPTVIEW/AllSalesreportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
        //    // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        //    string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        //    ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        //}
        //if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        //{
        //    string fromDate = InvoiceDateTextBox.Text;
        //    string toDate = todateTextBox.Text;
        //    int i = 1;
        //    string url = "../SInventory_RPTVIEW/AllSalesreportViewer.aspx?NationalReport=" + 1 + "&fromDate=" + fromDate + "&toDate=" + toDate;
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

        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
        if (CheckBox1.Checked)
        {
            dcDropDownList1.Enabled = false;
        }
        if (CheckBox1.Checked == false)
        {
            dcDropDownList1.Enabled = true;
        }
    }
    protected void CheckBox1_CheckedChanged1(object sender, EventArgs e)
    {
        OtherStockActionBLL aOtherStockActionBLL = new OtherStockActionBLL();
        aOtherStockActionBLL.DCLoad(dcDropDownList1);
        if (CheckBox1.Checked)
        {
            dcDropDownList1.Enabled = false;
        }
        if (CheckBox1.Checked == false)
        {
            dcDropDownList1.Enabled = true;
        }
    }
    private string Parm()
    {

        string param = "";
        if (CheckBox1.Checked)
        {


        }
        else
        {
            if (dcDropDownList1.SelectedValue != "")
            {
                param = param + " AND CU.ComUnitId='" + dcDropDownList1.SelectedValue + "' ";
            }
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



    
    protected void btnExport_Click(object sender, EventArgs e)
    {
        if (loadGridView.Rows.Count > 0)
        {






            Response.ClearContent();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", string.Format("attachment; filename={0}", "Delivery/Payment Report_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".xls"));
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);
            loadGridView.AllowPaging = false;
            //Change the Header Row back to white color
            loadGridView.HeaderRow.Style.Add("background-color", "#FFFFFF");
            //Applying stlye to gridview header cells
            for (int i = 0; i < loadGridView.HeaderRow.Cells.Count; i++)
            {
                loadGridView.HeaderRow.Cells[i].Style.Add("background-color", "#8BA8E0");
            }
            int j = 1;
            //This loop is used to apply stlye to cells based on particular row
            foreach (GridViewRow gvrow in loadGridView.Rows)
            {
                gvrow.BackColor = Color.White;
                if (j <= loadGridView.Rows.Count)
                {
                    if (j % 2 != 0)
                    {
                        for (int k = 0; k < gvrow.Cells.Count; k++)
                        {
                            gvrow.Cells[k].Style.Add("background-color", "#EFF3FB");
                        }
                    }
                }
                j++;
            }

            string headerTable = @"<span  style='text-align:center'><h3>  Delivery/Payment Report (Date Range : " + InvoiceDateTextBox.Text + "- " + todateTextBox.Text + ") </h3>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("MMMM dd, yyyy") + "</h4></span>";


            HttpContext.Current.Response.Write(headerTable);

            loadGridView.RenderControl(htw);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
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
        Session["SalesReport"] = "";
        Session["SalesReport"] = 1;

        if (InvoiceDateTextBox.Text != "" && todateTextBox.Text != "" && dcDropDownList1.SelectedValue != "")
        {
            if (todateTextBox.Text == "")
            {
                InvoiceDateTextBox.Text = todateTextBox.Text;
            }

            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            string districtId = dcDropDownList1.SelectedValue;

            string url = "../SInventory_RPTVIEW/AllSalesreportViewer.aspx?fromDate=" + fromDate + "&toDate=" + toDate + "&districtId=" + districtId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
        if (CheckBox1.Checked && todateTextBox.Text != "" && InvoiceDateTextBox.Text != "")
        {
            string fromDate = InvoiceDateTextBox.Text;
            string toDate = todateTextBox.Text;
            int i = 1;
            string url = "../SInventory_RPTVIEW/AllSalesreportViewer.aspx?NationalReport=" + 1 + "&fromDate=" + fromDate + "&toDate=" + toDate;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }
}