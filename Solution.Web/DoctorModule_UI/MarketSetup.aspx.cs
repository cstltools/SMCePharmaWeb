using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class DoctorModule_UI_MarketSetup : System.Web.UI.Page
{
    static CommonDataLoad _dataLoad=new CommonDataLoad();
    private HiddenField hfGroupId, hfZone, hfArea, hfTeritory, hfSubTeritory, hfMarket;
    private DropDownList F_GroupSelect, F_ZoneSelect, F_AreaSelect, F_TeritorySelect, F_SubTeritory, F_MarketSelect;

    private Setup2DAL _setupDAL = new Setup2DAL();


    protected void Page_Load(object sender, EventArgs e)
    {
        F_GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        F_ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        F_AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        F_TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        F_SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        F_MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;

        hfGroupId = (HiddenField)IVMarketStructure.FindControl("hfGroupId") as HiddenField;
        hfZone = (HiddenField)IVMarketStructure.FindControl("hfZone") as HiddenField;
        hfArea = (HiddenField)IVMarketStructure.FindControl("hfArea") as HiddenField;
        hfTeritory = (HiddenField)IVMarketStructure.FindControl("hfTeritory") as HiddenField;
        hfSubTeritory = (HiddenField)IVMarketStructure.FindControl("hfSubTeritory") as HiddenField;
        hfMarket = (HiddenField)IVMarketStructure.FindControl("hfMarket") as HiddenField;

        if (!IsPostBack)
        {
           
            LoadInitialInfo();


            if (!string.IsNullOrEmpty(Request.QueryString["id"]))
            {
                btnUpdate.Visible = true;
                divShowHide.Visible = true;
                id_mastetID.Value = Request.QueryString["id"];
                GetOneRecord(id_mastetID.Value);
                //F_GroupSelect.Enabled = false;
                //F_ZoneSelect.Enabled = false;
                //F_AreaSelect.Enabled = false;
                //F_TeritorySelect.Enabled = false;
                //F_SubTeritory.Enabled = false;
            }
            else
            {
                btnSave.Visible = true;
            }
        }


    }

    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt = _setupDAL.GetMarketEditDataDAL(Convert.ToInt32(Id)))
            {
                mainName.Text = dt.Rows[0]["MarketName"].ToString();
                acDate.Text = dt.Rows[0]["AcOrInAcDate"].ToString();
                
                hfGroupId.Value = dt.Rows[0]["GroupId"].ToString();


                hfZone.Value = dt.Rows[0]["RegionId"].ToString();

                try
                {

                    if(dt.Rows[0]["IsActive"].ToString()=="1")
                    {
                        chkIsActive.Checked = true;
                    }
                    else
                    {
                        chkIsActive.Checked = false;
                    } 
                }
                catch (Exception ex)
                {
                    chkIsActive.Checked = false;
                }


                hfArea.Value = dt.Rows[0]["AreaId"].ToString();


                hfTeritory.Value = dt.Rows[0]["TerritoryId"].ToString();

                hfSubTeritory.Value = dt.Rows[0]["SubTerritoryId"].ToString();



                hfMarket.Value = dt.Rows[0]["MarketId"].ToString();
                DivisionSelect.SelectedValue = dt.Rows[0]["DivisionId"].ToString();
                DivisionSelect_SelectedIndexChanged(null, null);
                DistrictSelect.SelectedValue = dt.Rows[0]["DistrictId"].ToString();
                DistrictSelect_SelectedIndexChanged(null, null);
                ThanaSelect.SelectedValue = dt.Rows[0]["ThanaId"].ToString();

                if (dt.Rows[0]["RoleTypeId"].ToString() != "" && dt.Rows[0]["StationTypeId"].ToString() != "")
                {
                    gv_UserRole.DataSource = dt;
                    gv_UserRole.DataBind();
                }


                try
                {
                    using (DataTable dtMarketCount = _setupDAL.GetMarketCountDataDAL(Convert.ToInt32(Id)))
                    {
                        gv_Count.DataSource = dtMarketCount;
                        gv_Count.DataBind();
                    }
                }
                catch (Exception ex) { }

            }


           
        }
        catch (Exception ex) { }
    }
    public bool Validation()
    {


        F_SubTeritory.CssClass = "form-select form-select-sm mb-3 mySelect2";
        F_TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ThanaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        F_AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";


        mainName.CssClass = "form-control form-control-sm";
        acDate.CssClass = "form-control form-control-sm datepicker";



        if (F_AreaSelect.SelectedValue == "")
        {
            F_AreaSelect.ToolTip = "please fill out this field";
            F_AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            F_AreaSelect.Focus();
            return false;
        }


        if (F_TeritorySelect.SelectedValue == "")
        {
            F_TeritorySelect.ToolTip = "please fill out this field";
            F_TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            F_TeritorySelect.Focus();
            return false;
        }


       

        if (F_SubTeritory.SelectedValue == "")
        {
            F_SubTeritory.ToolTip = "please fill out this field";
            F_SubTeritory.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            F_SubTeritory.Focus();
            return false;
        }

        if (mainName.Text == "")
        {
            mainName.ToolTip = "please fill out this field";
            mainName.CssClass = "form-control form-control-sm is-invalid";
            mainName.Focus();
            return false;
        }



        if (ThanaSelect.SelectedValue == "")
        {
            ThanaSelect.ToolTip = "please fill out this field";
            ThanaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ThanaSelect.Focus();
            return false;
        }
        if (acDate.Text == "")
        {
            acDate.ToolTip = "please fill out this field";
            acDate.CssClass = "form-control form-control-sm is-invalid datepicker";
            acDate.Focus();
            return false;
        }

        if (gv_UserRole.Rows.Count == 0 )
        {
            showMessageBox("please Add to List User Role Wise Station Type!");

            return false;
        }

        int countMIO = 0;
        int countDZSM = 0;
        int countAM = 0;
        for (int i = 0; i < gv_UserRole.Rows.Count; i++)
        {
            HiddenField hfRoleTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfRoleTypeId"));

            if (hfRoleTypeId.Value == "1")
            {
                countMIO++;

            }

            if (hfRoleTypeId.Value == "2")
            {
                countAM++;

            }

            if (hfRoleTypeId.Value == "3")
            {
                countDZSM++;

            }

        }

        if (countMIO != 1)
        {

            showMessageBox("MIO must be added in list!!!");
            return false;
        }
        if (countAM != 1)
        {

            showMessageBox("AM must be added in list!!!");

            return false;
        }

        if (countDZSM != 1)
        {

            showMessageBox("DZSM must be added in list!!!");

            return false;
        }


        return true;
    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {

            List<MarketStationDetailDao> MarketList = new List<MarketStationDetailDao>();


            for (int i = 0; i < gv_UserRole.Rows.Count; i++)
            {
                HiddenField hfRoleTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfRoleTypeId"));

                HiddenField hfStationTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfStationTypeId"));




                MarketStationDetailDao _DAO = new MarketStationDetailDao();

                _DAO.UserRoleID = string.IsNullOrEmpty(hfRoleTypeId.Value) ? (int?)null : int.Parse(hfRoleTypeId.Value);

                _DAO.StationTypeId = string.IsNullOrEmpty(hfStationTypeId.Value) ? (int?)null : int.Parse(hfStationTypeId.Value);
              
                 

                MarketList.Add(_DAO);

            }





            Market aMaster = new Market();

            aMaster.MarketId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);
             

            aMaster.MarketName = string.IsNullOrEmpty(mainName.Text) ? null : mainName.Text;
            aMaster.SubTerritoryId = F_SubTeritory.SelectedIndex > 0 ? int.Parse(F_SubTeritory.SelectedValue) : (int?)null;
            aMaster.ThanaId = ThanaSelect.SelectedIndex > 0 ? int.Parse(ThanaSelect.SelectedValue) : (int?)null;


            aMaster.AcOrInAcDate = string.IsNullOrEmpty(acDate.Text) ? (DateTime?)null : DateTime.Parse(acDate.Text);
            
          aMaster.IsActive = chkIsActive.Checked;





            ResultInfo Res = _setupDAL.SaveMarket(aMaster,  MarketList, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','MarketRecords.aspx');", true);

            }

            else if (Res.isDuplicateCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);


            }

            else if (Res.isValiCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Data cannot be deactivated!" + "','Faild');", true);


            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }

    }


    private void LoadInitialInfo()
    {


        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("RoleTypeId");
        aDataTable.Columns.Add("StationTypeId");
        aDataTable.Columns.Add("RoleType");
        aDataTable.Columns.Add("StationTypeName");
        gv_UserRole.DataSource = aDataTable;
        gv_UserRole.DataBind();
        try
        {
            using (DataTable dt = _dataLoad.GetDivision_Active())
            {
                DivisionSelect.DataSource = dt;
                DivisionSelect.DataValueField = "DivisionId";
                DivisionSelect.DataTextField = "DivisionName";
                DivisionSelect.DataBind();
                DivisionSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                DivisionSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _setupDAL.Get_StationTypeInfoDAL())
            {
                StationTypeSelect.DataSource = dt;
                StationTypeSelect.DataValueField = "StationTypeId";
                StationTypeSelect.DataTextField = "StationTypeName";
                StationTypeSelect.DataBind();
                StationTypeSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                StationTypeSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _setupDAL.Get_UserTypeInfo())
            {
                UserRoleSelect.DataSource = dt;
                UserRoleSelect.DataValueField = "RoleTypeId";
                UserRoleSelect.DataTextField = "RoleType";
                UserRoleSelect.DataBind();
                UserRoleSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                UserRoleSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

    }


    protected void DivisionSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        DistrictSelect.Items.Clear();
        ThanaSelect.Items.Clear();
        try
        {
            using (DataTable dt = _dataLoad.GetDistrict_ByDivision_Active(Convert.ToInt32(DivisionSelect.SelectedValue)))
            {
                DistrictSelect.DataSource = dt;
                DistrictSelect.DataValueField = "DistrictId";
                DistrictSelect.DataTextField = "DistrictName";
                DistrictSelect.DataBind();
                DistrictSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                DistrictSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        
    }

    protected void DistrictSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        ThanaSelect.Items.Clear();
        try
        {
            using (DataTable dt = _dataLoad.GetThana_ByDistrict_Active(Convert.ToInt32(DistrictSelect.SelectedValue)))
            {
                ThanaSelect.DataSource = dt;
                ThanaSelect.DataValueField = "ThanaId";
                ThanaSelect.DataTextField = "ThanaName";
                ThanaSelect.DataBind();
                ThanaSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ThanaSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }

    protected void deleteImageButton_Click(object sender, EventArgs e)
    {
        LinkButton ImageButton = (LinkButton)sender;
        GridViewRow currentRow = (GridViewRow)ImageButton.Parent.Parent;
        int rowindex = 0;
        rowindex = currentRow.RowIndex;

        Remove(rowindex);
    }

    public void Remove(int row)
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("RoleTypeId");
        aDataTable.Columns.Add("StationTypeId");
        aDataTable.Columns.Add("RoleType");
        aDataTable.Columns.Add("StationTypeName");

        DataRow dataRow = null;
        for (int i = 0; i < gv_UserRole.Rows.Count; i++)
        {
            if (i != row)
            {
                dataRow = aDataTable.NewRow();
                HiddenField hfRoleTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfRoleTypeId"));

                HiddenField hfStationTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfStationTypeId"));


                Label lbl_RoleType = ((Label)gv_UserRole.Rows[i].Cells[1].FindControl("lbl_RoleType"));

                Label lbl_StationTypeName = ((Label)gv_UserRole.Rows[i].Cells[1].FindControl("lbl_StationTypeName"));

                dataRow["RoleType"] = lbl_RoleType.Text;
                dataRow["StationTypeName"] = lbl_StationTypeName.Text;

                dataRow["RoleTypeId"] = hfRoleTypeId.Value;
                dataRow["StationTypeId"] = hfStationTypeId.Value;
                aDataTable.Rows.Add(dataRow);
            }
        }
        gv_UserRole.DataSource = aDataTable;
        gv_UserRole.DataBind();

    }

    public void Add()
    {
        DataTable aDataTable = new DataTable();
        aDataTable.Columns.Add("RoleTypeId");
        aDataTable.Columns.Add("StationTypeId");
        aDataTable.Columns.Add("RoleType");
        aDataTable.Columns.Add("StationTypeName");


        DataRow dataRow = null;
        for (int i = 0; i < gv_UserRole.Rows.Count; i++)
        {
            dataRow = aDataTable.NewRow();

            HiddenField hfRoleTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfRoleTypeId"));

            HiddenField hfStationTypeId = ((HiddenField)gv_UserRole.Rows[i].Cells[1].FindControl("hfStationTypeId"));


            Label lbl_RoleType = ((Label)gv_UserRole.Rows[i].Cells[1].FindControl("lbl_RoleType"));

            Label lbl_StationTypeName = ((Label)gv_UserRole.Rows[i].Cells[1].FindControl("lbl_StationTypeName"));

            dataRow["RoleType"] = lbl_RoleType.Text;
            dataRow["StationTypeName"] = lbl_StationTypeName.Text;

            dataRow["RoleTypeId"] = hfRoleTypeId.Value;
            dataRow["StationTypeId"] = hfStationTypeId.Value;



            aDataTable.Rows.Add(dataRow);
        }
        dataRow = aDataTable.NewRow();
        dataRow["RoleType"] = UserRoleSelect.SelectedItem.Text;
        dataRow["RoleTypeId"] = UserRoleSelect.SelectedValue;

        dataRow["StationTypeName"] = StationTypeSelect.SelectedItem.Text;
        dataRow["StationTypeId"] = StationTypeSelect.SelectedValue;


        aDataTable.Rows.Add(dataRow);
        gv_UserRole.DataSource = aDataTable;
        gv_UserRole.DataBind();
        UserRoleSelect.SelectedValue = string.Empty;
        StationTypeSelect.SelectedValue = string.Empty;

    }
    protected void addButton_Click(object sender, EventArgs e)
    {
        UserRoleSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        StationTypeSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (UserRoleSelect.SelectedValue != "" )
        {

            if (StationTypeSelect.SelectedValue != "")
            {
                Add();
            }
            else
            {
                StationTypeSelect.ToolTip = "please fill out this field";
                StationTypeSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                StationTypeSelect.Focus();

            }
        }
        else
        {
            UserRoleSelect.ToolTip = "please fill out this field";
            UserRoleSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            UserRoleSelect.Focus();

        }
    }

    protected void restbtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("MarketSetup.aspx");
    }
}