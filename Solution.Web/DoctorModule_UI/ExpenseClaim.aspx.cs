using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_ExpenseClaim : System.Web.UI.Page
{
    static SeedDataDAL _seedRepo=new SeedDataDAL();
    static Setup2DAL _setupDAL=new Setup2DAL();
    static CommonDataLoad _dataLoad=new CommonDataLoad();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static string GetAreaList_Active_ByZoneId(int id)
    {
        DataTable dt = _setupDAL.GetAreaList_OnlyActive_ByZoneId(id);
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
    

    public static ResultInfo Save_ExpenseClaim(ExpenseClaimMasterDAO typeMaster)
    {

        var Id = HttpContext.Current.Session["UserId"].ToString();

        ResultInfo result = _setupDAL.Save_ExpenseClaim(typeMaster, Id);

        var MasterId = result.Id;


        MasterId = 0;

        return (result);

    }
    //[WebMethod] 
    //public static string GetExpenseClaimEditData(int id)
    //{
    //    DataTable dt = _setupDAL.GetExpenseClaimEditData(id);
    //    string JSONresult;
    //    JSONresult = JsonConvert.SerializeObject(dt);
    //    return (JSONresult);

    //}
    [WebMethod]
    public static string GetExpenseField_ByExpenseType(int id)
    {
        DataTable dt = _dataLoad.GetExpenseField_ByExpenseType(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    [WebMethod]
    public static List<ExpenseClaimDAOTT> GetExpenseClaimEditData(int id)
    {
        return (_setupDAL.GetExpenseClaimEditData(id));


    }
    [WebMethod]
    public static string GetExpenseType()
    {
        DataTable dt = _dataLoad.GetExpenseType();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod]
    public static string GetEmployeeList_Active()
    {
        DataTable dt = _dataLoad.GetEmployeeList_Active();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
    [WebMethod] public static string GetThana_WitTagDetails_forEditPage(int id)
    {
        DataTable dt = _setupDAL.GetThana_All_WithTagInfo_ForEditPage(id);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}