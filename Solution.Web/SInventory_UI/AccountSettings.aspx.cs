using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_AccountSettings : System.Web.UI.Page
{
    AccountSettingsBll aUserBll = new AccountSettingsBll();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
           // userIdHiddenField.Value = Session["UserId"].ToString();
            LoadDropdownlist();
            searchButton_Click(null,null);
            if (Session["LoginName"].ToString() == "admin")
            {
                userDropDownList.Enabled = true;
            }
            else
            {
                userDropDownList.Enabled = false;
            }
        }
    }

    private void LoadDropdownlist()
    {
        aUserBll.LoadUserOnDropDownList(userDropDownList);
        userDropDownList.SelectedValue = Session["UserId"].ToString();
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
        if (userNameTextBox.Text == "")
        {
            showMessageBox("Please Input User Name!!");
            return false;
        }
        if (loginNameTextBox.Text == "")
        {
            showMessageBox("Please Input Loging Name!!");
            return false;
        }

        if (passwordTextBox.Text == "")
        {
            showMessageBox("Please Input Password!!");
            return false;
        }
        if (contactTextBox.Text == "")
        {
            showMessageBox("Please Input Contact Number!!");
            return false;
        }
        return true;
    }

    protected void updateButton_Click1(object sender, EventArgs e)
    {
        if (Validation() == true)
        {

            UserInformation aUserInformation = new UserInformation()
            {
                UserId = Convert.ToInt32(userDropDownList.SelectedValue),
                UserName = userNameTextBox.Text,
                UserType = userTypeTextBox.Text,
                LoginName = loginNameTextBox.Text,
                Password = passwordTextBox.Text,
                UserStatus = userStatusTextBox.Text,
                Email = emailTextBox.Text,
                ContactNo = contactTextBox.Text,

            };
            AccountSettingsBll aBll = new AccountSettingsBll();

            if (!aBll.UpdateDataForUser(aUserInformation))
            {
                showMessageBox("Data Not Update!!!");
                MessageLabel.ForeColor = System.Drawing.Color.Red;
            }
            else
            {
                showMessageBox("Data Update Successfully!!!");
                MessageLabel.ForeColor = System.Drawing.Color.Green;
            }

        }
        else
        {
            showMessageBox("Please input data in all Textbox");
        }
    }

    private void UserLoad(string userId)
    {
        UserInformation aInformation = new UserInformation();

        aInformation = aUserBll.UserEditLoad(userId);

        userNameTextBox.Text = aInformation.UserName;
        userTypeTextBox.Text = aInformation.UserType;
        loginNameTextBox.Text = aInformation.LoginName;
        passwordTextBox.Text = aInformation.Password;
        userStatusTextBox.Text = aInformation.UserStatus;
        emailTextBox.Text = aInformation.Email;
        contactTextBox.Text = aInformation.ContactNo;

    }

    protected void searchButton_Click(object sender, EventArgs e)
    {
        UserLoad(userDropDownList.SelectedValue);
    }
}