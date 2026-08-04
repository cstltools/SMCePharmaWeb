using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_DoctorDesignation : System.Web.UI.Page
{
    public static DoctorDesignationDal setup = new DoctorDesignationDal();
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
    public static ResultInfo Save_DoctorDesignation(DoctorDesignation doctorDesignation)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.SaveDoctorDesignation(doctorDesignation, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }

    [WebMethod(EnableSession = true)]
    public static DoctorDesignation GetDoctorDesignationEditData(int id)
    {
        return setup.GetDoctorDesignationForEdit(id);
    }
}