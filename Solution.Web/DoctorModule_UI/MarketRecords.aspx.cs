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

public partial class DoctorModule_UI_MarketRecords : System.Web.UI.Page
{
    static Setup2DAL _setupDAL = new Setup2DAL();
    static CommonDataLoad _dataLoad4 = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string GetMarketList()
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
               
                    masArea= areaId.TrimEnd(',');

                    if (masArea == "")
                    {
                        dt = _setupDAL.GetMarketList("  and  A.AreaId in (" + dtMarket.Rows[0]["AreaId"].ToString() + ")");
                    }

                    else
                    {
                        dt = _setupDAL.GetMarketList(" and  A.AreaId in (" + masArea+")");

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
                        dt = _setupDAL.GetMarketList("  and  R.RegionId in (" + dtMarket.Rows[0]["RegionId"].ToString() + ")");
                    }

                    else
                    {
                        dt = _setupDAL.GetMarketList(" and R.RegionId in (" + masArea + ")");

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
                        dt = _setupDAL.GetMarketList("  and  G.GroupId in (" + dtMarket.Rows[0]["RegionId"].ToString() + ")");
                    }

                    else
                    {
                        dt = _setupDAL.GetMarketList(" and G.GroupId in (" + masArea + ")");

                    }
                    break;


                default:
                    dt = _setupDAL.GetMarketList("");
                    break;


            }
        }
         
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}