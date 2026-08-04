using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_IssueRequisitionProducts : System.Web.UI.Page
{
    DataTable aDataTable = new DataTable();
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    ProductBLL aProductBll = new ProductBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            string reqId = Request.QueryString["ReqId"];

            DataTable aTableexists = new DataTable();
            aTableexists = aRequisitionBll.ChallanExistsBll(reqId);
            if (aTableexists.Rows.Count > 0)
            {
                showMessageBox("Challan Already Generated  !!");
            }
            else
            {
                LoadGrid(reqId);
                LoadMainInfo(reqId);
            }
        }
       
    }

    private void LoadMainInfo(string reqId)
    {
        DataTable aTableInfo = new DataTable();
        aTableInfo = aRequisitionBll.GetRequisitionInfoByReqId(reqId);


        hdReqId.Value = aTableInfo.Rows[0]["ReqId"].ToString();
        reqNoTextBox.Text = aTableInfo.Rows[0]["ReqNo"].ToString();
        reqDateTextBox.Text = Convert.ToDateTime(aTableInfo.Rows[0]["ReqDate"].ToString()).ToString("dd-MMM-yyyy");
        pikNoTextBox.Text = aTableInfo.Rows[0]["PickingNo"].ToString();
        pikDateTextBox.Text = Convert.ToDateTime(aTableInfo.Rows[0]["PickingDate"].ToString()).ToString("dd-MMM-yyyy");

        truckNoTextBox.Text = aTableInfo.Rows[0]["TruckNo"].ToString();
        driverNameTextBox.Text = aTableInfo.Rows[0]["DriverName"].ToString();


        clnNoTextBox.Text = aRequisitionBll.ChalanNo(reqNoTextBox.Text.Trim());
        clnDateTextBox.Text = Convert.ToDateTime(System.DateTime.Today.ToString()).ToString("dd-MMM-yyyy");
    }

    private void LoadGrid(string reqId)
    {
        aDataTable.Columns.Add("ReqChildId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("UnitPrice");
        //aDataTable.Columns.Add("Quantity");
        aDataTable.Columns.Add("PriceAmount");
        aDataTable.Columns.Add("VATAmount");
        aDataTable.Columns.Add("TotalPriceAmount");
        aDataTable = aRequisitionBll.GetRequisitionDetailByReqId(reqId);

        issueGridView.DataSource = aDataTable;
        issueGridView.DataBind();

        foreach (GridViewRow row in issueGridView.Rows)
        {
            CheckBox cb = (CheckBox)issueGridView.Rows[row.RowIndex].Cells[10].FindControl("issueCheckBox");
            cb.Checked = true;
            cb.Enabled = false;
            PriceCalculation(row.RowIndex);
        }


    }
    protected void issueCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        int selRowIndex = ((GridViewRow)(((CheckBox)sender).Parent.Parent)).RowIndex;
        CheckBox cb = (CheckBox)issueGridView.Rows[selRowIndex].Cells[10].FindControl("issueCheckBox");

        if (cb.Checked)
        {
            TextBox issueQtyTextBox = (TextBox)issueGridView.Rows[selRowIndex].Cells[6].FindControl("issueQtyTextBox");
            issueQtyTextBox.Enabled = true;
        }
        else
        {
            TextBox issueQtyTextBox = (TextBox)issueGridView.Rows[selRowIndex].Cells[6].FindControl("issueQtyTextBox");
            issueQtyTextBox.Enabled = false;
        }
        PriceCalculation(selRowIndex);
        //Perform your logic
    }
    protected void issueQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        int setRowIndex = ((GridViewRow)(((TextBox)sender).Parent.Parent)).RowIndex;
        PriceCalculation(setRowIndex);
    }
    private void PriceCalculation(int rowIndex)
    {
        DataTable aDataTableProductPriceCase = new DataTable();
        aDataTableProductPriceCase =
            aProductBll.ProductPriceDetailWithCaseBLL(issueGridView.Rows[rowIndex].Cells[0].Text);

        TextBox issueQtyTextBox = (TextBox)issueGridView.Rows[rowIndex].Cells[6].FindControl("issueQtyTextBox");

        //if (Convert.ToDecimal(issueQtyTextBox.Text.Trim()) > Convert.ToDecimal(issueGridView.Rows[rowIndex].Cells[5].Text.Trim()))
        //{
        //    issueQtyTextBox.Text = issueGridView.Rows[rowIndex].Cells[5].Text.Trim();
        //    if (Convert.ToDecimal(issueQtyTextBox.Text.Trim()) > Convert.ToDecimal(issueGridView.Rows[rowIndex].Cells[3].Text.Trim()))
        //    {
        //        issueQtyTextBox.Text = issueGridView.Rows[rowIndex].Cells[3].Text.Trim();
        //    }
        //}

       
        decimal issueQty = Convert.ToDecimal(issueQtyTextBox.Text.Trim());
        decimal unitPrice = Convert.ToDecimal(issueGridView.Rows[rowIndex].Cells[5].Text.Trim());
        //decimal caseQty = (issueQty/Convert.ToDecimal(aDataTableProductPriceCase.Rows[0]["PcsPerCase"].
        //                                       ToString())) * Convert.ToDecimal(aDataTableProductPriceCase.Rows[0]["CaseQty"].
        //                                       ToString());


        TextBox priceTextBox = (TextBox)issueGridView.Rows[rowIndex].Cells[7].FindControl("priceTextBox");
        priceTextBox.Text = Convert.ToString(issueQty*unitPrice);
        TextBox vatTextBox = (TextBox)issueGridView.Rows[rowIndex].Cells[8].FindControl("vatTextBox");
        vatTextBox.Text = Convert.ToString(Convert.ToDecimal(aDataTableProductPriceCase.Rows[0]["VATAmountPerUnit"].
                                               ToString()) * issueQty);
        TextBox totalPriceTextBox = (TextBox)issueGridView.Rows[rowIndex].Cells[9].FindControl("totalPriceTextBox");

        totalPriceTextBox.Text = Convert.ToString(Convert.ToDecimal(priceTextBox.Text.Trim()) + Convert.ToDecimal(vatTextBox.Text.Trim()));
        //TextBox caseTextBox = (TextBox)issueGridView.Rows[rowIndex].Cells[10].FindControl("caseTextBox");
        //caseTextBox.Text = caseQty.ToString();
        decimal totalPrice = 0;
        decimal totalVat = 0;
        decimal grandTotal = 0;
        for (int i = 0; i < issueGridView.Rows.Count; i++)
        {
            CheckBox cb = (CheckBox)issueGridView.Rows[i].Cells[10].FindControl("issueCheckBox");
            if (cb.Checked)
            {
                TextBox priceTextBox1 = (TextBox) issueGridView.Rows[i].Cells[7].FindControl("priceTextBox");
                totalPrice += Convert.ToDecimal(priceTextBox1.Text.Trim() != "" ? priceTextBox1.Text.Trim() : "0");
                TextBox vatTextBox1 = (TextBox) issueGridView.Rows[i].Cells[8].FindControl("vatTextBox");
                totalVat += Convert.ToDecimal(vatTextBox1.Text.Trim() != "" ? vatTextBox1.Text.Trim() : "0");
                TextBox totalPriceTextBox1 = (TextBox) issueGridView.Rows[i].Cells[9].FindControl("totalPriceTextBox");
                grandTotal +=Convert.ToDecimal(totalPriceTextBox1.Text.Trim() != "" ? totalPriceTextBox1.Text.Trim() : "0");
            }

        }
        totalAllPriceTextBox.Text = totalPrice.ToString();
        vatAllPriceTextBox.Text = totalVat.ToString();
        grandTotalTextBox.Text = grandTotal.ToString();
    }


   private void SaveData()
   {
       Requesition aRequesition = new Requesition();
       aRequesition.ReqId = Convert.ToInt32(hdReqId.Value);
       aRequesition.IssueChalanNo = clnNoTextBox.Text.Trim();
       aRequesition.IssuChalanDate = Convert.ToDateTime(clnDateTextBox.Text.Trim());
       aRequesition.TruckNo = truckNoTextBox.Text.Trim();
       aRequesition.DriverName = driverNameTextBox.Text.Trim();
       aRequesition.Submit = "OK";
       aRequesition.SubmitDate = Convert.ToDateTime(clnDateTextBox.Text.Trim());
       aRequesition.TotalPrice = Convert.ToDecimal(totalAllPriceTextBox.Text.Trim());
       aRequesition.TotalVAT = Convert.ToDecimal(vatAllPriceTextBox.Text.Trim());
       aRequesition.GrandTotalPrice = Convert.ToDecimal(grandTotalTextBox.Text.Trim());


       bool updateReq = aRequisitionBll.UpdateIssueInformationOnRequisition(aRequesition);

       List<StockInTransfar> aStockInTransfarList = new List<StockInTransfar>();
       for (int i = 0; i < issueGridView.Rows.Count; i++)
       {
            CheckBox cb = (CheckBox)issueGridView.Rows[i].Cells[10].FindControl("issueCheckBox");
            if (cb.Checked)
            {

            StockInTransfar aStockInTransfar = new StockInTransfar();
            aStockInTransfar.StockInTransfarId = Convert.ToInt32(issueGridView.DataKeys[i][1].ToString());
            aStockInTransfar.ReqId = Convert.ToInt32(hdReqId.Value);
            aStockInTransfar.ReqChildId = Convert.ToInt32(issueGridView.DataKeys[i][0].ToString());
            aStockInTransfar.ProductCode = issueGridView.Rows[i].Cells[0].Text.Trim();
            aStockInTransfar.ProductName = issueGridView.Rows[i].Cells[1].Text.Trim();
            aStockInTransfar.PackSize = issueGridView.Rows[i].Cells[2].Text.Trim();
            aStockInTransfar.BatchNo = issueGridView.Rows[i].Cells[3].Text.Trim();

            aStockInTransfar.UnitPrice = Convert.ToDecimal(issueGridView.Rows[i].Cells[5].Text.Trim());

            TextBox issueQtyTextBox = (TextBox)issueGridView.Rows[i].Cells[6].FindControl("issueQtyTextBox");
            aStockInTransfar.Quantity = Convert.ToDecimal(issueQtyTextBox.Text.Trim());
           
            TextBox priceTextBox = (TextBox)issueGridView.Rows[i].Cells[7].FindControl("priceTextBox");
            aStockInTransfar.PriceAmount = Convert.ToDecimal(priceTextBox.Text.Trim());
            TextBox vatTextBox = (TextBox)issueGridView.Rows[i].Cells[8].FindControl("vatTextBox");
            aStockInTransfar.VATAmount = Convert.ToDecimal(vatTextBox.Text.Trim());
            TextBox totalPriceTextBox = (TextBox)issueGridView.Rows[i].Cells[9].FindControl("totalPriceTextBox");
            aStockInTransfar.TotalPriceAmount = Convert.ToDecimal(totalPriceTextBox.Text.Trim());
            aStockInTransfar.IsIssue = "OK";
             
                aStockInTransfarList.Add(aStockInTransfar);
            }
       }

       string msg = aRequisitionBll.UpdateStockTransfarInfoUpdate(aStockInTransfarList);

       Clear();
       showMessageBox(msg);
   }

    private void Clear()
    {
        reqNoTextBox.Text = "";
        reqDateTextBox.Text = "";
        truckNoTextBox.Text = "";
        driverNameTextBox.Text = "";
        clnDateTextBox.Text = "";
        clnNoTextBox.Text = "";
        issueGridView.DataSource = null;
        issueGridView.DataBind();
        totalAllPriceTextBox.Text = "";
        vatAllPriceTextBox.Text = "";
        grandTotalTextBox.Text = "";
        pikDateTextBox.Text = "";
        pikNoTextBox.Text = "";

    }
    protected void bmitButton_Click(object sender, EventArgs e)
    {
        //if (driverNameTextBox.Text.Trim() != "" && truckNoTextBox.Text.Trim() != "")
        //{
             SaveData();
        //}
        //else
        //{
        //    showMessageBox("Please Select Driver Name and Truck No!!");
        //}
       
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        Response.Redirect("ViewRequisitionForIssue.aspx");
    }
}