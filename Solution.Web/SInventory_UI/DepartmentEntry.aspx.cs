using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.BLL.SInventory_BLL;
using Library.DAO.SInventory_Entities;

public partial class SInventory_UI_DepartmentEntry : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    private void Clear()
    {
       DepartmentNameTextBox.Text = string.Empty;       
    }
   
    protected void submitButton_Click(object sender, EventArgs e)
    {
        if ( DepartmentNameTextBox.Text !="")
        {
            Department aDepartment = new Department()
                 {
                    DepartmentName = DepartmentNameTextBox.Text
                 };
            DepartmentBLL aDepartmentBll=new DepartmentBLL();
            MessageLabel.Text = aDepartmentBll.SaveDataForDepartment(aDepartment);
            Clear();
        }
        else
        {
            MessageLabel.Text = "Please input data in all Textbox";
        }
    }
    protected void departmentListImageButton_Click(object sender, ImageClickEventArgs e)
    {
        Response.Redirect("DepartmentView.aspx");
    }
}