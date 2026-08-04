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
using Library.DAO.DoctorModule_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.Models;

public partial class DoctorMaster_UI_PrescriptionTypeView : System.Web.UI.Page
{
   
    private  static PrescriptionTypeDal  aTypeDal = new PrescriptionTypeDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod(EnableSession = true)]
    public static string Get_PrescriptionTypeList()
    {
        DataTable ds = aTypeDal.GetPrescriptionTypeList();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }



    //[WebMethod(EnableSession = true)]
    //public static ResultInfo Delete_DoctorSpecialDay(int Id)
    //{
    //    ResultInfo resultInfo = new ResultInfo();
    //    resultInfo = aTypeDal.Delete_PrescriptionType(Id, HttpContext.Current.Session["UserId"].ToString());
    //    return resultInfo;
    //}

}