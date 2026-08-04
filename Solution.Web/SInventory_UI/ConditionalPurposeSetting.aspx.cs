using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.SInventory_DAL;

public partial class SInventory_UI_ConditionalPurposeSetting : System.Web.UI.Page
{

    ConditionalPurposeDal aDal = new ConditionalPurposeDal();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdownList();
        }
    }

    private void LoadDropdownList()
    {
        aDal.LoadCondition(conditionDropDownList);
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (Validation())
        {
            if (aDal.SaveSettings(purposeTextBox.Text, conditionDropDownList.SelectedValue))
            {
                purposeTextBox.Text = "";
                conditionDropDownList.SelectedValue = "";
                ShowMessageBox("Data Save Successfully !!!");
            }
        }
    }

    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {

        if (purposeTextBox.Text == "")
        {
            ShowMessageBox("Pourpose is required !!");
            return false;
        }

        if (conditionDropDownList.SelectedValue == "")
        {
            ShowMessageBox("Please select condition !!");
            return false;
        }

        return true;
    }

    protected void viewLinkButton_Click(object sender, EventArgs e)
    {

    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

    }

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("ConditionalPurposeSetting.aspx");
    }
}