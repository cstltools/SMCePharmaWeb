using Library.DAL.DoctorVisit_DAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorVisit_UI_DoctorVisitReport : System.Web.UI.Page
{
    public static  DoctorVisitDAL _DoctorVisit_DAL = new DoctorVisitDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod]
    public static string GetDoctorVisitList(string param)
    {
        DataTable dt = _DoctorVisit_DAL.GetDoctorVisitList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string GetDynamicPivotDoctorWiseDoctorVisitPlan(string param)
    {
        DataTable dt = _DoctorVisit_DAL.DynamicPivotDoctorWiseDoctorVisitPlan(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

}