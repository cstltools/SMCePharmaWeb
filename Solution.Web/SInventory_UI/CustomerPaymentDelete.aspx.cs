using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.MasterSetup_DAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_CustomerPaymentDelete : System.Web.UI.Page
{
    CustomerPaymentDeleteBLL customerPaymentDeleteBLL = new CustomerPaymentDeleteBLL();
    CustomerPaymentDeleteDAL custPaymentDeleteDAL = new CustomerPaymentDeleteDAL();
    OrderInfoBLL arderInfoBll = new OrderInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            DropDown();
        }
    }

    public void DropDown()
    {
        arderInfoBll.LoadSC(DepoNameDropDownList, Session["UserId"].ToString());
    }

    protected void DateTextBox_TextChanged(object sender, EventArgs e)
    {
        // Only load if BOTH dates have values
        if (!string.IsNullOrEmpty(fromDateTextBox.Text) &&
            !string.IsNullOrEmpty(toDateTextBox.Text) && DepoNameDropDownList.SelectedValue != "")
        {
            try
            {
                // Validate dates first
                DateTime fromDate, toDate;
                if (DateTime.TryParse(fromDateTextBox.Text, out fromDate) &&
                    DateTime.TryParse(toDateTextBox.Text, out toDate))
                {
                    if (fromDate > toDate)
                    {
                        showMessageBox("From Date cannot be after To Date");
                        return;
                    }

                    
                        // Load the invoices
                        customerPaymentDeleteBLL.LoadInvoicesByDateRange(
                        InvoiceNoDropDownList,
                        DepoNameDropDownList.SelectedValue,
                        fromDateTextBox.Text,
                        toDateTextBox.Text);
                    
                }
                else
                {
                    showMessageBox("Invalid date format");
                }
            }
            catch (Exception ex)
            {
                showMessageBox("Error loading invoices: " + ex.Message);
            }
        }

        else {
            InvoiceNoDropDownList.Items.Clear();

        }
    }
    

    public void Clear()
    {
        fromDateTextBox.Text = "";
        toDateTextBox.Text = "";
        InvoiceNoDropDownList.SelectedValue = "";
        DepoNameDropDownList.SelectedValue = "";

    }
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    public void depoNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        InvoiceNoDropDownList.Items.Clear();
        try
        { 
            
                using (DataTable dt = _seedRepo.GetRouteInfoforCustPayment(Convert.ToInt32(DepoNameDropDownList.SelectedValue)))
                {
                    rootDropDownList.DataSource = dt;

                    rootDropDownList.DataValueField = "DistributionRouteId";
                    rootDropDownList.DataTextField = "DistributionRouteName";
                    rootDropDownList.DataBind();
                    rootDropDownList.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    rootDropDownList.SelectedIndex = 0;
                }


             
 
        }
        catch (Exception ex)
        {

        }
    }

    public void invoiceNoDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {

        string InvoiceId = InvoiceNoDropDownList.SelectedValue;
        string comUnitId = DepoNameDropDownList.SelectedValue;

        invoiceGridView.DataSource = null;
        invoiceGridView.DataBind();

        DataTable dt = customerPaymentDeleteBLL.LoadData(Convert.ToInt32(InvoiceId));
        if (dt != null && dt.Rows.Count > 0)
        {
            DateTime latestDate = Convert.ToDateTime(dt.AsEnumerable()
                .Max(row => row["custPaymentDate"]));
            ViewState["LatestPaymentDate"] = latestDate;
        }
        invoiceGridView.DataSource = dt;
        invoiceGridView.DataBind();
    }

    protected void invoiceGridView_RowDataBound(object sender, GridViewRowEventArgs e)
    {
        if (e.Row.RowType == DataControlRowType.DataRow)
        {
            DateTime rowDate = Convert.ToDateTime(DataBinder.Eval(e.Row.DataItem, "custPaymentDate"));
            DateTime latestDate = (DateTime)ViewState["LatestPaymentDate"];

            Button btnDelete = (Button)e.Row.FindControl("btnDelete");
            if (btnDelete != null)
            {
                btnDelete.Enabled = rowDate == latestDate;
            }
        }
    }


    public void invoiceGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "DeleteRow")
        {
            int id = Convert.ToInt32(e.CommandArgument);

            int rowIndex = ((GridViewRow)((Control)e.CommandSource).NamingContainer).RowIndex;
            GridViewRow row = invoiceGridView.Rows[rowIndex];
            TextBox remarksTextBox = (TextBox)row.FindControl("remarksText");
            string remarks = remarksTextBox.Text;
            if (remarks!="")
            {
                try
                {

                    bool isDeleted = customerPaymentDeleteBLL.DeleteCustomerPaymentDetail(id, remarks, Session["LoginName"].ToString()); // call your BLL method

                    if (isDeleted)
                    {
                        showMessageBox("Record deleted successfully.");

                        // Rebind the grid after deletion
                        string invoiceId = InvoiceNoDropDownList.SelectedValue;
                        string comUnitId = DepoNameDropDownList.SelectedValue;
                        if (!string.IsNullOrEmpty(invoiceId))
                        {
                            invoiceGridView.DataSource = customerPaymentDeleteBLL.LoadData(Convert.ToInt32(invoiceId));
                            invoiceGridView.DataBind();
                        }
                    }
                    else
                    {
                        showMessageBox("Delete failed.");
                    }
                }
                catch (Exception ex)
                {
                    showMessageBox("Error: " + ex.Message);
                }
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

    
    protected void saveButton_Click(object sender, EventArgs e)
    {
        
    }
   

   

   
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CustomerPaymentDelete.aspx");
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        //lblCount.Text = "Total Pay Amount: 0";
        //LoadGridView();

    }


    protected void rootDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {

        InvoiceNoDropDownList.Items.Clear();

        customerPaymentDeleteBLL.LoadInvoicesByRoute(
                       InvoiceNoDropDownList,
                       DepoNameDropDownList.SelectedValue,
                       rootDropDownList.SelectedValue);
    }
}