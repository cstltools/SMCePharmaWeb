using Library.DAL.DoctorModule_DAL;
using Library.DAL.SInventory_DAL;
using Library.DAO.DoctorModule_DAO;
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

public partial class MasterSetup_UI_UserSetupforEMP : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private static UserInfoDAL _UserDAL = new UserInfoDAL();


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
            LoadInitialInfo();
            Market_gv_Initial();

            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
                GetOneRecord(id_mastetID.Value);
                lbemp.Enabled = true;

            }

            else if (!string.IsNullOrEmpty(Request.QueryString["EmpID"]))
            {
                btnSave.Visible = true;


                hfEmpId.Value = Request.QueryString["EmpID"];

                try
                {

                    using (DataTable dt = _UserDAL.GetUserSetupByEmpId(hfEmpId.Value))
                    {
                        id_mastetID.Value= dt.Rows[0]["EmpInfoId"].ToString();
                    }
                } catch(Exception ex)
                {

                }

                        GetOneRecord(id_mastetID.Value);
                lbemp.Enabled = true;

            }
            else
            {
                btnSave.Visible = true;
                lbemp.Enabled = false;

            }
        }
    }
    protected void MarketdeleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveMarket(rowindex);
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
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();

    }
    private void GetOneRecord(string Id)
    {
        try
        {

            using (DataTable dt = _UserDAL.GetUserSetupById(Id))
            {
                ddlUserType.SelectedValue = dt.Rows[0]["UserTypeId"].ToString();
                ddlUserType_SelectedIndexChanged(null, null);
                ddlEmployeeName.SelectedValue = dt.Rows[0]["EmpInfoId"].ToString();

                txtUserName.Text = dt.Rows[0]["UserName"].ToString();
                txtLoginName.Text = dt.Rows[0]["LoginName"].ToString();
                txtPassword.Text = dt.Rows[0]["Password"].ToString();

                bool isApp = false;
                try
                {
                    isApp =Convert.ToBoolean(dt.Rows[0]["IsAppsUser"].ToString());
                }
                catch(Exception ex)
                {

                }
                if (isApp)
                {
                    chkMobileAccess.Checked = true;

                    divMei.Visible = true;
                }
                else
                {
                    chkMobileAccess.Checked = false;

                }

                txtImei1.Text = dt.Rows[0]["IMEI_One"].ToString();

                txtImei2.Text = dt.Rows[0]["IMEI_Two"].ToString();


                ddlUserRole.SelectedValue = dt.Rows[0]["UserRoleID"].ToString();
                ddlUserRole_SelectedIndexChanged(null, null);

                txtacDate.Text = dt.Rows[0]["ActiveInActiveDate"].ToString();


                if(dt.Rows[0]["UserStatus"].ToString()== "Active")
                {
                    chkIsActive.Checked = true;
                }



                using (DataTable dtDetail = _UserDAL.GetUserDetailMarketById(Id))
                {
                    gv_Market.DataSource = dtDetail;
                    gv_Market.DataBind();

                }




                string[] degree = dt.Rows[0]["UserDCID"].ToString().Trim().Split(',');

                foreach (ListItem item in ddlDistributionCenter.Items)
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
        }
        catch (Exception ex) { }
    }
        private void LoadInitialInfo()
    {

        try
        {
            using (DataTable dt = _seedRepo.GetEmployee_All())
            {
                ddlEmployeeName.DataSource = dt;
                ddlEmployeeName.DataValueField = "EmpInfoId";
                ddlEmployeeName.DataTextField = "EmployeeName";
                ddlEmployeeName.DataBind();
                ddlEmployeeName.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlEmployeeName.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _seedRepo.GetUserRoleList())
            {
                ddlUserRole.DataSource = dt;
                ddlUserRole.DataValueField = "UserRoleID";
                ddlUserRole.DataTextField = "RoleName";
                ddlUserRole.DataBind();
                ddlUserRole.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlUserRole.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _seedRepo.GetUserTypeList())
            {
                ddlUserType.DataSource = dt;
                ddlUserType.DataValueField = "UserTypeId";
                ddlUserType.DataTextField = "UserType";
                ddlUserType.DataBind();
                ddlUserType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlUserType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _seedRepo.GetDistributionCenterDataTableList())
            {
                ddlDistributionCenter.DataSource = dt;
                ddlDistributionCenter.DataValueField = "ComUnitId";
                ddlDistributionCenter.DataTextField = "ComUnitName";
                ddlDistributionCenter.DataBind();
                ddlDistributionCenter.Items.Insert(-1, "");
                ddlDistributionCenter.SelectedIndex = 0;
            }
        }

        catch (Exception ex) { }

    }


    public bool Validation()
    {


        txtLoginName.CssClass = "form-control form-control-sm";
        txtUserName.CssClass = "form-control form-control-sm";
        txtPassword.CssClass = "form-control form-control-sm";
        ddlUserType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlEmployeeName.CssClass = "form-select form-select-sm mb-3 mySelect2";


        txtImei1.CssClass = "form-control form-control-sm";
        txtImei2.CssClass = "form-control form-control-sm";
        txtacDate.CssClass = "datepicker form-control form-control-sm";


        if (ddlUserType.SelectedValue == "")
        {
            ddlUserType.ToolTip = "please fill out this field";
            ddlUserType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlUserType.Focus();
            return false;
        }


        if (ddlUserType.SelectedValue == "3" || ddlUserType.SelectedValue == "1")
        {
            if (ddlEmployeeName.SelectedValue == "")
            {
                ddlEmployeeName.ToolTip = "please fill out this field";
                ddlEmployeeName.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                ddlEmployeeName.Focus();
                return false;
            }

        }

        if (txtUserName.Text == "")
        {
            txtUserName.ToolTip = "please fill out this field";
            txtUserName.CssClass = "form-control form-control-sm is-invalid";
            txtUserName.Focus();
            return false;
        }

        if (txtLoginName.Text == "")
        {
            txtLoginName.ToolTip = "please fill out this field";
            txtLoginName.CssClass = "form-control form-control-sm is-invalid";
            txtLoginName.Focus();
            return false;
        }

        if (txtPassword.Text == "")
        {
            txtPassword.ToolTip = "please fill out this field";
            txtPassword.CssClass = "form-control form-control-sm is-invalid";
            txtPassword.Focus();
            return false;
        }

        if (ddlUserRole.SelectedValue == "")
        {
            ddlUserRole.ToolTip = "please fill out this field";
            ddlUserRole.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlUserRole.Focus();
            return false;
        }


        if (chkMobileAccess.Checked)
        {
            if (txtImei1.Text == "")
            {
                txtImei1.ToolTip = "please fill out this field";
                txtImei1.CssClass = "form-control form-control-sm is-invalid";
                txtImei1.Focus();
                return false;
            }

            if (txtImei2.Text == "")
            {
                txtImei2.ToolTip = "please fill out this field";
                txtImei2.CssClass = "form-control form-control-sm is-invalid";
                txtImei2.Focus();
                return false;
            }
        }

        if (txtacDate.Text == "")
        {
            txtacDate.ToolTip = "please fill out this field";
            txtacDate.CssClass = "datepicker form-control form-control-sm is-invalid";
            txtacDate.Focus();
            return false;
        }

        return true;
    }
        protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validation())
        {

            List<BonusCampaignMarketDetailDAO> MarketList = new List<BonusCampaignMarketDetailDAO>();


            for (int i = 0; i < gv_Market.Rows.Count; i++)
            {
                HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfGroupId"));
                HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfRegionId"));
                HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfAreaId"));
                HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfTerritoryId"));

                HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfSubTerritoryId"));

                HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfMarketId"));




                BonusCampaignMarketDetailDAO _DAO = new BonusCampaignMarketDetailDAO();

                _DAO.GroupId = string.IsNullOrEmpty(hfGroupId.Value) ? (int?)null : int.Parse(hfGroupId.Value);

                _DAO.RegionId = string.IsNullOrEmpty(hfRegionId.Value) ? (int?)null : int.Parse(hfRegionId.Value);
                _DAO.AreaId = string.IsNullOrEmpty(hfAreaId.Value) ? (int?)null : int.Parse(hfAreaId.Value);
                _DAO.TerritoryId = string.IsNullOrEmpty(hfTerritoryId.Value) ? (int?)null : int.Parse(hfTerritoryId.Value);
                _DAO.SubTerritoryId = string.IsNullOrEmpty(hfSubTerritoryId.Value) ? (int?)null : int.Parse(hfSubTerritoryId.Value);
                _DAO.MarketId = string.IsNullOrEmpty(hfMarketId.Value) ? (int?)null : int.Parse(hfMarketId.Value);








                MarketList.Add(_DAO);

            }

            UserDAO aMaster = new UserDAO();

            aMaster.UserId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);
            aMaster.UserType = ddlUserType.SelectedIndex > 0 ? ddlUserType.SelectedItem.Text : null;
            aMaster.UserTypeId = ddlUserType.SelectedIndex > 0 ? int.Parse(ddlUserType.SelectedValue) : (int?)null;
            aMaster.EmpInfoId = ddlEmployeeName.SelectedIndex > 0 ? int.Parse(ddlEmployeeName.SelectedValue) : (int?)null;

            aMaster.UserName = string.IsNullOrEmpty(txtUserName.Text) ? null : txtUserName.Text;
            aMaster.Password = string.IsNullOrEmpty(txtPassword.Text) ? null : txtPassword.Text;
            aMaster.LoginName = string.IsNullOrEmpty(txtLoginName.Text) ? null : txtLoginName.Text;

            aMaster.IsAppsUser = chkMobileAccess.Checked;

            aMaster.IMEI_One = string.IsNullOrEmpty(txtImei1.Text) ? null : txtImei1.Text;
            aMaster.IMEI_Two = string.IsNullOrEmpty(txtImei2.Text) ? null : txtImei2.Text;


            aMaster.UserRoleID = ddlUserRole.SelectedIndex > 0 ? int.Parse(ddlUserRole.SelectedValue) : (int?)null;


            aMaster.ActiveInActiveDate = string.IsNullOrEmpty(txtacDate.Text) ? (DateTime?)null : DateTime.Parse(txtacDate.Text);

            if (chkIsActive.Checked)
            {
                aMaster.UserStatus = "Active";
            }
            else
            {
                aMaster.UserStatus = "Inactive";

            }
            string DisArray = "";

            foreach (ListItem item in ddlDistributionCenter.Items)
            {
                if (item.Selected)
                {

                    DisArray = DisArray + item.Value + ",";
                }
            }

            DisArray = DisArray.TrimEnd(',');
            ResultInfo Res = _UserDAL.SaveUserInfo(aMaster, MarketList, DisArray, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','../user-records');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }
        }
        }



        protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("UserSetup.aspx");

    }

    protected void chkMobileAccess_CheckedChanged(object sender, EventArgs e)
    {
        divMei.Visible = false;
        if (chkMobileAccess.Checked)
        {
            divMei.Visible = true;

        }
    }

    protected void ddlUserType_SelectedIndexChanged(object sender, EventArgs e)
    {
        DivEmp.Visible = false;
        if(ddlUserType.SelectedValue== "3" || ddlUserType.SelectedValue == "1")
        {
            DivEmp.Visible = true;

        }
    }

    protected void chkIsActive_CheckedChanged(object sender, EventArgs e)
    {
        if (chkIsActive.Checked)
        {
            pacinTxt.InnerText = "Active Date:";
        }
        else
        {
            pacinTxt.InnerText = "Inactive Date:";

        }
    }

    protected void btnAddtoListMarket_Click(object sender, EventArgs e)
    {
        GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (GroupSelect.SelectedValue != "")
        {
            AddMarket();

        }
        else
        {
            GroupSelect.ToolTip = "please fill out this field";
            GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            GroupSelect.Focus();

        }
    }

    protected void deleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        RemoveMarket(rowindex);
    }

    public void AddMarket()
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




        DataRow dataRow = null;
        for (int i = 0; i < gv_Market.Rows.Count; i++)
        {




            dataRow = aDataTable.NewRow();


            HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfGroupId"));
            HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfRegionId"));
            HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfAreaId"));
            HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfTerritoryId"));

            HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfSubTerritoryId"));

            HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfMarketId"));


            Label lbl_GroupName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_GroupName"));

            Label lbl_RegionName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_RegionName"));
            Label lbl_AreaName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_AreaName"));
            Label lbl_TerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_TerritoryName"));
            Label lbl_SubTerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_SubTerritoryName"));
            Label lbl_MarketName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_MarketName"));


            dataRow["GroupId"] = hfGroupId.Value;
            dataRow["RegionId"] = hfRegionId.Value;
            dataRow["AreaId"] = hfAreaId.Value;
            dataRow["TerritoryId"] = hfTerritoryId.Value;
            dataRow["SubTerritoryId"] = hfSubTerritoryId.Value;
            dataRow["MarketId"] = hfMarketId.Value;

            dataRow["GroupName"] = lbl_GroupName.Text;
            dataRow["RegionName"] = lbl_RegionName.Text;
            dataRow["AreaName"] = lbl_AreaName.Text;
            dataRow["TerritoryName"] = lbl_TerritoryName.Text;
            dataRow["SubTerritoryName"] = lbl_SubTerritoryName.Text;
            dataRow["MarketName"] = lbl_MarketName.Text;



            aDataTable.Rows.Add(dataRow);
        }
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




        aDataTable.Rows.Add(dataRow);
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();
        GroupSelect.SelectedValue = string.Empty;
        ZoneSelect.Items.Clear();
        AreaSelect.Items.Clear();
        TeritorySelect.Items.Clear();
        SubTeritory.Items.Clear();
        MarketSelect.Items.Clear();


    }

    public void RemoveMarket(int row)
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

        DataRow dataRow = null;
        for (int i = 0; i < gv_Market.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();
                HiddenField hfGroupId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfGroupId"));
                HiddenField hfRegionId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfRegionId"));
                HiddenField hfAreaId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfAreaId"));
                HiddenField hfTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfTerritoryId"));

                HiddenField hfSubTerritoryId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfSubTerritoryId"));

                HiddenField hfMarketId = ((HiddenField)gv_Market.Rows[i].Cells[1].FindControl("hfMarketId"));


                Label lbl_GroupName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_GroupName"));

                Label lbl_RegionName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_RegionName"));
                Label lbl_AreaName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_AreaName"));
                Label lbl_TerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_TerritoryName"));
                Label lbl_SubTerritoryName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_SubTerritoryName"));
                Label lbl_MarketName = ((Label)gv_Market.Rows[i].Cells[1].FindControl("lbl_MarketName"));


                dataRow["GroupId"] = hfGroupId.Value;
                dataRow["RegionId"] = hfRegionId.Value;
                dataRow["AreaId"] = hfAreaId.Value;
                dataRow["TerritoryId"] = hfTerritoryId.Value;
                dataRow["SubTerritoryId"] = hfSubTerritoryId.Value;
                dataRow["MarketId"] = hfMarketId.Value;

                dataRow["GroupName"] = lbl_GroupName.Text;
                dataRow["RegionName"] = lbl_RegionName.Text;
                dataRow["AreaName"] = lbl_AreaName.Text;
                dataRow["TerritoryName"] = lbl_TerritoryName.Text;
                dataRow["SubTerritoryName"] = lbl_SubTerritoryName.Text;
                dataRow["MarketName"] = lbl_MarketName.Text;

                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_Market.DataSource = aDataTable;
        gv_Market.DataBind();

    }

    protected void ddlUserRole_SelectedIndexChanged(object sender, EventArgs e)
    {
        divmrkAccess.Visible = true;
        dcDiv.Visible = false;
        gv_Market.DataSource = null;
        gv_Market.DataBind();
        try
        {
             
                ddlDistributionCenter.SelectedIndex = -1;
           
        }
        catch (Exception ex) { }

        if (ddlUserRole.SelectedValue == "14")
        {
            divmrkAccess.Visible = false;
            dcDiv.Visible = true;
        }
    }

    protected void loadUserRole_Click(object sender, EventArgs e)
    {
        try
        {
            using (DataTable dt = _seedRepo.GetUserRoleList())
            {
                ddlUserRole.DataSource = dt;
                ddlUserRole.DataValueField = "UserRoleID";
                ddlUserRole.DataTextField = "RoleName";
                ddlUserRole.DataBind();
                ddlUserRole.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlUserRole.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

    }

    protected void lbemp_Click(object sender, EventArgs e)
    {
        if (id_mastetID.Value != "")
        {
            Response.Redirect("../MasterSetup_UI/EmployeeSetup.aspx?MID=" + id_mastetID.Value);
        }
    }
}
