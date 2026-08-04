using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_ChamberTypeView : System.Web.UI.Page
{
    private static DoctorChamberDal setup = new DoctorChamberDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string Get_Doctor_Chamber()
    {
        DataTable ds = setup.GetDoctorChamberList();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Delete_Doctorchamber(int Id)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.DeleteDoctorchamber(Id, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }
}