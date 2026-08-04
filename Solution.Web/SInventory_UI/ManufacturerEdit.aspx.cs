using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ManufacurerEdit : System.Web.UI.Page
{
    ManufacturerBLL manufacturerBll = new ManufacturerBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            manufacturerIdHiddenField.Value = Request.QueryString["ID"];
            ManufacturerLoad(manufacturerIdHiddenField.Value);
        }

    }
    private void Clear()
    {
        manufacturerNameTextBox.Text = string.Empty;
        manufacturerAddressTextBox.Text = string.Empty;
    }

    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (manufacturerNameTextBox.Text != "" && manufacturerAddressTextBox.Text != "")
        {
            Manufacturer aManufacturer = new Manufacturer()
            {
                ManufacId = Convert.ToInt32(manufacturerIdHiddenField.Value),
                ManufacName = manufacturerNameTextBox.Text,
                ManufacAddress = manufacturerAddressTextBox.Text,
            };
            ManufacturerBLL aManufacturerBll = new ManufacturerBLL();
            if (!aManufacturerBll.UpdateManufacturerInfo(aManufacturer))
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

    private void ManufacturerLoad(string ID)
    {
        Manufacturer aManufacturer = new Manufacturer();
        aManufacturer = manufacturerBll.ManufacturerEditLoad(ID);
        manufacturerNameTextBox.Text = aManufacturer.ManufacName;
        manufacturerAddressTextBox.Text = aManufacturer.ManufacAddress;
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

    }

}