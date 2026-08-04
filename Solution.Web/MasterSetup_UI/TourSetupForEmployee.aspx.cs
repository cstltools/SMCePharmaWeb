using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.MasterSetup_DAL;
using Library.DAO.MasterSetup_DAO;
using SalesSolution.Web.DataLayer;

public partial class MasterSetup_UI_TourSetupForEmployee : System.Web.UI.Page
{
    TourSetupForEmployeeDAL aDal = new TourSetupForEmployeeDAL();
    private static SeedDataDAL _seedRepo = new SeedDataDAL();
    private CommonDataLoad _dataLoad = new CommonDataLoad();

    protected void Page_Load(object sender, EventArgs e)
    {

        if (!IsPostBack)
        {
            LoadInitialInfo();
            rbType_SelectedIndexChanged(null, null);


                btnSave.Visible = true;
             
        }

    }


    private void LoadInitialInfo()
    {

        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_Active())
            {
                ddlEmployee.DataSource = dt;
                ddlEmployee.DataValueField = "EmpInfoId";
                ddlEmployee.DataTextField = "EmpName";
                ddlEmployee.DataBind();
                ddlEmployee.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlEmployee.SelectedIndex = 0;
            }
        }
        catch (Exception ex)
        {

        }


        try
        {
            using (DataTable dt = _seedRepo.GetStationTypeList())
            {
                ddlTourType.DataSource = dt;
                ddlTourType.DataValueField = "StationTypeId";
                ddlTourType.DataTextField = "StationTypeName";
                ddlTourType.DataBind();
                ddlTourType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlTourType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _dataLoad.GetRoleTypeInfoDAL())
            {
                ddlRoleType.DataSource = dt;
                ddlRoleType.DataValueField = "RoleTypeId";
                ddlRoleType.DataTextField = "RoleType";
                ddlRoleType.DataBind();
                ddlRoleType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlRoleType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }
        private void GetOneRecord(int daId)
    {
        
    }


    private void ShowMessageBox(string message)
    {
        message = message.Replace("'", "\'");
        string sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
    }

    private bool Validation()
    {
        
        txtCount.CssClass = "form-control form-control-sm";
        ddlTourType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlRoleType.CssClass = "form-select form-select-sm mb-3 mySelect2";
        ddlEmployee.CssClass = "form-select form-select-sm mb-3 mySelect2";



        if (rbType.Items[0].Selected)
        {
            if (ddlRoleType.SelectedValue == "")
            {
                ddlRoleType.ToolTip = "please fill out this field";
                ddlRoleType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                ddlRoleType.Focus();
                return false;
            }

        }
        else
        {
            if (ddlEmployee.SelectedValue == "")
            {
                ddlEmployee.ToolTip = "please fill out this field";
                ddlEmployee.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
                ddlEmployee.Focus();
                return false;
            }


        }
        //txtPhone.CssClass = "form-control form-control-sm";
        //txtEmergencyContactNo.CssClass = "form-control form-control-sm";
        //txtReferenceName.CssClass = "form-control form-control-sm";
        //txtReferencePhone.CssClass = "form-control form-control-sm";


        if (ddlTourType.SelectedValue == "")
        {
            ddlTourType.ToolTip = "please fill out this field";
            ddlTourType.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            ddlTourType.Focus();
            return false;
        }

        if (txtCount.Text == "")
        {


            txtCount.ToolTip = "please fill out this field";
            txtCount.CssClass = "form-control form-control-sm is-invalid";
            txtCount.Focus();


            return false;
        }





        return true;
    }

    protected void btnSave_Click(object sender, EventArgs e)
    {
        if (Validation())
        {

            
                var aDao = new TourTypeSetupDAO();
            aDao.IsRoleWise = rbType.Items[0].Selected;
            aDao.IsEmployeeWise = rbType.Items[1].Selected;

            aDao.TourSetupEmployeeId = 0;
            aDao.StationTypeId = ddlTourType.SelectedIndex > 0 ? int.Parse(ddlTourType.SelectedValue) : (int?)null;
            aDao.EmpInfoId = ddlEmployee.SelectedIndex > 0 ? int.Parse(ddlEmployee.SelectedValue) : (int?)null;
            aDao.RoleTypeId = ddlRoleType.SelectedIndex > 0 ? int.Parse(ddlRoleType.SelectedValue) : (int?)null;
            aDao.CountNo = string.IsNullOrEmpty(txtCount.Text) ? (int?)null : int.Parse(txtCount.Text);

            aDao.EntryBy = Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString());
                aDao.EntryDate = DateTime.Now;

                if (aDal.SaveDAInfo(aDao) > 0)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','TourSetupForEmployeeList.aspx');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                }
          
            
        }
    }

  
     

    protected void btnReset_Click(object sender, EventArgs e)
    {
        Response.Redirect("TourSetupForEmployee.aspx");
    }

    protected void rbType_SelectedIndexChanged(object sender, EventArgs e)
    {

        ddlEmployee.SelectedValue = "";
        ddlRoleType.SelectedValue = "";
        divEmp.Visible = false;
        divRoleType.Visible = false;
        if (rbType.Items[0].Selected)
        {
            divRoleType.Visible = true;

        }
        else
        {
            divEmp.Visible = true;
             

        }
    }
}