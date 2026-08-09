using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_CustomerEntry : System.Web.UI.Page
{
    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    private static CustomerInfoDAL _DAL = new CustomerInfoDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    private DropDownList GroupSelect, ZoneSelect, AreaSelect, TeritorySelect, SubTeritory, MarketSelect;
    private HiddenField hfGroupId, hfZone, hfArea, hfTeritory, hfSubTeritory, hfMarket;
    string RoleTypeName = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        hfGroupId = (HiddenField)IVMarketStructure.FindControl("hfGroupId") as HiddenField;
        hfZone = (HiddenField)IVMarketStructure.FindControl("hfZone") as HiddenField;
        hfArea = (HiddenField)IVMarketStructure.FindControl("hfArea") as HiddenField;
        hfTeritory = (HiddenField)IVMarketStructure.FindControl("hfTeritory") as HiddenField;
        hfSubTeritory = (HiddenField)IVMarketStructure.FindControl("hfSubTeritory") as HiddenField;
        hfMarket = (HiddenField)IVMarketStructure.FindControl("hfMarket") as HiddenField;
        GroupSelect = (DropDownList)IVMarketStructure.FindControl("GroupSelect") as DropDownList;
        ZoneSelect = (DropDownList)IVMarketStructure.FindControl("ZoneSelect") as DropDownList;
        AreaSelect = (DropDownList)IVMarketStructure.FindControl("AreaSelect") as DropDownList;
        TeritorySelect = (DropDownList)IVMarketStructure.FindControl("TeritorySelect") as DropDownList;
        SubTeritory = (DropDownList)IVMarketStructure.FindControl("SubTeritory") as DropDownList;
        MarketSelect = (DropDownList)IVMarketStructure.FindControl("MarketSelect") as DropDownList;

        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            
        }
        catch { }
        if (hfimgShow.Value != "")
        {
            outputimage.ImageUrl = hfimgShow.Value;
        }

        if (hfimgShowTrade.Value != "")
        {
            Tradeimage.ImageUrl = hfimgShowTrade.Value;
        }

        if (!IsPostBack)
        {

            LoadInitialInfo();


            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
                btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
                GetOneRecord(id_mastetID.Value);



                if (Session["LoginName"] != null && Session["LoginName"].ToString() == "51419"    )
                {
                    // Editable - Enable all dropdowns
                    GroupSelect.Enabled = true;
                    ZoneSelect.Enabled = true;
                    AreaSelect.Enabled = true;
                    TeritorySelect.Enabled = true;
                    SubTeritory.Enabled = true;
                    MarketSelect.Enabled = true;
                }
                if (RoleTypeName  == "Admin"  )
                {
                    // Editable - Enable all dropdowns
                    GroupSelect.Enabled = true;
                    ZoneSelect.Enabled = true;
                    AreaSelect.Enabled = true;
                    TeritorySelect.Enabled = true;
                    SubTeritory.Enabled = true;
                    MarketSelect.Enabled = true;
                }
                else
                {
                    // Read-only - Disable all dropdowns
                    GroupSelect.Enabled = false;
                    ZoneSelect.Enabled = false;
                    AreaSelect.Enabled = false;
                    TeritorySelect.Enabled = false;
                    SubTeritory.Enabled = false;
                    MarketSelect.Enabled = false;
                }
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
            using (DataTable dt = _DAL.GetCustomerSetupById(Id))
            {


                txtChemistName.Text = dt.Rows[0]["CustomerName"].ToString();
                ddlChemisType.SelectedValue = dt.Rows[0]["CustomerTypeId"].ToString();

                ddlDistributionRoute.SelectedValue = dt.Rows[0]["DistributionRouteId"].ToString();



                txtEmail.Text = dt.Rows[0]["Email"].ToString();

                txtMobile.Text = dt.Rows[0]["CellNo"].ToString();


                txtOwnerName.Text = dt.Rows[0]["OwnerName"].ToString();


                txtAddress.Text = dt.Rows[0]["Address"].ToString();


                txtVoterID.Text = dt.Rows[0]["VoterID"].ToString();



                txtTradeLicense.Text = dt.Rows[0]["TradeLicense"].ToString();



                txtDrugLicense.Text = dt.Rows[0]["DrugLicense"].ToString();



                txtPharmacyCouncilCertificate.Text = dt.Rows[0]["PharmacyCouncilCertificate"].ToString();


                txtBCDS.Text = dt.Rows[0]["BCDS"].ToString();


                txtRemarks.Text = dt.Rows[0]["Reamrks"].ToString();

                try
                {
                    chkIsActive.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"].ToString());
                }
                catch (Exception ex)
                {
                    chkIsActive.Checked = false;
                }


                ddlStationType.SelectedValue = dt.Rows[0]["StationTypeId"].ToString();
                ddlAMStationType.SelectedValue = dt.Rows[0]["NSMStationTypeId"].ToString();
                ddlDZSMStationType.SelectedValue = dt.Rows[0]["DZSMStationTypeId"].ToString().Trim();
                ddlDistributionCenter.SelectedValue = dt.Rows[0]["ComUnitId"].ToString().Trim();
                ddlProgramType.SelectedValue = dt.Rows[0]["ProgramTypeId"].ToString();

                ddlDivision.SelectedValue = dt.Rows[0]["DivisionId"].ToString();
                ddlDivision_SelectedIndexChanged(null, null);

                ddlDistrict.SelectedValue = dt.Rows[0]["DistrictId"].ToString();
                ddlDistrict_SelectedIndexChanged(null, null);
                ddlThana.SelectedValue = dt.Rows[0]["ThanaId"].ToString();


                GroupSelect.SelectedValue = dt.Rows[0]["GroupId"].ToString();

                hfGroupId.Value = dt.Rows[0]["GroupId"].ToString();


                hfZone.Value = dt.Rows[0]["RegionId"].ToString();



                hfArea.Value = dt.Rows[0]["AreaId"].ToString();


                hfTeritory.Value = dt.Rows[0]["TerritoryId"].ToString();

                hfSubTeritory.Value = dt.Rows[0]["SubTerritoryId"].ToString();



                hfMarket.Value = dt.Rows[0]["MarketId"].ToString();



                // string ProLineId = "";
                // for (int i = 0; i < dt.Rows.Count; i++)
                // {

                //     ProLineId = ProLineId + dt.Rows[i]["ProductLineID"].ToString() + ",";
                // }
                // ProLineId = ProLineId.TrimEnd(',');

                //ddlProLine.SelectedValue = ProLineId;

                foreach (ListItem item in ddlProLine.Items)
                {

                    for (int i = 0; i < dt.Rows.Count; i++)
                    {
                        if (item.Value == dt.Rows[i]["ProductLineID"].ToString())
                        {
                            item.Selected = true;

                        }
                    }
                }

                using (DataTable dtTaggedDoctor = _DAL.GetTaggedDoctorList(Convert.ToInt32(Id)))
                {
                    foreach (ListItem item in ddlDoctorTag.Items)
                    {
                        foreach (DataRow row in dtTaggedDoctor.Rows)
                        {
                            if (item.Value == row["DoctorId"].ToString())
                            {
                                item.Selected = true;
                            }
                        }
                    }
                }


                try
                {
                    string imagefullpath = (dt.Rows[0]["ImagePreName"].ToString() + Id.ToString() + ".jpg");


                    try
                    {
                        byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
                        var src = "data:image/jpeg;base64,";

                        outputimage.ImageUrl = src + Convert.ToBase64String(imageArray);
                        hfimgShow.Value = src + Convert.ToBase64String(imageArray);
                        //64.Value = imagefullpath;
                        // outputimage.ImageUrl = imagefullpath;
                        //if (hfimgShow.Value != "")
                        //{
                        //    outputimage.ImageUrl = hfimgShow.Value;
                        //}

                    }
                    catch (Exception ex)
                    {

                    }
                }
                catch (Exception ex)
                {

                }


                try
                {
                    string imagefullpath2 = (dt.Rows[0]["TradeLicensePreName"].ToString() + Id.ToString() + ".jpg");


                    try
                    {
                        byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath2);
                        var src = "data:image/jpeg;base64,";
                        Tradeimage.ImageUrl = src + Convert.ToBase64String(imageArray);
                        hfimgShowTrade.Value = src + Convert.ToBase64String(imageArray);



                    }
                    catch (Exception ex)
                    {

                    }
                }
                catch (Exception ex)
                {

                }





            }







        }
        catch (Exception ex) { }


        try
        {
            if(Session["RoleTypeName"].ToString() != "Admin" )
            {
                ddlDistributionRoute.Enabled = false;
                ddlStationType.Enabled = false;
                ddlAMStationType.Enabled = false;
                ddlDZSMStationType.Enabled = false;
                ddlDistributionCenter.Enabled = false;
                ddlProgramType.Enabled = false;
                ddlDivision.Enabled = false;
                ddlDistrict.Enabled = false;
                ddlThana.Enabled = false;
                GroupSelect.Enabled = false;
                ZoneSelect.Enabled = false;
                AreaSelect.Enabled = false;
                TeritorySelect.Enabled = false;
                SubTeritory.Enabled = false;
                MarketSelect.Enabled = false;
                ddlPharmaPlatform.Enabled = false;

                txtChemistName.ReadOnly = true;
                txtEmail.ReadOnly = true;
                txtMobile.ReadOnly = true;
                txtOwnerName.ReadOnly = true;
                txtAddress.ReadOnly = true;
                txtTradeLicense.ReadOnly = true;
                txtDrugLicense.ReadOnly = true;
                txtPharmacyCouncilCertificate.ReadOnly = true;
                txtBCDS.ReadOnly = true;
                txtRemarks.ReadOnly = true;
            }

            if (Session["LoginName"].ToString() == "53323")
            {
                ddlDistributionRoute.Enabled = true;
                ddlStationType.Enabled = true;
                ddlAMStationType.Enabled = true;
                ddlDZSMStationType.Enabled = true;
                ddlDistributionCenter.Enabled = true;
                ddlProgramType.Enabled = true;
                ddlDivision.Enabled = true;
                ddlDistrict.Enabled = true;
                ddlThana.Enabled = true;
                GroupSelect.Enabled = true;
                ZoneSelect.Enabled = true;
                AreaSelect.Enabled = true;
                TeritorySelect.Enabled = true;
                SubTeritory.Enabled = true;
                MarketSelect.Enabled = true;
                ddlPharmaPlatform.Enabled = true;
                txtChemistName.ReadOnly = false;
                txtEmail.ReadOnly = false;
                txtMobile.ReadOnly = false;
                txtOwnerName.ReadOnly = false;
                txtAddress.ReadOnly = false;
                txtTradeLicense.ReadOnly = false;
                txtDrugLicense.ReadOnly = false;
                txtPharmacyCouncilCertificate.ReadOnly = false;
                txtBCDS.ReadOnly = false;
                txtRemarks.ReadOnly = false;
            }
        }
        catch
        {

        }
    }

    private void LoadInitialInfo()
    {


        try
        {
            using (DataTable dtDoctor = _DAL.GetDoctorListForTagging())
            {
                foreach (DataRow row in dtDoctor.Rows)
                {
                    ddlDoctorTag.Items.Add(new ListItem(row["DoctorCode"] + " : " + row["DoctorName"], row["DoctorId"].ToString()));
                }
            }

            using (DataTable dt = _seedRepo.GetProLineDataTableList())
            {
                ddlProLine.DataSource = dt;
                ddlProLine.DataValueField = "ProductLineID";
                ddlProLine.DataTextField = "LineName";
                ddlProLine.DataBind();
                ddlProLine.Items.Insert(-1, "");
                ddlProLine.SelectedIndex = 0;
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
                ddlDistributionCenter.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDistributionCenter.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        try
        {
            using (DataTable dt = _seedRepo.GetChemistTypeList())
            {
                ddlChemisType.DataSource = dt;
                ddlChemisType.DataValueField = "CustomerTypeId";
                ddlChemisType.DataTextField = "CustomerType";
                ddlChemisType.DataBind();
                ddlChemisType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlChemisType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _seedRepo.GetDistributionRouteList())
            {
                ddlDistributionRoute.DataSource = dt;
                ddlDistributionRoute.DataValueField = "DistributionRouteId";
                ddlDistributionRoute.DataTextField = "DistributionRouteName";
                ddlDistributionRoute.DataBind();
                ddlDistributionRoute.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDistributionRoute.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _seedRepo.GetDivisionList())
            {
                ddlDivision.DataSource = dt;
                ddlDivision.DataValueField = "DivisionId";
                ddlDivision.DataTextField = "DivisionName";
                ddlDivision.DataBind();
                ddlDivision.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDivision.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _seedRepo.GetStationTypeList())
            {
                ddlStationType.DataSource = dt;
                ddlStationType.DataValueField = "StationTypeId";
                ddlStationType.DataTextField = "StationTypeName";
                ddlStationType.DataBind();
                ddlStationType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlStationType.SelectedIndex = 0;

                ddlAMStationType.DataSource = dt;
                ddlAMStationType.DataValueField = "StationTypeId";
                ddlAMStationType.DataTextField = "StationTypeName";
                ddlAMStationType.DataBind();
                ddlAMStationType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlAMStationType.SelectedIndex = 0;


                ddlDZSMStationType.DataSource = dt;
                ddlDZSMStationType.DataValueField = "StationTypeId";
                ddlDZSMStationType.DataTextField = "StationTypeName";
                ddlDZSMStationType.DataBind();
                ddlDZSMStationType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlDZSMStationType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }





        try
        {
            using (DataTable dt = _seedRepo.GetProgramTypeListParam(" and GRP.IsCustomer=1"))
            {
                ddlProgramType.DataSource = dt;
                ddlProgramType.DataValueField = "ProgramTypeId";
                ddlProgramType.DataTextField = "ProgramTypeName";
                ddlProgramType.DataBind();
                ddlProgramType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlProgramType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _seedRepo.GetSMCTypeListParam(" and GRP.forCustomer=1"))
            {
                ddlPharmaPlatform.DataSource = dt;
                ddlPharmaPlatform.DataValueField = "SMCTypeId";
                ddlPharmaPlatform.DataTextField = "SMCType";
                ddlPharmaPlatform.DataBind();
                ddlPharmaPlatform.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlPharmaPlatform.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


    }

    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public bool Validation()
    {


        txtOwnerName.CssClass = "form-control form-control-sm";
        txtChemistName.CssClass = "form-control form-control-sm";
        txtVoterID.CssClass = "form-control form-control-sm";
        txtAddress.CssClass = "form-control form-control-sm";
        txtMobile.CssClass = "form-control form-control-sm";
        ddlChemisType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlDistributionRoute.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlDistributionCenter.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlStationType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlAMStationType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlDZSMStationType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlProgramType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ZoneSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        SubTeritory.CssClass = "form-select form-select-sm mb-3 mySelect2";
        MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlDivision.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlDistrict.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlThana.CssClass = "form-select form-select-sm mb-3 mySelect2";
        if (txtChemistName.Text == "")
        {
            txtChemistName.ToolTip = "please fill out this field";
            txtChemistName.CssClass = "form-control form-control-sm is-invalid";
            txtChemistName.Focus();
            return false;
        }

        if (ddlChemisType.SelectedValue == "")
        {
            ddlChemisType.ToolTip = "please fill out this field";
            ddlChemisType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlChemisType.Focus();
            return false;
        }

        //if (ddlDistributionRoute.SelectedValue == "")
        //{
        //    ddlDistributionRoute.ToolTip = "please fill out this field";
        //    ddlDistributionRoute.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlDistributionRoute.Focus();
        //    return false;
        //}


        //if (txtVoterID.Text == "")
        //{
        //    txtVoterID.ToolTip = "please fill out this field";
        //    txtVoterID.CssClass = "form-control form-control-sm is-invalid";
        //    txtVoterID.Focus();
        //    return false;
        //}
        if (txtMobile.Text == "")
        {
            txtMobile.ToolTip = "please fill out this field";
            txtMobile.CssClass = "form-control form-control-sm is-invalid";
            txtMobile.Focus();
            return false;
        }
      
        if (txtOwnerName.Text == "")
        {
            txtOwnerName.ToolTip = "please fill out this field";
            txtOwnerName.CssClass = "form-control form-control-sm is-invalid";
            txtOwnerName.Focus();
            return false;
        }


        if (txtAddress.Text == "")
        {
            txtAddress.ToolTip = "please fill out this field";
            txtAddress.CssClass = "form-control form-control-sm is-invalid";
            txtAddress.Focus();
            return false;
        }

        //if (ddlStationType.SelectedValue == "")
        //{
        //    ddlStationType.ToolTip = "please fill out this field";
        //    ddlStationType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlStationType.Focus();
        //    return false;
        //}

        //if (ddlAMStationType.SelectedValue == "")
        //{
        //    ddlAMStationType.ToolTip = "please fill out this field";
        //    ddlAMStationType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlAMStationType.Focus();
        //    return false;
        //}
        //if (ddlDZSMStationType.SelectedValue == "")
        //{
        //    ddlDZSMStationType.ToolTip = "please fill out this field";
        //    ddlDZSMStationType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlDZSMStationType.Focus();
        //    return false;
        //}


        if (ddlProgramType.SelectedValue == "")
        {
            ddlProgramType.ToolTip = "please fill out this field";
            ddlProgramType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlProgramType.Focus();
            return false;
        }
        //if (ddlDistributionCenter.SelectedValue == "")
        //{
        //    ddlDistributionCenter.ToolTip = "please fill out this field";
        //    ddlDistributionCenter.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlDistributionCenter.Focus();
        //    return false;
        //}

        if (GroupSelect.SelectedValue == "")
        {
            GroupSelect.ToolTip = "please fill out this field";
            GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            GroupSelect.Focus();
            return false;
        }

        if (ZoneSelect.SelectedValue == "")
        {
            ZoneSelect.ToolTip = "please fill out this field";
            ZoneSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ZoneSelect.Focus();
            return false;
        }



        if (AreaSelect.SelectedValue == "")
        {
            AreaSelect.ToolTip = "please fill out this field";
            AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            AreaSelect.Focus();
            return false;
        }


        if (TeritorySelect.SelectedValue == "")
        {
            TeritorySelect.ToolTip = "please fill out this field";
            TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            TeritorySelect.Focus();
            return false;
        }


        if (SubTeritory.SelectedValue == "")
        {
            SubTeritory.ToolTip = "please fill out this field";
            SubTeritory.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            SubTeritory.Focus();
            return false;
        }

        if (MarketSelect.SelectedValue == "")
        {
            MarketSelect.ToolTip = "please fill out this field";
            MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            MarketSelect.Focus();
            return false;
        }

        //if (ddlDivision.SelectedValue == "")
        //{
        //    ddlDivision.ToolTip = "please fill out this field";
        //    ddlDivision.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlDivision.Focus();
        //    return false;
        //}


        //if (ddlDistrict.SelectedValue == "")
        //{
        //    ddlDistrict.ToolTip = "please fill out this field";
        //    ddlDistrict.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlDistrict.Focus();
        //    return false;
        //}


        //if (ddlThana.SelectedValue == "")
        //{
        //    ddlThana.ToolTip = "please fill out this field";
        //    ddlThana.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
        //    ddlThana.Focus();
        //    return false;
        //}



        //if (txtVoterID.Text != "")
        //{
        //    if (txtVoterID.Text.Length != 17)
        //    {

        //        string text6 = "NID No must be 17 digits!";
        //        ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
        //        txtVoterID.Focus();
        //        txtVoterID.CssClass = "form-control form-control-sm  is-invalid";

        //        return false;
        //    }
        //}

        if (txtMobile.Text != "")
        {
            if (txtMobile.Text.Length != 11)
            {

                string text6 = "Mobile NO must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtMobile.Focus();
                txtMobile.CssClass = "form-control form-control-sm  is-invalid";

                return false;
            }
        }



        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {



            CustMasterInfoDAO aMaster = new CustMasterInfoDAO();

            aMaster.CustomerMasterId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.CustomerName = string.IsNullOrEmpty(txtChemistName.Text) ? null : txtChemistName.Text;
            aMaster.CustomerTypeId = ddlChemisType.SelectedIndex > 0 ? int.Parse(ddlChemisType.SelectedValue) : (int?)null;
            aMaster.CustomerType = ddlChemisType.SelectedIndex > 0 ? ddlChemisType.SelectedItem.Text : null;

            aMaster.DistributionRouteId = ddlDistributionRoute.SelectedIndex > 0 ? int.Parse(ddlDistributionRoute.SelectedValue) : (int?)null;

            aMaster.Email = string.IsNullOrEmpty(txtEmail.Text) ? null : txtEmail.Text;
            aMaster.CellNo = string.IsNullOrEmpty(txtMobile.Text) ? null : txtMobile.Text;
            aMaster.OwnerName = string.IsNullOrEmpty(txtOwnerName.Text) ? null : txtOwnerName.Text;
            aMaster.Address = string.IsNullOrEmpty(txtAddress.Text) ? null : txtAddress.Text;
            aMaster.VoterID = string.IsNullOrEmpty(txtVoterID.Text) ? null : txtVoterID.Text;
            aMaster.TradeLicense = string.IsNullOrEmpty(txtTradeLicense.Text) ? null : txtTradeLicense.Text;
            aMaster.DrugLicense = string.IsNullOrEmpty(txtDrugLicense.Text) ? null : txtDrugLicense.Text;
            aMaster.PharmacyCouncilCertificate = string.IsNullOrEmpty(txtPharmacyCouncilCertificate.Text) ? null : txtPharmacyCouncilCertificate.Text;
            aMaster.BCDS = string.IsNullOrEmpty(txtBCDS.Text) ? null : txtBCDS.Text;
            aMaster.Reamrks = string.IsNullOrEmpty(txtRemarks.Text) ? null : txtRemarks.Text;
            aMaster.IsActive = chkIsActive.Checked;

            aMaster.MarketName = MarketSelect.SelectedIndex > 0 ? MarketSelect.SelectedItem.Text : null;
            aMaster.MarketId = MarketSelect.SelectedIndex > 0 ? int.Parse(MarketSelect.SelectedValue) : (int?)null;




            aMaster.StationTypeId = ddlStationType.SelectedIndex > 0 ? int.Parse(ddlStationType.SelectedValue) : (int?)null;
            aMaster.CustomerStation = ddlStationType.SelectedIndex > 0 ? ddlStationType.SelectedItem.Text : null;



            aMaster.NSMStationTypeId = ddlAMStationType.SelectedIndex > 0 ? int.Parse(ddlAMStationType.SelectedValue) : (int?)null;
            aMaster.DZSMStationTypeId = ddlDZSMStationType.SelectedIndex > 0 ? int.Parse(ddlDZSMStationType.SelectedValue) : (int?)null;
            aMaster.ComUnitId = ddlDistributionCenter.SelectedIndex > 0 ? int.Parse(ddlDistributionCenter.SelectedValue) : (int?)null;





            aMaster.ProgramTypeId = ddlProgramType.SelectedIndex > 0 ? int.Parse(ddlProgramType.SelectedValue) : (int?)null;





            aMaster.DivisionId = ddlDivision.SelectedIndex > 0 ? int.Parse(ddlDivision.SelectedValue) : (int?)null;

            aMaster.Division = ddlDivision.SelectedIndex > 0 ? ddlDivision.SelectedItem.Text : null;

            aMaster.DistrictId = ddlDistrict.SelectedIndex > 0 ? int.Parse(ddlDistrict.SelectedValue) : (int?)null;

            aMaster.District = ddlDistrict.SelectedIndex > 0 ? ddlDistrict.SelectedItem.Text : null;


            aMaster.ThanaId = ddlThana.SelectedIndex > 0 ? int.Parse(ddlThana.SelectedValue) : (int?)null;

            aMaster.Thana = ddlThana.SelectedIndex > 0 ? ddlThana.SelectedItem.Text : null;




            string ProLineArray = "";

            foreach (ListItem item in ddlProLine.Items)
            {
                if (item.Selected)
                {

                    ProLineArray = ProLineArray + item.Value + ",";
                }
            }

            ProLineArray = ProLineArray.TrimEnd(',');

            string DoctorArray = "";

            foreach (ListItem item in ddlDoctorTag.Items)
            {
                if (item.Selected)
                {
                    DoctorArray = DoctorArray + item.Value + ",";
                }
            }

            DoctorArray = DoctorArray.TrimEnd(',');


            ResultInfo Res = _DAL.SaveInfo(aMaster, ProLineArray, DoctorArray, Session["UserId"].ToString());
            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','CustomerView.aspx');", true);

            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

            }

        }

    }

    protected void ddlDivision_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlDivision.SelectedIndex > 0)
        {
            try
            {
                using (DataTable dt = _seedRepo.GetDistrictList(ddlDivision.SelectedValue))
                {
                    ddlDistrict.DataSource = dt;
                    ddlDistrict.DataValueField = "DistrictId";
                    ddlDistrict.DataTextField = "DistrictName";
                    ddlDistrict.DataBind();
                    ddlDistrict.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlDistrict.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
        }
        else
        {
            ddlDistrict.Items.Clear();
            ddlThana.Items.Clear();
        }
    }

    protected void ddlDistrict_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (ddlDistrict.SelectedIndex > 0)
        {
            try
            {
                using (DataTable dt = _seedRepo.GetThanaList(ddlDistrict.SelectedValue))
                {
                    ddlThana.DataSource = dt;
                    ddlThana.DataValueField = "ThanaId";
                    ddlThana.DataTextField = "ThanaName";
                    ddlThana.DataBind();
                    ddlThana.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                    ddlThana.SelectedIndex = 0;
                }


            }
            catch (Exception ex) { }
        }
        else
        {

            ddlThana.Items.Clear();
        }
    }

    protected void btnReset_OnClick(object sender, EventArgs e)
    {
        Response.Redirect("CustomerEntry.aspx");
    }
}