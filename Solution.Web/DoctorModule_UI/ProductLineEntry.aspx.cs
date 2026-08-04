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

public partial class DoctorModule_UI_ProductLineEntry : System.Web.UI.Page
{
    private static TherapueticGroupDal therapueticGroupDal = new TherapueticGroupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo Save_TherapueticGroup(TherapeuticGroup therapeutic)
    {
        
            return (therapueticGroupDal.Save_TherapueticGroup(therapeutic, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        
    }

    [WebMethod]
    public static TherapeuticGroup GetTherapueticGroupEditData(int id)
    {
        return (therapueticGroupDal.GetTherapueticGroupForEdit(id));
    }
}