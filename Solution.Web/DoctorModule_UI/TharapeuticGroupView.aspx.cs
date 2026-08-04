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

public partial class DoctorModule_UI_TharapeuticGroupView : System.Web.UI.Page
{
    private static TherapueticGroupDal therapueticGroupDal=new TherapueticGroupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetTherapueticGroupList()
    {
        string param = " ";
        DataTable dt = therapueticGroupDal.GetTherapueticGroupList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetProductLineList()
    {
        string param = " ";
        DataTable dt = therapueticGroupDal.GetProductLineList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}