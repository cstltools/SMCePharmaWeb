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

public partial class DoctorModule_UI_TourTypeSetup : System.Web.UI.Page
{
    private static TourTypeDal tourTypeDal=new TourTypeDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static TourType  GetTourTypeEditData(int id)
    {
        return (tourTypeDal.GetTourTypeForEdit(id));
    }
    [WebMethod]
    public static ResultInfo Save_TourType(TourType tourType)
    {
        return (tourTypeDal.SaveTourType(tourType, HttpContext.Current.Session["UserId"].ToString()));
    }
}