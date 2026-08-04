using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_Department : System.Web.UI.Page
{
    private static DepartmentDal _departmentDal = new DepartmentDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo Save_DepartmentInfo(Department department)
    {
        
            return (_departmentDal.Save_DepartmentInfo(department, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        
    }
    [WebMethod]
    public static Department GetDepartmentEditData(int id)
    {
        return (_departmentDal.GetEmployeeLeaveForEdit(id));
    }
}