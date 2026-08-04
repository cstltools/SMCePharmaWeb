using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using Library.DAL.DoctorModule_DAL;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_ChamberType : System.Web.UI.Page
{
    public static DoctorChamberDal setup = new DoctorChamberDal();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Request.QueryString["id"] != "" && Request.QueryString["id"] != null)
        {
            masterId.Text = Request.QueryString["id"];
        }
        else
        {
            masterId.Text = 0.ToString();
        }
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Save_DoctorChamber(DoctorChamber chamber)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.SaveDoctorChamber(chamber, Convert.ToInt32(HttpContext.Current.Session["UserId"]));
        return resultInfo;
    }


    [WebMethod(EnableSession = true)]
    public static DoctorChamber GetDoctorDegreeEditDataa(int id)
    {
        return setup.GetDoctorChamberForEditt(id);
    }
}