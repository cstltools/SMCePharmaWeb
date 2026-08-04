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

public partial class DoctorModule_UI_DesignationView : System.Web.UI.Page
{
    private static DesignationDal _designationDal=new DesignationDal();
    protected void Page_Load(object sender, EventArgs e)
    {


    }

    [WebMethod]
    public static string   GetDesignationList()
    {
        string param = " ";

        DataTable dt = _designationDal.GetDesignationList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static ResultInfo ActiveInactive_DesignationInfo(int Id)
    {
        return (_designationDal.ActiveInactive_DesignationInfo(Id, 2));
    }
}