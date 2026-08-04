using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SInventory_UI_IVMarketStructureInvoSearch : System.Web.UI.UserControl
{

    private CommonDataLoad _dataLoad = new CommonDataLoad();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialDDL();

            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
            string pram = "", Role = "";
            //   EmpMarketAccess( pram,  Role);

            if (EmpInfoId != "" || EmpInfoId != null)
            {
                if (ToRoleTypeId != "5")
                {
                    DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active_forReport(EmpInfoId, RoleTypeName);
                    hfEmpGroupId.Value = dtMarket.Rows[0]["GroupId"].ToString();
                    hfEmpRegionId.Value = dtMarket.Rows[0]["RegionId"].ToString();
                    hfEmpAreaId.Value = dtMarket.Rows[0]["AreaId"].ToString();
                    hfEmpTerrId.Value = dtMarket.Rows[0]["TerritoryId"].ToString();
                    string FFID = "";
                    switch (RoleTypeName)
                    {
                        case "MIO":

                            GroupSelect.SelectedValue = hfEmpGroupId.Value;
                            GroupSelect_SelectedIndexChanged(null, null);
                            ZoneSelect.SelectedValue = hfEmpRegionId.Value;
                            ZoneSelect_SelectedIndexChanged(null, null);
                            AreaSelect.SelectedValue = hfEmpAreaId.Value;
                            AreaSelect_SelectedIndexChanged(null, null);
                            TeritorySelect.SelectedValue = hfEmpTerrId.Value;
                            TeritorySelect_SelectedIndexChanged(null, null);

                            GroupSelect.Enabled = false;
                            ZoneSelect.Enabled = false;
                            AreaSelect.Enabled = false;
                            TeritorySelect.Enabled = false;


                            break;

                        case "AM":
                            GroupSelect.SelectedValue = hfEmpGroupId.Value;
                            GroupSelect_SelectedIndexChanged(null, null);
                            ZoneSelect.SelectedValue = hfEmpRegionId.Value;
                            ZoneSelect_SelectedIndexChanged(null, null);
                            AreaSelect.SelectedValue = hfEmpAreaId.Value;
                            AreaSelect_SelectedIndexChanged(null, null);


                            GroupSelect.Enabled = false;
                            ZoneSelect.Enabled = false;
                            AreaSelect.Enabled = false;



                            break;
                        case "DZSM":
                            GroupSelect.SelectedValue = hfEmpGroupId.Value;
                            GroupSelect_SelectedIndexChanged(null, null);
                            ZoneSelect.SelectedValue = hfEmpRegionId.Value;
                            ZoneSelect_SelectedIndexChanged(null, null);



                            GroupSelect.Enabled = false;
                            ZoneSelect.Enabled = false;

                            break;
                        case "NSM":
                            GroupSelect.SelectedValue = hfEmpGroupId.Value;
                            GroupSelect_SelectedIndexChanged(null, null);




                            GroupSelect.Enabled = false;

                            break;

                        //case "DIC":
                        //    FFID = dtMarket.Rows[0]["EmpGroupId"].ToString();
                        //    pram = " AND  dcMas.DCId=" + ddlDistributionCenter.SelectedValue;
                        //    Role = "DIC";
                        //    break;
                        default:
                            pram = "";
                            Role = "";
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
            using (DataTable dt = _dataLoad.GetGroupInfo_Rpt())
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

        }


       }
    protected void GroupSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {

            using (DataTable dt = _dataLoad.GetZone_byGroupId_Rpt(Convert.ToInt32(GroupSelect.SelectedValue)))
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

            using (DataTable dt = _dataLoad.GetArea_ByZoneId_Rpt(Convert.ToInt32(ZoneSelect.SelectedValue)))
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

            using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_Rpt(Convert.ToInt32(AreaSelect.SelectedValue)))
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

            using (DataTable dt = _dataLoad.GetSubTerritory_ByTerritoryId_Rpt(Convert.ToInt32(TeritorySelect.SelectedValue)))
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

            using (DataTable dt = _dataLoad.GetMarket_BySubTerritoryId_Rpt(Convert.ToInt32(SubTeritory.SelectedValue)))
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