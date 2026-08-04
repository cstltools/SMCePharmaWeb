using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorMaster_DAL;
using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_DoctorSpecialityView : System.Web.UI.Page
{
    private static DoctorSpecialityDal setup = new DoctorSpecialityDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string Get_DoctorSpeciality()
    {
        DataTable ds = setup.GetDoctorSpecialityList();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Delete_DoctorSpeciality(int Id)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.DeleteDoctorSpeciality(Id, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }
}