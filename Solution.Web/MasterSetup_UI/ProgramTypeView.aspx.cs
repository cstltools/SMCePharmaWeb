using CrystalDecisions.ReportAppServer.CommonObjectModel;
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

public partial class MasterSetup_UI_ProgramTypeView : System.Web.UI.Page
{

    private static ProgramDal _departmentDal = new ProgramDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static SalesSolution.Web.Models.ResultInfo Save_DepartmentInfo(ProgramType department)
    {

        

            return  (_departmentDal.Save_DepartmentInfo(department, Convert.ToInt32(HttpContext.Current.Session["UserId"])));



    }


    [WebMethod(EnableSession = true)]
    public static SalesSolution.Web.Models.ResultInfo Save_SMCTypeInfo(SMCTypeDAO department)
    {



        return (_departmentDal.Save_SMCTypeInfo(department, Convert.ToInt32(HttpContext.Current.Session["UserId"])));



    }

    [WebMethod(EnableSession = true)]
    public static string GetDepartmentList()
    {
        string param = " ";

        DataTable dt = _departmentDal.GetDepartmentList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }


    [WebMethod(EnableSession = true)]
    public static string GetSMCTypeList()
    {
        string param = " ";

        DataTable dt = _departmentDal.GetSMCTypeList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    //public ActionResult ActiveInactive_departmentInfo(int Id)
    //{
    //    return Json(_departmentDal.ActiveInactive_DepartmentInfo(Id, 2), JsonRequestBehavior.AllowGet);
    //}

    [WebMethod(EnableSession = true)]
    public static ProgramType GetDepartmentEditData(int id)
    {
        return  (_departmentDal.GetEmployeeLeaveForEdit(id));
    }

    [WebMethod(EnableSession = true)]
    public static SMCTypeDAO GetSMCTypeEditData(int id)
    {
        return (_departmentDal.GetSMCTypeEditData(id));
    }
    //public ActionResult Delete_EmployeeDepartment(int Id)
    //{
    //    return Json(_departmentDal.Delete_employeeleave(Id), JsonRequestBehavior.AllowGet);
    //}
}