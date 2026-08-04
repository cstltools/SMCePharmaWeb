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

public partial class DoctorModule_UI_Leave : System.Web.UI.Page
{
    private static LeaveDal _leaveDal = new LeaveDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static EmployeeLeave GetEmployeeEditData(int id)
    {
        return (_leaveDal.GetEmployeeLeaveForEdit(id));
    }

    [WebMethod]
    public static ResultInfo Save_Leaveinfo(EmployeeLeave employee)
    {

        
            return (_leaveDal.Save_LeaveInfo(employee, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        

    }
}