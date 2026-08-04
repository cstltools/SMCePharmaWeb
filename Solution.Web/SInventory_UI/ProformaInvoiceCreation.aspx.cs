using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_ProformaInvoiceCreation : System.Web.UI.Page
{
    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            salesCenterDropDownList_SelectedIndexChanged(sender, e);
            SessionChoose();
            if (Session["MarketId"] != null)
            {
                marketDropDownList.SelectedValue = Session["MarketId"].ToString();
                GridView();
            }
        }
    }

    public void DropDownlist()
    {
        aOrderInfoBll.LoadSC(salesCenterDropDownList, Session["UserId"].ToString());
        aOrderInfoBll.LoadManufac(manufacDropDownList);
        manufacDropDownList.SelectedIndex = 1;
        salesCenterDropDownList.SelectedIndex = 1;
    }
    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aOrderInfoBll.LoadMarketOrderWise(marketDropDownList, salesCenterDropDownList.SelectedValue);
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

    public void SessionChoose()
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

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)orderGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
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

    public void GridView()
    {
        try
        {
            DataTable aTable = new DataTable();
            //aTable = aOrderInfoBll.LoadOrderForOrderCreation(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
            //    marketDropDownList.SelectedValue);
            //orderGridView.DataSource = aTable;
            //orderGridView.DataBind();
            //Session["MarketId"] = marketDropDownList.SelectedValue;


            //// decimal total = aTable.AsEnumerable().Sum(row => row.Field<int?>("NumberofProformaInvoice") == null ? 0 : row.Field<int>("NumberofProformaInvoice"));
            //orderGridView.FooterRow.Cells[6].Text = "Total";
            //orderGridView.FooterRow.Cells[6].HorizontalAlign = HorizontalAlign.Right;
            //// orderGridView.FooterRow.Cells[2].Text = total.ToString();

            //decimal total2 = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("GrossValue") == null ? 0 : row.Field<decimal>("GrossValue"));

            //orderGridView.FooterRow.Cells[7].Text = total2.ToString("N2");

        }
        catch (Exception)
        {

            //  throw;
        }

    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        GridView();
    }

    protected void btnSubmit0_Click(object sender, EventArgs e)
    {
        //throw new NotImplementedException();

        int status = 0;

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox cb = (CheckBox)orderGridView.Rows[i].FindControl("chkSelect");
            if (cb.Checked)
            {
                status = aInvoiceBll.SaveProformaInvoice((orderGridView.DataKeys[i][3].ToString()), Session["UserId"].ToString());
            }

        }
      //  if (status == 1)
        {
            showMessageBox("Invoice Generated Successfully");
            GridView();

        }







        //int status = aInvoiceBll.SaveRejectInvoice(orderGridView.Rows[rowindex].Cells[7].Text,
        //           Session["LoginName"].ToString()).SelectedItem
        //               .Text);
        //if (status == 1)
        //{
        //    showMessageBox("Invoice Generated Successfully");
        //    GridView();
          
        //}
    }
}