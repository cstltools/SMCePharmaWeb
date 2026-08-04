using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SubDepot_UI_SubDepotInvoiceCreation : System.Web.UI.Page
{
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            salesCenterDropDownList_SelectedIndexChanged(sender, e);
            SessionChoose();
            if (Session["MarketId"] !=null)
            {
                marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                GridView();
                
            }
        }
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)orderGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[6].FindControl("chkSelect");
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
    protected void invoiceButton_Click(object sender, EventArgs e)
    {

        try
        {
            string batchn = "";
            //ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

            batchn = (aOrderInfoBll.LoadSubInvoiceBatchId().Rows[0][0].ToString());
            batchn = "06" + "-" + batchn;
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {
                CheckBox cb = (CheckBox)orderGridView.Rows[i].FindControl("chkSelect");
                if (cb.Checked)
                {
                    Int32 orderId = Convert.ToInt32(orderGridView.DataKeys[i]["OrderId"].ToString());
                    aOrderInfoBll.GenerateSubInvoiceByOrderId(orderId, Convert.ToInt32(Session["UserId"].ToString()), batchn);
                }

                batchno.Text = batchn.ToString();
            }

            if (Session["MarketId"] != null)
            {
                marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                GridView();
            }
            ShowMessageBox("Invoice Generated Successfully.");
        }
        catch (Exception ex)
        {

        }

    }

    public string GenerateParameter()
    {
        string pram = @" WHERE IV.InvoiceNo IN (SELECT InvoiceNo FROM dbo.tblSubInvoiceMasterBatch
        LEFT JOIN dbo.tblSubInvoiceMaster ON tblSubInvoiceMaster.InvoiceId = tblSubInvoiceMasterBatch.InvoiceId
        WHERE BatchNo = '" + batchno.Text + "')";
        return pram;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {



        string pram = "";
        pram = GenerateParameter();

        Session["paydetailId"] = "";
        Session["paydetailId"] = pram;


        string url = "../SInventory_RPTVIEW/SubDeportInvoiceReportViewer.aspx";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }

    public void DropDownlist()
    {
        aOrderInfoBll.LoadSC(salesCenterDropDownList);

        

        aOrderInfoBll.LoadManufac(manufacDropDownList);
        manufacDropDownList.SelectedIndex = 1;
        salesCenterDropDownList.SelectedIndex = 1;
        aOrderInfoBll.SubLoadDisRouteforInvoice(rootDropDownList, 6);
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        RequisitionBLL aRequisitionBll = new RequisitionBLL();
        aRequisitionBll.SubdeportLoad(subdeportDropDownList1, salesCenterDropDownList.SelectedValue);
        aOrderInfoBll.SubdeportLoadMarketOrderWise(marketDropDownList, salesCenterDropDownList.SelectedValue,subdeportDropDownList1.SelectedValue);
        orderGridView.DataSource = null;
        orderGridView.DataBind();
    }
    protected void manufacDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        
    }
    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
        //    marketDropDownList.SelectedValue);
        //orderGridView.DataSource = aTable;
        //orderGridView.DataBind();
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        Session["SubDepotId"] = (subdeportDropDownList1.SelectedValue).ToString();
        Response.Redirect("ProformaInvoiceCreation.aspx");

    }

    public void SessionChoose()
    {
        DataTable aTable = new DataTable();
        if (Session["MarketId"] !=null)
        {
            //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
            //Session["MarketId"].ToString());
            //if (aTable.Rows.Count>0)
            //{
            //    marketDropDownList.SelectedValue = Session["MarketId"].ToString();
            //}
            //else
            //{
            //    marketDropDownList.SelectedIndex = 0;
            //}
        }
        
    }

    public void GridView()
    {
        if (subdeportDropDownList1.SelectedValue != "")
        {
            DataTable aTable = new DataTable();
            aTable = aOrderInfoBll.subDepoOrderLoad(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
             rootDropDownList.SelectedValue);
            orderGridView.DataSource = aTable;
            orderGridView.DataBind();
            Session["MarketId"] = marketDropDownList.SelectedValue;

            try
            {

                decimal total2 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));

                orderGridView.FooterRow.Cells[8].Text = total2.ToString("N2");
            }
            catch(Exception ex)
            {

            }
        }
        else
        {
           // showMessageBox("Please Select Sub-Depot !!");
        }
        
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView();
    }
}