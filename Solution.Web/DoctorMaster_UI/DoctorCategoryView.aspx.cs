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

public partial class DoctorMaster_UI_DoctorCategoryView : System.Web.UI.Page
{
    public static DoctorCategoryDal setup = new DoctorCategoryDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string Get_DoctorCategory()
    {
        DataTable ds = setup.GetDoctorCategoryList();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }


    //[WebMethod(EnableSession = true)]
    //public static ResultInfo Delete_DoctorCategory(int Id)
    //{
    //    //ResultInfo resultInfo = new ResultInfo();
    //    //resultInfo = setup.DeleteDoctorcategory(Id, Session["UserId"].ToString());
    //    //return resultInfo;
    //}
}