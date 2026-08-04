using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SubDepot_UI_DelivaryInvoiceList : System.Web.UI.Page
{
    OrderInfoBLL aOrderInfoBll=new OrderInfoBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownlist();
            salesCenterDropDownList_SelectedIndexChanged(sender, e);
            SessionChoose();
            if (Session["DelMarketId"] != null)
            {
                marketDropDownList.SelectedValue = Session["DelMarketId"].ToString();
                GridView();

            }
            //for (int i = 0; i < orderGridView.Rows.Count; i++)
            //{
                
            //    aInvoiceBll.ReturnReason(
            //        ((DropDownList)orderGridView.Rows[i].FindControl("reasonReturnDropDownList")));
            //}
        }
    }
    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("DelivaryInvoiceList.aspx");
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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
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
        RequisitionBLL aRequisitionBll = new RequisitionBLL();
        aRequisitionBll.SubdeportLoad(subdeportDropDownList1, salesCenterDropDownList.SelectedValue);
        aOrderInfoBll.SubdeportLoadMarketByInvoice(marketDropDownList, salesCenterDropDownList.SelectedValue);
        orderGridView.DataSource = null;
        orderGridView.DataBind();
    }
    protected void manufacDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
       
    }
    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //DataTable aTable = new DataTable();
        //aTable = aOrderInfoBll.LoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
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
        DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
        if (statusDropDownList.SelectedItem.Text=="Partial")
        {
            Session["InvoiceId"] = orderGridView.DataKeys[rowindex]["InvoiceId"].ToString();
            Response.Redirect("DelivaryInvoiceCreationForCustomerAuto.aspx");    
        }
        else if (statusDropDownList.SelectedItem.Text=="Full")
        {
            int status = aInvoiceBll.SubdeportSaveFullInvoice(orderGridView.Rows[rowindex].Cells[7].Text,
                Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"));
            {
                showMessageBox("Delivery Invoice Save Successfully");
                GridView();
            }
        }
        else 
        {
            int status = aInvoiceBll.SubSaveRejectInvoice(orderGridView.Rows[rowindex].Cells[7].Text,
                    Session["LoginName"].ToString(), DateTime.Now.ToString("dd-MMM-yyyy"),
                    ((DropDownList) orderGridView.Rows[rowindex].FindControl("reasonReturnDropDownList")).SelectedItem
                        .Text);
                {
                    showMessageBox("Delivery Invoice Reject Successfully");
                    GridView();
                   
                }

        }
        //Session["OrderId"] = orderGridView.DataKeys[rowindex]["OrderId"].ToString();
        

    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (subdeportDropDownList1.SelectedValue !="")
        {
            GridView();
        }
        //for (int i = 0; i < orderGridView.Rows.Count; i++)
        //{

        //    aInvoiceBll.ReturnReason(
        //        ((DropDownList)orderGridView.Rows[i].FindControl("reasonReturnDropDownList")));
        //}
    }

    public void GridView()
    {
        DataTable aTable = new DataTable();
        aTable = aOrderInfoBll.SubDeportLoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
            marketDropDownList.SelectedValue);
        orderGridView.DataSource = aTable;
        orderGridView.DataBind();
        Session["DelMarketId"] = marketDropDownList.SelectedValue;
    }
    
    public void SessionChoose()
    {
        DataTable aTable = new DataTable();
        if (Session["DelMarketId"] != null)
        {
            aTable = aOrderInfoBll.SubDeportLoadOrderWithInvoice(salesCenterDropDownList.SelectedValue, manufacDropDownList.SelectedValue,
            Session["DelMarketId"].ToString());
            if (aTable.Rows.Count > 0)
            {
                marketDropDownList.SelectedValue = Session["DelMarketId"].ToString();
            }
            else
            {
                marketDropDownList.SelectedIndex = 0;
            }
        }

    }

    protected void statusDropDownList_OnTextChanged(object sender, EventArgs e)
    {
        DropDownList DropDownList = (DropDownList)sender;
        GridViewRow currentRow = (GridViewRow)DropDownList.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DropDownList statusDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("statusDropDownList"));
        DropDownList reasonReturnDropDownList = ((DropDownList)orderGridView.Rows[rowindex].FindControl("reasonReturnDropDownList"));
        if (statusDropDownList.SelectedItem.Text=="Reject")
        {
            reasonReturnDropDownList.Visible = true;

        }
        else
        {
            reasonReturnDropDownList.Visible = false;
        }

    }
}