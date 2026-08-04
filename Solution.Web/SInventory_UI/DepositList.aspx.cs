using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DepositList : System.Web.UI.Page
{
    CompanywisebranchDal aDal = new CompanywisebranchDal();
    private const int DepositDeleteDays = 60;

    private DataTable DepositListTable
    {
        get { return ViewState["DepositListTable"] as DataTable; }
        set { ViewState["DepositListTable"] = value; }
    }

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            fromDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            toDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            Loaddropdownlist();
        }
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
    private void Loaddropdownlist()
    {
        aDal.LoadCompany(companyNameDropDownList, Session["UserId"].ToString());
        try
        {
            if (Session["RoleTypeName"].ToString() == "DIC")
            {
                companyNameDropDownList.SelectedIndex = 1;
            }
             
        }
        catch
        {

        }
    }

    protected void clearButton_OnClick(object sender, EventArgs e)
    {
        Loaddropdownlist();
        fromDateTextBox.Text = "";
        toDateTextBox.Text = "";

        invoiceGridView.DataSource = null;
        invoiceGridView.DataBind();
        DepositListTable = null;
        lblCount.Text = "Total Amount: 0";
    }

    private void LoadInfo()
    {
        invoiceGridView.DataSource = null;
        invoiceGridView.DataBind();
        DepositListTable = null;
        lblCount.Text = "Total Amount: 0";
        if (Validation())
        {
            DateTime fromDate = Convert.ToDateTime(fromDateTextBox.Text.Trim());
            DateTime toDate = Convert.ToDateTime(toDateTextBox.Text.Trim());
            DataTable aTable = aDal.LoadDepositList(fromDate, toDate, companyNameDropDownList.SelectedValue);

            if (aTable.Rows.Count > 0)
            {
                DepositListTable = aTable;
                BindDepositGrid(aTable);
            }
            else
            {
                invoiceGridView.DataSource = null;
                invoiceGridView.DataBind();
            }
        }
    }

    private void BindDepositGrid(DataTable aTable)
    {
        invoiceGridView.DataSource = aTable;
        invoiceGridView.DataBind();

        decimal total = aTable.AsEnumerable().Sum(row => row.Field<decimal?>("Amount") == null ? 0 : row.Field<decimal>("Amount"));
        lblCount.Text = "Total Amount: " + total.ToString();

        ApplyDeleteButtonState();
    }

    private void ApplyDeleteButtonState()
    {
        for (int i = 0; i < invoiceGridView.Rows.Count; i++)
        {
            ImageButton deleteButton = invoiceGridView.Rows[i].FindControl("editImageButton") as ImageButton;
            ImageButton editButton = invoiceGridView.Rows[i].FindControl("btnEdit") as ImageButton;

            if (deleteButton != null)
            {
                DateTime depositDateTime;
                bool canDelete = IsDepositDeleteUser() && TryGetDepositDate(i, out depositDateTime) && IsDepositDateInDeleteWindow(depositDateTime);
                deleteButton.Enabled = canDelete;
                deleteButton.ToolTip = canDelete ? "" : "You can not delete this deposit slip.";
            }

            if (editButton != null)
            {
                DateTime depositDateTime;
                bool canEdit = IsDepositDeleteUser() && TryGetDepositDate(i, out depositDateTime) && IsDepositDateInDeleteWindow(depositDateTime);
                editButton.Enabled = canEdit;
                editButton.ToolTip = canEdit ? "" : "You can not edit this deposit slip.";
            }
        }
    }

    private bool TryGetDepositDate(int rowIndex, out DateTime depositDateTime)
    {
        depositDateTime = DateTime.MinValue;

        if (invoiceGridView.DataKeys == null || invoiceGridView.DataKeys.Count <= rowIndex || invoiceGridView.DataKeys[rowIndex] == null)
        {
            return false;
        }

        object depositDateValue = invoiceGridView.DataKeys[rowIndex][1];
        if (depositDateValue == null)
        {
            return false;
        }

        return DateTime.TryParse(depositDateValue.ToString(), out depositDateTime);
    }

    private bool IsDepositDateInDeleteWindow(DateTime depositDateTime)
    {
        DateTime today = DateTime.Now.Date;
        DateTime fromDate = today.AddDays(-DepositDeleteDays);
        DateTime depositDate = depositDateTime.Date;

        return depositDate >= fromDate && depositDate <= today;
    }

    private bool IsDepositDeleteUser()
    {
        string loginName = Session["LoginName"] == null ? "" : Session["LoginName"].ToString();
        return loginName == "51419000000" || loginName == "50588";
    }

    protected void Button_Click(object sender, EventArgs e)
    {
        LoadInfo();
    }

    private bool Validation()
    {

        if (Session["RoleTypeName"].ToString() == "DIC")
        {
            if (companyNameDropDownList.SelectedValue == "")
            {
                ShowMessageBox("Please select sales center !!");
                return false;
            }
        }
        
        
        if (fromDateTextBox.Text == "")
        {
            ShowMessageBox("Please select from date !!");
            return false;
        }

        if (toDateTextBox.Text == "")
        {
            ShowMessageBox("Please select to date !!");
            return false;
        }

        

        return true;
    }

    protected void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\\'");
        string sScript = String.Format("alert('{0}'); if (typeof restoreDepositListScrollPosition === 'function') restoreDepositListScrollPosition();", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditDeposit")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string depositId = invoiceGridView.DataKeys[rowindex][0].ToString();
            DateTime depositDateTime;

            if (!IsDepositDeleteUser())
            {
                ShowMessageBox("You do not have permission to edit this deposit slip.");
                return;
            }

            if (!TryGetDepositDate(rowindex, out depositDateTime) || !IsDepositDateInDeleteWindow(depositDateTime))
            {
                ShowMessageBox("Only today's and previous 60 days deposit slip can be edited.");
                return;
            }

            Response.Redirect("CompanyWiseBranch.aspx?DepositId=" + depositId);
        }
        else if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string depositId = invoiceGridView.DataKeys[rowindex][0].ToString();
            DateTime depositDateTime;

            if (!IsDepositDeleteUser())
            {
                ShowMessageBox("You can not delete deposit slip !!");
                ApplyDeleteButtonState();
                return;
            }

            if (!TryGetDepositDate(rowindex, out depositDateTime) || !IsDepositDateInDeleteWindow(depositDateTime))
            {
                ShowMessageBox("Only today's and previous 60 days deposit slip can be deleted.");
                ApplyDeleteButtonState();
                return;
            }

            if (depositId != null)
            {
                CompanyWiseDepositDao aDao = new CompanyWiseDepositDao();

                aDao.IsDelete = true;
                aDao.DeleteBy = Session["LoginName"].ToString();
                aDao.DeleteDate = DateTime.Now;
                aDao.DepositId = Convert.ToInt32(depositId);

                bool isDeleted = aDal.UpdateDepositInfo(aDao);
                if (isDeleted)
                {
                    RemoveDeletedDepositRow(aDao.DepositId);
                    ShowMessageBox("Deposit slip deleted successfully.");
                }
                else
                {
                    ShowMessageBox("Deposit slip delete failed.");
                    ApplyDeleteButtonState();
                }
            }
        }
    }

    private void RemoveDeletedDepositRow(int depositId)
    {
        DataTable aTable = DepositListTable;
        if (aTable == null)
        {
            return;
        }

        DataRow[] deletedRows = aTable.Select("DepositId = " + depositId);
        foreach (DataRow row in deletedRows)
        {
            aTable.Rows.Remove(row);
        }

        aTable.AcceptChanges();
        DepositListTable = aTable;

        if (aTable.Rows.Count > 0)
        {
            BindDepositGrid(aTable);
        }
        else
        {
            invoiceGridView.DataSource = null;
            invoiceGridView.DataBind();
            lblCount.Text = "Total Amount: 0";
        }
    }
    protected void ListImageButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CompanyWiseBranch.aspx");
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\\'");
        sScript = String.Format("alert('{0}'); if (typeof restoreDepositListScrollPosition === 'function') restoreDepositListScrollPosition();", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void ListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("CompanyWiseBranch.aspx");
    }
   
    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {
        if (invoiceGridView.Rows.Count > 0)
        {
            string attachment = "attachment; filename=Deposit.xls";
            Response.ClearContent();
            Response.AddHeader("content-disposition", attachment);
            Response.ContentType = "application/ms-excel";
            StringWriter sw = new StringWriter();
            HtmlTextWriter htw = new HtmlTextWriter(sw);

            invoiceGridView.AllowPaging = false;



            //loadGridView.Columns[loadGridView.Columns.Count - 1].Visible =
            //            false;
            //loadGridView.Columns[loadGridView.Columns.Count - 2].Visible =
            //   false;
            //loadGridView.Columns[loadGridView.Columns.Count - 3].Visible =
            //   false;

            this.LoadInfo();

            // Create a form to contain the grid  
            HtmlForm frm = new HtmlForm();
            invoiceGridView.Parent.Controls.Add(frm);
            //frm.Attributes["runat"] = "server";
            //frm.Controls.Add(loadGridView);
            //frm.RenderControl(htw);

            invoiceGridView.HeaderRow.Style.Add("background-color", "#E5EEF1");

            // Set background color of each cell of GridView1 header row
            foreach (TableCell tableCell in invoiceGridView.HeaderRow.Cells)
            {
                tableCell.Style["background-color"] = "#E5EEF1";
            }

            // Set background color of each cell of each data row of GridView1
            foreach (GridViewRow gridViewRow in invoiceGridView.Rows)
            {
                gridViewRow.BackColor = System.Drawing.Color.White;

                foreach (TableCell gridViewRowTableCell in gridViewRow.Cells)
                {
                    gridViewRowTableCell.Style["background-color"] = "#FFFFFF";

                }
            }


            invoiceGridView.RenderControl(htw);
            string headerTable = @"<span  style='text-align:left'><h4>From Date : " + fromDateTextBox.Text + "</h4> <h4> To Date : " + toDateTextBox.Text + "</h4>  </span> <span   style='text-align:right'><h4> Print Date: " + DateTime.Now.ToString("dd/MMMM/yyyy") + "</h4></span>";

            string SubTi = @"<span   style='text-align:center'>
   <h3>Deposit List Report	</h3>

</span>";

            HttpContext.Current.Response.Write(headerTable);
            HttpContext.Current.Response.Write(SubTi);
            Response.Write(sw.ToString());
            Response.End();
        }
        else
        {
            showMessageBox("No Data Found!!");
        }
    }
    public override void VerifyRenderingInServerForm(Control control)
    {
        // //required to avoid the runtime error "  
        //Control 'GridView1' of type 'GridView' must be placed inside a form tag with runat=server."  
    }
}
