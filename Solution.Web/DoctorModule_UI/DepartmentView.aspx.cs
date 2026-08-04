using System;
using System.Activities.Expressions;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_DepartmentView : System.Web.UI.Page
{
    private static DepartmentDal _departmentDal=new DepartmentDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetDepartmentList()
    {
        string param = " ";

        DataTable dt = _departmentDal.GetDepartmentList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static ResultInfo ActiveInactive_departmentInfo(int Id)
    {
        return (_departmentDal.ActiveInactive_DepartmentInfo(Id, 2));
    }
    [WebMethod]
    public static ResultInfo Delete_EmployeeDepartment(int Id)
    {
        return (_departmentDal.Delete_employeeleave(Id));
    }
}