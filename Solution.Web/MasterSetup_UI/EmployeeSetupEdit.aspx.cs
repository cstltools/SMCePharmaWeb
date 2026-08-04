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

public partial class MasterSetup_UI_EmployeeSetupEdit : System.Web.UI.Page
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


 
        }

    private void LoadInitialInfo()
    {


        
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

            DataTable dt = _UserDAL.check_UserInfoByEmpCodeUpdate(id_mastetID.Value, txtEmpCode.Text);

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

 
 
}