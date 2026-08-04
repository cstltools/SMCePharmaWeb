using Library.DAL.Doctor_Monitoring_DAL;
using Microsoft.VisualBasic.ApplicationServices;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SixTenProjectReportApps : System.Web.UI.Page
{

    private static DoctorMonitoringDAL _DAL = new DoctorMonitoringDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = ""; 
    string areaId = "";
    string masArea = "";
    string strRole = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {

            LoadInitialDDL();
            EmpInfoId = Request.QueryString["EmpInfoId"] != null
      ? Request.QueryString["EmpInfoId"].Trim()
      : string.Empty;
            //usRT.RoleTypeId, usRT.RoleType, usR.RoleName
            DataTable dtEmpInfo = _dataLoad.Get_EmpGeneralInfoByEmployeeId(EmpInfoId);

            if (dtEmpInfo.Rows.Count > 0)
            {
                ToRoleTypeId=dtEmpInfo.Rows[0]["RoleTypeId"].ToString();
                RoleTypeName = dtEmpInfo.Rows[0]["RoleType"].ToString();
            }
            else
            {
                return;
            }
            if (ToRoleTypeId == "")
            {
                return;

            }
            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

                string FFID = "";

                switch (RoleTypeName)
                {

                    case "AM":

                        strRole = "AM";
                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["AreaId"].ToString() + ',';
                        }

                        masArea = areaId.TrimEnd(',');
                        break;

                    case "MIO":

                        strRole = "MIO";
                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["TerritoryId"].ToString() + ',';
                        }

                        masArea = areaId.TrimEnd(',');



                        break;
                    case "DZSM":
                        strRole = "DZSM";

                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["RegionId"].ToString() + ',';
                        }
                        masArea = areaId.TrimEnd(',');

                        break;
                    case "NSM":
                        strRole = "NSM";

                        for (int i = 0; i < dtMarket.Rows.Count; i++)
                        {
                            areaId = areaId + dtMarket.Rows[i]["GroupId"].ToString() + ',';
                        }
                        masArea = areaId.TrimEnd(',');


                        break;


                    default:
                        GroupSelect.SelectedIndex = 1;
                        GroupSelect_SelectedIndexChanged(null, null);

                        break;


                }
            }

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

                string FFID = "";
                switch (RoleTypeName)
                {

                    case "MIO":
                        hfGroupId.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        hfZone.Value = dtMarket.Rows[0]["RegionId"].ToString();
                        hfArea.Value = dtMarket.Rows[0]["AreaId"].ToString();
                        hfTeritory.Value = dtMarket.Rows[0]["TerritoryId"].ToString();
                        GroupSelect.Enabled = false;
                        ZoneSelect.Enabled = false;
                        AreaSelect.Enabled = false;
                        break;

                    case "AM":
                        hfGroupId.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        hfZone.Value = dtMarket.Rows[0]["RegionId"].ToString();
                        hfArea.Value = dtMarket.Rows[0]["AreaId"].ToString();
                        GroupSelect.Enabled = false;
                        ZoneSelect.Enabled = false;
                        //  AreaSelect.Enabled = false;
                        break;
                    case "DZSM":
                        hfGroupId.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        hfZone.Value = dtMarket.Rows[0]["RegionId"].ToString();
                        GroupSelect.Enabled = false;
                        // ZoneSelect.Enabled = false;
                        break;
                    case "NSM":
                        hfGroupId.Value = dtMarket.Rows[0]["GroupId"].ToString();
                        GroupSelect.Enabled = false;
                        break;


                    default:

                        break;


                }
            }
            if (hfGroupId.Value != "")
            {

                try
                {
                    using (DataTable dt = _dataLoad.GetGroupInfo_All())
                    {
                        GroupSelect.DataSource = dt;
                        GroupSelect.DataValueField = "GroupId";
                        GroupSelect.DataTextField = "GroupName";
                        GroupSelect.DataBind();
                        GroupSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        GroupSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                // showMessageBox(hfGroupId.Value);
                GroupSelect.SelectedValue = hfGroupId.Value;


                try
                {

                    using (DataTable dt = _dataLoad.GetZone_byGroupId_All(Convert.ToInt32(GroupSelect.SelectedValue)))
                    {
                        ZoneSelect.DataSource = dt;
                        ZoneSelect.DataValueField = "RegionId";
                        ZoneSelect.DataTextField = "RegionName";
                        ZoneSelect.DataBind();
                        ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        ZoneSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                if (strRole == "DZSM")
                {
                    try
                    {

                        if (masArea == "")
                        {
                            using (DataTable dt = _dataLoad.GetZone_byGroupId_forDSM(areaId.ToString()))
                            {
                                ZoneSelect.DataSource = dt;
                                ZoneSelect.DataValueField = "RegionId";
                                ZoneSelect.DataTextField = "RegionName";
                                ZoneSelect.DataBind();
                                ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                                ZoneSelect.SelectedIndex = 0;
                            }
                        }
                        else
                        {
                            using (DataTable dt = _dataLoad.GetZone_byGroupId_forDSM(masArea))
                            {
                                ZoneSelect.DataSource = dt;
                                ZoneSelect.DataValueField = "RegionId";
                                ZoneSelect.DataTextField = "RegionName";
                                ZoneSelect.DataBind();
                                ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                                ZoneSelect.SelectedIndex = 0;
                            }
                        }


                    }
                    catch (Exception ex)
                    {

                    }

                }

                ZoneSelect.SelectedValue = hfZone.Value;


                try
                {

                    using (DataTable dt = _dataLoad.GetArea_ByZoneId_All(Convert.ToInt32(ZoneSelect.SelectedValue)))
                    {
                        AreaSelect.DataSource = dt;
                        AreaSelect.DataValueField = "AreaId";
                        AreaSelect.DataTextField = "AreaName";
                        AreaSelect.DataBind();
                        AreaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        AreaSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }

                if (strRole == "AM")
                {
                    try
                    {

                        if (masArea == "")
                        {
                            using (DataTable dt = _dataLoad.GetArea_ByZoneId_AllForAMOnly(areaId.ToString()))
                            {
                                AreaSelect.DataSource = dt;
                                AreaSelect.DataValueField = "AreaId";
                                AreaSelect.DataTextField = "AreaName";
                                AreaSelect.DataBind();
                                AreaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                                AreaSelect.SelectedIndex = 0;
                            }
                        }
                        else
                        {
                            using (DataTable dt = _dataLoad.GetArea_ByZoneId_AllForAMOnly(masArea))
                            {
                                AreaSelect.DataSource = dt;
                                AreaSelect.DataValueField = "AreaId";
                                AreaSelect.DataTextField = "AreaName";
                                AreaSelect.DataBind();
                                AreaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                                AreaSelect.SelectedIndex = 0;
                            }
                        }


                    }
                    catch (Exception ex)
                    {

                    }

                }

                AreaSelect.SelectedValue = hfArea.Value;


                try
                {

                    using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(Convert.ToInt32(AreaSelect.SelectedValue)))
                    {
                        TeritorySelect.DataSource = dt;
                        TeritorySelect.DataValueField = "TerritoryId";
                        TeritorySelect.DataTextField = "TerritoryName";
                        TeritorySelect.DataBind();
                        TeritorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        TeritorySelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                TeritorySelect.SelectedValue = hfTeritory.Value;

                 
                 

            }
        }

    }
    private void LoadInitialDDL()
    {
        try
        {
            using (DataTable dt = _dataLoad.GetGroupInfo_Active())
            {
                GroupSelect.DataSource = dt;
                GroupSelect.DataValueField = "GroupId";
                GroupSelect.DataTextField = "GroupName";
                GroupSelect.DataBind();
                GroupSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                GroupSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

            GroupSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
            GroupSelect.SelectedIndex = 0;
        }
    }

    protected void GroupSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetZone_byGroupId_Active(Convert.ToInt32(GroupSelect.SelectedValue)))
            {
                ZoneSelect.DataSource = dt;
                ZoneSelect.DataValueField = "RegionId";
                ZoneSelect.DataTextField = "RegionName";
                ZoneSelect.DataBind();
                ZoneSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ZoneSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }

        AreaSelect.Items.Clear();
        TeritorySelect.Items.Clear(); 
    }

    protected void ZoneSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetArea_ByZoneId_Active(Convert.ToInt32(ZoneSelect.SelectedValue)))
            {
                AreaSelect.DataSource = dt;
                AreaSelect.DataValueField = "AreaId";
                AreaSelect.DataTextField = "AreaName";
                AreaSelect.DataBind();
                AreaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                AreaSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


        TeritorySelect.Items.Clear(); 
    }




    protected void AreaSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_Active(Convert.ToInt32(AreaSelect.SelectedValue)))
            {
                TeritorySelect.DataSource = dt;
                TeritorySelect.DataValueField = "TerritoryId";
                TeritorySelect.DataTextField = "TerritoryName";
                TeritorySelect.DataBind();
                TeritorySelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                TeritorySelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


         
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }
    private void LoadData()
    {
        string param = "";

        string Area = ""; string Terr = "";
        string Type = "";
        string ZonId = "";
        string GroupId = "";
        GroupId =  GroupSelect.SelectedValue;
        ZonId =  ZoneSelect.SelectedValue;
        Area =  AreaSelect.SelectedValue;
        Terr =  TeritorySelect.SelectedValue;

        DataTable aDataTable = _DAL.GetDoctorVisitMonitoringApprovalList(param, FromDate.Text, ToDate.Text, GroupId, ZonId, Area, Terr);

        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();


        // ===== Totals for KPI =====
        int totDCP = 0, totDCR = 0, totRX = 0;
        decimal totSales = 0m;

        if (aDataTable != null && aDataTable.Rows.Count > 0)
        {
            foreach (DataRow r in aDataTable.Rows)
            {
                totDCP += ToIntSafe(r["DCP"]);
                totDCR += ToIntSafe(r["DCR"]);
                totRX += ToIntSafe(r["RX"]);
                totSales += ToDecSafe(r["TSalesNetTP"]);   // কলাম নাম ভিন্ন হলে এখানে বদলান
                                                           // যদি "GPSales" কেও দরকার হয়: totGps += ToDecSafe(r["GPSales"]);
            }
        }

        // KPI লেবেলে সেট করুন (ফরম্যাটসহ)
        lblKpiDCP.Text = totDCP.ToString("N0");
        lblKpiDCR.Text = totDCR.ToString("N0");
        lblKpiRX.Text = totRX.ToString("N0");
        lblKpiSales.Text = totSales.ToString("N2");

    //for (int i = 0; i < loadGridView.Rows.Count; i++)
    //{

    //    HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");
    //    HiddenField hfRoleType = (HiddenField)loadGridView.Rows[i].FindControl("hfRoleType");
    //    Label hfTerritoryCode = (Label)loadGridView.Rows[i].FindControl("hfTerritoryCode");
    //    Label lblTerritory = (Label)loadGridView.Rows[i].FindControl("lblTerritory");

    //    DataTable dtTErriCode = _EmployeeInformationDaL.GetTerritoryCodeByRoleTypeEmpId(hfEmpInfoId.Value, hfRoleType.Value);

    //    try
    //    {
    //        hfTerritoryCode.Text = dtTErriCode.Rows[0]["TerritoryCode"].ToString();
    //        lblTerritory.Text = dtTErriCode.Rows[0]["TerritoryName"].ToString();
    //    }
    //    catch { }

    //}


}




    // ===== helpers (C#4 safe) =====
    private static int ToIntSafe(object v)
    {
        if (v == null || v == DBNull.Value) return 0;
        int i;
        if (v is int) return (int)v;
        if (int.TryParse(Convert.ToString(v, CultureInfo.InvariantCulture),
                         NumberStyles.Any, CultureInfo.InvariantCulture, out i)) return i;

        decimal d;
        if (decimal.TryParse(Convert.ToString(v, CultureInfo.InvariantCulture),
                             NumberStyles.Any, CultureInfo.InvariantCulture, out d)) return (int)d;
        return 0;
    }

    private static decimal ToDecSafe(object v)
    {
        if (v == null || v == DBNull.Value) return 0m;
        if (v is decimal) return (decimal)v;

        decimal d;
        if (decimal.TryParse(Convert.ToString(v, CultureInfo.InvariantCulture),
                             NumberStyles.Any, CultureInfo.InvariantCulture, out d)) return d;

        double dbl;
        if (double.TryParse(Convert.ToString(v, CultureInfo.InvariantCulture),
                            NumberStyles.Any, CultureInfo.InvariantCulture, out dbl)) return (decimal)dbl;

        return 0m;
    }


}