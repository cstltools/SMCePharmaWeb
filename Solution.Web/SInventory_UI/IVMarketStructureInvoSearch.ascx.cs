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

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            LoadInitialDDL();

            if(hfGroupId.Value!="")
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


        try
        {
            using (DataTable dt = _dataLoad.GetNSMInfo_Rpt())
            {
                ddlNSM.DataSource = dt;
                ddlNSM.DataValueField = "ValueId";
                ddlNSM.DataTextField = "TextName";
                ddlNSM.DataBind();
                ddlNSM.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlNSM.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }

        try
        {
            using (DataTable dt = _dataLoad.GetDZSMInfo_Rpt())
            {
                ddlDZSM.DataSource = dt;
                ddlDZSM.DataValueField = "ValueId";
                ddlDZSM.DataTextField = "TextName";
                ddlDZSM.DataBind();
                ddlDZSM.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDZSM.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }

        try
        {
            using (DataTable dt = _dataLoad.GetAMInfo_Rpt())
            {
                ddlAM.DataSource = dt;
                ddlAM.DataValueField = "ValueId";
                ddlAM.DataTextField = "TextName";
                ddlAM.DataBind();
                ddlAM.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlAM.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


        try
        {
            using (DataTable dt = _dataLoad.GetMIOInfo_Rpt())
            {
                ddlMIO.DataSource = dt;
                ddlMIO.DataValueField = "ValueId";
                ddlMIO.DataTextField = "TextName";
                ddlMIO.DataBind();
                ddlMIO.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlMIO.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
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