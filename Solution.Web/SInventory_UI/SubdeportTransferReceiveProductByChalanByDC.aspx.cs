using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_SubdeportTransferReceiveProductByChalanByDC : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    ChalanBLL aChalanBll=new ChalanBLL();
    DataTable aTable = new DataTable();
    DataTable aDataTableForGrid = new DataTable();
    private string reqId = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            reqId = Request.QueryString["SChalanId"];
            LoadInfo(reqId);
            LoadGrid(reqId);
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
    private void LoadInfo(string reqId)
    {
        aTable = aChalanBll.SubGetChalanReceieve(reqId);
        hdReqId.Value = aTable.Rows[0]["ChalanNo"].ToString();
        clnNoTextBox.Text = aTable.Rows[0]["ChalanNo"].ToString();
        clnDateTextBox.Text = Convert.ToDateTime(aTable.Rows[0]["ChalanDate"].ToString()).ToString("dd-MMM-yyyy");
        rcvDateTextBox.Text = Convert.ToDateTime(System.DateTime.Today.ToString()).ToString("dd-MMM-yyyy");
        driverNameTextBox.Text = aTable.Rows[0]["DriverName"].ToString();
        truckTextBox.Text = aTable.Rows[0]["TrackNo"].ToString();
        hdComUnitId.Value = aTable.Rows[0]["ComUnitId"].ToString();
    }
    private void LoadGrid(string reqId)
    {
        aDataTableForGrid = aChalanBll.SubGetChalanReceieve(reqId);
        rcvGridView.DataSource = aDataTableForGrid;
        rcvGridView.DataBind();
    }

    private void Save()
    {
        List<DCStockNew> aDcStockNewsList = new List<DCStockNew>();
        for (int i = 0; i < rcvGridView.Rows.Count; i++)
        {
            TextBox rcvQtyTextBox = (TextBox) rcvGridView.Rows[i].Cells[7].FindControl("rcvQtyTextBox");
            TextBox damageTextBox = (TextBox) rcvGridView.Rows[i].Cells[8].FindControl("damageTextBox");
            DCStockNew aDcStockNew = new DCStockNew()
            {
                ProductCode = rcvGridView.Rows[i].Cells[0].Text,
                ProductName = rcvGridView.Rows[i].Cells[1].Text,
                PackSize = rcvGridView.Rows[i].Cells[2].Text,
                BatchNo = rcvGridView.Rows[i].Cells[3].Text,
                TotalQuantity = Convert.ToDecimal(rcvGridView.Rows[i].Cells[4].Text),
                StockQty = Convert.ToDecimal(rcvQtyTextBox.Text.Trim()),
                DamageQty = Convert.ToDecimal(damageTextBox.Text.Trim()),
                ExpDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[5].Text),
                mfgdate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[9].Text),
                ReceiveDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[6].Text),
                StockRcvDate = Convert.ToDateTime(rcvDateTextBox.Text.Trim()),
                ChalanNo = clnNoTextBox.Text.Trim(),
                ChalanDate = Convert.ToDateTime(clnDateTextBox.Text.Trim()),
                ComUnitId=Convert.ToInt32(6),
                ChalanDetailsId = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString()),
                ChalanId = Convert.ToInt32(rcvGridView.DataKeys[i][0].ToString()),
                
            };
            int DCStoreId = aChalanBll.DCStockInSub(aDcStockNew);
            if (Convert.ToDecimal(damageTextBox.Text.Trim()) > 0)
            {
                DCStoreFreezeDAO aDCStoreFreezeDAO = new DCStoreFreezeDAO();
                aDCStoreFreezeDAO.DCStoreId =   DCStoreId;
                  
                aDCStoreFreezeDAO.StorageLocation = "";
                aDCStoreFreezeDAO.ProductCode = rcvGridView.Rows[i].Cells[0].Text;
                aDCStoreFreezeDAO.ProductName = rcvGridView.Rows[i].Cells[1].Text;
                aDCStoreFreezeDAO.PackSize = rcvGridView.Rows[i].Cells[2].Text;
                aDCStoreFreezeDAO.BatchNo = rcvGridView.Rows[i].Cells[3].Text;
                aDCStoreFreezeDAO.TotalQuantity = Convert.ToDecimal(damageTextBox.Text.Trim());
                aDCStoreFreezeDAO.StockQty = Convert.ToDecimal(damageTextBox.Text.Trim());
                aDCStoreFreezeDAO.DamageQty = 0;
                aDCStoreFreezeDAO.ExpDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[5].Text);
                aDCStoreFreezeDAO.ReceiveDate = Convert.ToDateTime(rcvGridView.Rows[i].Cells[6].Text);
                aDCStoreFreezeDAO.StockRcvDate = Convert.ToDateTime(rcvDateTextBox.Text.Trim());
                aDCStoreFreezeDAO.ChalanNo = clnNoTextBox.Text.Trim();
                aDCStoreFreezeDAO.ChalanDate = Convert.ToDateTime(clnDateTextBox.Text.Trim());
                aDCStoreFreezeDAO.ComUnitId = Convert.ToInt32(hdComUnitId.Value);
                aDCStoreFreezeDAO.StockCondition = "Restricted";
                aDCStoreFreezeDAO.ChalanDetailsId = aDcStockNew.ChalanDetailsId;
                aDCStoreFreezeDAO.ChalanId = Convert.ToInt32(rcvGridView.DataKeys[i][0].ToString());
                //aDCStoreFreezeDAO.ReqId = Convert.ToInt32(rcvGridView.DataKeys[i][0].ToString());
                //aDCStoreFreezeDAO.ReqChildId = Convert.ToInt32(rcvGridView.DataKeys[i][1].ToString());
                //aDCStoreFreezeDAO.StockInTransfarId = Convert.ToInt32(rcvGridView.DataKeys[i][2].ToString());
                aChalanBll.SaveDCStoreFreeze2(aDCStoreFreezeDAO);
            }
        }
        //DC Freez
        showMessageBox("Data Save Successfully!!");
       // Popup(hdReqId.Value);
        Clear();
    }

    public void Popup(string reqId)
    {
        string url = "../SInventory_RPTVIEW/TransferStockReceiveReportViewer.aspx?ChalanId=" + reqId;
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void submitButton_Click(object sender, EventArgs e)
    {
        Save();
    }
    private void Clear()
    {

        hdReqId.Value = "";
        clnNoTextBox.Text = "";
        clnDateTextBox.Text = "";
        rcvDateTextBox.Text = "";
        driverNameTextBox.Text = "";
        truckTextBox.Text = "";
        hdComUnitId.Value = "";
        rcvGridView.DataSource = null;
        rcvGridView.DataBind();
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void damageTextBox_TextChanged(object sender, EventArgs e)
    {
        int setRowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;

        decimal issueQty = 0;
        decimal damageQty = 0;
        issueQty = Convert.ToDecimal(rcvGridView.Rows[setRowIndex].Cells[4].Text.Trim());
        damageQty = Convert.ToDecimal(((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text.Trim()!=""?((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text.Trim():"0");
        ((TextBox) rcvGridView.Rows[setRowIndex].Cells[7].FindControl("rcvQtyTextBox")).Text =
            Convert.ToString(issueQty - damageQty);
    }
    protected void rcvQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        int setRowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;

        decimal issueQty = 0;
        decimal rcveQty = 0;
        issueQty = Convert.ToDecimal(rcvGridView.Rows[setRowIndex].Cells[4].Text.Trim());
        rcveQty = Convert.ToDecimal(((TextBox)rcvGridView.Rows[setRowIndex].Cells[7].FindControl("rcvQtyTextBox")).Text.Trim() != "" ? ((TextBox)rcvGridView.Rows[setRowIndex].Cells[7].FindControl("rcvQtyTextBox")).Text.Trim() : "0");
        ((TextBox)rcvGridView.Rows[setRowIndex].Cells[8].FindControl("damageTextBox")).Text =
            Convert.ToString(issueQty - rcveQty);
    }
    protected void backLinkButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("TransferStockReceiveByDC.aspx");
    }

    
}