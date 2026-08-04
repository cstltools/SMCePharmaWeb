using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_WarehouseStockInView : System.Web.UI.Page
{
    WarehouseStockInBll aWarehouseStockInBll = new WarehouseStockInBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadGridView();
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

    private void LoadGridView()
    {
        DataTable aDataTable = new DataTable();

        aDataTable = aWarehouseStockInBll.LoadWarehouseStockInData();
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();
    }

    private void PopUp(string Id)
    {
        string url = "WarehouseStockInEdit.aspx?ID=" + Id;
        string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=700,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void printButton_Click(object sender, EventArgs e)
    {
        int iRowIndex = (((ImageButton)sender).Parent.Parent as GridViewRow).RowIndex;
        string reqId = loadGridView.DataKeys[iRowIndex][0].ToString();

        Session["ReportType"] = "";
        Session["ReportType"] = "STD";

        string url = "../SInventory_RPTVIEW/WHStockInReportViewer.aspx?reqId=" + reqId;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string stockInId = loadGridView.DataKeys[rowindex][0].ToString();
            Session["IDInformation"] = loadGridView.DataKeys[rowindex][0].ToString();
            Response.Redirect("WarehouseStockIn.aspx");

            //PoUp(stockInId);
           // Session["BankBranchInformation"] = e.CommandArgument.ToString();
            //Response.Redirect("BankBranchInformation.aspx");
        }

        if (e.CommandName == "DeleteData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string stockInId = loadGridView.DataKeys[rowindex][0].ToString();
            
            aWarehouseStockInBll.DeleteWhStockInInfoById(stockInId);
            ShowMessageBox("Welldone! Stockin Information Deleted Successfully!!!");
        }

        LoadGridView();

    }

    protected void addNewLinkButton_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("WarehouseStockIn.aspx");
    }

    protected void reloadLinkButton_OnClick(object sender, EventArgs e)
    {
        LoadGridView();
    }
}