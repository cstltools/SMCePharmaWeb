using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_WHStockInReportList : System.Web.UI.Page
{
    WHStockInReportBll aStockInReportBll = new WHStockInReportBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

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
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private void LoadGridView()
    {
        DataTable aDataTable = new DataTable();

        aDataTable = aStockInReportBll.LoadWarehouseStockInData(stockInDateTextBox.Text);
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        LoadGridView();
    }

    protected void printButton_Click(object sender, EventArgs e)
    {
        int iRowIndex = (((ImageButton)sender).Parent.Parent as GridViewRow).RowIndex;
        string reqId = loadGridView.DataKeys[iRowIndex][0].ToString();

        if (reportDropDownList.SelectedValue == "STD")
        {
            Session["ReportType"] = "";
            Session["ReportType"] = "STD";

            Session["Excel"] = "";
            Session["Excel"] = 0;

            string url = "../SInventory_RPTVIEW/WHStockInReportViewer.aspx?reqId=" + reqId;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL =
                "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url +
                "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof (string), "OPEN_WINDOW", fullURL, true);
        }
        
    }

    protected void reportDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        if (reportDropDownList.SelectedValue == "STD")
        {
            stockInDate.Visible = true;
            productName.Visible = false;

            reportButton.Visible = false;
            excelButton.Visible = false;

            searchButton.Visible = true;
        }

        else if (reportDropDownList.SelectedValue == "CSR")
        {
            stockInDate.Visible = false;
            aStockInReportBll.LoadProductInformation(productDropDownList);
            productName.Visible = true;

            reportButton.Visible = true;
            excelButton.Visible = true;
            searchButton.Visible = false;

            loadGridView.DataSource = null;
            loadGridView.DataBind(); 

        }

        else
        {
            stockInDate.Visible = false;
            productName.Visible = false;

            reportButton.Visible = false;
            excelButton.Visible = false;
            searchButton.Visible = true;

            loadGridView.DataSource = null;
            loadGridView.DataBind(); 
        }
    }

    protected void reportButton_OnClick(object sender, EventArgs e)
    {
        if (reportDropDownList.SelectedValue == "CSR")
        {
            Session["ReportType"] = "";
            Session["ReportType"] = "CSR";
            Session["ProductCode"] = "";
            Session["ProductCode"] = productDropDownList.SelectedValue;

            //if (productDropDownList.SelectedValue != string.Empty)
            //{
            //    Session["ProductId"] = Conv(productDropDownList.SelectedValue);
            //}

            Session["Excel"] = "";
            Session["Excel"] = 0;

            string url = "../SInventory_RPTVIEW/WHStockInReportViewer.aspx?reqId=";
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL =
                "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url +
                "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (reportDropDownList.SelectedValue == "CSR")
        {
            Session["ReportType"] = "";
            Session["ReportType"] = "CSR";
            Session["ProductCode"] = "";
            Session["ProductCode"] = productDropDownList.SelectedValue;
            //if (productDropDownList.SelectedValue != string.Empty)
            //{
            //    Session["ProductId"] = Convert.ToInt32(productDropDownList.SelectedValue);
            //}
             
            Session["Excel"] = "";
            Session["Excel"] = 1;

            string url = "../SInventory_RPTVIEW/WHStockInReportViewer.aspx?reqId=";
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL =
                "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url +
                "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }
}