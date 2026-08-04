using Library.DAL.DoctorModule_DAL;
using Library.DAL.MasterSetup_DAL;
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

public partial class MasterSetup_UI_EmployeeSetup : System.Web.UI.Page
{
    private static RSMSetupDal _setupDAL = new RSMSetupDal();

    private static SeedDataDAL _seedRepo = new SeedDataDAL();

    private static EmployeeInformationDaL _DAL = new EmployeeInformationDaL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();
    private static UserInfoDAL _UserDAL = new UserInfoDAL();
 

    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {

            LoadInitialInfo();


            if (!string.IsNullOrEmpty(Request.QueryString["MID"]))
            {
              //  btnUpdate.Visible = true;

                id_mastetID.Value = Request.QueryString["MID"];
                GetOneRecord(id_mastetID.Value);
            }
            else
            {
                btnSave.Visible = true;
            }


        }
    }

    private void GetOneRecord(string value)
    {
        try
        {
            using (DataTable dt = _DAL.GetEmployeeInfoForEdit(Convert.ToInt32(value)))
            {


                txtEmpName.Text = dt.Rows[0]["EmpName"].ToString();
                txtEmpFatherName.Text = dt.Rows[0]["FatherName"].ToString();
                txtEmpCode.Text = dt.Rows[0]["EmpMasterCode"].ToString();
                txtEmpMotherName.Text = dt.Rows[0]["MotherName"].ToString();

                txtEmpdobDate.Text = dt.Rows[0]["DateOfBirth"].ToString();
                txtProbationEndDate.Text = dt.Rows[0]["ProbitionEndDate"].ToString();

                txtEmpAddress.Text = dt.Rows[0]["AddressPresent"].ToString();

                txtEmpPresentAddress.Text = dt.Rows[0]["AddressPermanent"].ToString();  

                GenderSelect.SelectedValue = dt.Rows[0]["Gender"].ToString();
                ReligionSelect.SelectedValue = dt.Rows[0]["Religion"].ToString();

                Nationality.SelectedValue = dt.Rows[0]["Nationality"].ToString();

                BloodGroupSelect.SelectedValue = dt.Rows[0]["BloodGroup"].ToString();

                MaritalStatusSelect.SelectedValue = dt.Rows[0]["MaritalStatus"].ToString();

                txtNIDNO.Text = dt.Rows[0]["NationalIdNo"].ToString();
                txtJobLeftDate.Text = dt.Rows[0]["JobLeftDate"].ToString();
                txtLastCompanyName.Text = dt.Rows[0]["LastCompanyName"].ToString();
                txtLastJobLocation.Text = dt.Rows[0]["LastJobLocation"].ToString();



                txtDateofjoin.Text = dt.Rows[0]["JoiningDate"].ToString();

                DepartmentSelect.SelectedValue = dt.Rows[0]["DepartmentId"].ToString();

                DesignationSelect.SelectedValue = dt.Rows[0]["DesignationId"].ToString();

                ShiftSelect.SelectedValue = dt.Rows[0]["ShiftId"].ToString();



                txtEmail.Text = dt.Rows[0]["Email"].ToString();

                txtEmpContactNo.Text = dt.Rows[0]["CellNumber"].ToString();

                ReferencePersonName.Text = dt.Rows[0]["RefName"].ToString();

                ReferenceContactNo.Text = dt.Rows[0]["RefContactNo"].ToString();

                txtEmergencyContactNo.Text = dt.Rows[0]["EmrgContactNo"].ToString();

                txtEmail.Text = dt.Rows[0]["Email"].ToString();
                txtEmrgContactNoRelaton.Text = dt.Rows[0]["EmrgContactNoRelaton"].ToString();

                bool IsProb = false;

                try
                {
                    IsProb = Convert.ToBoolean(dt.Rows[0]["IsProbition"].ToString());
                }
                catch(Exception ex)
                {

                }

                chkIsProbation.Checked = IsProb;


                bool Istemp = false;

                try
                {
                    Istemp = Convert.ToBoolean(dt.Rows[0]["IsTempEmployeeCode"].ToString());
                }
                catch (Exception ex)
                {

                }

                chkIsTempEmployeeCode.Checked = Istemp;


                if (dt.Rows[0]["EmployeeStatus"].ToString()== "Active")
                {
                    chkIsActive.Checked = true;
                }
                else
                {
                    chkIsActive.Checked = false;

                }

              
                 
 
                string[] degree = dt.Rows[0]["AllowanceId"].ToString().Split(',');

                foreach (ListItem item in ddlMonthlyAllawance.Items)
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



        try
        {

            using (DataTable dt = _UserDAL.GetUserSetupByEmpId(value))
            {
                //ddlUserType.SelectedValue = dt.Rows[0]["UserTypeId"].ToString();
                //ddlUserType_SelectedIndexChanged(null, null);
                //ddlEmployeeName.SelectedValue = dt.Rows[0]["EmpInfoId"].ToString();
                hfUserId.Value= dt.Rows[0]["UserId"].ToString();
                //txtUserName.Text = dt.Rows[0]["UserName"].ToString();
                txtLoginName.Text = dt.Rows[0]["LoginName"].ToString();
                txtPassword.Text = dt.Rows[0]["Password"].ToString();
                try
                {
                    rbDashboard.Items[0].Selected = Convert.ToBoolean(dt.Rows[0]["IsMainDashboard"].ToString());
                }
                catch (Exception ex)
                {

                }

                try
                {
                    rbDashboard.Items[1].Selected = Convert.ToBoolean(dt.Rows[0]["IsDepotDashboard"].ToString());
                }
                catch (Exception ex)
                {

                }
                bool isApp = false;
                try
                {
                    isApp = Convert.ToBoolean(dt.Rows[0]["IsAppsUser"].ToString());
                }
                catch (Exception ex)
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


                if (dt.Rows[0]["UserStatus"].ToString() == "Active")
                {
                    chkIsActive.Checked = true;
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

        if (hfRoleType.Value != "")
        {

            if (hfRoleType.Value == "MIO")
            {

                try
                {

                    using (DataTable dt = _setupDAL.GetMIOetupEditDataByEmpId(value))
                    {

                        hfMIOId.Value = dt.Rows[0]["MIOId"].ToString();
                        GroupSelect.SelectedValue=    dt.Rows[0]["GroupId"].ToString();
                        GroupSelect_SelectedIndexChanged(null, null);

                        ZoneSelect.SelectedValue = dt.Rows[0]["RegionId"].ToString();
                        ZoneSelect_SelectedIndexChanged(null, null);

                        AreaSelect.SelectedValue = dt.Rows[0]["AreaId"].ToString();
                        AreaSelect_SelectedIndexChanged(null, null);
                        TeritorySelect.SelectedValue = dt.Rows[0]["TerritoryId"].ToString();

                     txtacDate.Text= dt.Rows[0]["ActiveDateStr"].ToString();


                    }
                }
                catch (Exception ex) { }
            }



            if (hfRoleType.Value == "AM")
            {

                try
                {

                    using (DataTable dt = _setupDAL.GetAMSetupEditDataByEmpId(value))
                    {

                        hfAMID.Value = dt.Rows[0]["ASMId"].ToString();
                        GroupSelect.SelectedValue = dt.Rows[0]["GroupId"].ToString();
                        GroupSelect_SelectedIndexChanged(null, null);

                        ZoneSelect.SelectedValue = dt.Rows[0]["RegionId"].ToString();
                        ZoneSelect_SelectedIndexChanged(null, null);

                        AreaSelect.SelectedValue = dt.Rows[0]["AreaId"].ToString();
                        //AreaSelect_SelectedIndexChanged(null, null);
                        //TeritorySelect.SelectedValue = dt.Rows[0]["TerritoryId"].ToString();

                        txtacDate.Text = dt.Rows[0]["ActiveDateStr"].ToString();


                    }
                }
                catch (Exception ex) { }
            }




            if (hfRoleType.Value == "DZSM")
            {

                try
                {

                    using (DataTable dt = _setupDAL.GetDZSMSetupEditDataByEmpId(value))
                    {

                        hfRSMId.Value = dt.Rows[0]["RSMId"].ToString();
                        GroupSelect.SelectedValue = dt.Rows[0]["GroupId"].ToString();
                        GroupSelect_SelectedIndexChanged(null, null);

                        ZoneSelect.SelectedValue = dt.Rows[0]["RegionId"].ToString();
                        //ZoneSelect_SelectedIndexChanged(null, null);

                        //AreaSelect.SelectedValue = dt.Rows[0]["AreaId"].ToString();
                        //AreaSelect_SelectedIndexChanged(null, null);
                        //TeritorySelect.SelectedValue = dt.Rows[0]["TerritoryId"].ToString();

                        txtacDate.Text = dt.Rows[0]["ActiveDateStr"].ToString();


                    }
                }
                catch (Exception ex) { }
            }


            if (hfRoleType.Value == "NSM")
            {

                try
                {

                    using (DataTable dt = _setupDAL.GetNSMSetupEditDataByEmpId(value))
                    {

                        hfNSMId.Value = dt.Rows[0]["NSMId"].ToString();
                        GroupSelect.SelectedValue = dt.Rows[0]["GroupId"].ToString();
                        //GroupSelect_SelectedIndexChanged(null, null);

                        //ZoneSelect.SelectedValue = dt.Rows[0]["RegionId"].ToString();
                        //ZoneSelect_SelectedIndexChanged(null, null);

                        //AreaSelect.SelectedValue = dt.Rows[0]["AreaId"].ToString();
                        //AreaSelect_SelectedIndexChanged(null, null);
                        //TeritorySelect.SelectedValue = dt.Rows[0]["TerritoryId"].ToString();

                        txtacDate.Text = dt.Rows[0]["ActiveDateStr"].ToString();


                    }
                }
                catch (Exception ex) { }
            }
        }
        }

    private void LoadInitialInfo()
    {


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
            using (DataTable dt = _seedRepo.GetlMonthlyAllawanceList())
            {
                ddlMonthlyAllawance.DataSource = dt;
                ddlMonthlyAllawance.DataValueField = "MonthlyAllowanceId";
                ddlMonthlyAllawance.DataTextField = "MonthlyAllowanceName";
                ddlMonthlyAllawance.DataBind();
                ddlMonthlyAllawance.Items.Insert(-1, "");
                ddlMonthlyAllawance.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
        try
        {
            using (DataTable dt = _dataLoad.GetDepartment_Active())
            {
                DepartmentSelect.DataSource = dt;
                DepartmentSelect.DataValueField = "DeptId";
                DepartmentSelect.DataTextField = "DeptName";
                DepartmentSelect.DataBind();
                DepartmentSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                DepartmentSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _dataLoad.GetDesignation_Active_Emp())
            {
                DesignationSelect.DataSource = dt;
                DesignationSelect.DataValueField = "DesignationId";
                DesignationSelect.DataTextField = "DesigName";
                DesignationSelect.DataBind();
                DesignationSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                DesignationSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


        try
        {
            using (DataTable dt = _dataLoad.GetShift_Active())
            {
                ShiftSelect.DataSource = dt;
                ShiftSelect.DataValueField = "ShiftId";
                ShiftSelect.DataTextField = "ShiftText";
                ShiftSelect.DataBind();
                ShiftSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ShiftSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }



       


        


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
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }
    public bool Validation()
    {

        txtEmpName.CssClass = "form-control form-control-sm  mb-3";
        txtDateofjoin.CssClass = "form-control form-control-sm mb-3 datepicker";
        txtEmpCode.CssClass = "form-control form-control-sm mb-3";
        ShiftSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";


        txtNIDNO.CssClass = "form-control form-control-sm";
        txtEmpContactNo.CssClass = "form-control form-control-sm";
        ReferenceContactNo.CssClass = "form-control form-control-sm";
        txtEmergencyContactNo.CssClass = "form-control form-control-sm";
        txtacDate.CssClass = "datepicker form-control form-control-sm";

        //user
        ddlUserRole.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (txtEmpName.Text == "")
        {
            txtEmpName.ToolTip = "please fill out this field";
            txtEmpName.CssClass = "form-control form-control-sm is-invalid";

            txtEmpName.Focus();
            return false;
        }

        if (txtEmpCode.Text == "")
        {
            txtEmpCode.ToolTip = "please fill out this field";
            txtEmpCode.CssClass = "form-control form-control-sm is-invalid";

            txtEmpCode.Focus();
            return false;
        }


        if (txtDateofjoin.Text == "")
        {
            txtDateofjoin.ToolTip = "please fill out this field";
            txtDateofjoin.CssClass = "form-control form-control-sm datepicker is-invalid";

            txtDateofjoin.Focus();
            return false;
        }


        if (ShiftSelect.SelectedIndex == 0)
        {
            ShiftSelect.ToolTip = "please fill out this field";
            ShiftSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";

            ShiftSelect.Focus();
            return false;
        }



        if (txtNIDNO.Text != "")
        {
            if (txtNIDNO.Text.Length != 17)
            {

                string text6 = "NID No must be 17 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtNIDNO.Focus();
                txtNIDNO.CssClass = "form-control form-control-sm  is-invalid";

                return false;
            }
        }

        if (txtEmpContactNo.Text != "")
        {
            if (txtEmpContactNo.Text.Length != 11)
            {

                string text6 = "Employee Contact No must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtEmpContactNo.Focus();
                txtEmpContactNo.CssClass = "form-control form-control-sm  is-invalid";

                return false;
            }
        }


        if (ReferenceContactNo.Text != "")
        {
            if (ReferenceContactNo.Text.Length != 11)
            {

                string text6 = "Reference Contact No  must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                ReferenceContactNo.Focus();
                ReferenceContactNo.CssClass = "form-control form-control-sm  is-invalid";

                return false;
            }
        }

        if (txtEmergencyContactNo.Text != "")
        {
            if (txtEmergencyContactNo.Text.Length != 11)
            {

                string text6 = "Emergency Contact No must be 11 digits!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtEmergencyContactNo.Focus();
                txtEmergencyContactNo.CssClass = "form-control form-control-sm  is-invalid";

                return false;
            }
        }


        if (txtEmpCode.Text != "")
        {

            DataTable dt = _UserDAL.check_UserInfoByEmpCode(  txtEmpCode.Text.Trim(), "UserEmpCode");

            if (dt.Rows.Count != 0)
            {
                string text6 = "Employee Code Already Exist in User!";
                ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                txtEmpCode.Focus();
                txtEmpCode.CssClass = "form-control form-control-sm  is-invalid";

                txtEmpCode.Focus();
                return false;
            }
           
        }

        //user
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


        //if (chkMobileAccess.Checked)
        //{
        //    if (txtImei1.Text == "")
        //    {
        //        txtImei1.ToolTip = "please fill out this field";
        //        txtImei1.CssClass = "form-control form-control-sm is-invalid";
        //        txtImei1.Focus();
        //        return false;
        //    }

        //    if (txtImei2.Text == "")
        //    {
        //        txtImei2.ToolTip = "please fill out this field";
        //        txtImei2.CssClass = "form-control form-control-sm is-invalid";
        //        txtImei2.Focus();
        //        return false;
        //    }
        //}

        if (txtacDate.Text == "")
        {
            txtacDate.ToolTip = "please fill out this field";
            txtacDate.CssClass = "datepicker form-control form-control-sm is-invalid";
            txtacDate.Focus();
            return false;
        }

        if (ddlUserRole.SelectedValue != "")
        {

            if (hfRoleType.Value == "MIO")
        
            {
                if (TeritorySelect.SelectedValue == "")
                {
                    TeritorySelect.ToolTip = "please fill out this field";
                    TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    TeritorySelect.Focus();
                    return false;
                }


                if (TeritorySelect.SelectedValue != "")
                {
                    DataTable dt = _UserDAL.check_UserInfoByEmpCode(TeritorySelect.SelectedValue.Trim(), "MIObyTeriID");

                    if (dt.Rows.Count != 0)
                    {
                        string text6 = "Employee  Already Exist in Territory!";
                        ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                        TeritorySelect.ToolTip = "please fill out this field";
                        TeritorySelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        TeritorySelect.Focus();
                        return false;
                    }
                }

            }



            if (hfRoleType.Value == "AM")
            {
                if (AreaSelect.SelectedValue == "")
                {
                    AreaSelect.ToolTip = "please fill out this field";
                    AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    AreaSelect.Focus();
                    return false;
                }


                if (AreaSelect.SelectedValue != "")
                {
                    DataTable dt = _UserDAL.check_UserInfoByEmpCode(AreaSelect.SelectedValue.Trim(), "AMbyAreaID");

                    if (dt.Rows.Count != 0)
                    {
                        string text6 = "Employee  Already Exist in Area!";
                        ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                        AreaSelect.ToolTip = "please fill out this field";
                        AreaSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        AreaSelect.Focus();
                        return false;
                    }
                }

            }




            if (hfRoleType.Value == "DZSM")
            {
                if (ZoneSelect.SelectedValue == "")
                {
                    ZoneSelect.ToolTip = "please fill out this field";
                    ZoneSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    ZoneSelect.Focus();
                    return false;
                }


                if (ZoneSelect.SelectedValue != "")
                {
                    DataTable dt = _UserDAL.check_UserInfoByEmpCode(ZoneSelect.SelectedValue.Trim(), "DZSMbyZoneID");

                    if (dt.Rows.Count != 0)
                    {
                        string text6 = "Employee  Already Exist in Zone!";
                        ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                        ZoneSelect.ToolTip = "please fill out this field";
                        ZoneSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        ZoneSelect.Focus();
                        return false;
                    }
                }

            }




            if (hfRoleType.Value == "NSM")
            {
                if (GroupSelect.SelectedValue == "")
                {
                    GroupSelect.ToolTip = "please fill out this field";
                    GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    GroupSelect.Focus();
                    return false;
                }


                if (GroupSelect.SelectedValue != "")
                {
                    DataTable dt = _UserDAL.check_UserInfoByEmpCode(GroupSelect.SelectedValue.Trim(), "NSMbyGroupID");

                    if (dt.Rows.Count != 0)
                    {
                        string text6 = "Employee  Already Exist in Group!";
                        ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                        GroupSelect.ToolTip = "please fill out this field";
                        GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                        GroupSelect.Focus();
                        return false;
                    }
                }

            }


            if (hfRoleType.Value == "DIC")
            {
                 
                if (ddlDistributionCenter.SelectedValue == "")
                {
                    ddlDistributionCenter.ToolTip = "please fill out this field";
                    ddlDistributionCenter.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                    ddlDistributionCenter.Focus();
                    return false;
                }


                //if (ddlDistributionCenter.SelectedValue != "")
                //{
                //    DataTable dt = _UserDAL.check_UserInfoByEmpCode(GroupSelect.SelectedValue.Trim(), "NSMbyGroupID");

                //    if (dt.Rows.Count != 0)
                //    {
                //        string text6 = "Employee  Already Exist in Group!";
                //        ScriptManager.RegisterStartupScript(this, typeof(Page), "Success", "<script>showpop6('" + text6 + "')</script>", false);
                //        GroupSelect.ToolTip = "please fill out this field";
                //        GroupSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                //        GroupSelect.Focus();
                //        return false;
                //    }
                //}

            }
        }

            return true;
    }
    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validation())
        {



            EmployeeInformation aMaster = new EmployeeInformation();

            aMaster.EmpInfoId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);
            aMaster.CompanyId = 1;
             
           

            aMaster.EmpMasterCode = string.IsNullOrEmpty(txtEmpCode.Text) ? null : txtEmpCode.Text;
            aMaster.EmpName = string.IsNullOrEmpty(txtEmpName.Text) ? null : txtEmpName.Text;
            aMaster.FatherName = string.IsNullOrEmpty(txtEmpFatherName.Text) ? null : txtEmpFatherName.Text;
            aMaster.MotherName = string.IsNullOrEmpty(txtEmpMotherName.Text) ? null : txtEmpMotherName.Text; 
            aMaster.DateOfBirth = string.IsNullOrEmpty(txtEmpdobDate.Text) ? (DateTime?)null : DateTime.Parse(txtEmpdobDate.Text).Date;
            aMaster.AddressPresent = string.IsNullOrEmpty(txtEmpAddress.Text) ? null : txtEmpAddress.Text;
            aMaster.AddressPermanent = string.IsNullOrEmpty(txtEmpPresentAddress.Text) ? null : txtEmpPresentAddress.Text;
            aMaster.Gender = GenderSelect.SelectedIndex > 0 ? GenderSelect.SelectedItem.Text : null;
            aMaster.Religion = ReligionSelect.SelectedIndex > 0 ? ReligionSelect.SelectedItem.Text : null;
            aMaster.Nationality = Nationality.SelectedIndex > 0 ? Nationality.SelectedItem.Text : null;
            aMaster.BloodGroup = BloodGroupSelect.SelectedIndex > 0 ? BloodGroupSelect.SelectedItem.Text : null;
            aMaster.MaritalStatus = MaritalStatusSelect.SelectedIndex > 0 ? MaritalStatusSelect.SelectedItem.Text : null;
            aMaster.NationalIdNo = string.IsNullOrEmpty(txtNIDNO.Text) ? null : txtNIDNO.Text;

            aMaster.JoiningDate = string.IsNullOrEmpty(txtDateofjoin.Text) ? (DateTime?)null : DateTime.Parse(txtDateofjoin.Text).Date;

            aMaster.JobLeftDate = string.IsNullOrEmpty(txtJobLeftDate.Text) ? (DateTime?)null : DateTime.Parse(txtJobLeftDate.Text).Date;
            aMaster.ProbitionEndDate = string.IsNullOrEmpty(txtProbationEndDate.Text) ? (DateTime?)null : DateTime.Parse(txtProbationEndDate.Text).Date;
            aMaster.LastCompanyName = string.IsNullOrEmpty(txtLastCompanyName.Text) ? null : txtLastCompanyName.Text;

            aMaster.LastJobLocation = string.IsNullOrEmpty(txtLastJobLocation.Text) ? null : txtLastJobLocation.Text;


            aMaster.DepartmentId = DepartmentSelect.SelectedIndex > 0 ? int.Parse(DepartmentSelect.SelectedValue) : (int?)null;
          

            aMaster.DesignationId = DesignationSelect.SelectedIndex > 0 ? int.Parse(DesignationSelect.SelectedValue) : (int?)null;
            aMaster.ShiftId = ShiftSelect.SelectedIndex > 0 ? int.Parse(ShiftSelect.SelectedValue) : (int?)null;
           
            aMaster.Email = string.IsNullOrEmpty(txtEmail.Text) ? null : txtEmail.Text;
            aMaster.CellNumber = string.IsNullOrEmpty(txtEmpContactNo.Text) ? null : txtEmpContactNo.Text;
            aMaster.RefName = string.IsNullOrEmpty(ReferencePersonName.Text) ? null : ReferencePersonName.Text;
            aMaster.RefContactNo = string.IsNullOrEmpty(ReferenceContactNo.Text) ? null : ReferenceContactNo.Text;
            aMaster.EmrgContactNo = string.IsNullOrEmpty(txtEmergencyContactNo.Text) ? null : txtEmergencyContactNo.Text;
            aMaster.EmrgContactNoRelaton = string.IsNullOrEmpty(txtEmrgContactNoRelaton.Text) ? null : txtEmrgContactNoRelaton.Text;

            aMaster.IsProbition = chkIsProbation.Checked;
            aMaster.IsTempEmployeeCode = chkIsTempEmployeeCode.Checked;

            if (chkIsActive.Checked)
            {
                aMaster.EmployeeStatus = "Active";
            }
            else
            {
                aMaster.EmployeeStatus = "Inactive";
             

            }

            string MonthlyArray = "";

            foreach (ListItem item in ddlMonthlyAllawance.Items)
            {
                if (item.Selected)
                {

                    MonthlyArray = MonthlyArray + item.Value + ",";
                }
            }

            MonthlyArray = MonthlyArray.TrimEnd(',');

            int MyPK = 0;

            MyPK = _DAL.SaveEmployeeInformation(aMaster, MonthlyArray, Session["UserId"].ToString(),   0);
            if  (MyPK > 0)
            {

                if (MyPK > 0)
                {
                    List<BonusCampaignMarketDetailDAO> MarketList = new List<BonusCampaignMarketDetailDAO>();


                     

                    UserDAO aMasterUser = new UserDAO();

                    aMasterUser.UserId = hfUserId.Value == "" ? 0 : Convert.ToInt32(hfUserId.Value);
                    aMasterUser.UserType = "Employee";
                    aMasterUser.UserTypeId = 3;
                    aMasterUser.EmpInfoId = MyPK;

                    aMasterUser.UserName =txtEmpName.Text;
                    aMasterUser.Password = string.IsNullOrEmpty(txtPassword.Text) ? null : txtPassword.Text;
                    aMasterUser.LoginName = string.IsNullOrEmpty(txtLoginName.Text) ? null : txtLoginName.Text;

                    aMasterUser.IsAppsUser = chkMobileAccess.Checked;

                    aMasterUser.IMEI_One = string.IsNullOrEmpty(txtImei1.Text) ? null : txtImei1.Text;
                    aMasterUser.IMEI_Two = string.IsNullOrEmpty(txtImei2.Text) ? null : txtImei2.Text;


                    aMasterUser.UserRoleID = ddlUserRole.SelectedIndex > 0 ? int.Parse(ddlUserRole.SelectedValue) : (int?)null;


                    aMasterUser.ActiveInActiveDate = string.IsNullOrEmpty(txtacDate.Text) ? (DateTime?)null : DateTime.Parse(txtacDate.Text);

                    aMasterUser.IsMainDashboard = false;
                    aMasterUser.IsDepotDashboard = false;
                    if (rbDashboard.Items[0].Selected)
                    {
                        aMasterUser.IsMainDashboard = true;
                    }
                    else
                    {
                        aMasterUser.IsDepotDashboard = true;


                    }

                    if (chkIsActive.Checked)
                    {
                        aMasterUser.UserStatus = "Active";
                    }
                    else
                    {
                        aMasterUser.UserStatus = "Inactive";

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
                    ResultInfo Res2 = _UserDAL.SaveUserInfo(aMasterUser, MarketList, DisArray, Session["UserId"].ToString());


                  

                    if (hfRoleType.Value == "MIO")
                    {

                        MIOInfo aMIOInfo = new MIOInfo();


                        aMIOInfo.MIOId =    hfMIOId.Value == "" ? 0 : Convert.ToInt32(hfMIOId.Value);
                        /*jsonData["CompanyId"] = $('#ddlGroup').val();*/
                        aMIOInfo.EmployeeId = MyPK;
                        aMIOInfo.TerritoryId = Convert.ToInt32(TeritorySelect.SelectedValue);
                        aMIOInfo.IsActive = chkIsActive.Checked;
                        aMIOInfo.ActiveDate = Convert.ToDateTime(txtacDate.Text);
                        _setupDAL.Save_MIOInfo(aMIOInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString()));

                    }


                   
                    if (hfRoleType.Value == "AM")
                    {

                        ASMInfo aASMInfo = new ASMInfo();
                        

                        aASMInfo.ASMId = hfAMID.Value == "" ? 0 : Convert.ToInt32(hfAMID.Value);
                        /*jsonData["CompanyId"] = $('#ddlGroup').val();*/
                        aASMInfo.EmployeeId = MyPK;
                        aASMInfo.AreaId = Convert.ToInt32(AreaSelect.SelectedValue);
                        
                        aASMInfo.IsActive = chkIsActive.Checked;
                        aASMInfo.ActiveDate = Convert.ToDateTime(txtacDate.Text);
                        _setupDAL.Save_ASMInfo(aASMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString()));

                    }
                    if (hfRoleType.Value == "DZSM")
                    {

                        RSMInfo aRSMInfo = new RSMInfo();


                        aRSMInfo.RSMId =  hfRSMId.Value == "" ? 0 : Convert.ToInt32(hfRSMId.Value);
                        /*jsonData["CompanyId"] = $('#ddlGroup').val();*/
                        aRSMInfo.CompanyId = 1;
                        aRSMInfo.EmployeeId = MyPK;
                        aRSMInfo.RegionId = Convert.ToInt32(ZoneSelect.SelectedValue);

                        aRSMInfo.IsActive = chkIsActive.Checked;
                        aRSMInfo.ActiveDate = Convert.ToDateTime(txtacDate.Text);
                    _setupDAL.Save_RSMInfo(aRSMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString()));


                    }
                    if (hfRoleType.Value == "NSM")
                    {

                        NSMInfo aNSMInfo = new NSMInfo();
                       

                        aNSMInfo.NSMId = hfNSMId.Value == "" ? 0 : Convert.ToInt32(hfNSMId.Value);
                        /*jsonData["CompanyId"] = $('#ddlGroup').val();*/
                        aNSMInfo.CompanyId = 1;
                        aNSMInfo.EmployeeId = MyPK;
                        aNSMInfo.GroupId = Convert.ToInt32(GroupSelect.SelectedValue);

                        aNSMInfo.IsActive = chkIsActive.Checked;
                        aNSMInfo.ActiveDate = Convert.ToDateTime(txtacDate.Text);
                      _setupDAL.Save_NSMInfo(aNSMInfo, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString()));



                    }

                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','EmployeeRecords.aspx');", true);
                }
               

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

    protected void ddlUserRole_SelectedIndexChanged(object sender, EventArgs e)
    {
        divGroup.Visible = false;
        divZone.Visible = false;
        divArea.Visible = false;
        divTerritory.Visible = false;
        divmRAccess.Visible = false;

        hfRoleType.Value = "";
        try
        {
            using (DataTable dt = _seedRepo.GetUserRoleTypeListById(ddlUserRole.SelectedValue))
            {
                hfRoleType.Value = dt.Rows[0]["RoleType"].ToString();
            }
            if (hfRoleType.Value== "MIO")
            {
                divGroup.Visible = true;
                divZone.Visible = true;
                divArea.Visible = true;
                divTerritory.Visible = true;
                divmRAccess.Visible = true;

            }


            if (hfRoleType.Value == "AM")
            {
                divGroup.Visible = true;
                divZone.Visible = true;
                divArea.Visible = true;
                divmRAccess.Visible = true;

            }

            if (hfRoleType.Value == "DZSM")
            {
                divGroup.Visible = true;
                divZone.Visible = true;

                divmRAccess.Visible = true;

            }

            if (hfRoleType.Value == "NSM")
            {
                divGroup.Visible = true;

                divmRAccess.Visible = true;

            }


         
            dcDiv.Visible = false;
            
            try
            {

                ddlDistributionCenter.SelectedIndex = -1;

            }
            catch (Exception ex) { }

            if (hfRoleType.Value == "DIC")
            {
               
              
                dcDiv.Visible = true;
            }

        }
        catch (Exception ex) { }
    }


    protected void chkMobileAccess_CheckedChanged(object sender, EventArgs e)
    {
        divMei.Visible = false;
        if (chkMobileAccess.Checked)
        {
            divMei.Visible = true;

        }
    }

    protected void txtEmpCode_TextChanged(object sender, EventArgs e)
    {
        txtLoginName.Text = txtEmpCode.Text.Trim();
        txtPassword.Text = txtEmpCode.Text.Trim();
    }
}