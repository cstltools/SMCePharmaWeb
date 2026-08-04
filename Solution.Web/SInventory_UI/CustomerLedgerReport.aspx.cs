using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_CustomerLedgerReport : System.Web.UI.Page
{
    RequisitionBLL aRequisitionBll = new RequisitionBLL();
    CustomerMasterBLL aCustomerMasterBll = new CustomerMasterBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           
        }
    }
    protected void custNameTextBox_TextChanged(object sender, EventArgs e)
    {


        string empName = cCodeTextBox.Text.Trim();

        if (empName != "")
        {
            try
            {
                if (empName.Contains(':'))
                {
                    string[] emp = empName.Split('|');
                    string[] custCode = empName.Split(':');
                    hfCustomerId.Value = custCode[0].Trim();
                    cCodeTextBox.Text = emp[0].Trim();



                }
                else
                {

                    //custNameTextBox.Text = "";
                    hfCustomerId.Value = "";
                    //ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Input Correct Data !" + "','Faild');", true);


                }

            }
            catch
            {
                hfCustomerId.Value = "";
            }
        }

    }

    protected void viewRptButton_Click(object sender, EventArgs e)
    {

        if (hfCustomerId.Value.Trim() != "")
        {

            DateTime? fromDate = null;
            DateTime? toDate = null;

            // Check if fromDateTextBox.Text is not empty
            if (!string.IsNullOrEmpty(fromDateTextBox.Text))
            {
                fromDate = Convert.ToDateTime(fromDateTextBox.Text);
            }

            // Check if toDateTextBox.Text is not empty
            if (!string.IsNullOrEmpty(toDateTextBox.Text))
            {
                toDate = Convert.ToDateTime(toDateTextBox.Text);
            }
            string CustomerID = hfCustomerId.Value.Trim();
            string url = "../SInventory_RPTVIEW/CustomerLedgerViewer.aspx?CustomerID=" + CustomerID + "&fromDate=" + fromDate + "&toDate=" + toDate; 

            string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
            ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true); 
        }
        else
        {
            showMessageBox("Please Insert Valid Customer Code!!");
        }
      
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {

        Response.Redirect("CustomerLedgerReport.aspx");
    }

        protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
}