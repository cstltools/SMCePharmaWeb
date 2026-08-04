using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using Newtonsoft.Json;
public partial class DoctorModule_UI_Holiday : System.Web.UI.Page
{

    private static HolidayDal _holidayDal = new HolidayDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static Holiday GetHoliEditData(int id)
    {
        return (_holidayDal.GetholidayForEdit(id));
    }
    [WebMethod]
    public static ResultInfo Save_Holiday(Holiday holiday)
    {

        
            return (_holidayDal.Save_LeaveInfo(holiday, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));


    }

    [WebMethod(EnableSession = true)]
    public static string GetFinanCialyear()
    {
        DataTable ds = _holidayDal.GetFinanCialyear();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

}