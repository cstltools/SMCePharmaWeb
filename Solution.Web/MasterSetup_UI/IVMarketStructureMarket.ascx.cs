using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_IVMarketStructureMarket : System.Web.UI.UserControl
{

    private CommonDataLoad _dataLoad = new CommonDataLoad();
    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";

    string areaId = "";
    string masArea = "";
    string strRole = "";

    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();

        }
        catch { }
        if (!IsPostBack)
        {
            LoadInitialDDL();

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
                       
                        break;


                }
            }

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                DataTable dtMarket = _dataLoad.GetHigharcyInfoByEmployeeId(EmpInfoId.ToString(), ToRoleTypeId.ToString());

                string FFID = "";
                switch (RoleTypeName)
                {

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
            if (hfGroupId.Value!="")
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

                        if (masArea == "") {
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


                try
                {

                    using (DataTable dt = _dataLoad.GetSubTerritory_ByTerritoryId_Alle(Convert.ToInt32(TeritorySelect.SelectedValue)))
                    {
                        SubTeritory.DataSource = dt;
                        SubTeritory.DataValueField = "SubTerritoryId";
                        SubTeritory.DataTextField = "SubTerritoryName";
                        SubTeritory.DataBind();
                        SubTeritory.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        SubTeritory.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                SubTeritory.SelectedValue = hfSubTeritory.Value;


                try
                {

                    using (DataTable dt = _dataLoad.GetMarket_BySubTerritoryId_All(Convert.ToInt32(SubTeritory.SelectedValue)))
                    {
                        MarketSelect.DataSource = dt;
                        MarketSelect.DataValueField = "MarketId";
                        MarketSelect.DataTextField = "MarketName";
                        MarketSelect.DataBind();
                        MarketSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                        MarketSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                MarketSelect.SelectedValue = hfMarket.Value;


            }
        }
        }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    private void LoadInitialDDL()
    {
        try {
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
        catch(Exception ex)
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
        SubTeritory.Items.Clear();
        MarketSelect.Items.Clear();
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
        SubTeritory.Items.Clear();
        MarketSelect.Items.Clear();
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


       
        SubTeritory.Items.Clear();
        MarketSelect.Items.Clear();
    }

    protected void TeritorySelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetSubTerritory_ByTerritoryId_Active(Convert.ToInt32(TeritorySelect.SelectedValue)))
            {
                SubTeritory.DataSource = dt;
                SubTeritory.DataValueField = "SubTerritoryId";
                SubTeritory.DataTextField = "SubTerritoryName";
                SubTeritory.DataBind();
                SubTeritory.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                SubTeritory.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


        
       
        MarketSelect.Items.Clear();
    }

    protected void SubTeritory_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetMarket_BySubTerritoryId_Active(Convert.ToInt32(SubTeritory.SelectedValue)))
            {
                MarketSelect.DataSource = dt;
                MarketSelect.DataValueField = "MarketId";
                MarketSelect.DataTextField = "MarketName";
                MarketSelect.DataBind();
                MarketSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                MarketSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }
    }
}