using Library.DAL.UserProfileDAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
 

public partial class UserProfile_UI_UserProfile : System.Web.UI.Page
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
             

               // GetOneRecord(Session["EmpInfoId"].ToString());
                GetOneRecordPassword(_userId);


             
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
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','ChangePassword.aspx');", true);
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }
    }

    private bool Validat()
    {

        txt_Password.CssClass = "form-control form-control-sm";
        txtConfirm.CssClass = "form-control form-control-sm";
        txtConfirm.CssClass = "form-control form-control-sm";
        bool isVAlid = true;
        if (txt_Password.Text.Trim() == "")
        {
            txt_Password.ToolTip = "please fill out this field";
            txt_Password.CssClass = "form-control form-control-sm is-invalid";
            txt_Password.Focus();
            isVAlid = false;
        }


        if (txtConfirm.Text.Trim() == "")
        {
            txtConfirm.ToolTip = "please fill out this field";
            txtConfirm.CssClass = "form-control form-control-sm is-invalid";
            txtConfirm.Focus();
            isVAlid = false;
        }

        if (txt_Password.Text.Trim() != "" && txtConfirm.Text.Trim() != "")
        {
            if (txt_Password.Text.Trim() != txtConfirm.Text.Trim())
            {
                txtConfirm.ToolTip = "please fill out this field";
                txtConfirm.CssClass = "form-control form-control-sm is-invalid";
                txtConfirm.Focus();
                isVAlid = false; 
            }
        }
        return isVAlid;
    }
}
