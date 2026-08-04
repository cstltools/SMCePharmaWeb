using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_Transport : System.Web.UI.Page
{
    private static SetupDAL _setupDAL = new SetupDAL();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static ResultInfo Save_Transport(Transport Transport)
    {
      
        var Id = HttpContext.Current.Session["UserId"].ToString();
       

        return (_setupDAL.SaveTransport(Transport, Id));



    }
    [WebMethod]

    public static Transport GetTransportEditData(int id)
    {
        return (_setupDAL.GetTransportForEdit(id));
    }
}