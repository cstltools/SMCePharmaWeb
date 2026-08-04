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

public partial class Thana_UI_District_Entry : System.Web.UI.Page
{
    private static ThanaDal _Thana = new ThanaDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static ResultInfo Save_ThanaInfo(ThanaDao thanaDao)
    {

        
        return (_Thana.SaveThanaInfo(thanaDao, HttpContext.Current.Session["UserId"].ToString()));
        
    }

    [WebMethod]
    public static string Get_Division_All_DDL()
    {
        DataTable dt = _Thana.GetDivision_All_DDL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string Get_District_All_DDL(string id)
    {
        DataTable dt = _Thana.GetDistrict_All_DDL(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string Get_Thana_By_Id(string id)
    {
        DataTable dt = _Thana.Get_Thana_By_Id_Dal(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
}