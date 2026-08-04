using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.TargetDAL;
using Library.DAO.Target_DAO;
using Newtonsoft.Json;

public partial class Target_UI_ProductWiseTarget : System.Web.UI.Page
{
    public static ProuctWiseSalesDAL aTargetDal = new ProuctWiseSalesDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static string SaveTarget(ProductWiseTargetDAO aTargetDao)
    {
        string day = "01";
        string month = aTargetDao.Month.ToString();
        string year = aTargetDao.Year.ToString();
        string date = day + "-" + month + "-" + year;
        DateTime maindate = Convert.ToDateTime(date);
        aTargetDao.Date = maindate;
        
        bool status = false;
        if (aTargetDao.ProductSalesTargetId > 0)
        {
            status = aTargetDal.UpdateMonthlyTarget(aTargetDao);
        }
        else
        {
            status = aTargetDal.SaveProductWiseSales(aTargetDao);
        }


        return status.ToString();
    }

    [WebMethod(EnableSession = true)]
    public static string LoadMonthlyTargetById(string id)
    {
        DataTable ds = aTargetDal.LoadMonthlyTargetById(id);
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }
    [WebMethod(EnableSession = true)]
    public static string LoadProduct()
    {
        DataTable ds = aTargetDal.LoadProduct();
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }
}