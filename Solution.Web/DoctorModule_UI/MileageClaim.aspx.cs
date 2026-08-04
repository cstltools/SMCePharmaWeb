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

public partial class DoctorModule_UI_MileageClaim : System.Web.UI.Page
{
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetThana_WitTagDetails_forEditPage(int id)
    {
        DataTable dt = _setupDAL.GetThana_All_WithTagInfo_ForEditPage(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static MileageClaimDAO GetMileageClaimEditData(int id)
    {
        return (_setupDAL.GetMileageClaimEditData(id));


    }
    [WebMethod]
    public static ResultInfo Save_MileageClaim(MileageClaimDAO degree)
    {
        return (_setupDAL.Save_MileageClaim(degree, HttpContext.Current.Session["UserId"].ToString()));
    }
}