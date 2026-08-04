using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_SeedData : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }



    [WebMethod]
    public static string GetDivisionList()
    {
        DataTable dt = _seedRepo.GetDivisions_All();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }
    [WebMethod]
    public static string GetDivisionList_NotInAnyTagWithZone()
    {
        DataTable dt = _seedRepo.GetDivisionList_NotInAnyTagWithZone();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetZoneList_Active()
    {
        DataTable dt = _seedRepo.GetZone_ActiveOnly();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string GetBrandNameALL()
    {
        DataTable dt = _seedRepo.GetBrandNameALL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static string GetDistrictList_Active()
    {
        DataTable dt = _seedRepo.GetDistrict_ActiveOnly();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string GetThana_All()
    {
        DataTable dt = _seedRepo.GetThana_All_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetEmployeeList()
    {
        DataTable dt = _seedRepo.GetEmployee_All();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetEmployee_AllFieldForceEmployeeList()
    {
        DataTable dt = _seedRepo.GetEmployee_AllFieldForceEmployeeList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string GetThana_WitTagDetails()
    {
        DataTable dt = _seedRepo.GetThana_All_WithTagInfo();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string GetGroupList()
    {
        DataTable dt = _seedRepo.GetGroup_All();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetOfferTypeInfo(int id)
    {
        DataTable dt = _seedRepo.GetOfferTypeInfo(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetChemistTypeList()
    {
        DataTable dt = _seedRepo.GetChemistTypeList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetCampaignTypeList()
    {
        DataTable dt = _seedRepo.GetCampaignTypeList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}