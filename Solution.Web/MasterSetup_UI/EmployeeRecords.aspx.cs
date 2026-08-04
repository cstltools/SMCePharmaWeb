using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_EmployeeRecords : System.Web.UI.Page
{

    private static EmployeeInformationDaL _EmployeeInformationDaL = new EmployeeInformationDaL();

    protected void Page_Load(object sender, EventArgs e)
    {
       
       UserPersmissionValidation();
    }
    private CommonDataLoad _CmnLoad = new CommonDataLoad();

    [WebMethod]
    public static string GetEmployeeInformationList(string param)
    {
        DataTable dt = _EmployeeInformationDaL.GetEmployeeInformationList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }


    public void UserPersmissionValidation()
    {
        if (Session["UserRoleID"].ToString() != "2")
        {
            try
            {
                string filepath = Path.GetDirectoryName(Request.Path);
                filepath = filepath.TrimStart('\\');
                string text = Path.GetExtension(Request.Path);
                filepath = "../" + filepath + "/" + Path.GetFileName(Request.Path);
                DataTable dtuserpermission = _CmnLoad.GetPermissionForUserRole(filepath);
                if (dtuserpermission.Rows.Count > 0)
                {
                    if (Session["UserRoleID"].ToString() != "2")
                    {
                      // btnAdd.Visible = Convert.ToBoolean(dtuserpermission.Rows[0]["RAdd"].ToString());
                       // chkShow.Checked = Convert.ToBoolean(dtuserpermission.Rows[0]["RAdd"].ToString());
                    }
                }
                else
                {
                    Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
                }
            }
            catch (Exception ex)
            {
                Response.Redirect("../Dashboard_UI/DashboardOne.aspx");
            }
        }
    }
}