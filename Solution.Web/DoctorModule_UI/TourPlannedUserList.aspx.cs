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

public partial class DoctorModule_UI_TourPlannedUserList : System.Web.UI.Page
{
    private static TourTypeDal tourTypeDal=new TourTypeDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string  GetTourPlanList(string param)
    {
        DataTable dt = tourTypeDal.GetTourPlanList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    
    [WebMethod]
    public static string  GetTourPlanReport(string param)
    {
        DataTable dt = tourTypeDal.GetTourPlanList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetYear_Active()
    {
        DataTable dt = tourTypeDal.GetTourPlanUserYear_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}