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

public partial class PromoAlloc_GroupWisePromoQtyList : System.Web.UI.Page
{
    public static GroupWisePromoQtyDAL aTargetDal = new GroupWisePromoQtyDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string LoadGroupWiseQty()
    {
        DataTable ds = aTargetDal.LoadGroupWiseQty();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }
}