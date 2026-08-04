using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;

public partial class SInventory_UI_DeleteOrderReport : System.Web.UI.Page
{
    DeleteOrderReportBll aOrderReportBll = new DeleteOrderReportBll();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadDropdownlist();
        }
    }

    private void LoadDropdownlist()
    {
        aOrderReportBll.LoadSalesCenter(comUnitNameDropDownList);
        //aOrderReportBll.LoadCustomer(customerDropDownList);
    }

    private void ShowMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }


    private void Popup()
    {
            
        string rptType = "0";

        if (nationalCheckBox.Checked == false)
        {
            rptType = "1";
        }

        Session["Excel"] = "";
        Session["Excel"] = "N";

        SetReportFilters();

        string url = "../SInventory_RPTVIEW/DeleteOrderReportViewer.aspx?rptType=" + rptType ;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true); ;


    }

    private void SetReportFilters()
    {
        Session["ComUnitCode"] = comUnitNameDropDownList.Text.Trim();
        Session["FromDate"] = fromDateTextBox.Text.Trim();
        Session["ToDate"] = toDateTextBox.Text.Trim();
    }

    protected void cancelButton_OnClick(object sender, EventArgs e)
    {
        Clear();
    }

    private void Clear()
    {
        MessageLabel.Text = "";
    }

    private void DateValidationCheck(TextBox dateTextBox)
    {
        DateTime temp;
        if (!DateTime.TryParse(dateTextBox.Text, out temp))
        {
            ShowMessageBox("Please select valid date!!!");
            dateTextBox.Text = "";
        }
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (comUnitNameDropDownList.SelectedValue != "" || nationalCheckBox.Checked)
        {
            if (Validation())
            {
                Popup();
                Clear();
            }
        }
        else
        {
             ShowMessageBox("Please select national report or a sales center!!!");
        }
    }

    private bool Validation()
    {
        if (fromDateTextBox.Text != "")
        {
            if (toDateTextBox.Text == "")
            {
                ShowMessageBox("Please select to date");
                return false;
            }
        }
        else if (toDateTextBox.Text != "")
        {
            if (fromDateTextBox.Text == "")
            {
                ShowMessageBox("Please select from date");
                return false;
            }
        }

        return true;
    }

    protected void nationalCheckBox_OnCheckedChanged(object sender, EventArgs e)
    {
        if (nationalCheckBox.Checked)
        {
            comUnitNameDropDownList.SelectedValue = "";
            comUnitNameDropDownList.Enabled = false;
        }
        else
        {
            comUnitNameDropDownList.Enabled = true;
        }
    }

    protected void excelButton_OnClick(object sender, EventArgs e)
    {
        if (Validation())
        {
            ExcelPopUp();
        }
        
    }

    private void ExcelPopUp()
    {
        string rptType = "0";

        if (nationalCheckBox.Checked == false)
        {
            rptType = "1";
        }

        Session["Excel"] = "";
        Session["Excel"] = "Y";

        SetReportFilters();

        string url = "../SInventory_RPTVIEW/DeleteOrderReportViewer.aspx?rptType=" + rptType;
        string fullURL = "var Mleft = (screen.width/2)-(950/2);var Mtop = (screen.height/2)-(700/2);window.open( '" + url + "', null, 'height=700,width=950,status=yes,toolbar=no,addressbar=no, scrollbars=yes,menubar=no,location=no,top=\'+Mtop+\', left=\'+Mleft+\'' );";
        ScriptManager.RegisterStartupScript(this, typeof(string), "OPEN_WINDOW", fullURL, true); ;
    }

    protected void fromDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateValidationCheck(fromDateTextBox);
    }


    protected void toDateTextBox_OnTextChanged(object sender, EventArgs e)
    {
        DateValidationCheck(toDateTextBox);
    }

   
}
