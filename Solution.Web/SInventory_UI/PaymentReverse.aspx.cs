using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_PaymentReverse : System.Web.UI.Page
{

    PaymentReverseDal aDal = new PaymentReverseDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
        }
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (orderNoTextBox.Text != "")
        {
            DataTable aTable = aDal.GetOrderInformationByOrderNo(orderNoTextBox.Text.Trim());

            if (aTable.Rows.Count > 0)
            {
                Int32 inoiceId = Convert.ToInt32(aTable.Rows[0]["InvoiceId"]);
                bool pst = ResetInvoicePaymentStatus(inoiceId);
                bool payment = DeleteCustomerPaymentInfo(inoiceId);

                if (pst && payment)
                {
                    orderNoTextBox.Text = "";
                    ShowMessageBox("Payment Reverse Succesfully Done !!!");
                }
            }
            else
            {
                ShowMessageBox("No Information Found !!!");
            }
        }
        else
        {
            ShowMessageBox("Please Insert Order No !!!");
        }
    }

    private bool DeleteCustomerPaymentInfo(int inoiceId)
    {
        DataTable aTable = aDal.GetPaymentInfoByInvoiceId(inoiceId);

        bool status = false;

        if (aTable.Rows.Count > 0)
        {
            aDal.DeletePaymentMaster(Convert.ToInt32(aTable.Rows[0]["CustPayId"]));
            status = aDal.DeletePaymentDetail(Convert.ToInt32(aTable.Rows[0]["CustPayId"]));
        }

        return status;

    }

    private bool ResetInvoicePaymentStatus(int inoiceId)
    {
        return aDal.ResetInvoicePaymentStatus(inoiceId);
    }

    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void Unnamed_Click(object sender, EventArgs e)
    {
        Response.Redirect("PaymentReverse.aspx");
    }
}