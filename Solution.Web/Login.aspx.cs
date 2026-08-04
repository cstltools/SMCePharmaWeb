using Library.BLL.Panal_BLL;
using Org.BouncyCastle.Asn1.X509;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Login : System.Web.UI.Page
{
    DataTable aTableLogin = new DataTable();
    PanalBLL aPanalBll = new PanalBLL();
    protected void Page_Load(object sender, EventArgs e)
    {
    }
    protected void loginButton_Click(object sender, EventArgs e)
    {
        msgLabel.Text = "";
        msgLabel.CssClass = "";
        string loginName = string.Empty;
        string passwordText = string.Empty;
        if (!string.IsNullOrEmpty(userNameTextBox.Text.Trim()))
        {
            loginName = userNameTextBox.Text.Trim();
            if (!string.IsNullOrEmpty(passwordTextBox.Text.Trim()))
            {
                passwordText = passwordTextBox.Text.Trim();
                aTableLogin = aPanalBll.Login(loginName, passwordText);
                if (aTableLogin.Rows.Count > 0)
                {

                    Session["UserId"] = aTableLogin.Rows[0]["UserId"].ToString().Trim();
                    Session["UserRoleID"] = aTableLogin.Rows[0]["UserRoleID"].ToString().Trim();
                    Session["RoleTypeId"] = aTableLogin.Rows[0]["RoleTypeId"].ToString().Trim();
                    Session["RoleTypeName"] = aTableLogin.Rows[0]["RoleTypeName"].ToString().Trim();
                    
                    Session["LoginName"] = aTableLogin.Rows[0]["LoginName"].ToString().Trim();
                    Session["UserType"] = aTableLogin.Rows[0]["UserType"].ToString().Trim();
                    Session["CentralWareHouse"] = aTableLogin.Rows[0]["CentralWareHouse"].ToString().Trim();
                    if (aTableLogin.Rows[0]["UserType"].ToString().Trim()!="Admin")
                    {
                        Session["ComUnitId"] = aTableLogin.Rows[0]["CompanyUnitId"].ToString().Trim();
                    }
                    aPanalBll.LoginLog(Session["UserId"].ToString(), Session["LoginName"].ToString(), DateTime.Now);
                    Session["UserTime"] = DateTime.Now.ToString("f");
                    UserSessionTrackingManager.StartTracking(HttpContext.Current);

                    Session["EmpInfoId"] = aTableLogin.Rows[0]["EmpInfoId"].ToString().Trim();
                    Session["EmpName"] = aTableLogin.Rows[0]["EmpName"].ToString().Trim();
                    Session["EmpMasterCode"] = aTableLogin.Rows[0]["EmpMasterCode"].ToString().Trim();
                    Session["DesigName"] = aTableLogin.Rows[0]["DesigName"].ToString().Trim();
                    Session["DICCompanyUnitId"] = aTableLogin.Rows[0]["DICCompanyUnitId"].ToString().Trim();
                    if (aTableLogin.Columns.Contains("IsPasswordChange"))
                    {
                        Session["IsPasswordChange"] = aTableLogin.Rows[0]["IsPasswordChange"].ToString().Trim();
                    }
                    else
                    {
                        Session["IsPasswordChange"] = "True";
                    }
                    try
                    {
                        Session["DICUnitId"] = aTableLogin.Rows[0]["CompanyUnitIdList"].ToString().Trim();
                    }catch(Exception ex)
                    {

                    }

                    bool IsMainDashboard = false;
                    try
                    {

                        IsMainDashboard = Convert.ToBoolean(aTableLogin.Rows[0]["IsMainDashboard"].ToString().Trim());
                        
                    }
                    catch(Exception ex)
                    {

                    }

                    string target ="";
                    try
                    {
                        target = Request.QueryString["aspxerrorpath"];
                    }
                    catch
                    {

                    }

                    if (IsMainDashboard == true)
                    {
                        
                        Response.Redirect("Dashboard_UI/AdminDashboard.aspx");

                    }
                    else if (!string.IsNullOrEmpty(target))
                    {
                        // URL decode করে নিরাপদ হলে redirect
                        target = Server.UrlDecode(target);

                        if (!target.StartsWith("http", StringComparison.OrdinalIgnoreCase)) // security check
                        {
                            Response.Redirect(target, endResponse: true);
                        }
                        else
                        {
                            // fallback
                            Response.Redirect("Dashboard_UI/DashboardOne.aspx");
                        }
                    }
                    else
                    {
                        Response.Redirect("Dashboard_UI/DashboardOne.aspx");

                    }
                }
                else
                {
                    msgLabel.Text = "User name or password incourect !!!!";
                    msgLabel.CssClass = "alert alert-warning";
                }
            }
            else
            {
                msgLabel.Text = "Input Password Please!!!";
                msgLabel.CssClass = "alert alert-warning";

            }
        }
        else
        {
            msgLabel.Text = "Input Use Name Please!!!";
            msgLabel.CssClass = "alert alert-warning";

        }
    }
}