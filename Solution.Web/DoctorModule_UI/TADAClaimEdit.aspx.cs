using DocumentFormat.OpenXml.Wordprocessing;
using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls; 


public partial class DoctorModule_UI_TADAClaimEdit : System.Web.UI.Page
{
    private static EmployeeInformationDaL _EmployeeInformationDaL = new EmployeeInformationDaL();
    public static SetupDAL _setupDAL = new SetupDAL();
    private static Setup2DAL _setupDALs = new Setup2DAL();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    
    protected void Page_Load(object sender, EventArgs e)
    {

       
        try
        { 
            if (!IsPostBack)
            {
                TadaDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
               
                LoadInitialInfo();



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
        catch (Exception ex)
        {
        }
    }
    private void GetOneRecord(string Id)
    {
        try
        {
            using (DataTable dt33 = _setupDALs.GetTadaForEdit(Id))
            {

                id_mastetID.Value = dt33.Rows[0]["TadaID"].ToString();
                TadaDate.Text = dt33.Rows[0]["TadaDate"].ToString();
                txtDAAmount.Text = dt33.Rows[0]["DAAmount"].ToString();
                txtRemarks.Text = dt33.Rows[0]["Remarks"].ToString();
                txtHotelName.Text = dt33.Rows[0]["HotelName"].ToString();
                txtHotelPhone.Text = dt33.Rows[0]["HotelPhone"].ToString();
                ddlTourType.SelectedValue = dt33.Rows[0]["TourTypeId"].ToString();
                ddlTourType.SelectedValue = dt33.Rows[0]["TourTypeId"].ToString();
                EmployeeIdSelect.SelectedValue = dt33.Rows[0]["EmpInfoId"].ToString();

                using (DataTable dtTTPs = _setupDALs.Get_TourPlanByTourPlanDate(EmployeeIdSelect.SelectedValue, TadaDate.Text))
                {
                    ddlTourPurpose.SelectedValue = dtTTPs.Rows[0]["TPId"].ToString();
                }


                    try
                {
                    using (DataTable dt = _dataLoad.GetGroupInfo_All())
                    {
                        GroupSelect.DataSource = dt;
                        GroupSelect.DataValueField = "GroupId";
                        GroupSelect.DataTextField = "GroupName";
                        GroupSelect.DataBind();
                        GroupSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
    
                        GroupSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                // showMessageBox(hfGroupId.Value);
                GroupSelect.SelectedValue = dt33.Rows[0]["GroupId"].ToString();


                try
                {

                    using (DataTable dt = _dataLoad.GetZone_byGroupId_All(Convert.ToInt32(GroupSelect.SelectedValue)))
                    {
                        ZoneSelect.DataSource = dt;
                        ZoneSelect.DataValueField = "RegionId";
                        ZoneSelect.DataTextField = "RegionName";
                        ZoneSelect.DataBind();
                        ZoneSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        ZoneSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }


                ZoneSelect.SelectedValue = dt33.Rows[0]["RegionId"].ToString();
                ;


                try
                {

                    using (DataTable dt = _dataLoad.GetArea_ByZoneId_All(Convert.ToInt32(ZoneSelect.SelectedValue)))
                    {
                        AreaSelect.DataSource = dt;
                        AreaSelect.DataValueField = "AreaId";
                        AreaSelect.DataTextField = "AreaName";
                        AreaSelect.DataBind();
                        AreaSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        AreaSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }

                AreaSelect.SelectedValue = dt33.Rows[0]["AreaId"].ToString();


                try
                {

                    using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(Convert.ToInt32(AreaSelect.SelectedValue))
                        )
                    {
                        TeritorySelect.DataSource = dt;
                        TeritorySelect.DataValueField = "TerritoryId";
                        TeritorySelect.DataTextField = "TerritoryName";
                        TeritorySelect.DataBind();
                        TeritorySelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        TeritorySelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                TeritorySelect.SelectedValue = dt33.Rows[0]["TerritoryId"].ToString();


                try
                {

                    using (
                        DataTable dt =
                            _dataLoad.GetSubTerritory_ByTerritoryId_Alle(Convert.ToInt32(TeritorySelect.SelectedValue)))
                    {
                        SubTeritory.DataSource = dt;
                        SubTeritory.DataValueField = "SubTerritoryId";
                        SubTeritory.DataTextField = "SubTerritoryName";
                        SubTeritory.DataBind();
                        SubTeritory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        SubTeritory.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                SubTeritory.SelectedValue = dt33.Rows[0]["SubTerritoryId"].ToString();


                try
                {

                    using (
                        DataTable dt =
                            _dataLoad.GetMarket_BySubTerritoryId_All(Convert.ToInt32(SubTeritory.SelectedValue)))
                    {
                        MarketSelect.DataSource = dt;
                        MarketSelect.DataValueField = "MarketId";
                        MarketSelect.DataTextField = "MarketName";
                        MarketSelect.DataBind();
                        MarketSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        MarketSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {

                }
                MarketSelect.SelectedValue = dt33.Rows[0]["MarketId"].ToString();


            }





            //gv_ProductList.DataSource = dtDetail;
            //gv_ProductList.DataBind();

        }
        catch (Exception ex)
        {

            TadaDate.Text = "";
            txtDAAmount.Text = "";
            txtRemarks.Text = "";
            txtHotelName.Text = "";
            txtHotelPhone.Text = "";
            ddlTourType.Text = "";
            EmployeeIdSelect.SelectedValue = "";
            GroupSelect.SelectedValue = "";
            ZoneSelect.SelectedValue = "";
            AreaSelect.SelectedValue = "";
            TeritorySelect.SelectedValue = "";
            SubTeritory.SelectedValue = "";
            MarketSelect.SelectedValue = "";
            AreaSelect.Items.Clear();
            TeritorySelect.Items.Clear();
            SubTeritory.Items.Clear();
            MarketSelect.Items.Clear();
        }
    }
   

   
    protected void gv_DocumentUpload_PreRender(object sender, EventArgs e)
    {
        GridView gv = (GridView)sender;

        if ((gv.ShowHeader == true && gv.Rows.Count > 0)
            || (gv.ShowHeaderWhenEmpty == true))
        {
            //Force GridView to use <thead> instead of <tbody> - 11/03/2013 - MCR.
            gv.HeaderRow.TableSection = TableRowSection.TableHeader;
        }
    }
    private void LoadInitialInfo()
    {


        try
        {
            using (DataTable dt = _setupDAL.Get_StationTypeInfo())
            {
                ddlTourType.DataSource = dt;
                ddlTourType.DataValueField = "StationTypeId";
                ddlTourType.DataTextField = "StationTypeName";
                ddlTourType.DataBind();
                ddlTourType.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                ddlTourType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        

        try
        {
            using (DataTable dt = _setupDAL.Get_TourPurposeInfo())
            {
                ddlTourPurpose.DataSource = dt;
                ddlTourPurpose.DataValueField = "TPId";
                ddlTourPurpose.DataTextField = "TPName";
                ddlTourPurpose.DataBind();
                ddlTourPurpose.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                ddlTourPurpose.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_Active())
            {
                EmployeeIdSelect.DataSource = dt;
                EmployeeIdSelect.DataValueField = "EmpInfoId";
                EmployeeIdSelect.DataTextField = "EmpName";
                EmployeeIdSelect.DataBind();
                EmployeeIdSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                EmployeeIdSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }

    

    public bool Validation()
    {

        TadaDate.CssClass = "form-control form-control-sm";
        txtDAAmount.CssClass = "form-control form-control-sm";
        EmployeeIdSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlTourType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlTourPurpose.CssClass = "form-select form-select-sm mb-3 mySelect2";
        MarketSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";


        if (EmployeeIdSelect.SelectedValue == "")
        {
            EmployeeIdSelect.ToolTip = "please fill out this field";
            EmployeeIdSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            EmployeeIdSelect.Focus();
            return false;
        }
        if (TadaDate.Text == "")
        {
            TadaDate.ToolTip = "please fill out this field";
            TadaDate.CssClass = "form-control form-control-sm is-invalid";
            TadaDate.Focus();
            return false;
        }


        if (txtDAAmount.Text == "")
        {
            txtDAAmount.ToolTip = "please fill out this field";
            txtDAAmount.CssClass = "form-control form-control-sm is-invalid";
            txtDAAmount.Focus();
            return false;
        }


        if (ddlTourType.SelectedValue == "")
        {
            ddlTourType.ToolTip = "please fill out this field";
            ddlTourType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlTourType.Focus();
            return false;
        }
        

        if (ddlTourPurpose.SelectedValue == "")
        {
            ddlTourPurpose.ToolTip = "please fill out this field";
            ddlTourPurpose.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlTourPurpose.Focus();
            return false;
        }

        string selectedText = ddlTourPurpose.SelectedItem.Text;
        string extractedText = string.Empty;

        bool chkMArketNeed = true;
        if (selectedText.Contains("(Other Visit)"))
        {
            // Extract "(Other Visit)"
            chkMArketNeed = false;

            // Your logic for handling "(Other Visit)" goes here
        }
        if (chkMArketNeed)
        {
            if (MarketSelect.SelectedValue == "")
            {
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

        if (Validation())
        {


            TADADAO aMaster = new TADADAO();

            aMaster.TadaID = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.EmpInfoId = EmployeeIdSelect.SelectedIndex > 0 ? int.Parse(EmployeeIdSelect.SelectedValue) : (int?)null;
            aMaster.TadaDate = string.IsNullOrEmpty(TadaDate.Text) ? (DateTime?)null : DateTime.Parse(TadaDate.Text).Date;
            aMaster.Remarks = string.IsNullOrEmpty(txtRemarks.Text) ? null : txtRemarks.Text;
            aMaster.HotelName = string.IsNullOrEmpty(txtHotelName.Text) ? null : txtHotelName.Text;
            aMaster.HotelPhone = string.IsNullOrEmpty(txtHotelPhone.Text) ? null : txtHotelPhone.Text;
            aMaster.DAAmount =  Convert.ToDecimal(txtDAAmount.Text) ;

            aMaster.TourTypeId = ddlTourType.SelectedIndex > 0 ? int.Parse(ddlTourType.SelectedValue) : (int?)null;

            aMaster.GroupId = GroupSelect.SelectedIndex > 0 ? int.Parse(GroupSelect.SelectedValue) : (int?)null;
            aMaster.RegionId = ZoneSelect.SelectedIndex > 0 ? int.Parse(ZoneSelect.SelectedValue) : (int?)null;

            aMaster.AreaId = AreaSelect.SelectedIndex > 0 ? int.Parse(AreaSelect.SelectedValue) : (int?)null;

            aMaster.TerritoryId = TeritorySelect.SelectedIndex > 0 ? int.Parse(TeritorySelect.SelectedValue) : (int?)null;

            aMaster.SubTerritoryId = SubTeritory.SelectedIndex > 0 ? int.Parse(SubTeritory.SelectedValue) : (int?)null;

            aMaster.MarketId = MarketSelect.SelectedIndex > 0 ? int.Parse(MarketSelect.SelectedValue) : (int?)null;

           

            bool result = false;

            ResultInfo Res = _setupDALs.SaveTADADA(aMaster, Session["UserId"].ToString());


            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TADAClaimView.aspx');", true);
            }
             

            else
            {
       
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }


        }

    }


    protected void restbtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("TADAClaimEdit.aspx");
    }

    protected void TadaDate_TextChanged(object sender, EventArgs e)
    {
        try
        {
            LoadInfo();
        }
        catch (Exception)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Tour plan not Exists!" + "','Faild');", true);
            // TadaDate.Text = "";
            txtDAAmount.Text = "";
            txtRemarks.Text = "";
            txtHotelName.Text = "";
            txtHotelPhone.Text = "";
            ddlTourType.Text = "";
          ///  EmployeeIdSelect.SelectedValue = "";
            GroupSelect.SelectedValue = "";
            ZoneSelect.SelectedValue = "";
            AreaSelect.SelectedValue = "";
            TeritorySelect.SelectedValue = "";
            SubTeritory.SelectedValue = "";
            MarketSelect.SelectedValue = "";

            AreaSelect.Items.Clear();
            TeritorySelect.Items.Clear();
            SubTeritory.Items.Clear();
            MarketSelect.Items.Clear();
        }
    }

    private void LoadInfo()
    {
        if (EmployeeIdSelect.SelectedValue != "")
        {
            using (DataTable dt33 = _setupDALs.Get_TourPlanByTourPlanDate(EmployeeIdSelect.SelectedValue, TadaDate.Text))
            {
                try
                {
                    using (DataTable dt = _dataLoad.GetGroupInfo_All())
                    {
                        GroupSelect.DataSource = dt;
                        GroupSelect.DataValueField = "GroupId";
                        GroupSelect.DataTextField = "GroupName";
                        GroupSelect.DataBind();
                        GroupSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        GroupSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                }
                // showMessageBox(hfGroupId.Value);
                GroupSelect.SelectedValue = dt33.Rows[0]["GroupId"].ToString();


                try
                {
                    using (DataTable dt = _dataLoad.GetZone_byGroupId_All(Convert.ToInt32(GroupSelect.SelectedValue)))
                    {
                        ZoneSelect.DataSource = dt;
                        ZoneSelect.DataValueField = "RegionId";
                        ZoneSelect.DataTextField = "RegionName";
                        ZoneSelect.DataBind();
                        ZoneSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        ZoneSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                }


                ZoneSelect.SelectedValue = dt33.Rows[0]["RegionId"].ToString();
                ;


                try
                {
                    using (DataTable dt = _dataLoad.GetArea_ByZoneId_All(Convert.ToInt32(ZoneSelect.SelectedValue)))
                    {
                        AreaSelect.DataSource = dt;
                        AreaSelect.DataValueField = "AreaId";
                        AreaSelect.DataTextField = "AreaName";
                        AreaSelect.DataBind();
                        AreaSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        AreaSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                }

                AreaSelect.SelectedValue = dt33.Rows[0]["AreaId"].ToString();


                try
                {
                    using (DataTable dt = _dataLoad.GetTerritory_ByAreaId_All(Convert.ToInt32(AreaSelect.SelectedValue)))
                    {
                        TeritorySelect.DataSource = dt;
                        TeritorySelect.DataValueField = "TerritoryId";
                        TeritorySelect.DataTextField = "TerritoryName";
                        TeritorySelect.DataBind();
                        TeritorySelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        TeritorySelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                }
                TeritorySelect.SelectedValue = dt33.Rows[0]["TerritoryId"].ToString();


                try
                {
                    using (
                        DataTable dt =
                            _dataLoad.GetSubTerritory_ByTerritoryId_Alle(Convert.ToInt32(TeritorySelect.SelectedValue)))
                    {
                        SubTeritory.DataSource = dt;
                        SubTeritory.DataValueField = "SubTerritoryId";
                        SubTeritory.DataTextField = "SubTerritoryName";
                        SubTeritory.DataBind();
                        SubTeritory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        SubTeritory.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                }
                SubTeritory.SelectedValue = dt33.Rows[0]["SubTerritoryId"].ToString();


                try
                {
                    using (
                        DataTable dt = _dataLoad.GetMarket_BySubTerritoryId_All(Convert.ToInt32(SubTeritory.SelectedValue)))
                    {
                        MarketSelect.DataSource = dt;
                        MarketSelect.DataValueField = "MarketId";
                        MarketSelect.DataTextField = "MarketName";
                        MarketSelect.DataBind();
                        MarketSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                        MarketSelect.SelectedIndex = 0;
                    }
                }
                catch (Exception ex)
                {
                }
                MarketSelect.SelectedValue = dt33.Rows[0]["MarketId"].ToString();


                txtDAAmount.Text = dt33.Rows[0]["DAAmount"].ToString();

                ddlTourType.SelectedValue = dt33.Rows[0]["TourTypeId"].ToString();
                try
                {
                    ddlTourPurpose.SelectedValue = dt33.Rows[0]["TPId"].ToString();
                }
                catch { }
            }
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
                ZoneSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
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
                AreaSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
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
                TeritorySelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
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
                SubTeritory.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
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
                MarketSelect.Items.Insert(0, new System.Web.UI.WebControls.ListItem("Please Select From List", ""));
                MarketSelect.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }
    }

    protected void EmployeeIdSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        try
        {
            LoadInfo();
        }
        catch (Exception)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + " Tour plan not Exists!" + "','Faild');", true);
            //TadaDate.Text = "";
            txtDAAmount.Text = "";
            txtRemarks.Text = "";
            txtHotelName.Text = "";
            txtHotelPhone.Text = "";
            ddlTourType.Text = "";
            //EmployeeIdSelect.SelectedValue = "";
            GroupSelect.SelectedValue = "";
            ZoneSelect.SelectedValue = "";
            AreaSelect.SelectedValue = "";
            TeritorySelect.SelectedValue = "";
            SubTeritory.SelectedValue = "";
            MarketSelect.SelectedValue = "";

            AreaSelect.Items.Clear();
            TeritorySelect.Items.Clear();
            SubTeritory.Items.Clear();
            MarketSelect.Items.Clear();
        }
    }
}
 
