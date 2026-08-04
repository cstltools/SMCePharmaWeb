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

public partial class UserTracking_UserTrackingList : System.Web.UI.Page
{
    static CommonDataLoad adata=new CommonDataLoad();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetUserLocationTrackig(int empId, DateTime trackDate)
    {
        DataTable dt = adata.GetUserLocationTracking(empId, trackDate);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}