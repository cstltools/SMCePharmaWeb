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

public partial class DoctorModule_UI_ShiftInfoEntry : System.Web.UI.Page
{
    private static  AttendanceDAL _AttendanceDAL=new AttendanceDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo Save_ShiftInfo(Employee_ShiftInfosDAO DAO)
    {
        return (_AttendanceDAL.Save_ShiftInfo(DAO, HttpContext.Current.Session["UserId"].ToString()));
    }
    [WebMethod]
    public static Employee_ShiftInfosDAO GetShiftInfoEditData(int id)
    {
        return (_AttendanceDAL.GetShiftInfoEditData(id));
    }
}