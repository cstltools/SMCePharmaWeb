using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.DoctorModule_DAL;
using Newtonsoft.Json;
using SalesSolution.Web.Models;

public partial class DoctorModule_UI_ExpenseTypeView : System.Web.UI.Page
{
    static SetupDAL _setupDAL = new SetupDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod]
    public static string GetExpensemasterList()
    {
        DataTable dt = _setupDAL.Get_ExpenseTypeMasterList();
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return JSONresult;
    }

    [WebMethod]
    public static ResultInfo Delete_ExpenseType(int Id)
    {
        return (_setupDAL.Delete_ExpenseType(Id));
    }

}