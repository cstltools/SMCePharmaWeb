using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using SalesSolution.Web.DataLayer;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_FinancialYearEntry : System.Web.UI.Page
{
    private static FinancialYearDal _setupDAL = new FinancialYearDal();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod]
    public static ResultInfo Save_FinancialYearInfo(FinancialYear department)
    {

        return (_setupDAL.Save_DepartmentInfo(department, 2));
    }
    [WebMethod]
    public static FinancialYear  GetFinancialYeaEditData(int id)
    {
        return (_setupDAL.GetFinancialYearForEdit(id));
    }
}