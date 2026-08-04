using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_DoctorDesignationView : System.Web.UI.Page
{
    public static DoctorDesignationDal setup = new DoctorDesignationDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string Get_DoctorDesignation()
    {
        DataTable ds = setup.GetDoctorDesignationList();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo Delete_DoctorDesignation(int Id)
    {
        ResultInfo resultInfo = new ResultInfo();
        resultInfo = setup.DeleteDoctorDesignation(Id, HttpContext.Current.Session["UserId"].ToString());
        return resultInfo;
    }
}