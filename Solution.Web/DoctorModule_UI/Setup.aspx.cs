using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Library.DAO.DoctorModule_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_Setup : System.Web.UI.Page
{
    //private readonly iZoneSetup _aRepo;
    private static TourTypeDal tourTypeDal = new TourTypeDal();
    private static Setup2DAL _setupDAL=new Setup2DAL();
    private static ZoneSetupDAL azone=new ZoneSetupDAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();

    //DoctorApiClient docClient;
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    static CommonDataLoad _dataLoad4 = new CommonDataLoad();
    //Product_HttpClient _productClient;
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    //public static string ImageUpload(PrescriptionMaster model)
    //{
    //    string path = @"D:\Files\";
    //    string imgId = "";
    //    var file = model.ImageName;

    //    if (file != null)
    //    {
    //        if (!Directory.Exists(path))
    //        {
    //            Directory.CreateDirectory(path);
    //        }
    //        file.SaveAs(path + Path.GetFileName(file.FileName));

    //        imgId = path + Path.GetFileName(file.FileName);
    //    }
    //    return  (imgId );
    //}
    ////Doctor Setup

    ////public async Task<static string> GetInstitutionList()
    ////{
    ////    DataTable dt = await _aRepo.GetInstitutionList();
    ////    string JSONresult;
    ////    JSONresult = JsonConvert.SerializeObject(dt);
    ////    return  (JSONresult );
    ////}


    ////public static string TourPlanDetailsView(int id = 0)
    ////{

    ////    ViewBag.Id = id;
    ////    return View();
    ////}
    [WebMethod]


    public static ResultInfo Approve_PrescriptionList(string MyArry, string rbValue)
    {

        return (_setupDAL.Approve_PrescriptionList(MyArry, rbValue, HttpContext.Current.Session["UserId"].ToString()));


    }
    [WebMethod]

    public static string TourPlanApproveList(string param)
    {
        DataTable dt = tourTypeDal.GetTourPlanList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //public static string Approve_ExpenseClaimList(string MyArry, string rbValue)
    //{

    //    return  (_setupDAL.Approve_ExpenseClaimList(MyArry, rbValue, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );


    //}

    //public static string Approve_MileageClaimList(string MyArry, string rbValue)
    //{

    //    return  (_setupDAL.Approve_MileageClaimList(MyArry, rbValue, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );


    //}

    ////public static string ZoneSetup(int id = 0)
    ////{
    ////    ViewBag.Id = id;
    ////    return View();
    ////}


    ////public static string ZoneRecords()
    ////{

    ////    return View();
    ////}

    [WebMethod]
    public static string GetZoneList()
    {
        DataTable dt =  azone.GetZoneList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }



    [WebMethod]
    public static ResultInfo SaveZone(Zone Zone)
    {
        return (azone.SaveZoneInfo(Zone, HttpContext.Current.Session["UserId"].ToString()));
    }

    [WebMethod]
    public ResultInfo Approve_TourPlanList(string MyArry, string rbValue)
    {

        return  (tourTypeDal.Approve_TourPlanList(MyArry, rbValue, HttpContext.Current.Session["UserId"].ToString()));


    }

    [WebMethod]
    public static Zone GetZoneEditData(int id)
    {
        return (azone.GetEditData(id));
    }


    //#region Zone
    //public static string ZoneSetup(int id = 0)
    //{

    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        ViewBag.Id = id;
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }

    //}

    //public static string ZoneRecords()
    //{

    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}

    //public async Task<static string> GetZoneList()
    //{
    //    DataTable dt = await _aRepo.GetZoneList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string SaveZone(Zone Zone)
    //{

    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        return  (_aRepo.SaveZoneInfo(Zone, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }

    //}



    //public static string GetZoneEditData(int id)
    //{
    //    return  (_aRepo.GetEditData(id) );
    //}
    //#endregion

    //#region Area Setup

    //public static string AreaSetup(int id = 0)
    //{


    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        ViewBag.Id = id;
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }



    //}

    [WebMethod]
    public static ResultInfo SaveArea(Area masterData)
    {

        
            return (_setupDAL.SaveAreaInfo(masterData, HttpContext.Current.Session["UserId"].ToString()));
        
    }


    //public static string AreaRecords()
    //{

    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {

    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }

    //}

    [WebMethod]
    public static Area GetAreaEditData(int id)
    {
        return (_setupDAL.GetEditData_Area(id));
    }




    [WebMethod]
    public static string GetAreaList(int RegionId)
    {
        DataTable dt = _setupDAL.GetAreaList(RegionId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    //#endregion

    //#region Territory
    //public static string TerritorySetup(int id = 0)
    //{


    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        ViewBag.Id = id;
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }

    //}

    //public static string GetAreaList_Active()
    //{
    //    DataTable dt = _setupDAL.GetAreaList_OnlyActive();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string GetAreaList_Active_ByZoneId(int id)
    //{
    //    DataTable dt = _setupDAL.GetAreaList_OnlyActive_ByZoneId(id);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string GetDistrict_ByDivision_Active(int DivisionId)
    //{
    //    DataTable dt = _setupDAL.GetDistrict_ByDivision_Active(DivisionId);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    [WebMethod]
    public static ResultInfo SaveTerritory(Territory masterData)
    {

        
            return (_setupDAL.SaveTerritory(masterData, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        
    }


    [WebMethod]
    public static ResultInfo SaveSubTerritory(SubTerritoryDAO masterData)
    {


        return (_setupDAL.SaveSubTerritory(masterData, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));

    }

    //public static string TerritoryRecords()
    //{

    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {

    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}

    [WebMethod]
    public static string GetTerritoryList(int RegionId, int areaId)
    {
        DataTable dt = _setupDAL.GetTerritoryList(RegionId, areaId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetSubTerritoryList()
    {

        string RoleTypeName = "";
        string EmpInfoId = "";
        string ToRoleTypeId = "";
        string ApprovalStatus = "";

        try
        {
            RoleTypeName = HttpContext.Current.Session["RoleTypeName"].ToString();
            EmpInfoId = HttpContext.Current.Session["EmpInfoId"].ToString();
            ToRoleTypeId = HttpContext.Current.Session["RoleTypeId"].ToString();

        }
        catch { }

        DataTable dt = new DataTable();
        if (EmpInfoId != "" || EmpInfoId != null)
        {
            DataTable dtMarket = _dataLoad4.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

            string FFID = "";
            string areaId = "";
            string masArea = "";
            switch (RoleTypeName)
            {

                case "AM":


                    for (int i = 0; i < dtMarket.Rows.Count; i++)
                    {
                        areaId = areaId + dtMarket.Rows[i]["AreaId"].ToString() + ',';
                    }

                    masArea = areaId.TrimEnd(',');

                    if (masArea == "")
                    {
                        dt = _setupDAL.GetSubTerritoryList("  and  ar.AreaId in (" + dtMarket.Rows[0]["AreaId"].ToString() + ")");
                    }

                    else
                    {
                        dt = _setupDAL.GetSubTerritoryList(" and  ar.AreaId in (" + masArea + ")");

                    }

                    break;
                case "DZSM":

                    for (int i = 0; i < dtMarket.Rows.Count; i++)
                    {
                        areaId = areaId + dtMarket.Rows[i]["RegionId"].ToString() + ',';
                    }
                    masArea = areaId.TrimEnd(',');

                    if (masArea == "")
                    {
                        dt = _setupDAL.GetSubTerritoryList("  and  R.RegionId in (" + dtMarket.Rows[0]["RegionId"].ToString() + ")");
                    }

                    else
                    {
                        dt = _setupDAL.GetSubTerritoryList(" and R.RegionId in (" + masArea + ")");

                    }
                    break;
                case "NSM":
                    for (int i = 0; i < dtMarket.Rows.Count; i++)
                    {
                        areaId = areaId + dtMarket.Rows[i]["GroupId"].ToString() + ',';
                    }
                    masArea = areaId.TrimEnd(',');

                    if (masArea == "")
                    {
                        dt = _setupDAL.GetSubTerritoryList("  and  G.GroupId in (" + dtMarket.Rows[0]["RegionId"].ToString() + ")");
                    }

                    else
                    {
                        dt = _setupDAL.GetSubTerritoryList(" and G.GroupId in (" + masArea + ")");

                    }
                    break;


                default:
                    dt = _setupDAL.GetSubTerritoryList("");
                    break;


            }
        }
    
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static Territory GetTerrritoryEditData(int id)
    {
        return (_setupDAL.GetEditData_Territory(id));
    }


    [WebMethod]
    public static SubTerritoryDAO GetSubTerrritoryEditData(int id)
    {
        return (_setupDAL.GetEditData_SubTerritory(id));
    }


    //#endregion

    //public static string GetMileageClaimEditData(int id)
    //{
    //    return  (_setupDAL.GetMileageClaimEditData(id) );


    //}

    //#region Market

    //public static string MarketSetup(int id = 0)
    //{
    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        ViewBag.Id = id;
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}

    //public static string SaveMarket(Market masterData)
    //{

    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {
    //        var User = Convert.ToInt32(HttpContext.Current.HttpContext.Current.Session["UserId"].ToString());

    //        return  (_setupDAL.SaveMarket(masterData, User) );
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}

    //public static string MarketRecords()
    //{
    //    if (HttpContext.Current.HttpContext.Current.Session["UserId"] != null)
    //    {

    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }


    //}

    //public static string GetMarketEditData(int id)
    //{
    //    return  (_setupDAL.GetEditData_Market(id) );
    //}

    //#endregion

    ////public static string AreaSetup(int id = 0)
    ////{

    ////    ViewBag.Id = id;
    ////    return View();
    ////}


    ////public static string SaveArea(Area masterData)
    ////{
    ////    return  (_setupDAL.SaveAreaInfo(masterData, "Shaon") );
    ////}


    ////public static string AreaRecords()
    ////{
    ////    return View();
    ////}


    //public static string GetAreaList()
    //{
    //    DataTable dt = _setupDAL.GetAreaList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}








    ////public static string TerritorySetup(int id=0)
    ////{
    ////    ViewBag.Id = id;
    ////    return View();
    ////}


    ////public static string GetAreaList_Active()
    ////{
    ////    DataTable dt = _setupDAL.GetAreaList_OnlyActive();
    ////    string JSONresult;
    ////    JSONresult = JsonConvert.SerializeObject(dt);
    ////    return  (JSONresult );
    ////}


    ////public static string GetAreaList_Active_ByZoneId(int id)
    ////{
    ////    DataTable dt = _setupDAL.GetAreaList_OnlyActive_ByZoneId(id);
    ////    string JSONresult;
    ////    JSONresult = JsonConvert.SerializeObject(dt);
    ////    return  (JSONresult );
    ////}



    ////public static string SaveTerritory(Territory masterData)
    ////{
    ////    return  (_setupDAL.SaveTerritory(masterData, "Shaon") );
    ////}


    ////public static string TerritoryRecords()
    ////{
    ////    return View();
    ////}

    ////public static string GetTerritoryList()
    ////{
    ////    DataTable dt = _setupDAL.GetTerritoryList();
    ////    string JSONresult;
    ////    JSONresult = JsonConvert.SerializeObject(dt);
    ////    return  (JSONresult );
    ////}

    ////public static string GetTerrritoryEditData(int id)
    ////{
    ////    return  (_setupDAL.GetEditData_Territory(id) );
    ////}









    //public static string GetDoctorSetupyEditData(int id)
    //{

    //    return  (_setupDAL.GetEditData_DoctorSetup(id) );
    //}
    [WebMethod]
    public static string GetThana_WitTagDetails_forEditPage(int id)
    {
        DataTable dt = _setupDAL.GetThana_All_WithTagInfo_ForEditPage(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    ////public static string MarketSetup(int id = 0)
    ////{
    ////    ViewBag.Id = id;
    ////    return View();
    ////}
    //[WebMethod]
    //public static ResultInfo SaveMarket(Market masterData)
    //{
    //    return (_setupDAL.SaveMarket(masterData, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    //}

    ////public static string MarketRecords()
    ////{
    ////    return View();
    ////}

    ////public static string GetMarketList()
    ////{
    ////    DataTable dt = _setupDAL.GetMarketList();
    ////    string JSONresult;
    ////    JSONresult = JsonConvert.SerializeObject(dt);
    ////    return  (JSONresult );
    ////}
    
    [WebMethod]
    

    public static string GetMarketEditData(int id)
    {
        DataTable dt = _setupDAL.GetMarketEditDataDAL(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);

    }

    //public static string SubMarketSetup(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string SaveSubMarket(SubMarket masterData)
    //{
    //    return  (_setupDAL.SaveSubMarket(masterData, "Shaon") );
    //}

    //public static string SubMarketRecords()
    //{
    //    return View();
    //}

    //public static string GetSubMarketList()
    //{
    //    DataTable dt = _setupDAL.GetSubMarketList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string GetSubMarketEditData(int id)
    //{
    //    return  (_setupDAL.GetEditData_SubMarket(id) );
    //}

    //#region DoctorSpecailDay

    //public static string Delete_DoctorSpeacialDay(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorSpecialDayType(Id, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string Save_DoctorSpeacialDay(DoctorSpecailDay doctorSpecailDay)
    //{
    //    return  (_setupDAL.SaveDoctorSpeacialDay(doctorSpecailDay, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string GetDoctorSpeacialDayEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorSpecialDayForEdit(id) );
    //}
    //public static string GetDoctorSpeacialDayList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorSpecialDayList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}
    //public static string SpecialDaySetup(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}
    //public static string SpecialDaySetupView()
    //{
    //    return View();
    //}
    //#endregion

    //#region Doctor Patient Type

    //public static string Delete_DoctorPatientType(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorPatientType(Id, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string Save_DoctorPatientType(DoctorPatientType doctorPatientType)
    //{
    //    return  (_setupDAL.SaveDoctorpatientType(doctorPatientType, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string GetDoctorPatientTypeEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorPatientTypeForEdit(id) );
    //}
    //public static string GetDoctorPatientTypeList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorPatientTypeList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string PatientType(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}
    //public static string PatientTypeView()
    //{
    //    return View();
    //}
    //#endregion

    //#region DoctorChamber

    //public static string Delete_DoctorChamber(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorchamber(Id, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string Save_DoctorChamber(DoctorChamber doctorChamber)
    //{
    //    return  (_setupDAL.SaveDoctorChamber(doctorChamber, HttpContext.Current.HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string GetDoctorChamberEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorChamberForEdit(id) );
    //}
    //public static string GetDoctorChamberList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorChamberList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}
    //public static string ChamberType(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string ChamberTypeView()
    //{
    //    return View();
    //}

    //#endregion

    //#region doctor Speciality

    //public static string Delete_DoctorSpeaciality(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorSpeciality(Id, HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string Save_DoctorSpeaciality(DoctorSpeciality doctorSpeciality)
    //{
    //    return  (_setupDAL.SaveDoctorSpeaciality(doctorSpeciality, HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string GetDoctorSpeacialityEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorSpecialityForEdit(id) );
    //}
    //public static string GetDoctorSpeacialityList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorSpecialityList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string Speciality(int id = 0)
    //{

    //    ViewBag.Id = id;

    //    return View();
    //}
    //public static string SpecialityView()
    //{
    //    return View();
    //}
    //#endregion

    //#region Doctor_Degree

    ////Tareq_28-03-2021 
    //public static string Delete_DoctorDegree(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorDegree(Id, HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string Save_DoctorDegree(DoctorDegree degree)
    //{
    //    return  (_setupDAL.SaveDoctorDegree(degree, HttpContext.Current.Session["UserId"].ToString()) );
    //}


    //public static string Save_MileageClaim(MileageClaimDAO degree)
    //{
    //    return  (_setupDAL.Save_MileageClaim(degree, HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string GetDoctorDegreeEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorDegreeForEdit(id) );
    //}
    //public static string GetExpenseClaimEditData(int id)
    //{
    //    DataTable dt = _setupDAL.GetExpenseClaimEditData(id);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );

    //}

    //public static string GetDoctorDegreeList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorDegreeList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string GetExpenseClaimList(string param)
    //{
    //    DataTable dt = _setupDAL.GetExpenseClaimList(param);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string GetMileageClaimList(string param)
    //{
    //    DataTable dt = _setupDAL.GetMileageClaimList(param);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);


    //    var jsonResult =  (JSONresult );
    //    jsonResult.MaxJsonLength = int.MaxValue;
    //    return jsonResult;

    //}

    //public static string Degree(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string DegreeView()
    //{
    //    return View();
    //}

    //#endregion

    //#region DoctorDesignation

    //public static string Delete_DoctorDesignation(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorchamber(Id, HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string Save_DoctorDesignation(DoctorDesignation designation)
    //{
    //    return  (_setupDAL.SaveDoctorDesignation(designation, HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string GetDoctorDesignationEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorDesignationForEdit(id) );
    //}
    //public static string GetDoctorDesignationList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorDesignationList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string DoctorDesignation(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}
    //public static string DoctorDesignationView()
    //{
    //    return View();
    //}

    //#endregion

    //#region Doctor_Category
    //public static string Delete_DoctorCategory(int Id)
    //{
    //    return  (_setupDAL.DeleteDoctorcategory(Id, HttpContext.Current.Session["UserId"].ToString()) );
    //}
    //public static string Save_DoctorCategory(DoctorCategory doctorCategory)
    //{
    //    return  (_setupDAL.SaveDoctorCategory(doctorCategory, HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string GetDoctorcategoryEditData(int id)
    //{
    //    return  (_setupDAL.GetDoctorCategoryForEdit(id) );
    //}
    //public static string GetDoctorCategoryList()
    //{
    //    DataTable dt = _setupDAL.GetDoctorCategoryList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}
    //public static string DoctorCategory(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}
    //public static string DoctorCategoryView()
    //{
    //    return View();
    //}
    //#endregion

    //#region prescription 
    [WebMethod]
    public static string Get_CapturedBy_For_ddl()
    {
        DataTable dt = _setupDAL.GetCapturedBy_For_ddl();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static string Get_Doctor_For_ddl()
    {
        DataTable dt = _setupDAL.GetDFoctorlist_For_ddl();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static string Get_ProductList_List_New()
    {
        DataTable dt = _setupDAL.Get_ProductList_List();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string Get_PrescriptionType_For_ddl()
    {
        DataTable dt = _setupDAL.GetPrescriptionTypelist_For_ddl();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static string Get_ProductList_For_ddl()
    {
        DataTable dt = _setupDAL.Get_ProductList_For_Ddl();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //public static string Prescription(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    
    //public static string PrescriptionView()
    //{
    //    return View();
    //}

    //[HttpPost]
    //public async Task<static string> Save_PrescriptionMasterDetailsAsync(PrescriptionMaster master, HttpPostedFileBase file)
    //{

    //    ResultInfo result = await docClient.SavePrescription(master);


    //    return  (result );

    //}
    [WebMethod]
    public static ResultInfo Delete_Prescription(int Id)
    {
        return (_setupDAL.Delete__Prescription(Id));
    }


    //public static string GetPrescriptionDetailsListForEdit(int id)
    //{
    //    DataTable dt = _setupDAL.Get_PrescriptionDetailsByPrescriptionId(id);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return (JSONresult);
    //}
    [WebMethod]
    public static string Get_ApprovalStatus_ddl()
    {
        DataTable dt = _seedRepo.GetApprovalStatusList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //#endregion


    //#region Prescription type

    //public static string Delete_PrescriptionType(int Id)
    //{
    //    return  (_setupDAL.Delete_PrescriptionType(Id) );
    //}



    //public static string Save_PrescriptionType(PrescriptionType prescription)
    //{
    //    return  (_setupDAL.SavePrescription(prescription, HttpContext.Current.Session["UserId"].ToString()) );
    //}


    //public static string GetPrescriptiontTypeList()
    //{
    //    DataTable dt = _setupDAL.GetPrescriptionTypeList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    [WebMethod]
    public static string Get_PrescriptionList(string param)
    {
        DataTable dt = _setupDAL.Get_PrescriptionList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //public static string PrescriptionApprovalList()
    //{
    //    if (HttpContext.Current.Session["UserId"] != null)
    //    {
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}

    //public static string ExpenseClaimApprovalList()
    //{
    //    if (HttpContext.Current.Session["UserId"] != null)
    //    {
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}


    //public static string MileageClaimApprovalList()
    //{
    //    if (HttpContext.Current.Session["UserId"] != null)
    //    {
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}

    //public static string PrescriptionType(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}


    //public static string PrescriptionTypeView()
    //{
    //    return View();
    //}


    //#endregion

    //public static string DoctorSetup(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string DoctorSetupView()
    //{
    //    return View();
    //}
    //public static string Get_DoctorList()
    //{
    //    DataTable dt = _setupDAL.Get_DoctorList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    [WebMethod]
    public static string Get_TADAList(string param)
    {
        DataTable dt = _setupDAL.Get_TADAList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //#region Expense_Claim_TransportSetup

    //public static string Delete_Transport(int Id)
    //{
    //    return  (_setupDAL.DeleteTrasport(Id, HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string GetTransportEditData(int id)
    //{
    //    return (_setupDAL.GetTransportForEdit(id));
    //}
    [WebMethod]
    public static string GetTransportList()
    {
        DataTable dt = _setupDAL.GetTransportList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //public static string Transport(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string TransportView()
    //{
    //    return View();
    //}

    //#endregion

    //#region MonthlyAllowance
    //public static string MonthlyAllowance(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}
    //public static string MonthlyAllowanceView()
    //{
    //    return View();
    //}
    [WebMethod]
    public static ResultInfo Delete_MonthlyAllowance(int Id)
    {
        return (_setupDAL.DeleteMonthlyAllowance(Id, HttpContext.Current.Session["UserId"].ToString()));
    }

    //[WebMethod]
    //public static ResultInfo Save_MonthlyAllowance(MonthlyAllowance monthly)
    //{
    //    return (_setupDAL.SaveMonthlyAllowance(monthly, HttpContext.Current.Session["UserId"].ToString()));
    //}
    //[WebMethod]
    //public static MonthlyAllowance GetMonthlyAllowanceEditData(int id)
    //{
    //    return (_setupDAL.GetMonthlyAllowanceForEdit(id));
    //}
    [WebMethod]
    public static string GetMonthlyAllowanceList()
    {
        DataTable dt = _setupDAL.GetMonthlyAllowanceList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string Get_AllowanceName_For_ddl()
    {
        DataTable dt = _setupDAL.GetAllowance_For_ddl();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    //#endregion

    //#region ExpenseType

    //public static string ExpenseType(int Id = 0)
    //{
    //    ViewBag.Id = Id;
    //    return View();
    //}

    //public static string ExpenseTypeView()
    //{
    //    return View();
    //}


    //public static string Save_ExpenseType(ExpenseTypeMaster typeMaster)
    //{

    //    var Id = HttpContext.Current.Session["UserId"].ToString();

    //    ResultInfo result = _setupDAL.SaveExpenseTypeMaster(typeMaster, Id);

    //    var MasterId = result.Id;

    //    foreach (var item in typeMaster.ExpenseTypeDetails)
    //    {
    //        ExpenseTypeDetails ADetailDao = new ExpenseTypeDetails();
    //        ADetailDao.ExpenseTypeId = MasterId;
    //        ADetailDao.FieldName = item.FieldName;
    //        ADetailDao.IsRequied = item.IsRequied;
    //        result = _setupDAL.SaveExpenseTypeDetails(ADetailDao);
    //    }

    //    MasterId = 0;

    //    return  (result );

    //}

    //public static string Save_ExpenseClaim(ExpenseClaimMasterDAO typeMaster)
    //{

    //    var Id = HttpContext.Current.Session["UserId"].ToString();

    //    ResultInfo result = _setupDAL.Save_ExpenseClaim(typeMaster, Id);

    //    var MasterId = result.Id;


    //    MasterId = 0;

    //    return  (result );

    //}


   



    //public static string GetExpensemasterList()
    //{
    //    DataTable dt = _setupDAL.Get_ExpenseTypeMasterList();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}


    //public static string Delete_ExpenseType(int Id)
    //{
    //    return  (_setupDAL.Delete_ExpenseType(Id) );
    //}

    //public static string GetExpensetypeDataForEdit(int id)
    //{
    //    return  (_setupDAL.GetEditDataForExpenseType(id) );
    //}



    //public static string GetExpenseTypeDeatisListForEdit(int id)
    //{
    //    DataTable dt = _setupDAL.Get_ExpenseTypeDetailsByExpenseId(id);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}



    //#endregion

    //public static string TADAClaim()
    //{
    //    return View();
    //}

    //public static string TADAClaimView()
    //{
    //    return View();
    //}

    //public static string MileageClaim(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string MileageClaimView()
    //{
    //    return View();
    //}

    //public static string ExpenseClaim(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string ExpenseClaimView()
    //{
    //    return View();
    //}


    //[HttpPost]
    //public static string SaveFiles(HttpPostedFileBase file, int id)
    //{
    //    //string path = Server.MapPath("~/ProImage/");
    //    string path = @"G:\Files\";
    //    if (file != null)
    //    {
    //        if (!Directory.Exists(path))
    //        {
    //            Directory.CreateDirectory(path);
    //        }
    //        file.SaveAs(path + Path.GetFileName(file.FileName));
    //    }
    //    string fullpath = path + Path.GetFileName(file.FileName);
    //    //  appDal.SaveRecipyFIleDAL((fullpath), file.FileName, id);

    //    return  (new
    //    {
    //        msg = "Successfully Inserted "
    //    });
    //}


    //[WebMethod]
    //public async Task<static string> Get_PrescriptionType_NewAsync()
    //{
    //    return (await docClient.GetPrescriptionTypeAsync());
    //}


    //public async Task<static string> Get_Product_Async()
    //{

    //    return (await _productClient.GetProductsAsync(151));
    //}


    //#region TADA Market Rule Config

    //public static string TADAMarketRuleConfiguration(int id = 0)
    //{
    //    ViewBag.Id = id;

    //    return View();
    //}

    //public static string TADAMarketRuleConfigurationView()
    //{
    //    return View();
    //}

    //public static string Delete_TADAMarketRuleConfiguration(int Id)
    //{
    //    return  (_setupDAL.DeleteTADAMarketRuleConfiguration(Id, HttpContext.Current.Session["UserId"].ToString()) );
    //}
    [WebMethod]
    public static ResultInfo Save_TADAMarketRuleConfiguration(TADAMarketruleConfig tADAMarketrule)
    {
        return (_setupDAL.SaveTADAMarketRuleConfiguration(tADAMarketrule, HttpContext.Current.Session["UserId"].ToString()));
    }
    [WebMethod]
    public static TADAMarketruleConfig GetTADAMarketRuleConfigurationDataById(int id)
    {
        return (_setupDAL.GeTADAMarketRuleConfigurationForEdit(id));
    }
    [WebMethod]
    public static string GetTADAMarketRuleConfigurationList()
    {
        DataTable dt = _setupDAL.GetTADAMarketRuleConfigurationList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string Get_TADAMarketRuleConfiguration_For_ddl()
    {
        DataTable dt = _setupDAL.GetTADAMarketRuleConfiguration_For_ddl();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static string Get_UserRoleInfo()
    {
        DataTable dt = _setupDAL.Get_UserRoleInfo();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetCustomerCategory()
    {
        DataTable dt = _setupDAL.GetCustomerCategory();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }



    [WebMethod]
    public static string GetEmployeeList_Active_Neww()
    {
        DataTable dt = _dataLoad.GetEmployeeList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string GetEmployeeDesignation()
    {
        DataTable dt = _dataLoad.GetDesignation_Active_Emp();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static string Get_UserTypeInfo()
    {
        DataTable dt = _setupDAL.Get_UserTypeInfo();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }


    [WebMethod]
    public static string Get_StationTypeInfo()
    {
        DataTable dt = _setupDAL.Get_StationTypeInfoDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    //#endregion


    //#region DoctorApproval


    //public static string DoctorApproval()
    //{
    //    return View();
    //}


    //public static string Get_DoctorList_Approval()
    //{
    //    DataTable dt = _setupDAL.Get_DoctorList_Approval();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}


    //public static string Approve_DoctorInfo(string MyArry)
    //{

    //    return  (_setupDAL.ApprovalDoctorInfo(MyArry, HttpContext.Current.Session["UserId"].ToString()) );

    //}

    //#endregion
    //public static string Get_TADAList_Approval()
    //{
    //    DataTable dt = _setupDAL.Get_TADAList_For_Approval();
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return  (JSONresult );
    //}

    //public static string Approve_TADAClaim(string MyArry)
    //{
    //    return  (_setupDAL.ApprovalTADAClaim(MyArry, HttpContext.Current.Session["UserId"].ToString()) );
    //}

    //public static string TADAClaimApproval()
    //{
    //    return View();
    //}


    //#region Trainning
    //public static string Trainning(int id = 0)
    //{
    //    if (HttpContext.Current.Session["UserId"] != null)
    //    {
    //        ViewBag.Id = id;
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }
    //}


    //public static string TrainningDetails(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string TrainningDetailsApp(int id = 0)
    //{
    //    ViewBag.Id = id;
    //    return View();
    //}

    //public static string TrainningView()
    //{
    //    if (HttpContext.Current.Session["UserId"] != null)
    //    {
    //        return View();
    //    }
    //    else
    //    {
    //        return RedirectToAction("SignIn", "UserLogin");
    //    }


    //}
    //[ValidateInput(false)]
    //public static ResultInfo Save_Trainning(Trainning trainning)
    //{

    //        return (_setupDAL.Save_Trainning(trainning, HttpContext.Current.Session["UserId"].ToString()));

    //}

    [WebMethod]
    public static string GetTrainningList()
    {
        DataTable dt = _setupDAL.GetTranningList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static ResultInfo Delete_Trainning(int Id)
    {
        return (_setupDAL.Delete_trainning(Id));
    }
    [WebMethod]
    public static Trainning GetTrainningEditData(int id)
    {
        return (_setupDAL.GetTrainningForEdit(id));
    }

    //#endregion

}