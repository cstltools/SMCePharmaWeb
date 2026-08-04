using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ZoneEntry : System.Web.UI.Page
{
    ZoneInfoBLL ZoneInfoBLL = new ZoneInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CompanyUnitName();
        }
    }
    private void Clear()
    {
        zonenameTextBox.Text = string.Empty;
        companyUnitNameDropDownList.SelectedValue = null;
    }

    public void CompanyUnitName()
    {
        ZoneInfoBLL.CompanyUnitNameLoad(companyUnitNameDropDownList);
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (zonenameTextBox.Text != "" && companyUnitNameDropDownList.SelectedValue != "")
        {
            ZoneInfo aZoneInfo = new ZoneInfo()
            {
                ZoneName = zonenameTextBox.Text,
                ComUnitId = Convert.ToInt32(companyUnitNameDropDownList.SelectedValue),
                ComUnitName = companyUnitNameDropDownList.SelectedItem.Text
            };

            ZoneInfoBLL ZoneInfoBLL = new ZoneInfoBLL();
            MessageLabel.Text = ZoneInfoBLL.SaveZone(aZoneInfo);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    protected void regionViewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("ZoneView.aspx");
    }
}