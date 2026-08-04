using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_StationTypeEntry : System.Web.UI.Page
{
    private static StationDal _departmentDal = new StationDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static ResultInfo Save_DepartmentInfo(StationType department)
    {

        
            return  (_departmentDal.Save_DepartmentInfo(department, Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
        

    }
    [WebMethod(EnableSession = true)]
    public static StationType GetDepartmentEditData(int id)
    {
        return  (_departmentDal.GetEmployeeLeaveForEdit(id));
    }
}