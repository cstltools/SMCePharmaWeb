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

public partial class Thana_UI_District_View : System.Web.UI.Page
{
    private static ThanaDal _Thana = new ThanaDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static  string
        GET_District_All_List()
    {
        DataTable dt = _Thana.Get_District_All_List();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}