using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_WHStockAdjustmentView : System.Web.UI.Page
{
    WHStockAdjDAL adjDal=new WHStockAdjDAL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadGrid();
        }
    }
    protected void viewLinkButton_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("WHStockAdjustmentEntry.aspx");
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public void LoadGrid()
    {
        DataTable dtdata = adjDal.LoadWHStockAdjustment(param());
        loadGridView.DataSource = dtdata;
        loadGridView.DataBind();
    }

    private string param()
    {

        string parameter = "   ";
        if (fromDateTextBox.Text != string.Empty && toDateTextBox.Text != string.Empty)
        {
            parameter = parameter + " AND TransactionDate BETWEEN '" + fromDateTextBox.Text + "' AND '" + toDateTextBox.Text + "' ";
        }
        if (fromDateTextBox.Text != string.Empty && toDateTextBox.Text == string.Empty)
        {
            parameter = parameter + " AND TransactionDate BETWEEN '" + fromDateTextBox.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        }

        if (fromDateTextBox.Text == string.Empty && toDateTextBox.Text != string.Empty)
        {
            parameter = parameter + " AND TransactionDate BETWEEN '" + toDateTextBox.Text + "' AND '" + toDateTextBox.Text + "' ";
        }

        return parameter;
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string id = loadGridView.DataKeys[rowindex][0].ToString();
            DataTable dtdata = adjDal.LoadWHStockAdjustmentById(id);
            if (dtdata.Rows.Count>0)
            {
                string adjustmenttype = dtdata.Rows[0]["AdjustmentType"].ToString();
                string sign = "";
                //if (adjustmenttype=="1")
                //{
                //    sign = "-";
                //}
                //else
                {
                    sign = "+";
                }
                for (int i = 0; i < dtdata.Rows.Count; i++)
                {
                    string rcvId = dtdata.Rows[i]["ReceiveId"].ToString();
                    decimal qty = Convert.ToDecimal(dtdata.Rows[i]["Quantity"].ToString());
                    string productId = dtdata.Rows[i]["ProductId"].ToString();
                    adjDal.UpdateCentralStoreStock(productId, qty, rcvId, sign);
                }
                adjDal.DeleteStockWHAdjustment(id);
                showMessageBox("Data Deleted Successfully");
                LoadGrid();
            }
            //PopUp(salesCenterId);
        }


        if (e.CommandName == "reportData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string id = loadGridView.DataKeys[rowindex][0].ToString();
            

            string url = "../SInventory_RPTVIEW/WHStockAdjustmentListReportViewer.aspx?WHStockAdjId=" + id;
            // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
        }
    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {
        LoadGrid();
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("WHStockAdjustmentView.aspx");
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
}