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

public partial class DoctorModule_UI_MonthlyAllowance : System.Web.UI.Page
{
    private static EmployeeInformationDaL _EmployeeInformationDaL = new EmployeeInformationDaL();
    public static SetupDAL _setupDAL = new SetupDAL();
    private static Setup2DAL _setupDALs = new Setup2DAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        try
        { 
            if (!IsPostBack)
            {
             
                LoadInitialInfo();

                LoadData();

                if (!string.IsNullOrEmpty(Request.QueryString["id"]))
                {
                    btnUpdate.Visible = true;

                    id_mastetID.Value = Request.QueryString["id"];
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
            using (DataTable dt = _setupDALs.GetMonthlyAllowanceForEdit(Id))
            {

                id_mastetID.Value = dt.Rows[0]["MonthlyAllowanceId"].ToString();
                MonthlyAllowanceName.Text = dt.Rows[0]["MonthlyAllowanceName"].ToString();
                Allowance.Text = dt.Rows[0]["MonthlyAllowance"].ToString();

                try
                {
                    customSwitch1.Checked = Convert.ToBoolean(dt.Rows[0]["IsActive"].ToString());
                }
                catch
                {

                }


                for (int i = 0; i < loadGridView.Rows.Count; i++)
                {
                    HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");
                    var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");


                    for (int k = 0; k < dt.Rows.Count; k++)
                    {
                        if (hfEmpInfoId.Value == dt.Rows[k]["EmpInfoId"].ToString())
                        {
                            chkBoxRows.Checked = true;
                            


                        }
                        else
                        {
                            //  chkBoxRows.Checked = false;

                        }
                    }
                }
            }
 
              
                //gv_ProductList.DataSource = dtDetail;
                //gv_ProductList.DataBind();
            
        }
        catch (Exception ex) { }
    }
    private string param()
    {
        var param = "  ";
        if (UserRoleSelect.SelectedValue != "")
        {

            param = param + " AND us.UserRoleID='" + UserRoleSelect.SelectedValue + "'";

        }

        return param;
    }

    private void LoadData()
    {
        DataTable aDataTable = _EmployeeInformationDaL.GetEmployeeInformationListForActive(param());

        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        try
        {
            using (DataTable dt = _setupDALs.GetMonthlyAllowanceForEdit(id_mastetID.Value))
            {

                for (int i = 0; i < loadGridView.Rows.Count; i++)
                {
                    HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");
                    var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");


                    for (int k = 0; k < dt.Rows.Count; k++)
                    {
                        if (hfEmpInfoId.Value == dt.Rows[k]["EmpInfoId"].ToString())
                        {
                            chkBoxRows.Checked = true;



                        }
                        else
                        {
                            //  chkBoxRows.Checked = false;

                        }
                    }
                }

            }
        }
        catch
        {

        }

            }
            protected void chkSelectAll_CheckedChanged(object sender, EventArgs e)
    {
        var chkBoxHeader = (CheckBox)loadGridView.HeaderRow.FindControl("chkSelectAll");

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            var chkBoxRows = (CheckBox)loadGridView.Rows[i].Cells[0].FindControl("chkSelect");
            chkBoxRows.Checked = chkBoxHeader.Checked;
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
            using (DataTable dt = _setupDAL.Get_UserRoleInfo())
            {
                UserRoleSelect.DataSource = dt;
                UserRoleSelect.DataValueField = "UserRoleID";
                UserRoleSelect.DataTextField = "RoleName";
                UserRoleSelect.DataBind();
                UserRoleSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                UserRoleSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }
    }

    protected void UserRoleSelect_SelectedIndexChanged(object sender, EventArgs e)
    {
        LoadData();
    }


    public bool Validation()
    {

        MonthlyAllowanceName.CssClass = "form-control form-control-sm";
        Allowance.CssClass = "form-control form-control-sm";
        UserRoleSelect.CssClass = "form-select form-select-sm mb-3 mySelect2";

        if (MonthlyAllowanceName.Text == "")
        {
            MonthlyAllowanceName.ToolTip = "please fill out this field";
            MonthlyAllowanceName.CssClass = "form-control form-control-sm is-invalid";
            MonthlyAllowanceName.Focus();
            return false;
        }


        if (Allowance.Text == "")
        {
            Allowance.ToolTip = "please fill out this field";
            Allowance.CssClass = "form-control form-control-sm is-invalid";
            Allowance.Focus();
            return false;
        }


        if (UserRoleSelect.SelectedValue == "")
        {
            UserRoleSelect.ToolTip = "please fill out this field";
            UserRoleSelect.CssClass = "form-select form-select-sm mb-3 mySelect2 is-invalid";
            UserRoleSelect.Focus();
            return false;
        }


        Int32 count = 0;

        for (int i = 0; i < loadGridView.Rows.Count; i++)
        {
            CheckBox chkSelect = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");

            if (chkSelect.Checked)
            {
                count++;
            }

            if (count > 0)
            {
                break;
            }
        }

        if (count == 0)
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Please Select at least one row !" + "','Faild');", true);
             
            return false;
        }

        return true;
    }


    protected void btnSave_Click(object sender, EventArgs e)
    {

        if (Validation())
        {
            List<MonthlyAllowanceDtlDAO> DtlList = new List<MonthlyAllowanceDtlDAO>();


            for (int i = 0; i < loadGridView.Rows.Count; i++)
            {
                HiddenField hfEmpInfoId = (HiddenField)loadGridView.Rows[i].FindControl("hfEmpInfoId");
                HiddenField hfUserRoleId = (HiddenField)loadGridView.Rows[i].FindControl("hfUserRoleId");


                CheckBox chkSelect = (CheckBox)loadGridView.Rows[i].FindControl("chkSelect");

                if (chkSelect.Checked == true)
                {

                    MonthlyAllowanceDtlDAO _DAO = new MonthlyAllowanceDtlDAO();

                    _DAO.EmpInfoId =  hfEmpInfoId.Value == "" ? 0 : Convert.ToInt32(hfEmpInfoId.Value);

                    _DAO.UserRoleId = hfUserRoleId.Value == "" ? 0 : Convert.ToInt32(hfUserRoleId.Value);


                    DtlList.Add(_DAO);
                }
            }


            MonthlyAllowance aMaster = new MonthlyAllowance();

            aMaster.MonthlyAllowanceId = id_mastetID.Value == "" ? 0 : Convert.ToInt32(id_mastetID.Value);

            aMaster.MonthlyAllowanceName = string.IsNullOrEmpty(MonthlyAllowanceName.Text) ? null : MonthlyAllowanceName.Text;
            aMaster.Allowance =  Convert.ToDecimal(Allowance.Text) ;
            aMaster.UserRoleId = UserRoleSelect.SelectedIndex > 0 ? int.Parse(UserRoleSelect.SelectedValue) : (int?)null;

            aMaster.IsActive = customSwitch1.Checked;
            
            bool result = false;

            ResultInfo Res = _setupDALs.SaveMonthlyAllowance(aMaster, DtlList, Session["UserId"].ToString());


            if (Res.isSuccess == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "successalert('" + "Operation successful!" + "','Success','MonthlyAllowanceView.aspx');", true);
            }
            else if (Res.isValiCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Data cannot be deactivated!" + "','Faild');", true);

            
            }
            else if (Res.isDuplicateCheck == true)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Already Exist!" + "','Faild');", true);

                
            }

            else
            {
       
                ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "Operation Faild!" + "','Faild');", true);

            }


        }

    }


    protected void restbtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("MonthlyAllowance.aspx");
    }
}