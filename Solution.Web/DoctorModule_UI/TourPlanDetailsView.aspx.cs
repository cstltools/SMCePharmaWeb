using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_TourPlanDetailsView : System.Web.UI.Page
{
    private static TourTypeDal tourTypeDal = new TourTypeDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string GetTourPlanDetailsViewDatabyID(int id)
    {


        DataTable dt = tourTypeDal.GetTourPlanDetailsViewDatabyID(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string Get_TourPlanBalance(int empId, int Month, int year)
    {


        DataTable dt = tourTypeDal.Get_TourPlanBalanceDAL(empId,Month, year);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}