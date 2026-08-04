using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SubDepot_UI_SubDeportCustomerPayment : System.Web.UI.Page
{
    private CustPaymentBLL aCustPaymentBll = new CustPaymentBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDownList();
            paymentDtTextBox.Text = Convert.ToDateTime(DateTime.Now).ToString("dd-MMM-yyyy");
        }
    }

    public void Clear()
    {
        orderGridView.DataSource = null;
        orderGridView.DataBind();
        salesCenterDropDownList.SelectedIndex = 0;
        marketDropDownList.SelectedIndex = 0;
        customerDropDownList.SelectedIndex = 0;
      //  paymentDtTextBox.Text = string.Empty;
        paymentAmountTextBox.Text = string.Empty;
        refDtTextBox.Text = string.Empty;
        refNameTextBox.Text = string.Empty;
       // payTypeDDL.SelectedIndex = 0;
        customerTextBox.Text = string.Empty;
        payTypeDDL.SelectedIndex = 1;

    }

    public void DropDownList()
    {
        aCustPaymentBll.LoadSC(salesCenterDropDownList,Session["UserId"].ToString());
        aCustPaymentBll.PaymentTypeLoadBLL(payTypeDDL);
        payTypeDDL.SelectedIndex = 1;

    }

    protected void salesCenterDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustPaymentBll.LoadMarket(marketDropDownList, salesCenterDropDownList.SelectedValue);
        orderGridView.DataSource = null;
        orderGridView.DataBind();
    }
    protected void customerTextBox_TextChanged(object sender, EventArgs e)
    {
        CustomerMaster aCustomerMaster;
        var CustomerID = CustomerId(out aCustomerMaster);
        DataTable dt = aCustPaymentBll.LoadInvoice(salesCenterDropDownList.SelectedValue,
         CustomerID.ToString()
          , marketDropDownList.SelectedValue);

        if (dt.Rows.Count > 0)
        {
            orderGridView.DataSource = dt;
            orderGridView.DataBind();
        }

        else
        {
            orderGridView.DataSource = null;
            orderGridView.DataBind();
            showMessageBox("No Invoice Found!!");
        }
    }

    private int CustomerId(out CustomerMaster aCustomerMaster)
    {
        int CustomerID = 0;
        aCustomerMaster = new CustomerMaster();
        aCustomerMaster = aCustPaymentBll.CustomerLoad(customerTextBox.Text.Trim());
        CustomerID = aCustomerMaster.CustomerMasterId;
        return CustomerID;
    }

    protected void customerDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
      
    }

    protected void marketDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        aCustPaymentBll.LoadCustomerMaster(customerDropDownList, marketDropDownList.SelectedValue);
        orderGridView.DataSource = null;
        orderGridView.DataBind();

        CustomerMaster aCustomerMaster;
        var CustomerID = CustomerId(out aCustomerMaster);
        DataTable dt = aCustPaymentBll.LoadSubDeportInvoice(salesCenterDropDownList.SelectedValue,
         marketDropDownList.SelectedValue);

        if (dt.Rows.Count > 0)
        {
            orderGridView.DataSource = dt;
            orderGridView.DataBind();

        }

        else
        {
            orderGridView.DataSource = null;
            orderGridView.DataBind();
            showMessageBox("No Invoice Found!!");
        }

    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        CheckBox ChkBoxHeader = (CheckBox) orderGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox) orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxHeader.Checked == true)
            {
                ChkBoxRows.Checked = true;
                TotalPaymentAmount();
            }
            else
            {
                ChkBoxRows.Checked = false;
                paymentAmountTextBox.Text = string.Empty;
            }
        }
    }

    public bool Validation()
    {
        int CK = 0;
        for (int j = 0; j < orderGridView.Rows.Count; j++)
        {
            CheckBox cbReject = (CheckBox)orderGridView.Rows[j].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                CK = CK + 1;
            }
        }
        if (CK == 0)
        {
            showMessageBox("Please Select Invoice from List!!");
            return false;
        }
        int count = 0;
        if (orderGridView.Rows.Count > 0)
        {
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {

                if (((CheckBox)orderGridView.Rows[i].Cells[1].FindControl("chkSelect")).Checked)
                {
                    if (((TextBox)orderGridView.Rows[i].FindControl("payAmountTextBox")).Text == "")
                    {
                        showMessageBox("Please fill out Pay Amount !!");
                        return false;
                    }
                    count++;
                }
            }
        }

        if (paymentAmountTextBox.Text.Trim() == "")
        {
            showMessageBox("Please Select Payment Amount!!");
            return false;
        }

        decimal totalamount = 0;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
             CheckBox cbReject = (CheckBox)orderGridView.Rows[i].FindControl("chkSelect");
            if (cbReject.Checked)
            {
                TextBox payAmountTextBox = (TextBox) orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");
                totalamount += Convert.ToDecimal((payAmountTextBox.Text));
            }

        }
        if (totalamount != Convert.ToDecimal((paymentAmountTextBox.Text)))
        {
            showMessageBox("Total Invoice Payment Amount Must Be Equel To Payment Amount");
            return false;
        }
        if (payTypeDDL.SelectedValue == "")
        {
            showMessageBox("Please Select Payment Type!!");
            return false;
        }
        if (paymentDtTextBox.Text == "")
        {
            showMessageBox("Please Select Payment Date!!");
            return false;
        }
        //if (customerTextBox.Text.Trim() == "")
        //{
        //    showMessageBox("Please Select Customer!!");
        //    return false;
        //}
       
        return true;
    }

    protected void saveButton_Click(object sender, EventArgs e)
    {
        if (Validation())
        {
            


            List<CustPaymentDetail> aCustPaymentDetails = new List<CustPaymentDetail>();
            List<CustPayment> aCustPayments = new List<CustPayment>();
            for (int i = 0; i < orderGridView.Rows.Count; i++)
            {



                CheckBox ChkBoxRows = (CheckBox) orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
                TextBox payAmountTextBox = (TextBox) orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");
                decimal prevamount = 0;
                if (orderGridView.Rows[i].Cells[6].Text != "&nbsp;")
                {
                     prevamount = Convert.ToDecimal(orderGridView.Rows[i].Cells[8].Text);
                }

                if (ChkBoxRows.Checked)
                {
                    CustomerMaster aCustomerMaster;
                    CustPayment aCustPayment = new CustPayment();
                    aCustPayment.CustomerMasterId = Convert.ToInt32(orderGridView.DataKeys[i][1].ToString());
                    aCustPayment.MarketId = Convert.ToInt32(marketDropDownList.SelectedValue);
                    aCustPayment.ComUnitId = Convert.ToInt32(salesCenterDropDownList.SelectedValue);
                    aCustPayment.PaymentDate = Convert.ToDateTime(paymentDtTextBox.Text);
                    aCustPayment.PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text);
                    aCustPayment.PayType = payTypeDDL.SelectedItem.Text;
                    aCustPayment.RefNo = refNameTextBox.Text;
                    if (refDtTextBox.Text != "")
                    {
                        aCustPayment.RefDate = Convert.ToDateTime(refDtTextBox.Text);
                    }
                    aCustPayment.CreateBy = Session["LoginName"].ToString();
                    aCustPayment.CreateDate = DateTime.Now;


                    if ((Convert.ToDecimal(payAmountTextBox.Text) + prevamount) ==
                        Convert.ToDecimal(orderGridView.Rows[i].Cells[7].Text))
                    {
                        decimal totalamount = 0;
                        totalamount = (Convert.ToDecimal(payAmountTextBox.Text) + prevamount);
                        aCustPaymentBll.SubdeportUpdateInvoicePaymentAmount(totalamount.ToString(), "Full",
                            orderGridView.DataKeys[i][0].ToString());
                    }
                    else
                    {
                        decimal totalamount = 0;
                        totalamount = (Convert.ToDecimal(payAmountTextBox.Text) + prevamount);
                        aCustPaymentBll.SubdeportUpdateInvoicePaymentAmount(totalamount.ToString(), "Partial",
                            orderGridView.DataKeys[i][0].ToString());
                    }
                    CustPaymentDetail aCustPaymentDetail = new CustPaymentDetail()
                    {
                        InvoiceId = Convert.ToInt32(orderGridView.DataKeys[i]["InvoiceId"].ToString()),
                        PaymentAmount = Convert.ToDecimal(payAmountTextBox.Text),


                    };
                    //aCustPaymentDetails.Add(aCustPaymentDetail);
                    //aCustPayments.Add(aCustPayment);
                    aCustPaymentBll.SubdeportSaveCustPayment(aCustPayment, aCustPaymentDetail);

                }
            }

            showMessageBox("Data Saved Successfully !!!!!");
            Clear();
            
        }
    }
    protected void payAmountTextBox_TextChanged(object sender, EventArgs e)
    {
        TextBox qtyTextBox = (TextBox)sender;
        GridViewRow currentRow = (GridViewRow)qtyTextBox.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;
        decimal prevamount = 0;
        TextBox payAmountTextBox = (TextBox) orderGridView.Rows[rowindex].Cells[7].FindControl("payAmountTextBox");
        decimal mainamount = string.IsNullOrEmpty(payAmountTextBox.Text) ? 0 : Convert.ToDecimal(payAmountTextBox.Text);
        decimal delamount = Convert.ToDecimal(orderGridView.Rows[rowindex].Cells[7].Text);
        if (orderGridView.Rows[rowindex].Cells[6].Text != "&nbsp;")
        {
              prevamount =  Convert.ToDecimal(orderGridView.Rows[rowindex].Cells[8].Text);
        }
       
           
        if ((mainamount+prevamount)>delamount)
        {
            payAmountTextBox.Text = "0";
            showMessageBox("Cannot Be Greater then Invoice Quantity ");

        }
        TotalPaymentAmount();

    }

    public void TotalPaymentAmount()
    {
        decimal amnt = 0;
        for (int i = 0; i < orderGridView.Rows.Count; i++)
        {
            CheckBox ChkBoxRows = (CheckBox) orderGridView.Rows[i].Cells[0].FindControl("chkSelect");
            if (ChkBoxRows.Checked)
            {
                TextBox payAmountTextBox = (TextBox)orderGridView.Rows[i].Cells[7].FindControl("payAmountTextBox");

                amnt = amnt + (string.IsNullOrEmpty(payAmountTextBox.Text) ? 0 : Convert.ToDecimal(payAmountTextBox.Text));
            }
            

        }

        paymentAmountTextBox.Text = amnt.ToString("F");
    }


    protected void chkSelect_OnCheckedChanged(object sender, EventArgs e)
    {
        TotalPaymentAmount();
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("SubDeportCustomerPayment.aspx");
    }
}