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

public partial class DoctorModule_UI_TourPurposeRecords : System.Web.UI.Page
{
    private static TourTypeDal tourTypeDal = new TourTypeDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetTourPurposeList()
    {
        DataTable dt = tourTypeDal.GetTourPurposeList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static ResultInfo Delete_TourPurpose(int Id)
    {
        return (tourTypeDal.DeleteTourPurpose(Id, HttpContext.Current.Session["UserId"].ToString()));
    }
}