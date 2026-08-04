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

public partial class DoctorModule_UI_RouterSetupView : System.Web.UI.Page
{
    private static RouterSetup _routerSetup=new RouterSetup();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string GetRouterMasterList()
    {
        string param = " ";
        DataTable dt = _routerSetup.GetRouterMasterList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}