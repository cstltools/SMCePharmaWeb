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

public partial class DoctorModule_UI_RouterSetupEntry : System.Web.UI.Page
{
    private static RouterSetup _routerSetup = new RouterSetup();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo Save_RouterSetup(RouterMaster router)
    {
        
            return (_routerSetup.Save_RouterSetup(router, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        
    }


    [WebMethod]
    public static string  GetmarketByTerryTori()
    {
        DataTable dt = _routerSetup.GetMarketByTerriTory();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
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

    [WebMethod]
    public static string GetmarketByTerryTori_ById(int Id)
    {
        DataTable dt = _routerSetup.GetMarketByTerriToryById(Id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static RouterMaster  GetRouterEditData(int id)
    {
        return (_routerSetup.GetRouterMasterForEdit(id));
    }
}