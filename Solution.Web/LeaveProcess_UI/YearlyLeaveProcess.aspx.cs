using Library.DAL.MasterSetup_DAL;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class LeaveProcess_UI_YearlyLeaveProcess : System.Web.UI.Page
{

    
    private static YearlyLeaveprocessDal _leaveDal = new YearlyLeaveprocessDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo SaveYearlyleave()
    {
        return  (_leaveDal.SaveYearlyleave(Convert.ToInt32(HttpContext.Current.Session["UserId"].ToString())));
    }
}