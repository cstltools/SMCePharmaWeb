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

public partial class DoctorModule_UI_CommonDataLoad : System.Web.UI.Page
{

    static CommonDataLoad _dataLoad=new CommonDataLoad();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    

    [WebMethod] public static string GetDesignation_Active()
    {
        DataTable dt = _dataLoad.GetDesignation_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDoctorSpeciality_Active()
    {
        DataTable dt = _dataLoad.DoctorSpeciality_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDoctorBrand_Active()
    {
        DataTable dt = _dataLoad.GetDoctorBrand_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetInstitute_Active()
    {
        DataTable dt = _dataLoad.GetInstitute_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }



    //
    [WebMethod] public static string GetZone_byGroupId_Active(int id)
    {
        DataTable dt = _dataLoad.GetZone_byGroupId_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string GetChamber_ByDoctorId(int id)
    {
        DataTable dt = _dataLoad.GetChamber_ByDoctorId(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetZone_byGroupId_All(int id)
    {
        DataTable dt = _dataLoad.GetZone_byGroupId_All(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string GetCompanyInfoAll()
    {
        DataTable dt = _dataLoad.GetCompanyInfoAll();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }
    [WebMethod]
    public static string GetExpenseField_ByExpenseType(int id)
    {
        DataTable dt = _dataLoad.GetExpenseField_ByExpenseType(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }



    [WebMethod] public static string GetArea_ByZoneId_Active(int id)
    {
        DataTable dt = _dataLoad.GetArea_ByZoneId_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetArea_ByZoneId_All(int id)
    {
        DataTable dt = _dataLoad.GetArea_ByZoneId_All(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    //
    [WebMethod] public static string GetContactType()
    {
        DataTable dt = _dataLoad.GetContactType();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetSpecialDay_Active()
    {
        DataTable dt = _dataLoad.GetSpecialDay_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetStationType_Active()
    {
        DataTable dt = _dataLoad.GetStationType_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetChamberType_Active()
    {
        DataTable dt = _dataLoad.GetChamberType_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDivision_Active()
    {
        DataTable dt = _dataLoad.GetDivision_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDistrict_ByDivision_Active(int id)
    {
        DataTable dt = _dataLoad.GetDistrict_ByDivision_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetThana_ByDistrict_Active(int id)
    {
        DataTable dt = _dataLoad.GetThana_ByDistrict_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDoctorType_Active()
    {
        DataTable dt = _dataLoad.GetDoctorType_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDoctorCustomer_Active()
    {
        DataTable dt = _dataLoad.DoctorCustomer_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetProgramType_Active()
    {
        DataTable dt = _dataLoad.DoctorProgramType_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDegree_Active()
    {
        DataTable dt = _dataLoad.GetDegree_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetZone_Active()
    {
        DataTable dt = _dataLoad.GetZone_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod] public static string GetGroupInfo_Active()
    {
        DataTable dt = _dataLoad.GetGroupInfo_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }



  

    [WebMethod]
    public static string GetRoleTypeInfo()
    {
        DataTable dt = _dataLoad.GetRoleTypeInfoDAL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetGroupInfo_All()
    {
        DataTable dt = _dataLoad.GetGroupInfo_All();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetFiscalYearInfo_Active()
    {
        DataTable dt = _dataLoad.GetFiscalYearInfo_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetZone_ActiveById(int id)
    {
        DataTable dt = _dataLoad.GetZone_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }



    [WebMethod] public static string GetTerritory_ByAreaId_Active(int id)
    {
        DataTable dt = _dataLoad.GetTerritory_ByAreaId_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod]
    public static string GetSubTerritory_ByTerritoryId_Active(int id)
    {
        DataTable dt = _dataLoad.GetSubTerritory_ByTerritoryId_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod]
    public static string GetSubTerritory_ByTerritoryId_All(int id)
    {
        DataTable dt = _dataLoad.GetSubTerritory_ByTerritoryId_Alle(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetTerritory_ByAreaId_All(int id)
    {
        DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetMarket_ByTerritoryId_Active(int id)
    {
        DataTable dt = _dataLoad.GetMarket_ByTerritoryId_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string GetMarket_BySubTerritoryId_Active(int id)
    {
        DataTable dt = _dataLoad.GetMarket_ByTerritoryId_Active(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetMarket_BySubTerritoryId_All(int id)
    {
        DataTable dt = _dataLoad.GetMarket_BySubTerritoryId_All(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string GetEmployeeList_All()
    {
        DataTable dt = _dataLoad.GetEmployeeList_All();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetEmployeeList_Active()
    {
        DataTable dt = _dataLoad.GetEmployeeList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDepartment_Active()
    {
        DataTable dt = _dataLoad.GetDepartment_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetDesignation_Active_Emp()
    {
        DataTable dt = _dataLoad.GetDesignation_Active_Emp();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetShift_Active()
    {
        DataTable dt = _dataLoad.GetShift_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string CompanyList_Active()
    {
        DataTable dt = _dataLoad.CompanyList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetTourTypeList_Active()
    {
        DataTable dt = _dataLoad.GetTourTypeList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string GetTourTypeList_All()
    {
        DataTable dt = _dataLoad.GetTourTypeList_ALL();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetTransportList_Active()
    {
        DataTable dt = _dataLoad.GetTransportList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod]
    public static string GetTransportList_All()
    {
        DataTable dt = _dataLoad.GetTransportList_All();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] public static string GetUserList_Active()
    {
        DataTable dt = _dataLoad.GetUserList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetExpenseType()
    {
        DataTable dt = _dataLoad.GetExpenseType();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
}