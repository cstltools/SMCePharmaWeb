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

public partial class DoctorModule_UI_GenericGroupView : System.Web.UI.Page
{
    private static GenericGroupDal groupDal=new GenericGroupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetGenericGroupList()
    {
        string param = " ";
        DataTable dt = groupDal.GetGenericGroupList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}