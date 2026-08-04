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

public partial class DoctorModule_UI_GenericGroupEntry : System.Web.UI.Page
{

    private static GenericGroupDal groupDal = new GenericGroupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static  ResultInfo Save_GenericGroup(GenericGroup generic)
    {
        
            return (groupDal.Save_GenericGroup(generic, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        
    }
    [WebMethod]
    public static GenericGroup GetGenericGroupEditData(int id)
    {
        return (groupDal.GetGenericGroupForEdit(id));
    }
}