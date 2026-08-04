using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using Library.BLL.SInventory_BLL;

using Library.DAO.SInventory_Entities;

public partial class HRM_UI_DepartmentEdit : System.Web.UI.Page
{
    DepartmentBLL aDepartmentBll = new DepartmentBLL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            deptIdHiddenField.Value = Request.QueryString["ID"];
            DepartmentLoad(deptIdHiddenField.Value);
        }
    }
    protected void updateButton_Click(object sender, EventArgs e)
    {
        if (departmentNameTextBox.Text != "" )
        { 
            Department aDepartment = new Department()
            {
                DepartmentId = Convert.ToInt32(deptIdHiddenField.Value),
                DepartmentName = departmentNameTextBox.Text                
            };
            DepartmentBLL aDepartmentBll = new DepartmentBLL();

            if (!aDepartmentBll.UpdateDataForDepartment(aDepartment))
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

    private void DepartmentLoad(string departmentId)
    {
        Department aDepartment = new Department();
        aDepartment = aDepartmentBll.DepartmentEditLoad(departmentId);
        departmentNameTextBox.Text = aDepartment.DepartmentName;    
    }


    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
}