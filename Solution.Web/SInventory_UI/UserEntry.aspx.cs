using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class HRM_UI_TDLUser : System.Web.UI.Page
{
    UserBLL aUserBll=new UserBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //loginUserNameTextBox.Text = string.Empty;
            //userPasswordTextBox.Text = string.Empty;
            LoadDropDown();
        }   
    }
   
    private void Clear()
    {
        empNameTextBox.Text = string.Empty;
        userStatusNameDropDownList.SelectedValue =string.Empty;
        loginUserNameTextBox.Text = string.Empty;
        userPasswordTextBox.Text = string.Empty;
        userStatusNameDropDownList.Text = string.Empty;
        emailNameTextBox.Text = string.Empty;
        contactNoTextBox.Text = string.Empty;
        comUnitDropDownList.SelectedValue = string.Empty;
        userTypeDropDownList.SelectedValue = string.Empty;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        if (empNameTextBox.Text == "")
        {
            showMessageBox("Please Input User Name!!");
            return false;
        }
        if (loginUserNameTextBox.Text == "")
        {
            showMessageBox("Please Input Loging Name!!");
            return false;
        }

        if (userPasswordTextBox.Text == "")
        {
            showMessageBox("Please Input Password!!");
            return false;
        }
        if (userStatusNameDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input User Status!!");
            return false;
        }
        if (userTypeDropDownList.SelectedIndex == 0)
        {
            showMessageBox("Please Input User Type!!");
            return false;
        }
        return true;
    }

    protected void submitButton_Click(object sender, EventArgs e)
    {
        if (Validation() == true)
        {
            
            UserInformation aUserInformation = new UserInformation()
            {
                UserName = empNameTextBox.Text,
                UserType = userTypeDropDownList.SelectedItem.Text.Trim(),
                ContactNo = contactNoTextBox.Text,
                LoginName = loginUserNameTextBox.Text,
                Password = userPasswordTextBox.Text,
                UserStatus = userStatusNameDropDownList.SelectedItem.Text,
                Email = emailNameTextBox.Text
                

            };

            UserCompanyUnit aUserCompanyUnit = new UserCompanyUnit()
                                                   {
                                                      CompanyUnitId = Convert.ToInt32(1)
                                                   };

            UserBLL aBll = new UserBLL();
            MessageLabel.Text = aBll.SaveDataForUser(aUserInformation,aUserCompanyUnit);
            Clear();
        }
        else
        {
           // showMessageBox("Please input data in all Textbox!!");
            //MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void viewListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("UserView.aspx");
    }

    public void LoadDropDown()
    {
        aUserBll.LoadUserType(userTypeDropDownList);
        aUserBll.LoadComUnit(comUnitDropDownList);
    }
    
}