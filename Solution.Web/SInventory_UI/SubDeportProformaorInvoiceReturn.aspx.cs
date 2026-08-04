using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_SubDeportProformaorInvoiceReturn : System.Web.UI.Page
{
    ProformaOrInvoiceReturnBLL aInvoiceReturnBll = new ProformaOrInvoiceReturnBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            
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
        proformaInvoiceTextBox.Text = string.Empty;
        ProformaCheckBox.Checked = false;
        InvoiceCheckBox.Checked = false;
    }
    protected void ProformaCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        InvoiceCheckBox.Checked = false;
        proformaInvoiceTextBox.Text = string.Empty;
    }
    protected void InvoiceCheckBox_CheckedChanged(object sender, EventArgs e)
    {
        ProformaCheckBox.Checked = false;
        proformaInvoiceTextBox.Text = string.Empty;
    }
    

    protected void saveButton_Click(object sender, EventArgs e)
    {
        if (proformaInvoiceTextBox.Text != "" && ProformaCheckBox.Checked)
        {
            aInvoiceReturnBll.DeleteProformaSub(proformaInvoiceTextBox.Text.Trim());
            Clear();
            showMessageBox("Delete successfully !!");

        }
        if (proformaInvoiceTextBox.Text != "" && InvoiceCheckBox.Checked)
        {

            DataTable dt1 = new DataTable();
            dt1 = aInvoiceReturnBll.LoadDetailID(proformaInvoiceTextBox.Text.Trim());
            int Count = 0;

            for (int i = 0; i < dt1.Rows.Count; i++)
            {
                DataTable dt2 = new DataTable();
                dt2 = aInvoiceReturnBll.LoadStock(dt1.Rows[i]["InvoiceDetailId"].ToString());
                if (dt2.Rows.Count>0)
                {
                    Count = 1;
                    break;
                }
            }

            if (Count==0)
            {
                aInvoiceReturnBll.SubdepoDeleteDeliveyInvoiceDal(proformaInvoiceTextBox.Text.Trim());
             Clear();
             showMessageBox("Delete successfully !!");
            }
            else
            {
                showMessageBox("Stock Already Returned From Freeze Stock, Cant't Delete !!");
            }
        }
    }
    protected void proformaInvoiceTextBox_TextChanged(object sender, EventArgs e)
    {
        if (ProformaCheckBox.Checked)
        {
            bool chk= aInvoiceReturnBll.chkProformaSub(proformaInvoiceTextBox.Text.Trim());
            if (chk)
            {

            }
            else
            {
               // showMessageBox("No Proforma Found or Invoice Created!!");
               // proformaInvoiceTextBox.Text = string.Empty;
            }
        }
        if (InvoiceCheckBox.Checked)
        {
            //bool chk = aInvoiceReturnBll.chkInvoice(proformaInvoiceTextBox.Text.Trim());

            bool chk = aInvoiceReturnBll.chkSubInvoice(proformaInvoiceTextBox.Text.Trim());
            if (chk)
            {
            }
            else
            {
                ///showMessageBox("No Invoice Found!!");
                //proformaInvoiceTextBox.Text = string.Empty;
            }
        }
    }
}