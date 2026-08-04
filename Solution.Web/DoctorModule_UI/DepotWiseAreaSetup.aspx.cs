using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_DepotWiseAreaSetup : System.Web.UI.Page
{

    private static DepotWiseAreaSetupDal _aRepo = new DepotWiseAreaSetupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod]
    public static string LoadCompany()
    {
        DataTable dt = _aRepo.GetCompanyList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }
    [WebMethod]
    public static string LoadDepotlist(int comapnyId)
    {
        DataTable dt = _aRepo.GetDepotList(comapnyId);
        string JSONresult;
         
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string LoadAreaByDepotId(int depotId)
    {
        DataTable dt = _aRepo.GetAreaByDepotId(depotId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]



    //public static ResultInfo Save_Depot(List<DepotWiseAreaDao> areaDao)
    //{
    //    //return Json(_aRepo.DepotWiseAreaInfo(areaDao, 1), JsonRequestBehavior.AllowGet);
    //    return Json("Success", JsonRequestBehavior.AllowGet);



    //}


    public static ResultInfo Save_DepotWiseAreaInfo(DepotWiseAreaDao areaDao, string DcId)
    {
        


        return  (_aRepo.DepotWiseAreaInfo(areaDao, 1, (DcId != "" || DcId != null) ? Convert.ToInt32(DcId) : 0));
         
    }
}