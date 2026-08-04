using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_Designation : System.Web.UI.Page
{
    private static DesignationDal _designationDal = new DesignationDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static ResultInfo Save_DesignationInfo(Designation designation)
    {

        string sessId = HttpContext.Current.Session["UserId"].ToString();


        return (_designationDal.Save_DesignationInfo(designation, Convert.ToInt32(sessId)));
        

    }
    [WebMethod]
    public static Designation GetDesignationEditData(int id)
    {
        return (_designationDal.GetDesignationForEdit(id));
    }
}