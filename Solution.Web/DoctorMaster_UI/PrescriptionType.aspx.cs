using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_PrescriptionType : System.Web.UI.Page
{

    private static PrescriptionTypeDal aTypeDal = new PrescriptionTypeDal();



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
    public static ResultInfo Save_PrescriptionType(PrescriptionType aPrescriptionType)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = aTypeDal.Save_PrescriptionType(aPrescriptionType, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }



    [WebMethod(EnableSession = true)]
    public static PrescriptionType GetDoctorSpecialDayForEdit(int id)
    {
        return aTypeDal.GetPrescriptionForEdit(id);
    }
}