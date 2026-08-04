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
using SalesSolution.Web.Models;

public partial class Target_UI_MonthlyTarget : System.Web.UI.Page
{

    public static TargetDAL aTargetDal=new TargetDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }
    [WebMethod(EnableSession = true)]
    public static string SaveTarget(TargetDAO aTargetDao)
    {
        string day = "01";
        string month = aTargetDao.Month.ToString();
        string year = aTargetDao.Year.ToString();
        string date = day + "-" + month + "-" + year;
        DateTime maindate = Convert.ToDateTime(date);
        aTargetDao.Date = maindate;
        aTargetDao.FinYearId = 0;
        bool status = false;
        if (aTargetDao.MTargetId>0)
        {

            DataTable dtMarket = aTargetDal.CheckLoadMonthlyTarget(year, month, Convert.ToString(aTargetDao.MTargetId));
            if (dtMarket.Rows.Count == 0)
            {

                status = aTargetDal.UpdateMonthlyTarget(aTargetDao);
            }
        }
        else
        {
            status = aTargetDal.SaveMonthlyTarget(aTargetDao);
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

}