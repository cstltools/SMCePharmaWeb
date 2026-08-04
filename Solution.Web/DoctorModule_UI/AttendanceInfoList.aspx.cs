using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;

public partial class DoctorModule_UI_AttendanceInfoList : System.Web.UI.Page
{
    static CommonDataLoad _dataLoad = new CommonDataLoad();

    private static AttendanceDAL _AttendanceDAL = new AttendanceDAL();
    static SeedDataDAL _seedRepo = new SeedDataDAL();
    static Setup2DAL _setupDAL = new Setup2DAL();
    static SetupDAL _setupDAL2 = new SetupDAL();

    string RoleTypeName = "";
    string EmpInfoId = "";
    string ToRoleTypeId = "";
    string ApprovalStatus = "";
    protected void Page_Load(object sender, EventArgs e)
    {

        try
        {
            RoleTypeName = Session["RoleTypeName"].ToString();
            EmpInfoId = Session["EmpInfoId"].ToString();
            ToRoleTypeId = Session["RoleTypeId"].ToString();
            if (!IsPostBack)
            {
                FromDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
                ToDate.Text = DateTime.Now.ToString("dd MMMM, yyyy");
                LoadInitialInfo();

                LoadData();
            }

        }
        catch (Exception ex)
        {
        }
        }
    [WebMethod]
    public static string Emp_AttendanceInfoList(string param)
    {
        DataTable dt = _AttendanceDAL.Get_Emp_AttendanceInfoList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }

    protected void loadGridView_PageIndexChanging(object sender, GridViewPageEventArgs e)
    {
        loadGridView.PageIndex = e.NewPageIndex;
        this.LoadData();
    }


