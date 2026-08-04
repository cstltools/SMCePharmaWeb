using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.PromoAllocDAL;
using Newtonsoft.Json;

public partial class PromoAlloc_PromoGroupList : System.Web.UI.Page
{

    public static PromoGroupDAL aTargetDal = new PromoGroupDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string LoadPromoGroup()
    {
        DataTable ds = aTargetDal.LoadPromoGroup();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }
}