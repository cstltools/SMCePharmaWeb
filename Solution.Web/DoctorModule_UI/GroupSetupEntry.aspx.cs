using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SalesSolution.Web.Controllers;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_GroupSetupEntry : System.Web.UI.Page
{
    private static GroupSetupDal _groupSetupDal = new GroupSetupDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static GroupSetup GetGroupSetupEditData(int id)
    {
        return (_groupSetupDal.GetEmployeeLeaveForEdit(id));
    }

    [WebMethod]
    public static ResultInfo Save_groupSetupInfo(GroupSetup department)
    {


        return (_groupSetupDal.Save_DepartmentInfo(department, HttpContext.Current.Session["UserId"].ToString()));

    }



}