    protected void btnExportToExcel_Click(object sender, EventArgs e)
    {

        if (gv_Export.Rows.Count > 0)
        {
            Response.Clear();
            Response.Buffer = true;
            Response.AddHeader("content-disposition", "attachment;filename=Attendance_List_" + DateTime.Now.ToString("dd_MMM_yyyy_hh_mm_tt") + ".csv");
            Response.Charset = "";
            Response.ContentType = "text/csv";
            Response.ContentEncoding = Encoding.Default;
            //To Export all pages.
            gv_Export.AllowPaging = false;
            this.LoadData();

            StringBuilder sb = new StringBuilder();
            foreach (TableCell cell in gv_Export.HeaderRow.Cells)
            {
                //Append data with separator.
                sb.Append(HttpUtility.HtmlDecode(cell.Text) + ',');
            }
            //Append new line character.
            sb.Append("\r\n");

            foreach (GridViewRow row in gv_Export.Rows)
            {
                foreach (TableCell cell in row.Cells)
                {
                    //Append data with separator.
                    if (cell.Text.Contains(","))
                    {
                        sb.Append(String.Format("\"{0}\",", cell.Text));
                    }
                    else
                    { sb.Append(HttpUtility.HtmlDecode(cell.Text) + ','); }
                }
                //Append new line character.
                sb.Append("\r\n");
            }

            Response.Output.Write(sb.ToString());
            Response.Flush();
            Response.End();
        }
        else
        {
            ScriptManager.RegisterStartupScript(this, GetType(), "Popup", "faildalert('" + "No Data Found!" + "','Faild');", true);

        }
    }
    protected void showMessageBox(string message)
    {
        string sScript;
        message = message.Replace("'", "\'");
        sScript = String.Format("alert('{0}');", message);
        ScriptManager.RegisterStartupScript(this, this.GetType(), "alert", sScript, true);
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

    protected void loadGridView_RowCommand(object sender, GridViewCommandEventArgs e)
    {
        if (e.CommandName == "EditData")
        {
            int rowindex = Convert.ToInt32(e.CommandArgument);
            string unitPriceId = loadGridView.DataKeys[rowindex][0].ToString();

            Response.Redirect("../DoctorModule_UI/ExpenseClaim.aspx?id=" + unitPriceId);
        }

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


    }
    private void LoadData()
    {



        DataTable aDataTable = _AttendanceDAL.Get_Emp_AttendanceInfoList(param());
        loadGridView.DataSource = aDataTable;
        loadGridView.DataBind();

        gv_Export.DataSource = aDataTable;
        gv_Export.DataBind();

        //for (int i = 0; i < loadGridView.Rows.Count; i++)
        //{

        //    Image imgShow = ((Image)loadGridView.Rows[i].Cells[1].FindControl("imgShow"));
        //    HyperLink hpImg = ((HyperLink)loadGridView.Rows[i].Cells[1].FindControl("hpImg"));

        //    try
        //    {
        //        string imagefullpath = aDataTable.Rows[i]["ImagePreName"].ToString();


        //        try
        //        {
        //            byte[] imageArray = System.IO.File.ReadAllBytes(@imagefullpath);
        //            var src = "data:image/jpeg;base64,";

        //            imgShow.ImageUrl = src + Convert.ToBase64String(imageArray);

        //            hpImg.NavigateUrl = src + Convert.ToBase64String(imageArray);
        //        }
        //        catch (Exception ex)
        //        {

        //        }
        //    }
        //    catch (Exception ex)
        //    {

        //    }
        //}
    }
    protected void btnSearch_Click(object sender, EventArgs e)
    {
        LoadData();
    }

    private string param()
    {


        var param = "  ";

        if (FromDate.Text != "" && ToDate.Text != "")
        {
            param = param + " AND CONVERT(date,att1.AttendanceDate)  BETWEEN '" + FromDate.Text + "' AND '" + ToDate.Text + "' ";
        }
        if (FromDate.Text != "" && ToDate.Text == "")
        {
            param = param + " AND CONVERT(date,att1.AttendanceDate)  BETWEEN '" + FromDate.Text + "' AND '" + DateTime.Now.ToString("dd-MMM-yyyy") + "' ";
        }


        if (ApprovalStatusSelect.SelectedValue != "")
        {

            param = param + " AND att1.ApprovalStatus='" + ApprovalStatusSelect.SelectedValue + "'";


        }

        if (UserRoleSelect.SelectedValue != "")
        {

            param = param + " AND  att1.UserRoleID='" + UserRoleSelect.SelectedValue + "'";

        }

        if (EmployeeIdSelect.SelectedValue != "")
        {

            param = param + " AND att1.EmpInfoId ='" + EmployeeIdSelect.SelectedValue + "'";

        }


        string Role = "";
        DataTable dtMarket = _dataLoad.GetEmpMarketStructure_Active(EmpInfoId);
         
        string FFID = "";
        switch (RoleTypeName)
        {



            case "MIO":
                FFID = dtMarket.Rows[0]["MIOEmpId"].ToString();
                param = param + " AND View_Webapi_EmployeeFieldForceInfo.MIOEmpId=" + FFID;
                Role = "AM";

                break;

            case "AM":
                FFID = dtMarket.Rows[0]["ASMEMPId"].ToString();
                param = param + " AND View_Webapi_EmployeeFieldForceInfo.ASMEMPId=" + FFID;
                Role = "AM";

                break;
            case "DZSM":
                FFID = dtMarket.Rows[0]["RSMEMPId"].ToString();
                param = param + " AND  View_Webapi_EmployeeFieldForceInfo.RSMEMPId=" + FFID;
                Role = "DZSM";
                break;
            case "NSM":
                FFID = dtMarket.Rows[0]["NSMEMPId"].ToString();
                param = param + " AND  View_Webapi_EmployeeFieldForceInfo.NSMEMPId=" + FFID;
                Role = "NSM";
                break;

           
            default:
                
                Role = "";
                break;
        }

        return param;
    }

    protected void resetBtn_Click(object sender, EventArgs e)
    {
        Response.Redirect("AttendanceInfoList.aspx");
    }


     
}