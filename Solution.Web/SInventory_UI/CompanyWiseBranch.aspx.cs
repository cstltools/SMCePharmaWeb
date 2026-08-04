using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;
using SalesSolution.Web.DataLayer;

public partial class SInventory_UI_CompanyWiseBranch : System.Web.UI.Page
{
    CompanywisebranchDal aDal = new CompanywisebranchDal();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            chkDateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            dateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
            Loaddropdownlist();

            if (Request.QueryString["DepositId"] != null)
            {
                int depositId = 0;
                if (int.TryParse(Request.QueryString["DepositId"].ToString(), out depositId))
                {
                    ViewState["EditDepositId"] = depositId;
                    LoadDepositInfoForEdit(depositId);
                }
            }
        }
    }

    private void LoadDepositInfoForEdit(int depositId)
    {
        DataTable dt = aDal.GetDepositInfoById(depositId);
        if (dt != null && dt.Rows.Count > 0)
        {
            DataRow row = dt.Rows[0];
            companyNameDropDownList.SelectedValue = row["CompanyId"].ToString();
            companyNameDropDownList_SelectedIndexChanged(null, null);

            if (row["MIOId"] != DBNull.Value && row["MIOId"].ToString() != "")
            {
                try { ddlMIO.SelectedValue = row["MIOId"].ToString(); } catch { }
            }

            amount.Text = row["Amount"].ToString();
            AITTextBox1.Text = row["AIT"].ToString();
            if (row["DepositDate"] != DBNull.Value)
            {
                dateTextBox.Text = Convert.ToDateTime(row["DepositDate"]).ToString("dd MMMM, yyyy");
            }
            remarksTextBox.Text = row["Remarks"].ToString();

            string depositType = row["DepositType"].ToString();
            for (int i = 0; i < CheckBoxList1.Items.Count; i++)
            {
                if (CheckBoxList1.Items[i].Text == depositType)
                {
                    CheckBoxList1.Items[i].Selected = true;
                }
                else
                {
                    CheckBoxList1.Items[i].Selected = false;
                }
            }
            CheckBoxList1_SelectedIndexChanged(null, null);

            try { ddlBank.SelectedValue = row["BankId"].ToString(); } catch { }
            accNameTextBox.Text = row["AccountName"].ToString();

            if (depositType != "Cash" && depositType != "Online")
            {
                branchTextBox.Text = row["BranchName"].ToString();
                chkTextBox.Text = row["CheckNumber"].ToString();
                if (row["CheckDate"] != DBNull.Value && row["CheckDate"].ToString() != "")
                {
                    chkDateTextBox.Text = Convert.ToDateTime(row["CheckDate"]).ToString("dd MMMM, yyyy");
                }
            }
        }
    }

    private void Loaddropdownlist()
    {
        aDal.LoadCompany(companyNameDropDownList, Session["UserId"].ToString());

        try
        {
            companyNameDropDownList.SelectedIndex = 1;
            companyNameDropDownList_SelectedIndexChanged(null, null);
        }
        catch
        {

        }
       

    }

    protected void dateTextBox_TextChanged(object sender, EventArgs e)
    {
        // Access the selected date using dateTextBox.Text
        string selectedDate = dateTextBox.Text;

        // Your additional server-side logic here
        if (!string.IsNullOrEmpty(selectedDate))
        {
            // Parse the selected date string to DateTime if needed
            DateTime parsedDate;
            if (DateTime.TryParseExact(selectedDate, "dd MMMM, yyyy", System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out parsedDate))
            {
                // Now you have the parsed date in the 'parsedDate' variable
                // Extract the month and year from the selected date
                int selectedMonth = parsedDate.Month;
                int selectedYear = parsedDate.Year;

                // Get the current month and year
                int currentMonth = DateTime.Now.Month;
                int currentYear = DateTime.Now.Year;

                // Compare the selected month and year with the current month and year
                if (selectedMonth == currentMonth && selectedYear == currentYear)
                {
                    // The selected date is in the current month and year
                    // Your logic for handling this case
                    // For example, display a message or execute some business logic
                }
                else
                {
                    dateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
                }
            }
            else
            {
                dateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
                // Handle parsing error
                // The selected date format doesn't match the expected format
            }
        }
    }
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    protected void ddlBank_OnSelectedIndexChanged(object sender, EventArgs e)
    {
        accNameTextBox.Text = "";
        branchTextBox.Text = "";
        chkTextBox.Text = "";
        try
        {
            using (DataTable dt = _seedRepo.GetBAnkInfoById(ddlBank.SelectedValue))
            {
                accNameTextBox.Text = dt.Rows[0]["BankAccountNumber"].ToString();

                branchTextBox.Text = dt.Rows[0]["BranchName"].ToString();
                chkTextBox.Text = dt.Rows[0]["chkAccNo"].ToString();
            }
        }catch { }

        //        //if (ddlBank.SelectedValue != "")
        //        //{
        //        //    aDal.LoadBranch(ddlBranch, ddlBank.SelectedValue);Pubali Bank Limited
        //        //}

          

        //if (ddlBank.SelectedItem.Text == "Pubali Bank Limited")
        //{
        //    accNameTextBox.Text = "3311102000707";
        //}
        //if (ddlBank.SelectedItem.Text == "Dutch-Bangla Bank Limited")
        //{
        //    accNameTextBox.Text = "1031200003742";
        //}

        //if (ddlBank.SelectedItem.Text == "Nagad")
        //{
        //    accNameTextBox.Text = "01648458878";
        //}
       
        

        //if (ddlBank.SelectedItem.Text == "Other")
        //{
        //    accNameTextBox.Text = "N/A";
        //    branchTextBox.Text = "N/A";
        //    chkTextBox.Text = "N/A";
        //    chkDateTextBox.Text=DateTime.Now.ToString("dd MMMM, yyyy");
        //    dateTextBox.Text = DateTime.Now.ToString("dd MMMM, yyyy");
        //}
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validattion())
        {
            var aDepositDao = new CompanyWiseDepositDao();

            aDepositDao.CompanyId = Convert.ToInt32(companyNameDropDownList.SelectedValue);
           
            aDepositDao.Amount = Convert.ToDecimal(amount.Text.Trim());
            aDepositDao.EntryBy = Session["LoginName"].ToString();
            aDepositDao.EntryDate = DateTime.Now;
            aDepositDao.DepositDate = Convert.ToDateTime(dateTextBox.Text.Trim());
            aDepositDao.IsDelete = false;
            aDepositDao.MIOId = ddlMIO.SelectedIndex > 0 ? int.Parse(ddlMIO.SelectedValue) : (int?)null;
            aDepositDao.Remarks = remarksTextBox.Text;
            aDepositDao.AIT = Convert.ToDecimal(AITTextBox1.Text.Trim());

            for (int i = 0; i < CheckBoxList1.Items.Count; i++)
            {
                if (CheckBoxList1.Items[i].Selected)
                {
                    aDepositDao.DepositType = CheckBoxList1.Items[i].Text.Trim();
                }
            }

            if (aDepositDao.DepositType == "Cash" || aDepositDao.DepositType == "Online")
            {
                aDepositDao.BankId = Convert.ToInt32(ddlBank.SelectedValue);
                aDepositDao.AccountName = accNameTextBox.Text;
            }
            else
            {
                aDepositDao.BankId = Convert.ToInt32(ddlBank.SelectedValue);
                aDepositDao.AccountName = accNameTextBox.Text;
                aDepositDao.BranchName = branchTextBox.Text;
                aDepositDao.CheckNumber = chkTextBox.Text;
                aDepositDao.CheckDate = Convert.ToDateTime(chkDateTextBox.Text.Trim()); 

            }

            if (ViewState["EditDepositId"] != null)
            {
                aDepositDao.DepositId = Convert.ToInt32(ViewState["EditDepositId"]);
                if (aDal.UpdateFullDepositInfo(aDepositDao))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Update successful!" + "','Success','DepositList.aspx');", true);
                }
            }
            else
            {
                if (aDal.SaveDepositInfo(aDepositDao) > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','DepositList.aspx');", true);
                }
            }
        }
    }
    protected void cancelButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("CompanyWiseBranch.aspx");

    }
    protected void viewLinkButton_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("DepositList.aspx");
    }
    private bool Validattion()
    {

        amount.CssClass = "form-control form-control-sm";
        branchTextBox.CssClass = "form-control form-control-sm";
        chkTextBox.CssClass = "form-control form-control-sm";
        dateTextBox.CssClass = "form-control form-control-sm";
        chkDateTextBox.CssClass = "form-control form-control-sm";
        accNameTextBox.CssClass = "form-control form-control-sm";
        AITTextBox1.CssClass = "form-control form-control-sm";
        companyNameDropDownList.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlBank.CssClass = "form-select form-select-sm mb-3 mySelect2";
        if (companyNameDropDownList.SelectedValue == "")
        {
            companyNameDropDownList.ToolTip = "please fill out this field";
            companyNameDropDownList.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            companyNameDropDownList.Focus();
            
            return false;
        }   if (AITTextBox1.Text == "")
        {
            AITTextBox1.ToolTip = "please fill out this field";
            AITTextBox1.CssClass = "form-control form-control-sm is-invalid";
            AITTextBox1.Focus();
            
            return false;
        }

        int count = 0;
        string text = "";

        for (int i = 0; i < CheckBoxList1.Items.Count; i++)
        {
            if (CheckBoxList1.Items[i].Selected)
            {
                count++;
                text = CheckBoxList1.Items[i].Text.Trim();
            }
        }

        if (count == 0)
        {
            ShowMessageBox("You should select deposit type !!!");
            return false;
        }
        if (ViewState["EditDepositId"] == null)
        {
            if (ddlMIO.SelectedValue == "")
            {
                ddlMIO.ToolTip = "please fill out this field";
                ddlMIO.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                ddlMIO.Focus();
                return false;
            }
        }

        if (text != "")
        {
            if (text == "Cash" || text == "Online")
            {
                if (ddlBank.SelectedValue == "")
                {
                    ddlBank.ToolTip = "please fill out this field";
                    ddlBank.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    ddlBank.Focus();
                    return false;
                }

                if (accNameTextBox.Text == "")
                {
                    accNameTextBox.ToolTip = "please fill out this field";
                    accNameTextBox.CssClass = "form-control form-control-sm is-invalid";
                    accNameTextBox.Focus();
                    return false;
                }
            }
            else
            {
                if (ddlBank.SelectedValue == "")
                {
                    ddlBank.ToolTip = "please fill out this field";
                    ddlBank.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    ddlBank.Focus();
                    return false;
                }

                if (accNameTextBox.Text == "")
                {
                    accNameTextBox.ToolTip = "please fill out this field";
                    accNameTextBox.CssClass = "form-control form-control-sm is-invalid";
                    accNameTextBox.Focus();
                    return false;
                }

                if (branchTextBox.Text == "")
                {
                    branchTextBox.ToolTip = "please fill out this field";
                    branchTextBox.CssClass = "form-control form-control-sm is-invalid";
                    branchTextBox.Focus();
                    return false;
                }

                if (chkTextBox.Text == "")
                {
                    chkTextBox.ToolTip = "please fill out this field";
                    chkTextBox.CssClass = "form-control form-control-sm is-invalid";
                    chkTextBox.Focus();
                    return false;
                }

                if (chkDateTextBox.Text == "")
                {
                    chkDateTextBox.ToolTip = "please fill out this field";
                    chkDateTextBox.CssClass = "form-control form-control-sm is-invalid";
                    chkDateTextBox.Focus();
                    return false;
                }
            }
        }

        

        if (dateTextBox.Text == "")
        {
            dateTextBox.ToolTip = "please fill out this field";
            dateTextBox.CssClass = "form-control form-control-sm is-invalid";
            dateTextBox.Focus();
            return false;
        }

        if (amount.Text == "")
        {
            amount.ToolTip = "please fill out this field";
            amount.CssClass = "form-control form-control-sm is-invalid";
            amount.Focus();
            return false;
        }
       
        return true;

    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    protected void clearButton_OnClick(object sender, EventArgs e)
    {
       Clear();
    }

    private void Clear()
    {
        Loaddropdownlist();
        ddlBranch.Items.Clear();
        accNameTextBox.Text = "";
        chkTextBox.Text = "";
        chkDateTextBox.Text = "";
        branchTextBox.Text = "";
        amount.Text = "";
        dateTextBox.Text = "";
        remarksTextBox.Text = "";

        for (int i = 0; i < CheckBoxList1.Items.Count; i++)
        {
            if (CheckBoxList1.Items[i].Selected)
            {
                CheckBoxList1.Items[i].Selected = false;
            }
        }

        branch.Visible = true;
        chkNo.Visible = true;
        chkDate.Visible = true;

        
    }

    protected void ListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DepositList.aspx");
    }
    protected void CheckBoxList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (CheckBoxList1.SelectedValue == "Cash" || CheckBoxList1.SelectedValue == "Online")
        {
            branch.Visible = false;
            chkNo.Visible = false;
            chkDate.Visible = false;
        }
        else
        {

            branch.Visible = true;
            chkNo.Visible = true;
            chkDate.Visible = true;
        }
    }

    protected void companyNameDropDownList_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            using (DataTable dt = _dataLoad.GetMIOInfo_SC_Rpt(companyNameDropDownList.SelectedValue))
            {
                ddlMIO.DataSource = dt;
                ddlMIO.DataValueField = "ValueId";
                ddlMIO.DataTextField = "TextName";
                ddlMIO.DataBind();
                ddlMIO.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlMIO.SelectedIndex = 0;
            }

            aDal.LoadBank(ddlBank, companyNameDropDownList.SelectedValue);
        }
        catch (Exception ex)
        {

        }
    }
}