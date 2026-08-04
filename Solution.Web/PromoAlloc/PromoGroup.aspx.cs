using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using Library.DAL.PromoAllocDAL;
using Library.DAO.PromoAlloc_DAO;
using Library.DAO.Target_DAO;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using SalesSolution.Web.Models;

public partial class PromoAlloc_PromoGroup : System.Web.UI.Page
{

    public static PromoGroupDAL aTargetDal = new PromoGroupDAL();
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    [WebMethod(EnableSession = true)]
    public static ResultInfo SaveGroup(GroupDAO aTargetDao)
    {
        string code = "";
        ResultInfo aInformation = new ResultInfo();
        //DataTable aDataTable = new DataTable();
        //aDataTable = aTargetDal.LoadPromoGroupCode();
        //code = aDataTable.Rows[0][0].ToString();
        //aTargetDao.PromoGroupCode = code;
        bool status = false;
        if (aTargetDao.PromoGroupId > 0)
        {

            aInformation.isSuccess  = aTargetDal.UpdatePromoGroup(aTargetDao);

        }
        else
        {
            aInformation.isSuccess = aTargetDal.SavePromoGroup(aTargetDao);
    
        }


        return aInformation;
    }

    [WebMethod(EnableSession = true)]
    public static string LoadPromoGroupById(string id)
    {
        DataTable ds = aTargetDal.LoadPromoGroupById(id);
        string _data = "";
        if (ds.Rows.Count > 0)
        {
            _data = JsonConvert.SerializeObject(ds);
        }
        return _data;
    }





}