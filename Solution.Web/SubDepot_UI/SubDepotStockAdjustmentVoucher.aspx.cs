using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;
using Library.DAO.SInventory_Entities;
using Library.DAO.SubDepot_DAO;

public partial class SubDepot_UI_SubDepotStockAdjustmentVoucher : System.Web.UI.Page
{
    
    SubDepotChalanBLL aChalanBll = new SubDepotChalanBLL();
    SubDepotStockAdjustmentsVoucherBll aBLL = new SubDepotStockAdjustmentsVoucherBll();


    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            aBLL.ProductLoadBll(productDropDownList);
            aBLL.DistributionCenterLoadBll(DistributioncenterDropDownList1);
        }

    }

    protected void ListImageButton_Click(object sender, EventArgs e)
    {

        Response.Redirect("SubDepotStockAdjustmentVoucherView.aspx");
   
    }

    public bool HasSubDCStoreId(int dcstoreId)
    {
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            if (Convert.ToInt32(ProductGridView.DataKeys[i][0].ToString()) == dcstoreId)
            {
                return false;
                break;
            }
        }
        return true;
    }
    protected void addButton_Click(object sender, EventArgs e)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SubDCStoreId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("StackOutQty");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("ReceiveDate");
        aDataTable.Columns.Add("PackSize");

        DataRow dataRow = null;
        for (int i = 0; i < DerectStoctOutGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)DerectStoctOutGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked && ((TextBox)DerectStoctOutGridView.Rows[i].Cells[6].FindControl("transferQtyTextBox")).Text.Trim() != "")
            {
                if (HasSubDCStoreId(Convert.ToInt32(DerectStoctOutGridView.DataKeys[i][0].ToString())))
                {
                    dataRow = aDataTable.NewRow();
                    dataRow["ProductCode"] = DerectStoctOutGridView.Rows[i].Cells[1].Text;
                    dataRow["ProductName"] = DerectStoctOutGridView.Rows[i].Cells[2].Text;
                    dataRow["BatchNo"] = DerectStoctOutGridView.Rows[i].Cells[4].Text;

                    dataRow["StackOutQty"] =
                        ((TextBox)DerectStoctOutGridView.Rows[i].Cells[6].FindControl("transferQtyTextBox")).Text.Trim();

                    dataRow["ExpDate"] = DerectStoctOutGridView.Rows[i].Cells[5].Text;
                    dataRow["ReceiveDate"] = DerectStoctOutGridView.Rows[i].Cells[6].Text;

                    dataRow["SubDCStoreId"] = DerectStoctOutGridView.DataKeys[i][0].ToString();
                    dataRow["PackSize"] = DerectStoctOutGridView.DataKeys[i][1].ToString();

                    aDataTable.Rows.Add(dataRow);
                }
            }
        }
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();
            dataRow["ProductCode"] = ProductGridView.Rows[i].Cells[0].Text;
            dataRow["ProductName"] = ProductGridView.Rows[i].Cells[1].Text;
            dataRow["BatchNo"] = ProductGridView.Rows[i].Cells[2].Text;
            dataRow["StackOutQty"] = ProductGridView.Rows[i].Cells[4].Text;
            dataRow["ExpDate"] = ProductGridView.Rows[i].Cells[5].Text;
            dataRow["ReceiveDate"] = ProductGridView.Rows[i].Cells[6].Text;
            dataRow["SubDCStoreId"] = ProductGridView.DataKeys[i][0].ToString();
            dataRow["PackSize"] = ProductGridView.DataKeys[i][1].ToString();
            aDataTable.Rows.Add(dataRow);
        }

        ProductGridView.DataSource = aDataTable;
        ProductGridView.DataBind();
    }

    protected void DeleteImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SubDCStoreId");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("StackOutQty");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("ReceiveDate");
       

        DataRow dataRow = null;
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            if (i != rowindex)
            {
                dataRow = aDataTable.NewRow();
                dataRow["ProductCode"] = ProductGridView.Rows[i].Cells[0].Text;
                dataRow["ProductName"] = ProductGridView.Rows[i].Cells[1].Text;
                dataRow["StackOutQty"] = ProductGridView.Rows[i].Cells[2].Text;
                dataRow["BatchNo"] = ProductGridView.Rows[i].Cells[3].Text;
                dataRow["ExpDate"] = ProductGridView.Rows[i].Cells[4].Text;
                dataRow["ReceiveDate"] = ProductGridView.Rows[i].Cells[5].Text;
                dataRow["SubDCStoreId"] = ProductGridView.DataKeys[i][0].ToString();
                dataRow["PackSize"] = ProductGridView.DataKeys[i][1].ToString();
              
                aDataTable.Rows.Add(dataRow);
            }

        }

        ProductGridView.DataSource = aDataTable;
        ProductGridView.DataBind();

    }

    protected void SubDepotInvoice_TextChanged(object sender, EventArgs e)
    {
        string Perticular = txtSubDepotInvoice.Text.Trim();


        if (Perticular.Contains(':'))
        {
            string[] emp = Perticular.Split(':');
            HiddenField1.Value = emp[0];
            txtSubDepotInvoice.Text = emp[1];
            string id = HiddenField1.Value;


            ProformaInvoiceNumDropDownList.SelectedValue = id;

        }
        else
        {
            ProformaInvoiceNumDropDownList.SelectedValue = "";
            HiddenField1.Value ="";
            txtSubDepotInvoice.Text = "";
            showMessageBox("Please Enter valid Data!!....");

        }



    }

    protected void dQtyTextBox_TextChanged(object sender, EventArgs e)
    {
        for (int i = 0; i < DerectStoctOutGridView.Rows.Count; i++)
        {
            CheckBox cbReject = (CheckBox)DerectStoctOutGridView.Rows[i].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                int rowindex = i;
                decimal mainqty = 0;
                decimal delqty = 0;
                delqty =
                    string.IsNullOrEmpty(
                        ((TextBox)DerectStoctOutGridView.Rows[rowindex].Cells[3].FindControl("transferQtyTextBox")).Text)
                        ? 0
                        : Convert.ToDecimal(
                            ((TextBox)DerectStoctOutGridView.Rows[rowindex].Cells[3].FindControl("transferQtyTextBox")).Text);

                mainqty = string.IsNullOrEmpty(DerectStoctOutGridView.Rows[i].Cells[3].Text)
                    ? 0
                    : Convert.ToDecimal(DerectStoctOutGridView.Rows[i].Cells[3].Text);
                if (delqty <= mainqty)
                {

                }
                else
                {
                    showMessageBox("Stock Out Qty. cantbe more then Stock Quantity");
                    ((TextBox)DerectStoctOutGridView.Rows[rowindex].Cells[3].FindControl("transferQtyTextBox")).Text =
                        string.Empty;
                }
            }
           
        }
       
       
        
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        DataTable dtdata = aBLL.GetProductDcStoreSubdeport(productDropDownList.SelectedValue);
        if (dtdata.Rows.Count > 0)
        {
            DerectStoctOutGridView.DataSource = dtdata;
            DerectStoctOutGridView.DataBind();
        }
        else
        {
            showMessageBox("No Product Found!!");
        }

    }

    protected void DistributioncenterDropDownList1_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        if (DistributioncenterDropDownList1.SelectedValue != "")
        {
            aBLL.ProformaInvoiceNumberBll(ProformaInvoiceNumDropDownList, DistributioncenterDropDownList1.SelectedValue);
   
        }

        Session["ComUnitId"] = null;
        Session["ComUnitId"] = DistributioncenterDropDownList1.SelectedValue;

        string unitCode = DistributioncenterDropDownList1.SelectedItem.Text.Split(':')[0];
        ComUnitCodeTextBox.Text = unitCode;
       
    }
    
   
    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox)DerectStoctOutGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < DerectStoctOutGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox)DerectStoctOutGridView.Rows[i].Cells[0].FindControl("chkSelect");
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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public void Clear()
    {

        StockOutTextBox.Text = string.Empty;
        txtReason.Text = string.Empty;
        ProformaInvoiceNumDropDownList.SelectedValue = string.Empty;
        productDropDownList.SelectedValue = string.Empty;
        DistributioncenterDropDownList1.SelectedValue = string.Empty;
                 ProductGridView.DataBind();
        DerectStoctOutGridView.DataSource = null;
        DerectStoctOutGridView.DataBind();

    }
    public bool Validation()
    {
       
        
        if (DistributioncenterDropDownList1.SelectedValue == "")
        {
            showMessageBox("Please Select Distribution center!!");
            return false;
        }
        if (ProformaInvoiceNumDropDownList.Text.Trim() == "")
        {
            showMessageBox("Please Select Proforma Invoice Number!!");
            return false;
        }
        if (StockOutTextBox.Text.Trim() == "")
        {
            showMessageBox("Please Insert Stock Out Date!!");
            return false;
        }

        if (txtReason.Text == "")
        {
            showMessageBox("Please Insert Reason!!");
            return false;
        }

        if (productDropDownList.Text.Trim() == "")
        {
            showMessageBox("Please Select Product!!");
            return false;
        }


        if (         ProductGridView.Rows.Count < 1)
        {
            showMessageBox("Please Add product and Stock Out Qty");
            return false;
        }
        return true;
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            SubdepotStockOutMasterDao aDcStockOutMasterDao = new SubdepotStockOutMasterDao()
            {
                ComUnitId = Convert.ToInt32(DistributioncenterDropDownList1.SelectedValue),
                InvoiceId = Convert.ToInt32(ProformaInvoiceNumDropDownList.SelectedValue),
                StockOutDate = Convert.ToDateTime(StockOutTextBox.Text.Trim()),
                Reason = txtReason.Text.Trim(),
                EntryBy = Session["LoginName"].ToString(),
                EntryDate = Convert.ToDateTime(DateTime.Now),
                Status = "Posted",

            };

            int SubDcStockOutMasterId;
            bool status = aBLL.SaveDataForSubDcStockOutMasterBll(aDcStockOutMasterDao, out SubDcStockOutMasterId);


            List<SubdepotStockOutDetailsDao> aStockOutDetailsDaoList = new List<SubdepotStockOutDetailsDao>();

            if (status == true)
            {
                for (int i = 0; i < ProductGridView.Rows.Count; i++)
                {
                    SubdepotStockOutDetailsDao aStockOutDetailsDao = new SubdepotStockOutDetailsDao()
                    {
                        SubDcStockOutMasterId = SubDcStockOutMasterId,
                        SubDCStoreId  = Convert.ToInt32(ProductGridView.DataKeys[i][0].ToString()),
                        ProductCode = ProductGridView.Rows[i].Cells[0].Text,
                        ProductName = ProductGridView.Rows[i].Cells[1].Text,
                        PackSize = ProductGridView.DataKeys[i][1].ToString(),
                        BatchNo = ProductGridView.Rows[i].Cells[2].Text,
                        ExpDate = Convert.ToDateTime(ProductGridView.Rows[i].Cells[4].Text),
                        ReceiveDate = Convert.ToDateTime(ProductGridView.Rows[i].Cells[5].Text),
                        StockOutQty = Convert.ToInt32(ProductGridView.Rows[i].Cells[3].Text),
                    };
                    aStockOutDetailsDaoList.Add(aStockOutDetailsDao);
                }

                if (aBLL.SaveDataForSubStockOutDetailBll(aStockOutDetailsDaoList))
                {
                    showMessageBox("Data save successfully");
                    Clear();

                    Response.Redirect("SubDepotStockAdjustmentVoucherView.aspx");
                }

            }

        }
    }


    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubDepotStockAdjustmentVoucher.aspx");
    }

    protected void LinkButton1_Click(object sender, EventArgs e)
    {
        LinkButton productCodeTextBox = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("SubDCStoreId");
        aDataTable.Columns.Add("PackSize");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("StackOutQty");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("ReceiveDate");


        DataRow dataRow = null;
        for (int i = 0; i < ProductGridView.Rows.Count; i++)
        {
            if (i != rowindex)
            {
                dataRow = aDataTable.NewRow();
                dataRow["ProductCode"] = ProductGridView.Rows[i].Cells[0].Text;
                dataRow["ProductName"] = ProductGridView.Rows[i].Cells[1].Text;
                dataRow["StackOutQty"] = ProductGridView.Rows[i].Cells[2].Text;
                dataRow["BatchNo"] = ProductGridView.Rows[i].Cells[3].Text;
                dataRow["ExpDate"] = ProductGridView.Rows[i].Cells[4].Text;
                dataRow["ReceiveDate"] = ProductGridView.Rows[i].Cells[5].Text;
                dataRow["SubDCStoreId"] = ProductGridView.DataKeys[i][0].ToString();
                dataRow["PackSize"] = ProductGridView.DataKeys[i][1].ToString();

                aDataTable.Rows.Add(dataRow);
            }

        }

        ProductGridView.DataSource = aDataTable;
        ProductGridView.DataBind();
    }
}