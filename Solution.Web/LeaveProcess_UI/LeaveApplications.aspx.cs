using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LeaveProcess_UI_LeaveApplications : System.Web.UI.Page
{

    private static LeaveApplicationDal _leaveDal = new LeaveApplicationDal();
    static CommonDataLoad _dataLoad = new CommonDataLoad();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static SeedDataDAL _seedRepo = new SeedDataDAL();

    protected void Page_Load(object sender, EventArgs e)
    {
        if(!IsPostBack)
        {
            LoadInitialInfo();
            FromDate.Text = DateTime.Now.AddDays(-7).ToString("dd MMMM, yyyy");
            ToDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");

            GetLeaveApplications();
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

    public void GetLeaveApplications()
    {
        DataTable dt = _leaveDal.GetAllLeaveRecords(param());
        loadGridView.DataSource = dt;
        loadGridView.DataBind();

       }

    protected void btnSearch_Click(object sender, EventArgs e)
    {
        GetLeaveApplications();
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("LeaveApplications.aspx");
    }

    private string param()
    {


        var param = "  ";

        if (FromDate.Text != "" && ToDate.Text != "")
        {
            param = param + " AND CONVERT(date,A.EntryDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        }
        if (FromDate.Text != "" && ToDate.Text == "")
        {
            param = param + " AND CONVERT(date,A.EntryDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        }


        if (ApprovalStatusSelect.SelectedValue != "")
        {

            param = param + " AND A.ApprovalStatus='" + ApprovalStatusSelect.SelectedValue + "'";


        }

        if (UserRoleSelect.SelectedValue != "")
        {

            param = param + " AND  us.UserRoleID='" + UserRoleSelect.SelectedValue + "'";

        }

        if (EmployeeIdSelect.SelectedValue != "")
        {

            param = param + " AND A.EmployeeId ='" + EmployeeIdSelect.SelectedValue + "'";

        }

        if (ddlLeaveType.SelectedValue != "")
        {

            param = param + " AND  B.LeaveTypeId ='" + ddlLeaveType.SelectedValue + "'";

        }


        return param;
    }
    private void LoadInitialInfo()
    {


        try
        {
            using (DataTable dt = _dataLoad.GetEmployeeList_Active())
            {
                EmployeeIdSelect.DataSource = dt;
                EmployeeIdSelect.DataValueField = "EmpInfoId";
                EmployeeIdSelect.DataTextField = "EmpName";
                EmployeeIdSelect.DataBind();
                EmployeeIdSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                EmployeeIdSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

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


        try
        {
            using (DataTable dt = _seedRepo.GetApprovalStatusList())
            {
                ApprovalStatusSelect.DataSource = dt;
                ApprovalStatusSelect.DataValueField = "SoftwareUseId";
                ApprovalStatusSelect.DataTextField = "WebShow";
                ApprovalStatusSelect.DataBind();
                ApprovalStatusSelect.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ApprovalStatusSelect.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }

        try
        {
            using (DataTable dt = _seedRepo.GetLeaveTypeList())
            {
                ddlLeaveType.DataSource = dt;
                ddlLeaveType.DataValueField = "LeaveBalanceId";
                ddlLeaveType.DataTextField = "LeaveTypeName";
                ddlLeaveType.DataBind();
                ddlLeaveType.Items.Insert(0, new ListItem("Please Select From List", String.Empty));
                ddlLeaveType.SelectedIndex = 0;
            }


        }
        catch (Exception ex) { }


    }
}