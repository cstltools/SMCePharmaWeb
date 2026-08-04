using Library.DAL.MasterSetup_DAL;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MasterSetup_UI_StationTypeView : System.Web.UI.Page
{

    private static StationDal _departmentDal = new StationDal();

    protected void Page_Load(object sender, EventArgs e)
    {

    }


    [WebMethod]
    public static string GetDepartmentList()
    {
        string param = " ";

        DataTable dt = _departmentDal.GetDepartmentList(param);
        string JSONresult;
        JSONresult = JsonConvert.SerializeObject(dt);
        return  (JSONresult);
    }
}