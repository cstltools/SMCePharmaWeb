using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class InvoicewisedetailssalesBLL
    {
        AreaDAL aAreaDAL = new AreaDAL();
        public string SaveArea(AreaInfo areaInfo)
        {
            try
            {
                if (!aAreaDAL.HasAreaName(areaInfo))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    areaInfo.AreaId = aClsPrimaryKeyFind.PrimaryKeyMax("AreaId", "tblArea");
                    //areaInfo.AreaCode = AreaCodeGenerator(areaInfo.AreaId);
                    aAreaDAL.SaveAreaInfo(areaInfo);
                    return "Data Save Successfully Territory Code  is :  " + areaInfo.AreaCode + " And Territory Name is :" + areaInfo.AreaName;
                }
                else
                {
                    return "Area Name already exist";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string AreaCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "0" + Id;
            }
            code = "AREA-" + Id;
            return code;
        }


        public bool UpdateDataForAreaInfo(AreaInfo aAreaInfo)
        {
            return aAreaDAL.UpdateAreaInfo(aAreaInfo);
        }

        public DataTable LoadSummaryProductcodewiseGyash(DateTime f , DateTime t,string Dc)
        {
            return aAreaDAL.LoadSummaryProductcodewiseGyash(f,t, Dc);
        }

        public AreaInfo AreaInfoEditLoad(string AreaInfoId)
        {
            return aAreaDAL.AreaEditLoad(AreaInfoId);
        }
        public void LoadDistrictName(DropDownList ddl)
        {
            aAreaDAL.LoadDistrictName(ddl);
        }
    }
}
