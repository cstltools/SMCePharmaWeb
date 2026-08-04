using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_LogisticeRollBackOperation : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    RollBackBLL aRollBackBll=new RollBackBLL();
    protected void Page_Load(object sender, EventArgs e)
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
    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        
        if (DropDownList1.SelectedValue=="SG")
        {
            sto.Visible = true;
            picking.Visible = false;
            challan.Visible = false;
            aDataTable = aRequisitionBll.GetRequisitionView();
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();    
        }
        else if (DropDownList1.SelectedValue == "PG")
        {
            sto.Visible = false;
            picking.Visible = true;
            challan.Visible = false;


            aDataTable = aRequisitionBll.GetAllNonSubmitReq();
            viewReqGridView.DataSource = aDataTable;
            viewReqGridView.DataBind();
        }
        else
        {
            sto.Visible = false;
            picking.Visible = false;
            challan.Visible = true;

            aDataTable = aRollBackBll.GetAllStockRcvByDcDAL();
            stockInTraGridView.DataSource = aDataTable;
            stockInTraGridView.DataBind();
        }


        

    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void ImageButton2_Click(object sender, ImageClickEventArgs e)
    {


        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
         bool sts= aRequisitionBll.DeleteRequisition(loadGridView.DataKeys[rowindex][0].ToString());


         if (sts==true)
         {
            showMessageBox("RollBack Successfull!!");
            sto.Visible = true;
            picking.Visible = false;
            challan.Visible = false;
            aDataTable = aRequisitionBll.GetRequisitionView();
            loadGridView.DataSource = aDataTable;
            loadGridView.DataBind();  
        }
         else
         {
             showMessageBox("Error!!");
         }

    }

    protected void editImageButton_OnClick(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RollBackBLL aRollBackBll=new RollBackBLL();
        DataTable dt = aRollBackBll.GetStockInTransfer(viewReqGridView.DataKeys[rowindex][0].ToString());
        bool UPsts = aRollBackBll.UpdatePickingInformationOnRequisitionDAL(viewReqGridView.DataKeys[rowindex][0].ToString());
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            aRollBackBll.UpdateIssueInformationOnRequisitionChildDAL(dt.Rows[i]["ReqChildId"].ToString());
            aRollBackBll.UpdateCentralStockStockOut(Convert.ToDecimal(dt.Rows[i]["Quantity"].ToString()),
                dt.Rows[i]["ReceiveId"].ToString());
            
        }
        bool Delsts = aRollBackBll.DeleteStockInTransfer(viewReqGridView.DataKeys[rowindex][0].ToString());

        if (UPsts == true && Delsts == true)
        {
            showMessageBox("RollBack Successfull!!");
            sto.Visible = false;
            picking.Visible = true;
            challan.Visible = false;

            aDataTable = aRequisitionBll.GetAllNonSubmitReq();
            viewReqGridView.DataSource = aDataTable;
            viewReqGridView.DataBind();
        }
        else
        {
            showMessageBox("Error!!");
        }

    }

    protected void edit2ImageButton_OnClick(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RollBackBLL aRollBackBll = new RollBackBLL();
        DataTable dt = aRollBackBll.GetStockInTransfer(stockInTraGridView.DataKeys[rowindex][0].ToString());
        bool UPsts = aRollBackBll.UpdatePickingInformationOnRequisitionDAL(stockInTraGridView.DataKeys[rowindex][0].ToString());
        for (int i = 0; i < dt.Rows.Count; i++)
        {
            aRollBackBll.UpdateIssueInformationOnRequisitionChildDAL(dt.Rows[i]["ReqChildId"].ToString());
            aRollBackBll.UpdateCentralStockStockOut(Convert.ToDecimal(dt.Rows[i]["Quantity"].ToString()),
                dt.Rows[i]["ReceiveId"].ToString());

        }
        bool Delsts = aRollBackBll.DeleteStockInTransfer(stockInTraGridView.DataKeys[rowindex][0].ToString());

        //
       // bool Delsts = aRollBackBll.DeleteStockInTransfer(stockInTraGridView.DataKeys[rowindex][0].ToString());

        aRollBackBll.UpdateIssueInformationOnRequisition(stockInTraGridView.DataKeys[rowindex][0].ToString());
        //for (int i = 0; i < stockInTraGridView.Rows.Count; i++)
        {
            aRollBackBll.UpdateStockTransfarInfoUpdate(stockInTraGridView.DataKeys[rowindex][0].ToString());
        }

        //

        if (UPsts == true && Delsts==true)
        {
            showMessageBox("RollBack Successfull!!");
            sto.Visible = false;
            picking.Visible = false;
            challan.Visible = true;

            aDataTable = aRollBackBll.GetAllStockRcvByDcDAL();
            stockInTraGridView.DataSource = aDataTable;
            stockInTraGridView.DataBind();
        }
        else
        {
            showMessageBox("Error!!");
        }
    }
}