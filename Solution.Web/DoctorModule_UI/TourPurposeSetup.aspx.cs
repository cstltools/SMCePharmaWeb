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

public partial class DoctorModule_UI_TourPurposeSetup : System.Web.UI.Page
{
    private static TourTypeDal tourTypeDal = new TourTypeDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static ResultInfo  Save_TourPurpose(TourPurpose purpose)
    {
        return (tourTypeDal.SaveTourPurpose(purpose, HttpContext.Current.Session["UserId"].ToString()));
    }

    [WebMethod]
    public static TourPurpose GetTourPurposeEditData(int id)
    {
        return (tourTypeDal.GetTourPurposeForEdit(id));
    }
}