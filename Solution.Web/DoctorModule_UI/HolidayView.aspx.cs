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

public partial class DoctorModule_UI_HolidayView : System.Web.UI.Page
{
    private static HolidayDal _holidayDal=new HolidayDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static ResultInfo ActiveInactive_EmployeeLeave(int Id)
    {
        return (_holidayDal.ActiveInactive_emplopyeeleave(Id, 2));
    }

    [WebMethod]
    public static string GetHolidayList()
    {
        DataTable dt = _holidayDal.GetHolydayList("");
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

}