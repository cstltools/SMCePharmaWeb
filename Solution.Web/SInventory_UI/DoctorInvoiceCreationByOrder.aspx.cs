using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.InternalCls;

public partial class SInventory_UI_InvoiceCreationByOrder : System.Web.UI.Page
{
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           DropDownlist();
            //salesCenterDropDownList_SelectedIndexChanged(sender, e);
            //SessionChoose();
            //if (Session["MarketId"] !=null)
            //{
            //    marketDropDownList.SelectedValue = Session["MarketId"].ToString();
            //    GridView();
                
            //}
        }
    }
    public string GenerateParameter()
    {
        string pram = @" WHERE IV.InvoiceNo IN (SELECT InvoiceNo FROM dbo.tblInvoiceBatch
        LEFT JOIN dbo.tblInvoice ON tblInvoice.InvoiceId = tblInvoiceBatch.InvoiceId
        WHERE BatchNo = '" + batchno.Text + "')";
        return pram;
    }
    protected void viewRptButton_Click(object sender, EventArgs e)
    {

        string pram = "";
        pram = GenerateParameter();

        Session["paydetailId"] = "";
        Session["paydetailId"] = pram;


        string url = "../SInventory_RPTVIEW/ProformaReportPrintViewer.aspx";
        // string fullURL = "window.open('" + url + "', '_blank', 'height=600,width=900,status=yes,toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=no,titlebar=no' );";
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true);
    }
    protected void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void invoiceButton_Click(object sender, EventArgs e)
    {

        try { 
        string batchn = "";
        //ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

        batchn = (aOrderInfoBll.LoadInvoiceBatchId().Rows[0][0].ToString());
        batchn = rootDropDownList.SelectedValue + "-" + batchn;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox cb = (CheckBox)orderGridView.Rows[i].FindControl("chkSelect");
            if (cb.Checked)
            {
                Int32 orderId = Convert.ToInt32(orderGridView.DataKeys[i]["OrderId"].ToString());
                //aOrderInfoBll.GenerateInvoiceByOrderId(orderId, Convert.ToInt32(Session["UserId"].ToString()), batchn);
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
        catch(Exception ex)
        {

        }

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

    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("InvoiceCreationByOrder.aspx");
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

    protected void rootDropDownList_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            Session["RouteId"] = rootDropDownList.SelectedValue;
        }
        catch(Exception ex)
        {

        }
    }

    public void DropDownlist()
    {
        aOrderInfoBll.LoadSC(salesCenterDropDownList,Session["UserId"].ToString());
        aOrderInfoBll.LoadManufac(manufacDropDownList);
       // aOrderInfoBll.LoadDisRoute(rootDropDownList);
        manufacDropDownList.SelectedIndex = 1;
        salesCenterDropDownList.SelectedIndex = 1;
        salesCenterDropDownList_SelectedIndexChanged(null, null);
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            aOrderInfoBll.LoadDisRouteforInvoice(rootDropDownList, Convert.ToInt32(salesCenterDropDownList.SelectedValue));
        }
        catch(Exception ex)
        {

        }
        //// aOrderInfoBll.LoadMarketOrderWise(marketDropDownList,salesCenterDropDownList.SelectedValue);
        // using (DataTable dt = aOrderInfoBll.LoadDistributionRoute(salesCenterDropDownList.SelectedValue))
        // {

        //     try
        //     {
        //         rootDropDownList.SelectedValue = dt.Rows[0]["RouteInformationMasterId"].ToString();
        //     }
        //     catch(Exception ex)
        //     {

        //     }
        // }

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
    protected void gotoinvoiceButton_Click(object sender, EventArgs e)
    {
        Button button = (Button)sender;
        GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        Response.Redirect("InvoiceCreationForCustomerByOrder.aspx");

    }
    protected void GeneratetoinvoiceButton_Click(object sender, EventArgs e)
    {
        //Button button = (Button)sender;
        //GridViewRow currentRow = (GridViewRow)button.Parent.Parent;
        //int rowindex = 0;
        //rowindex = currentRow.RowIndex;

        //Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        //Response.Redirect("InvoiceCreationForCustomerByOrder.aspx");

    }

    public void SessionChoose()
    {
        try
        {
            DataTable aTable = new DataTable();
            if (Session["MarketId"] != null)
            {
                //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
                //Session["MarketId"].ToString());
                //if (aTable.Rows.Count > 0)
                //{
                //    marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                //}
                //else
                //{
                //    marketDropDownList.SelectedIndex = 0;
                //}
            }
        }
        catch(Exception ex)
        {

        }
        
    }

    public void GridView()
    {
        try
        {
            DataTable aTable = new DataTable();
            aTable = aOrderInfoBll.LoadDoctorOrderForOrderCreation(salesCenterDropDownList.SelectedValue);
            orderGridView.DataSource = aTable;
            orderGridView.DataBind();
            Session["MarketId"] = rootDropDownList.SelectedValue;


            // decimal total = aTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
            //orderGridView.FooterRow.Cells[4].Text = "Total";
            //orderGridView.FooterRow.Cells[6].HorizontalAlign = HorizontalAlign.Right;
            //// orderGridView.FooterRow.Cells[2].Text = total.ToString();

            //decimal total2 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));

            //orderGridView.FooterRow.Cells[5].Text = total2.ToString("N2");

        }
        catch (Exception)
        {
            
          //  throw;
        }
     
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView();
    }
}