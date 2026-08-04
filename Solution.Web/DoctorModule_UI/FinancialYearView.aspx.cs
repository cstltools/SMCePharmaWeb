using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Newtonsoft.Json;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_FinancialYearView : System.Web.UI.Page
{
    private static FinancialYearDal _setupDAL=new FinancialYearDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo ActiveInactive_FinancialYearInfo(int Id)
    {
        return (_setupDAL.ActiveInactive_FinancialYearInfo(Id, 2));
    }
    [WebMethod]
    public static string GetFinancialYearList()
    {
        string param = " ";
        DataTable dt = _setupDAL.GetDepartmentList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return (JSONresult);
    }
}
