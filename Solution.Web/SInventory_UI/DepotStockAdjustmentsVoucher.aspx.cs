using System;
using System.Collections.Generic;
using System.Data;
using System.Diagnostics.Eventing.Reader;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.BLL.SubDepot_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DerectStockOut : System.Web.UI.Page
{
 

    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    SubDepotChalanBLL aChalanBll = new SubDepotChalanBLL();
    DeStockOutBLL aDeStockOutBll = new DeStockOutBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // Todate();
            aDeStockOutBll.ProductLoadBll(productDropDownList);
            aDeStockOutBll.DistributionCenterLoadBll(DistributioncenterDropDownList1);
            
           
        }

    }

    protected void ListImageButton_Click(object sender, EventArgs e)
    {

        Response.Redirect("DepotStockAdjustmentsVoucherView.aspx");
   
    }

    protected void ProformaInvoice_TextChanged(object sender, EventArgs e)
    {
        string Perticular = txtproformaInvoice.Text.Trim();


        if (Perticular.Contains(':'))
        {
            string[] emp = Perticular.Split(':');
            HiddenField1.Value = emp[0];
            txtproformaInvoice.Text = emp[1];
            string id = HiddenField1.Value;


          //  ProformaInvoiceNumDropDownList.SelectedValue = id;

        }
        else
        {
          //  ProformaInvoiceNumDropDownList.SelectedValue = "";
            HiddenField1.Value ="";
            txtproformaInvoice.Text ="";
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

                Label lbl_StockQty = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_StockQty");
                
                TextBox transferQtyTextBox = (TextBox)DerectStoctOutGridView.Rows[i].FindControl("transferQtyTextBox");
                int rowindex = i;
                decimal mainqty = 0;
                decimal delqty = 0;
                delqty =
                    string.IsNullOrEmpty(
                        (transferQtyTextBox.Text))
                        ? 0
                        : Convert.ToDecimal(
                            (transferQtyTextBox.Text));

                mainqty = string.IsNullOrEmpty(lbl_StockQty.Text)
                    ? 0
                    : Convert.ToDecimal(lbl_StockQty.Text);
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
        DataTable dtdata = aChalanBll.GetProductDcStoreSubdeport(productDropDownList.SelectedValue, ComUnitCodeTextBox.Text);
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
        //if (DistributioncenterDropDownList1.SelectedValue != "")
        //{
        //    aDeStockOutBll.ProformaInvoiceNumberBll(ProformaInvoiceNumDropDownList, DistributioncenterDropDownList1.SelectedValue);

        //}
        txtproformaInvoice.Text = "";
        HiddenField1.Value = "";
        if (DistributioncenterDropDownList1.SelectedValue != "")
        {
            txtproformaInvoice.ReadOnly = false;
            Session["ComUnitId"] = null;
            Session["ComUnitId"] = DistributioncenterDropDownList1.SelectedValue;

            string unitCode = DistributioncenterDropDownList1.SelectedItem.Text.Split(':')[0];
            ComUnitCodeTextBox.Text = unitCode;
        }
        else
        {
            txtproformaInvoice.Text = "";
            txtproformaInvoice.ReadOnly = true;
        }
       
    }
    
    
    public void Todate()
    {
        StockOutTextBox.Text = DateTime.Today.ToShortDateString();
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
 //       ProformaInvoiceNumDropDownList.SelectedValue = string.Empty;
        productDropDownList.SelectedValue = string.Empty;
        DistributioncenterDropDownList1.SelectedValue = string.Empty;
        chalanGridView.DataBind();
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
        if (HiddenField1.Value.Trim() == "")
        {
            showMessageBox("Please Select Invoice Number!!");
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



        if (chalanGridView.Rows.Count < 1)
        {
            showMessageBox("Please Add Product and Stoct Out Qty..!!");
            return false;
        }
        return true;
    }
    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            DcStockOutMasterDao aDcStockOutMasterDao = new DcStockOutMasterDao()
            {
                ComUnitId = Convert.ToInt32(DistributioncenterDropDownList1.SelectedValue),
                InvoiceId = Convert.ToInt32(HiddenField1.Value),
                StockOutDate = Convert.ToDateTime(StockOutTextBox.Text.Trim()),
                Reason = txtReason.Text.Trim(),
                EntryBy = Session["LoginName"].ToString(),
                EntryDate = Convert.ToDateTime(DateTime.Now),
                Status ="Posted",
                CustomerCode = customerTextBox.Text.Trim(),

            };
   
            int DcStockOutMasterId;
            bool status = aDeStockOutBll.SaveDataForDcStockOutMasterBll(aDcStockOutMasterDao, out DcStockOutMasterId);


            List<DcStockOutDetailsDao> aStockOutDetailsDaoList = new List<DcStockOutDetailsDao>();

            if (status == true)
            {
                for (int i = 0; i < chalanGridView.Rows.Count; i++)
                {

                    Label lbl_ProductCode = (Label)chalanGridView.Rows[i].FindControl("lbl_ProductCode");
                    Label lbl_ProductName = (Label)chalanGridView.Rows[i].FindControl("lbl_ProductName");
                    Label lbl_StackOutQty = (Label)chalanGridView.Rows[i].FindControl("lbl_StackOutQty");
                    Label lbl_BatchNo2 = (Label)chalanGridView.Rows[i].FindControl("lbl_BatchNo2");
                    Label lbl_ExpDate2 = (Label)chalanGridView.Rows[i].FindControl("lbl_ExpDate2");
                    Label lbl_ReceiveDate2 = (Label)chalanGridView.Rows[i].FindControl("lbl_ReceiveDate2");
                    DcStockOutDetailsDao aStockOutDetailsDao = new DcStockOutDetailsDao()
                    {
                        DcStockOutMasterId = DcStockOutMasterId,
                        DcStoreId = Convert.ToInt32(chalanGridView.DataKeys[i][0].ToString()),
                        PackSize = chalanGridView.DataKeys[i][1].ToString(),
                        ProductCode = lbl_ProductCode.Text,
                        ProductName = lbl_ProductName.Text,
                        BatchNo = lbl_BatchNo2.Text,
                        StackOutQty = Convert.ToInt32(lbl_StackOutQty.Text),
                        ExpDate = Convert.ToDateTime(lbl_ExpDate2.Text),
                        ReceiveDate = Convert.ToDateTime(lbl_ReceiveDate2.Text),
                    };
                    aStockOutDetailsDaoList.Add(aStockOutDetailsDao);
                }

                if (aDeStockOutBll.SaveDataForStockOutDetailBll(aStockOutDetailsDaoList))
                {
                    

                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','DepotStockAdjustmentsVoucherView.aspx');", true);
                }

            }


        }

    }

   






  

    public bool HasDCStoreId(int dcstoreId)
    {
        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            if (Convert.ToInt32(chalanGridView.DataKeys[i][0].ToString()) == dcstoreId)
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
        aDataTable.Columns.Add("DCStoreId");
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

        
            Label lbl_PCode = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_PCode");
            Label lbl_PName = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_PName");
            Label lbl_StockQty = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_StockQty");
            Label lbl_BatchNo = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_BatchNo");
            Label lbl_ExpDate = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_ExpDate");
            Label lbl_ReceiveDate = (Label)DerectStoctOutGridView.Rows[i].FindControl("lbl_ReceiveDate");
            TextBox transferQtyTextBox = (TextBox)DerectStoctOutGridView.Rows[i].FindControl("transferQtyTextBox");
            if (ChkBoxRows.Checked && ((TextBox)DerectStoctOutGridView.Rows[i].Cells[6].FindControl("transferQtyTextBox")).Text.Trim() != "")
            {
                if (HasDCStoreId(Convert.ToInt32(DerectStoctOutGridView.DataKeys[i][0].ToString())))
                {
                    dataRow = aDataTable.NewRow();
                    dataRow["ProductCode"] = lbl_PCode.Text;
                    dataRow["ProductName"] = lbl_PName.Text;
                    dataRow["BatchNo"] = lbl_BatchNo.Text;

                    dataRow["StackOutQty"] =
                        transferQtyTextBox.Text;
             
                    dataRow["ExpDate"] = lbl_ExpDate.Text;
                    dataRow["ReceiveDate"] = lbl_ReceiveDate.Text;
           
                    dataRow["DCStoreId"] = DerectStoctOutGridView.DataKeys[i][0].ToString();
                    dataRow["PackSize"] = DerectStoctOutGridView.DataKeys[i][1].ToString();

                    aDataTable.Rows.Add(dataRow);
                }
            }
        }
        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {


            Label lbl_ProductCode = (Label)chalanGridView.Rows[i].FindControl("lbl_ProductCode");
            Label lbl_ProductName = (Label)chalanGridView.Rows[i].FindControl("lbl_ProductName");
            Label lbl_StackOutQty = (Label)chalanGridView.Rows[i].FindControl("lbl_StackOutQty");
            Label lbl_BatchNo2 = (Label)chalanGridView.Rows[i].FindControl("lbl_BatchNo2");
            Label lbl_ExpDate2 = (Label)chalanGridView.Rows[i].FindControl("lbl_ExpDate2");
            Label lbl_ReceiveDate2 = (Label)chalanGridView.Rows[i].FindControl("lbl_ReceiveDate2");
           

            dataRow = aDataTable.NewRow();

      
            dataRow["ProductCode"] = lbl_ProductCode.Text;
            dataRow["ProductName"] = lbl_ProductName.Text;
            dataRow["BatchNo"] = lbl_BatchNo2.Text;
            dataRow["StackOutQty"] = lbl_StackOutQty.Text;
            dataRow["ExpDate"] = lbl_ExpDate2.Text;
            dataRow["ReceiveDate"] = lbl_ReceiveDate2.Text;
            dataRow["DCStoreId"] = chalanGridView.DataKeys[i][0].ToString();
            dataRow["PackSize"] = chalanGridView.DataKeys[i][1].ToString();

            aDataTable.Rows.Add(dataRow);
        }

        chalanGridView.DataSource = aDataTable;
        chalanGridView.DataBind();
    }
    protected void DeleteImageButton_Click(object sender, ImageClickEventArgs e)
    {
        ImageButton productCodeTextBox = (ImageButton)sender;
        GridViewRow currentRow = (GridViewRow)productCodeTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DCStoreId");
        aDataTable.Columns.Add("ProductCode");
        aDataTable.Columns.Add("ProductName");
        aDataTable.Columns.Add("StackOutQty");
        aDataTable.Columns.Add("BatchNo");
        aDataTable.Columns.Add("ExpDate");
        aDataTable.Columns.Add("ReceiveDate");
        aDataTable.Columns.Add("PackSize");

        DataRow dataRow = null;
        for (int i = 0; i < chalanGridView.Rows.Count; i++)
        {
            if (i != rowindex)
            {


                Label lbl_ProductCode = (Label)chalanGridView.Rows[i].FindControl("lbl_ProductCode");
                Label lbl_ProductName = (Label)chalanGridView.Rows[i].FindControl("lbl_ProductName");
                Label lbl_StackOutQty = (Label)chalanGridView.Rows[i].FindControl("lbl_StackOutQty");
                Label lbl_BatchNo2 = (Label)chalanGridView.Rows[i].FindControl("lbl_BatchNo2");
                Label lbl_ExpDate2 = (Label)chalanGridView.Rows[i].FindControl("lbl_ExpDate2");
                Label lbl_ReceiveDate2 = (Label)chalanGridView.Rows[i].FindControl("lbl_ReceiveDate2");
                dataRow = aDataTable.NewRow();
                dataRow["ProductCode"] = lbl_ProductCode.Text;
                dataRow["ProductName"] = lbl_ProductName.Text;
                dataRow["BatchNo"] = lbl_BatchNo2.Text;
                dataRow["StackOutQty"] = lbl_StackOutQty.Text;
                dataRow["ExpDate"] = lbl_ExpDate2.Text;
                dataRow["ReceiveDate"] = lbl_ReceiveDate2.Text;
                dataRow["DCStoreId"] = chalanGridView.DataKeys[i][0].ToString();
                dataRow["PackSize"] = chalanGridView.DataKeys[i][1].ToString();

                aDataTable.Rows.Add(dataRow);
            }

        }

        chalanGridView.DataSource = aDataTable;
        chalanGridView.DataBind();

    }



    protected void salescenterDropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {

    }

    protected void lblcancel_OnClick(object sender, EventArgs e)
    { 
    }

    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
         
    }

    protected void ProformaInvoiceNumDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        //HiddenField1.Value = ProformaInvoiceNumDropDownList.SelectedValue;
        //txtproformaInvoice.Text = ProformaInvoiceNumDropDownList.SelectedItem.Text;
       
         
    }
}