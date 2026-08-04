using System;
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

public partial class DoctorModule_UI_LeaveView : System.Web.UI.Page
{
    private static LeaveDal _leaveDal=new LeaveDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string  GetLeaveList()
    {
        DataTable dt = _leaveDal.GetLeaveList("");
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static ResultInfo ActiveInactive_EmployeeLeave(int Id)
    {
        return (_leaveDal.ActiveInactive_emplopyeeleave(Id, 2));
    }
    [WebMethod]
    public static ResultInfo Delete_EmployeeLeave(int Id)
    {
        return (_leaveDal.Delete_employeeleave(Id));
    }
}