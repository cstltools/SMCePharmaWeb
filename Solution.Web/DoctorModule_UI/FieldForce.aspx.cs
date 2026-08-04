using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAO.DoctorModule_DAO;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_FieldForce : System.Web.UI.Page
{
    private static RSMSetupDal _setupDAL=new RSMSetupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string LoadVacentGroup()
    {
        DataTable dt = _setupDAL.Get_VacentGroup();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] 
    public static string LoadVacentRegion(int groupId)
    {
        DataTable dt = _setupDAL.Get_VacentRegion(groupId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod] 
    public static string LoadVacentArea(int zoneId)
    {
        DataTable dt = _setupDAL.Get_VacentArea(zoneId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static ResultInfo Save_RSMInfo(RSMInfo aRSMInfo)
    {
        return   (_setupDAL.Save_RSMInfo(aRSMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }

    [WebMethod]public static string GetRSMList()
    {
        string param = " ";

        DataTable dt = _setupDAL.Get_RSMInfo(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult; 
    }

    [WebMethod]public static ResultInfo RsmInactiveById(int rsmId)
    {
        return   (_setupDAL.Inactive_RSMInfoById(rsmId, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }

    // ASM / FE 
    [WebMethod]public static string AsmRecords()
    {
        return "";
    }

    [WebMethod]public static ResultInfo Save_ASMInfo(ASMInfo aASMInfo)
    {
        return   (_setupDAL.Save_ASMInfo(aASMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }


    [WebMethod]
    public static ResultInfo InsertUpdate_ASMInfo(ASMInfo aASMInfo)
    {
        return (_setupDAL.InsertUpdate_ASMInfoDAL(aASMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }


    [WebMethod]
    public static ResultInfo Save_UserRoleInfo(UserRoleDao aRoleInfo)
    {
        return   (_setupDAL.Save_UserRoleInfo(aRoleInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    } 
    
    [WebMethod]
    public static ResultInfo Save_NSMInfo(NSMInfo aNSMInfo)
    {
        return   (_setupDAL.Save_NSMInfo(aNSMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    } [WebMethod]
    public static ResultInfo Save_NSMHeadInfo(NSMInfo aNSMInfo)
    {
        return   (_setupDAL.Save_NSMInfo(aNSMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }

    [WebMethod]
    public static string GetUserRoleList()
    {
        string param = " ";

        DataTable dt = _setupDAL.Get_UserRoleInfo(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }


    [WebMethod]
    public static string GetUserInfoList()
    {
        string param = " ";

        DataTable dt = _setupDAL.Get_UserListInfo(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }



    [WebMethod]
    public static NSMInfo GetNSMSetupEditData(int id)
    {
        return (_setupDAL.GetNSMSetupEditDataDAL(id));
    }




    [WebMethod]
    public static NSMInfo GetNSMSetupEditDataByEmpId(int id)
    {
        return (_setupDAL.GetNSMSetupEditDataByEmpIdDAL(id));
    }

    [WebMethod]
    public static UserRoleDao GetUserRoleEditData(int id)
    {
        return (_setupDAL.GetUserRoleEditDataDAL(id));
    }


    [WebMethod]
    public static RSMInfo GeDZSMSetupEditData(int id)
    {
        return (_setupDAL.GeDZNSMSetupEditDataDAL(id));
    }

    [WebMethod]
    public static RSMInfo GeDZSMSetupEditDataByEMPID(int id)
    {
        return (_setupDAL.GeDZSMSetupEditDataByEMPIDDAL(id));
    }


    [WebMethod]
    public static ASMInfo GeAMSetupEditData(int id)
    {
        return (_setupDAL.GeAMSetupEditDataDAL(id));
    }




    [WebMethod]
    public static MIOInfo GeMIOtupEditData(int id)
    {
        return (_setupDAL.GeMIOetupEditDataDAL(id));
    }


    [WebMethod]
    public static MIOInfo GeMIOMasterDataByEmpID(int id)
    {
        return (_setupDAL.GeMIOMasterDataByEmpIDDAL(id));
    }


    [WebMethod]
    public static ASMInfo GAMMasterDataByEmpID(int id)
    {
        return (_setupDAL.GAMMasterDataByEmpIDDAL(id));
    }

    [WebMethod]
    public static string GetNSMList()
    {
        string param = " ";

        DataTable dt = _setupDAL.Get_NSMInfo(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    } [WebMethod]
    public static string GetNSMHeadList()
    {
        string param = " ";

        DataTable dt = _setupDAL.GetNSMHeadList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static string GetASMList()
    {
        string param = " ";

        DataTable dt = _setupDAL.Get_ASMInfo(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]public static ResultInfo AsmInactiveById(int asmId)
    {
        return   (_setupDAL.Inactive_ASMInfoById(asmId, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }

    [WebMethod]public static string AsmSetup()
    {
        return "";
    }

    // MIO
    [WebMethod]public static string MioRecords()
    {
        return "";
    }

    [WebMethod]public static string MioSetup()
    {
        return "";
    }

    [WebMethod]
    public static ResultInfo Save_MIOInfo(MIOInfo aMIOInfo)
    {
        return   (_setupDAL.Save_MIOInfo(aMIOInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }
    [WebMethod]
    public static ResultInfo Insert_Update_MIOInfo(MIOInfo aMIOInfo)
    {
        return (_setupDAL.Insert_Update_MIOInfoDAL(aMIOInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }

    [WebMethod] public static string LoadVacentTerritory(int areaId)
    {
        DataTable dt = _setupDAL.Get_VacentTerritory(areaId);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }
    [WebMethod] public static string GetMIOList()
    {
        string param = " ";

        DataTable dt = _setupDAL.Get_MIOInfo(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]public static ResultInfo MioInactiveById(int mioId)
    {
        return   (_setupDAL.Inactive_MIOInfoById(mioId, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }
}