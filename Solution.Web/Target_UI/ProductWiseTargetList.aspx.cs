using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.TargetDAL;
using Newtonsoft.Json;

public partial class Target_UI_ProductWiseTargetList : System.Web.UI.Page
{
    public static ProuctWiseSalesDAL aTargetDal = new ProuctWiseSalesDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string LoadMonthlyTarget()
    {
        DataTable ds = aTargetDal.LoadMonthlyTarget();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }
}