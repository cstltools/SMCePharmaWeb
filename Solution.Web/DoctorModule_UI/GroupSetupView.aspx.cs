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
using SalesSolution.Web.Controllers;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_GroupSetupView : System.Web.UI.Page
{
    private static GroupSetupDal _groupSetupDal=new GroupSetupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string GetGroupSetupList()
    {
        DataTable dt = _groupSetupDal.GetGroupSetupList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);

    }
    [WebMethod]
    public static ResultInfo ActiveInactive_GroupSetupInfo(int Id)
    {
        return (_groupSetupDal.ActiveInactive_DepartmentInfo(Id, 2));
    }
}