using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_RegionEntry : System.Web.UI.Page
{
    RegionInfoBLL RegionInfoBLL = new RegionInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CompanyName();
        }
    }
    private void Clear()
    {
        regionnameTextBox.Text = string.Empty;
        companyNameDropDownList.SelectedValue = null;
        regioncodeTextBox.Text = string.Empty;
    }

    public void CompanyName()
    {
        RegionInfoBLL.CompanyNameLoad(companyNameDropDownList);
    }

    protected void submitButton_Click1(object sender, EventArgs e)
    {
        if (regionnameTextBox.Text != "" )
        {
            RegionInfo RegionInfo = new RegionInfo()
            {
                //CompanyName = companyNameDropDownList.SelectedItem.Text,
                //CompanyId = Convert.ToInt32(companyNameDropDownList.SelectedValue),
                RegionName = regionnameTextBox.Text,
                RegionCode = regioncodeTextBox.Text
            };

            RegionInfoBLL RegionInfoBLL = new RegionInfoBLL();
            MessageLabel.Text = RegionInfoBLL.SaveRegion(RegionInfo);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }

    protected void regionViewImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("RegionView.aspx");
    }
}