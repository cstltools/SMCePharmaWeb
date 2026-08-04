using Library.BLL.SInventory_BLL;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_RouteInformationEntry : System.Web.UI.Page
{
    private RouteInformationDAL _Dal = new RouteInformationDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    private static DepotWiseAreaSetupDal _aRepo = new DepotWiseAreaSetupDal();

    private int mid = 0;
    private string _userId;

    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
   

    protected void Page_Load(object sender, EventArgs e)
    {

        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;
        if (!IsPostBack)
        {
            LoadDropdownList();
            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
                GetOneRecord(id_mastetID.Value);
            }
            else
            {
                btnSave.Visible = true;
            }
        }
    }

    protected void dc_SelectedIndexChanged(object sender, EventArgs e)
    {

        LoadDANameDDL();
    }
    public void LoadDANameDDL()
    {
        int depoId = Convert.ToInt32(ddlDepotName.SelectedValue.ToString());
        try
        {
            using (DataTable dt = _Dal.GetDANameDDL(depoId))
            {
                ddlDAName.DataSource = dt;
                ddlDAName.DataValueField = "Value";
                ddlDAName.DataTextField = "TextField";
                ddlDAName.DataBind();
                ddlDAName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDAName.SelectedIndex = 0;
            }
        }
        catch (Exception ex) { }
    }
    
    public void Market_gv_Initial()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("GroupId");
        aDataTable.Columns.Add("RegionId");
        aDataTable.Columns.Add("AreaId");
        aDataTable.Columns.Add("TerritoryId");
        aDataTable.Columns.Add("SubTerritoryId");
        aDataTable.Columns.Add("MarketId");

        aDataTable.Columns.Add("GroupName");
        aDataTable.Columns.Add("RegionName");
        aDataTable.Columns.Add("AreaName");
        aDataTable.Columns.Add("TerritoryName");
        aDataTable.Columns.Add("SubTerritoryName");
        aDataTable.Columns.Add("MarketName");
        aDataTable.Columns.Add("Distance");
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        UpdateTotalDistanceFromGrid(aDataTable);

    }
    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _Dal.GetRouteInformationMasterById(Id))
            {
                ddlDepotName.SelectedValue = dt.Rows[0]["DCId"].ToString();
                dc_SelectedIndexChanged(null, null);
                try
                {
                    chkIsSubDepo.Checked = Convert.ToBoolean(dt.Rows[0]["IsSubDepo"].ToString());
                }
                catch(Exception ex)
                {
                    chkIsSubDepo.Checked = false;
                }

                txtRouteName.Text = dt.Rows[0]["RouteName"].ToString();
                txtTotalDistance.Text = dt.Rows[0]["TotalDistance"].ToString();
                txtTotalDay.Text = dt.Rows[0]["TotalDay"].ToString();

                txtTAAmount.Text = dt.Rows[0]["TAAmount"].ToString();
                txtDAAmount.Text = dt.Rows[0]["DAAmount"].ToString();

                ddlRouteType.SelectedValue= dt.Rows[0]["RouteTypeId"].ToString();


                string[] degree = dt.Rows[0]["BrandId"].ToString().Split(',');

                foreach (ListItem item in ddlRouteDay.Items)
                {
                    for (int i = 0; i < degree.Length; i++)
                    {
                        if (item.Value == degree[i].ToString())
                        {
                            item.Selected = true;

                        }
                    }
                }

            }


            using (DataTable dtDetail = _Dal.GeteRouteInformationDA_DetailById(Id))
            {
                gv_DA.DataSource = dtDetail;
                gv_DA.DataBind();

            }


            using (DataTable dtDetail = _Dal.GetRouteInformationDetailMarketById(Id))
            {
                if (!dtDetail.Columns.Contains("Distance"))
                {
                    dtDetail.Columns.Add("Distance");
                    foreach (DataRow row in dtDetail.Rows)
                    {
                        row["Distance"] = string.Empty;
                    }
                }
                gv_Market.DataSource = dtDetail;
                gv_Market.DataBind();
                UpdateTotalDistanceFromGrid(dtDetail);

            }
        }
        catch (Exception ex) { }
    }
    //private void LoadInitialGrid()
    //{
    //    DataTable aDataTable = new DataTable();
    //    aDataTable.Columns.Add("DANameId");
    //    aDataTable.Columns.Add("DAName");
    //    DataRow row = null;

    //    row = aDataTable.NewRow();

    //    row["DANameId"] = "";
    //    row["DAName"] = "";

    //    aDataTable.Rows.Add(row);

    //    gv_DA.DataSource = aDataTable;
    //    gv_DA.DataBind();

    //  //  Remove(0);
    //}


    OrderInfoBLL aOrderInfoBll = new OrderInfoBLL();

    private void LoadDropdownList()
    {

        aOrderInfoBll.LoadSC(ddlDepotName, Session["UserId"].ToString());

        try
        {
            using (DataTable dt = _Dal.GetWeekNameList())
            {
                ddlRouteDay.DataSource = dt;
                ddlRouteDay.DataValueField = "Value";
                ddlRouteDay.DataTextField = "TextField";
                ddlRouteDay.DataBind();
                ddlRouteDay.Items.Insert(-1, "");
                ddlRouteDay.SelectedIndex = 0;
            }
        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _Dal.GetRouteTypeInfoList())
            {
                ddlRouteType.DataSource = dt;
                ddlRouteType.DataValueField = "Value";
                ddlRouteType.DataTextField = "TextField";
                ddlRouteType.DataBind();
                ddlRouteType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlRouteType.SelectedIndex = 0;
            }
        }
        catch (Exception ex) { }

        Market_gv_Initial();
        DA_gv_Initial();
    }

    private void DA_gv_Initial()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DANameId");
        aDataTable.Columns.Add("DAName");
        gv_DA.DataSource = aDataTable;
        gv_DA.DataBind();
    }

    protected void addButtonDA_Click(object sender, EventArgs e)
    {

        ddlDAName.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (ddlDAName.SelectedValue != "")
        {
            Add();

        }
        else
        {
            ddlDAName.ToolTip = "please fill out this field";
            ddlDAName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlDAName.Focus();

        }

        
    }


    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    public void Add()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DANameId");
        aDataTable.Columns.Add("DAName");


        DataRow dataRow = null;
        for (int i = 0; i < gv_DA.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();
            dataRow["DAName"] = gv_DA.Rows[i].Cells[1].Text;
            dataRow["DANameId"] = gv_DA.DataKeys[i][0].ToString();


            aDataTable.Rows.Add(dataRow);
        }
        dataRow = aDataTable.NewRow();
        dataRow["DAName"] = ddlDAName.SelectedItem.Text;
        dataRow["DANameId"] = ddlDAName.SelectedValue;


        aDataTable.Rows.Add(dataRow);
        gv_DA.DataSource = aDataTable;
        gv_DA.DataBind();
        ddlDAName.SelectedValue = string.Empty;

    }
    public void Remove(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("DANameId");
        aDataTable.Columns.Add("DAName");

        DataRow dataRow = null;
        for (int i = 0; i < gv_DA.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();
                dataRow["DAName"] = gv_DA.Rows[i].Cells[1].Text;
                dataRow["DANameId"] = gv_DA.DataKeys[i][0].ToString();
                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_DA.DataSource = aDataTable;
        gv_DA.DataBind();

    }




    private DataTable BuildMarketTableFromGrid()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("GroupId");
        aDataTable.Columns.Add("RegionId");
        aDataTable.Columns.Add("AreaId");
        aDataTable.Columns.Add("TerritoryId");
        aDataTable.Columns.Add("SubTerritoryId");
        aDataTable.Columns.Add("MarketId");

        aDataTable.Columns.Add("GroupName");
        aDataTable.Columns.Add("RegionName");
        aDataTable.Columns.Add("AreaName");
        aDataTable.Columns.Add("TerritoryName");
        aDataTable.Columns.Add("SubTerritoryName");
        aDataTable.Columns.Add("MarketName");
        aDataTable.Columns.Add("Distance");

        DataRow dataRow = null;
        for (int i = 0; i < gv_Market.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();

            HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].FindControl("hfGroupId"));
            HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].FindControl("hfRegionId"));
            HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].FindControl("hfAreaId"));
            HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].FindControl("hfTerritoryId"));
            HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].FindControl("hfSubTerritoryId"));
            HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].FindControl("hfMarketId"));

            Label lbl_GroupName = ((Label)gv_Market.Rows[i].FindControl("lbl_GroupName"));
            Label lbl_RegionName = ((Label)gv_Market.Rows[i].FindControl("lbl_RegionName"));
            Label lbl_AreaName = ((Label)gv_Market.Rows[i].FindControl("lbl_AreaName"));
            Label lbl_TerritoryName = ((Label)gv_Market.Rows[i].FindControl("lbl_TerritoryName"));
            Label lbl_SubTerritoryName = ((Label)gv_Market.Rows[i].FindControl("lbl_SubTerritoryName"));
            Label lbl_MarketName = ((Label)gv_Market.Rows[i].FindControl("lbl_MarketName"));
            TextBox txtGridDistance = ((TextBox)gv_Market.Rows[i].FindControl("txtGridDistance"));

            dataRow["GroupId"] = hfGroupId != null ? hfGroupId.Value : string.Empty;
            dataRow["RegionId"] = hfRegionId != null ? hfRegionId.Value : string.Empty;
            dataRow["AreaId"] = hfAreaId != null ? hfAreaId.Value : string.Empty;
            dataRow["TerritoryId"] = hfTerritoryId != null ? hfTerritoryId.Value : string.Empty;
            dataRow["SubTerritoryId"] = hfSubTerritoryId != null ? hfSubTerritoryId.Value : string.Empty;
            dataRow["MarketId"] = hfMarketId != null ? hfMarketId.Value : string.Empty;

            dataRow["GroupName"] = lbl_GroupName != null ? lbl_GroupName.Text : string.Empty;
            dataRow["RegionName"] = lbl_RegionName != null ? lbl_RegionName.Text : string.Empty;
            dataRow["AreaName"] = lbl_AreaName != null ? lbl_AreaName.Text : string.Empty;
            dataRow["TerritoryName"] = lbl_TerritoryName != null ? lbl_TerritoryName.Text : string.Empty;
            dataRow["SubTerritoryName"] = lbl_SubTerritoryName != null ? lbl_SubTerritoryName.Text : string.Empty;
            dataRow["MarketName"] = lbl_MarketName != null ? lbl_MarketName.Text : string.Empty;
            dataRow["Distance"] = txtGridDistance != null ? txtGridDistance.Text : string.Empty;

            aDataTable.Rows.Add(dataRow);
        }

        return aDataTable;
    }

    public void AddMarket()
    {
        DataTable aDataTable = BuildMarketTableFromGrid();

        DataRow dataRow = null;
        dataRow = aDataTable.NewRow();
        dataRow["GroupId"] = GroupSelect.SelectedIndex > 0 ? int.Parse(GroupSelect.SelectedValue) : (int?)null;
        dataRow["RegionId"] = ZoneSelect.SelectedIndex > 0 ? int.Parse(ZoneSelect.SelectedValue) : (int?)null;
        dataRow["AreaId"] = AreaSelect.SelectedIndex > 0 ? int.Parse(AreaSelect.SelectedValue) : (int?)null;
        dataRow["TerritoryId"] = TeritorySelect.SelectedIndex > 0 ? int.Parse(TeritorySelect.SelectedValue) : (int?)null;
        dataRow["SubTerritoryId"] = SubTeritory.SelectedIndex > 0 ? int.Parse(SubTeritory.SelectedValue) : (int?)null;
        dataRow["MarketId"] = MarketSelect.SelectedIndex > 0 ? int.Parse(MarketSelect.SelectedValue) : (int?)null;


        dataRow["GroupName"] = GroupSelect.SelectedIndex > 0 ? GroupSelect.SelectedItem.Text : null;
        dataRow["RegionName"] = ZoneSelect.SelectedIndex > 0 ? ZoneSelect.SelectedItem.Text : null;


        dataRow["AreaName"] = AreaSelect.SelectedIndex > 0 ? AreaSelect.SelectedItem.Text : null;
        dataRow["TerritoryName"] = TeritorySelect.SelectedIndex > 0 ? TeritorySelect.SelectedItem.Text : null;
        dataRow["SubTerritoryName"] = SubTeritory.SelectedIndex > 0 ? SubTeritory.SelectedItem.Text : null;
        dataRow["MarketName"] = MarketSelect.SelectedIndex > 0 ? MarketSelect.SelectedItem.Text : null;
        dataRow["Distance"] = txtDistance.Text;




        aDataTable.Rows.Add(dataRow);
        aDataTable = SortMarketTableByDistance(aDataTable);
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        UpdateTotalDistanceFromGrid(aDataTable);
        txtDistance.Text = string.Empty;
        //GroupSelect.SelectedValue = string.Empty;
        //ZoneSelect.Items.Clear();
        //AreaSelect.Items.Clear();
        //TeritorySelect.Items.Clear();
        //SubTeritory.Items.Clear();
        //MarketSelect.Items.Clear();


    }

    private DataTable SortMarketTableByDistance(DataTable aDataTable)
    {
        if (aDataTable.Rows.Count <= 1)
        {
            return aDataTable;
        }

        DataTable sortedTable = aDataTable.Clone();
        foreach (DataRow row in aDataTable.AsEnumerable()
            .OrderBy(r => ParseDistance(r["Distance"])))
        {
            sortedTable.ImportRow(row);
        }

        return sortedTable;
    }

    private decimal ParseDistance(object value)
    {
        if (value == null)
        {
            return decimal.MaxValue;
        }

        decimal parsed;
        if (decimal.TryParse(value.ToString(), out parsed))
        {
            return parsed;
        }

        return decimal.MaxValue;
    }

    public void RemoveMarket(int row)
    {
        DataTable aDataTable = BuildMarketTableFromGrid();
        if (row >= 0 && row < aDataTable.Rows.Count)
        {
            aDataTable.Rows.RemoveAt(row);
        }
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        UpdateTotalDistanceFromGrid(aDataTable);

    }
    protected void btnAddtoListMarket_Click(object sender, EventArgs e)
    {
        MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        txtDistance.CssClass = "form-control form-control-sm mb-3 ";

        if (MarketSelect.SelectedValue != "")
        {
            if (string.IsNullOrWhiteSpace(txtDistance.Text))
            {
                txtDistance.ToolTip = "please fill out this field";
                txtDistance.CssClass = "form-control form-control-sm mb-3  is-invalid";
                txtDistance.Focus();
                return;
            }
            if (MarketValidation(Convert.ToInt32(MarketSelect.SelectedValue)))
            {
                AddMarket();

            }


        }
        else
        {
            MarketSelect.ToolTip = "please fill out this field";
            MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            MarketSelect.Focus();

        }
    }

    protected void deleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        Remove(rowindex);
    }

    protected void MarketdeleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveMarket(rowindex);
    }

    protected void MarketMoveUp_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)btn.Parent.Parent;
        int rowIndex = currentRow.RowIndex;
        if (rowIndex <= 0)
        {
            return;
        }

        DataTable aDataTable = BuildMarketTableFromGrid();
        DataRow row = aDataTable.Rows[rowIndex];
        DataRow targetRow = aDataTable.Rows[rowIndex - 1];
        object[] temp = row.ItemArray;
        row.ItemArray = targetRow.ItemArray;
        targetRow.ItemArray = temp;

        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        UpdateTotalDistanceFromGrid(aDataTable);
    }

    protected void MarketMoveDown_Click(object sender, EventArgs e)
    {
        LinkButton btn = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)btn.Parent.Parent;
        int rowIndex = currentRow.RowIndex;

        DataTable aDataTable = BuildMarketTableFromGrid();
        if (rowIndex < 0 || rowIndex >= aDataTable.Rows.Count - 1)
        {
            return;
        }

        DataRow row = aDataTable.Rows[rowIndex];
        DataRow targetRow = aDataTable.Rows[rowIndex + 1];
        object[] temp = row.ItemArray;
        row.ItemArray = targetRow.ItemArray;
        targetRow.ItemArray = temp;

        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        UpdateTotalDistanceFromGrid(aDataTable);
    }

    private void UpdateTotalDistanceFromGrid(DataTable aDataTable)
    {
        if (aDataTable.Rows.Count == 0)
        {
            txtTotalDistance.Text = string.Empty;
            return;
        }

        decimal total = 0m;
        foreach (DataRow row in aDataTable.Rows)
        {
            total += ParseDistanceForTotal(row["Distance"]);
        }

        txtTotalDistance.Text = total.ToString("0.##");
    }

    private decimal ParseDistanceForTotal(object value)
    {
        if (value == null)
        {
            return 0m;
        }

        decimal parsed;
        if (decimal.TryParse(value.ToString(), out parsed))
        {
            return parsed;
        }

        return 0m;
    }

    public bool Validation()
    {


        txtRouteName.CssClass = "form-control form-control-sm";
        ddlDepotName.CssClass = "form-control form-control-sm mySelect2";
        ddlRouteType.CssClass = "form-control form-control-sm mySelect2";
        ddlRouteDay.CssClass = "form-select form-select-sm mb-3 multiple-select";

        txtTotalDistance.CssClass = "form-control form-control-sm";
        txtTAAmount.CssClass = "form-control form-control-sm";
        txtDAAmount.CssClass = "form-control form-control-sm";
        addButtonDA.CssClass = "btn btn-sm btn-success";
        btnAddtoListMarket.CssClass = "btn btn-sm btn-success";

        txtTotalDay.CssClass = "form-control form-control-sm";

        if (ddlDepotName.SelectedValue == "")
        {
            ddlDepotName.ToolTip = "please fill out this field";
            ddlDepotName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlDepotName.Focus();
            return false;
        }

        if (txtRouteName.Text == "")
        {
            txtRouteName.ToolTip = "please fill out this field";
            txtRouteName.CssClass = "form-control form-control-sm is-invalid";
            txtRouteName.Focus();
            return false;
        }


        if (gv_DA.Rows.Count ==0)
        {
            showMessageBox("Please Add to List DA Name!");
            addButtonDA.ToolTip = "please fill out this field";
            addButtonDA.CssClass = "btn btn-sm btn-success is-invalid";
            addButtonDA.Focus();
            return false;
        }

        if (gv_Market.Rows.Count == 0)
        {
            showMessageBox("Please Add to List Market!");
            btnAddtoListMarket.ToolTip = "please fill out this field";
            btnAddtoListMarket.CssClass = "btn btn-sm btn-success is-invalid";
            btnAddtoListMarket.Focus();
            return false;
        }


        if (txtTotalDistance.Text == "")
        {
            txtTotalDistance.ToolTip = "please fill out this field";
            txtTotalDistance.CssClass = "form-control form-control-sm is-invalid";
            txtTotalDistance.Focus();
            return false;
        }


        if (txtTotalDay.Text == "")
        {
            txtTotalDay.ToolTip = "please fill out this field";
            txtTotalDay.CssClass = "form-control form-control-sm is-invalid";
            txtTotalDay.Focus();
            return false;
        }

        if (ddlRouteType.SelectedValue == "")
        {
            ddlRouteType.ToolTip = "please fill out this field";
            ddlRouteType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlRouteType.Focus();
            return false;
        }

        if (txtTAAmount.Text == "")
        {
            txtTAAmount.ToolTip = "please fill out this field";
            txtTAAmount.CssClass = "form-control form-control-sm is-invalid";
            txtTAAmount.Focus();
            return false;
        }

        if (txtDAAmount.Text == "")
        {
            txtDAAmount.ToolTip = "please fill out this field";
            txtDAAmount.CssClass = "form-control form-control-sm is-invalid";
            txtDAAmount.Focus();
            return false;
        }


        if (ddlRouteDay.SelectedValue == "")
        {
            ddlRouteDay.ToolTip = "please fill out this field";
            ddlRouteDay.CssClass = "form-select form-select-sm mb-3 multiple-select is-invalid";
            ddlRouteDay.Focus();
            return false;
        }


        return true;
    }


    public bool MarketValidation(int MarketId)
    {


        MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";


        for (int i = 0; i < gv_Market.Rows.Count; i++)
        {
            HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].FindControl("hfMarketId"));

            int? markId = string.IsNullOrEmpty(hfMarketId.Value) ? (int?)null : int.Parse(hfMarketId.Value);

            if(markId== MarketId)
            {
                showMessageBox("This Market is already exist in list!");
                MarketSelect.ToolTip = "please fill out this field";
                MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                MarketSelect.Focus();
                return false;
            }

          
        }


        

        return true;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        UpdateTotalDistanceFromGrid(BuildMarketTableFromGrid());
        if (Validation())
        {
            RouteInformationMasterDAO aMaster = new RouteInformationMasterDAO();

            List<BonusCampaignMarketDetailDAO> MarketList = new List<BonusCampaignMarketDetailDAO>();

            string Market = "";

            for (int i = 0; i < gv_Market.Rows.Count; i++)
            {
                HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].FindControl("hfGroupId"));
                HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].FindControl("hfRegionId"));
                HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].FindControl("hfAreaId"));
                HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].FindControl("hfTerritoryId"));

                HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].FindControl("hfSubTerritoryId"));

                HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].FindControl("hfMarketId"));
                TextBox txtGridDistance = ((TextBox)gv_Market.Rows[i].FindControl("txtGridDistance"));




                BonusCampaignMarketDetailDAO _DAO = new BonusCampaignMarketDetailDAO();

                _DAO.GroupId = string.IsNullOrEmpty(hfGroupId.Value) ? (int?)null : int.Parse(hfGroupId.Value);

                _DAO.RegionId = string.IsNullOrEmpty(hfRegionId.Value) ? (int?)null : int.Parse(hfRegionId.Value);
                _DAO.AreaId = string.IsNullOrEmpty(hfAreaId.Value) ? (int?)null : int.Parse(hfAreaId.Value);
                _DAO.TerritoryId = string.IsNullOrEmpty(hfTerritoryId.Value) ? (int?)null : int.Parse(hfTerritoryId.Value);
                _DAO.SubTerritoryId = string.IsNullOrEmpty(hfSubTerritoryId.Value) ? (int?)null : int.Parse(hfSubTerritoryId.Value);
                _DAO.MarketId = string.IsNullOrEmpty(hfMarketId.Value) ? (int?)null : int.Parse(hfMarketId.Value);
                _DAO.Distance = txtGridDistance == null || string.IsNullOrWhiteSpace(txtGridDistance.Text) ? (decimal?)null : decimal.Parse(txtGridDistance.Text);


                Market = Market + _DAO.MarketId+",";





                MarketList.Add(_DAO);

            }
            aMaster.MarketIdStr = Market.Trim(',');
            List<RouteInformationDADetailDAO> DtlList = new List<RouteInformationDADetailDAO>();


            for (int i = 0; i < gv_DA.Rows.Count; i++)
            {
                HiddenField hfDANameId = (HiddenField)gv_DA.Rows[i].FindControl("hfDANameId");





                RouteInformationDADetailDAO _DAO = new RouteInformationDADetailDAO();

                _DAO.DAId = string.IsNullOrEmpty(hfDANameId.Value) ? (int?)null : int.Parse(hfDANameId.Value);

 



                DtlList.Add(_DAO);

            }



            aMaster.RouteInformationMasterId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);
            aMaster.DCId = ddlDepotName.SelectedIndex > 0 ? int.Parse(ddlDepotName.SelectedValue) : (int?)null;
            aMaster.IsSubDepo = chkIsSubDepo.Checked;

            aMaster.RouteName = string.IsNullOrEmpty(txtRouteName.Text) ? null : txtRouteName.Text;
            

            aMaster.TotalDistance = string.IsNullOrEmpty(txtTotalDistance.Text) ? (decimal?)null : decimal.Parse(txtTotalDistance.Text);
            aMaster.TotalDay = string.IsNullOrEmpty(txtTotalDay.Text) ? (decimal?)null : decimal.Parse(txtTotalDay.Text);


            aMaster.RouteTypeId = ddlRouteType.SelectedIndex > 0 ? int.Parse(ddlRouteType.SelectedValue) : (int?)null;

            aMaster.TAAmount = string.IsNullOrEmpty(txtTAAmount.Text) ? (decimal?)null : decimal.Parse(txtTAAmount.Text);
            aMaster.DAAmount = string.IsNullOrEmpty(txtDAAmount.Text) ? (decimal?)null : decimal.Parse(txtDAAmount.Text);


            string RouteDayArray = "";

            foreach (ListItem item in ddlRouteDay.Items)
            {
                if (item.Selected)
                {

                    RouteDayArray = RouteDayArray + item.Value + ",";
                }
            }

            RouteDayArray = RouteDayArray.TrimEnd(',');
            ResultInfo Res = _Dal.SaveRouteInformation(aMaster, DtlList, MarketList, RouteDayArray, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','RouteInformationList.aspx');", true);

            }

            if (Res.isDuplicateCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Market Already Exist in Another Route!" + "','Faild');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }
    }

    protected void btnReset_Click(object sender, EventArgs e)
    {

    }
}
