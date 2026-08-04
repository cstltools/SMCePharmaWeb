using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_ManufacturerEntry : System.Web.UI.Page
{
    ManufacturerBLL manufacturerBll = new ManufacturerBLL();

    string Msg = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            if (!string.IsNullOrEmpty(Request.QueryString["ID"]))
            {
                updateButton.Visible = true;
                manufacturerIdHiddenField.Value = Request.QueryString["ID"];
                ManufacturerLoad(manufacturerIdHiddenField.Value);
            }
            else
            {
                submitButton.Visible = true;
            }
        }
    }


    private void ManufacturerLoad(string ID)
    {
        Manufacturer aManufacturer = new Manufacturer();
        aManufacturer = manufacturerBll.ManufacturerEditLoad(ID);
        manufacturerNameTextBox.Text = aManufacturer.ManufacName;
        manufacturerAddressTextBox.Text = aManufacturer.ManufacAddress;
    }
    private void Clear()
    {
        manufacturerNameTextBox.Text = string.Empty;
        manufacturerAddressTextBox.Text = string.Empty;
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {

       

         
        if (manufacturerNameTextBox.Text != "" && manufacturerAddressTextBox.Text !="")
        {

            if (manufacturerIdHiddenField.Value != "")
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
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ManufacturerView.aspx');", true);
                }
            }
            else
            {


                Manufacturer aManufacturer = new Manufacturer()
                {
                    ManufacName = manufacturerNameTextBox.Text,
                    ManufacAddress = manufacturerAddressTextBox.Text,
                };
                ManufacturerBLL aManufacturerBll = new ManufacturerBLL();
          
                Msg = aManufacturerBll.SaveManufacturer(aManufacturer);
                if (Msg == "Already Exist")
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ManufacturerView.aspx');", true);
                }
            }
        }
        else
        {
            showMessageBox( "Please input data in all Textbox");
        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void ResetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("ManufacturerEntry.aspx");
    }

    protected void detailsViewButton_Click(object sender, EventArgs e)
    {
        Response.Redirect("ManufacturerView.aspx");
    }
}