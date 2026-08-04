using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_RegionEdit : System.Web.UI.Page
{
    RegionInfoBLL RegionInfoBLL = new RegionInfoBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            CompanyName();
            regionInfoIdHiddenField.Value = Request.QueryString["ID"];
            RegionInfoLoad(regionInfoIdHiddenField.Value);
            
        }

    }

    public void CompanyName()
    {
        RegionInfoBLL.CompanyNameLoad(companyNameDropDownList);
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (regionnameTextBox.Text != "" )
        {
            RegionInfo RegionInfo = new RegionInfo()
            {
                RegionId = Convert.ToInt32(regionInfoIdHiddenField.Value),
                RegionName = regionnameTextBox.Text,
                //CompanyId = Convert.ToInt32(companyNameDropDownList.SelectedValue),
                //CompanyName = companyNameDropDownList.SelectedItem.Text,
                RegionCode = regioncodeTextBox.Text,

            };
            RegionInfoBLL aRegionInfoBLL = new RegionInfoBLL();

            if (!aRegionInfoBLL.UpdateDataForRegionInfo(RegionInfo))
            {
                MessageLabel.Text = "Data Not Update!!!";
                MessageLabel.ForeColor = System.Drawing.Color.Red;

            }
            else
            {
                MessageLabel.Text = "Data Update Successfully!!! Please Reload";
                MessageLabel.ForeColor = System.Drawing.Color.Green;

            }

        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }

    }

    private void RegionInfoLoad(string marketId)
    {
        RegionInfo RegionInfo = new RegionInfo();
        RegionInfo = RegionInfoBLL.RegionInfoEditLoad(marketId);
        regionnameTextBox.Text = RegionInfo.RegionName;
        //companyNameDropDownList.SelectedValue = RegionInfo.CompanyId.ToString();
        regioncodeTextBox.Text = RegionInfo.RegionCode;

    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }
}