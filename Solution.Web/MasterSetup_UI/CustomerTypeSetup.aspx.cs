using Library.DAL.MasterSetup_DAL; 
using Newtonsoft.Json;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_CustomerTypeSetup : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
    } 

    private static CustomerTypeDal _departmentDal = new CustomerTypeDal();




    [WebMethod]
    public static ResultInfo Save_DepartmentInfo( CustomerType department)
    {
         
            
        return (_departmentDal.Save_DepartmentInfo(department,Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));


    }


    [WebMethod]
    public static string GetDepartmentList()
    {
        string param = " ";

        DataTable dt = _departmentDal.GetDepartmentList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }

    [WebMethod]
    public static ResultInfo ActiveInactive_departmentInfo(int Id)
    {
        return  (_departmentDal.ActiveInactive_DepartmentInfo(Id, 2));
    }

    [WebMethod]
    public static CustomerType GetDepartmentEditData(int id)
    {
        return  (_departmentDal.GetEmployeeLeaveForEdit(id));
    }


    [WebMethod]
    public static ResultInfo Delete_EmployeeDepartment(int Id)
    {
        return  (_departmentDal.Delete_employeeleave(Id));
    }
}
 