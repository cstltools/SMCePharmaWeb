using Library.DAL.UserProfileDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
 

public partial class UserProfile_UI_ChangePassword : System.Web.UI.Page
{
    private string _userId;
    ChangePasswordDAL aDAL = new ChangePasswordDAL();
 

    protected void Page_Load(object sender, EventArgs e)
    {

        if (Session["UserId"] != null)
        {
            _userId = Session["UserId"].ToString();
        }
        if (!IsPostBack)
        {
            if (Session["EmpInfoId"] != null && Session["EmpInfoId"] != "")
            {

               // GetOneRecord(Session["EmpInfoId"].ToString());
                GetOneRecordPassword(_userId);



            }
        }
    }

    private void GetOneRecordPassword(string userId)
    {
        DataTable dataTable = aDAL.GetUserPassInfoDAL(userId);

        const int rowIndex = 0;

        if (dataTable.Rows.Count > 0)
        {
            lblshortName.Text = dataTable.Rows[rowIndex].Field<string>("EmpName");
            lblDesignation.Text = dataTable.Rows[rowIndex].Field<string>("DesigName");
            lblID.Text = dataTable.Rows[rowIndex].Field<string>("LoginName");
            lblRoleName.Text = dataTable.Rows[rowIndex].Field<string>("RoleName");
        }
    }


    private void GetOneRecord(string id)
    {

        DataTable dataTable = aDAL.GetEmployeeInfoDAL(id);

        const int rowIndex = 0;

        if (dataTable.Rows.Count > 0)
        {
            //if (dataTable.Rows[rowIndex].Field<string>("EmpImage") != "")
            //{
            //    UserImage.ImageUrl = "~/UploadImg/" + dataTable.Rows[rowIndex].Field<string>("EmpImage");
            //}
            //else
            //{
            //    UserImage.ImageUrl = "../Assets/man-icon.png";
            //}


            lblshortName.Text = dataTable.Rows[rowIndex].Field<string>("EmpName");
            lblDesignation.Text = dataTable.Rows[rowIndex].Field<string>("Designation");
            lblID.Text = dataTable.Rows[rowIndex].Field<string>("EmpMasterCode");

           


        }
    }

    protected void btn_Save_OnClick(object sender, EventArgs e)
    {
        if (Validat())
        {
            bool status = aDAL.UpdatePass(Convert.ToInt32(_userId), txt_Password.Text.Trim());
            if (status)
            {
                Session["IsPasswordChange"] = "True";
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Password updated successfully!" + "','Success','ChangePassword.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Password update failed!" + "','Failed');", true);

            }

        }
    }

    private bool Validat()
    {

        txt_Password.CssClass = "form-control";
        txtConfirm.CssClass = "form-control";
        lblPasswordError.Text = "";
        bool isVAlid = true;

        if (txt_Password.Text.Trim() == "")
        {
            txt_Password.ToolTip = "please fill out this field";
            txt_Password.CssClass = "form-control is-invalid";
            lblPasswordError.Text = "Please enter new password";
            txt_Password.Focus();
            isVAlid = false;
        }
        else if (!IsStrongPassword(txt_Password.Text.Trim()))
        {
            txt_Password.ToolTip = "Password must be 12 to 20 characters with uppercase, lowercase, number and special character";
            txt_Password.CssClass = "form-control is-invalid";
            lblPasswordError.Text = "Password is not strong enough";
            txt_Password.Focus();
            isVAlid = false;
        }
        else if (!IsNewPasswordDifferentFromCurrent(txt_Password.Text.Trim()))
        {
            txt_Password.ToolTip = "New password cannot be the same as current password";
            txt_Password.CssClass = "form-control is-invalid";
            lblPasswordError.Text = "New password cannot be the same as current password";
            txt_Password.Focus();
            isVAlid = false;
        }


        if (txtConfirm.Text.Trim() == "")
        {
            txtConfirm.ToolTip = "please fill out this field";
            txtConfirm.CssClass = "form-control is-invalid";
            txtConfirm.Focus();
            isVAlid = false;
        }

        if (txt_Password.Text.Trim() != "" && txtConfirm.Text.Trim() != "")
        {
            if (txt_Password.Text.Trim() != txtConfirm.Text.Trim())
            {
                txtConfirm.ToolTip = "please fill out this field";
                txtConfirm.CssClass = "form-control is-invalid";
                txtConfirm.Focus();
                isVAlid = false; 
            }
        }
        return isVAlid;
    }

    private bool IsNewPasswordDifferentFromCurrent(string newPassword)
    {
        DataTable dataTable = aDAL.GetUserCurrentPasswordDAL(_userId);

        if (dataTable.Rows.Count == 0)
        {
            return true;
        }

        string currentPassword = Convert.ToString(dataTable.Rows[0]["Password"]);
        return currentPassword != newPassword;
    }

    private bool IsStrongPassword(string password)
    {
        return Regex.IsMatch(password, @"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z\d]).{12,20}$");
    }
}
