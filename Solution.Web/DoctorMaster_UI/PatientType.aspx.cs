using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using Library.DAO.DoctorMaster_Dao;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_PatientType : System.Web.UI.Page
{
    
    private static PatientTypeDal aTypeDal = new PatientTypeDal();

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
    public static ResultInfo Save_PatientTypeDay(PatientTypeDao aPatientTypeDao)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = aTypeDal.SaveDoctorpatientType(aPatientTypeDao, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }

    [WebMethod(EnableSession = true)]
    public static PatientTypeDao GetDoctorSpecialDayForEdit(int id)
    {
        return aTypeDal.GetDoctorPatientTypeForEdit(id);
    }
}