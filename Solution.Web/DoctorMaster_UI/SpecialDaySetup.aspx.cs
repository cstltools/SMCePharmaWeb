using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_SpecialDaySetup : System.Web.UI.Page
{
    private static DoctorSpecailDayDal setup = new DoctorSpecailDayDal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != "" && Request.QueryString["id"] != null)
        {
            masterId.Text = Request.QueryString["id"];
        }
        else
        {
            masterId.Text = 0.ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Save_DoctorSpeacialDay(DoctorSpecailDay doctorSpecailDay)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.SaveDoctorSpeacialDay(doctorSpecailDay, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }

    [WebMethod(EnableSession = true)]
    public static DoctorSpecailDay GetDoctorSpecialDayForEdit(int id)
    {
        return setup.GetDoctorSpecialDayForEdit(id);
    }
}