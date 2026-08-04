using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_UserEdit : System.Web.UI.Page
{
    UserBLL aUserBll = new UserBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            userIdHiddenField.Value = Request.QueryString["ID"];

           UserLoad(userIdHiddenField.Value);
        }
    }

    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);

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
                UserId = Convert.ToInt32(userIdHiddenField.Value),
                UserName = userNameTextBox.Text,
                UserType = userTypeTextBox.Text,
                LoginName = loginNameTextBox.Text,
                Password = passwordTextBox.Text,
                UserStatus = userStatusTextBox.Text,
                Email = emailTextBox.Text,
                ContactNo = contactTextBox.Text,
                
            };
            UserBLL aBll = new UserBLL();

            if (!aBll.UpdateDataForUser(aUserInformation))
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

}