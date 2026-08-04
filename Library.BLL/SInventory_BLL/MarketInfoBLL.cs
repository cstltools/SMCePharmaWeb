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
    public class MarketInfoBLL
    {
        MarketInfoDAL aMarketInfoDAL = new MarketInfoDAL();
        public string SaveMarket(MarketInfo MarketInfo)
        {
            try
            {
                if (!aMarketInfoDAL.HasMarketName(MarketInfo))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    MarketInfo.MarketId = aClsPrimaryKeyFind.PrimaryKeyMax("MarketId", "tblMarket");
                    //MarketInfo.MarketCode = MarketCodeGenerator(MarketInfo.MarketId);
                    aMarketInfoDAL.SaveMarketInfo(MarketInfo);
                    return "Data Save Successfully  Market Code  is :  " + MarketInfo.MarketCode + " And  Market Name is :" + MarketInfo.MarketName;
                }
                else
                {
                    return "Company Name already exist";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string MarketCodeGenerator(int id)
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
            code = "MARK-" + Id;
            return code;
        }


        public bool UpdateDataForMarketInfo(MarketInfo aMarketInfo)
        {
            return aMarketInfoDAL.UpdateCustCategoryInfo(aMarketInfo);
        }

        public DataTable LoadMarketInfo()
        {
            return aMarketInfoDAL.LoadMarketCiew();
        }

        public MarketInfo MarketInfoEditLoad(string MarketInfoId)
        {
            return aMarketInfoDAL.MarketInfoEditLoad(MarketInfoId);
        }
        public void LoadAreaName(DropDownList ddl)
        {
            aMarketInfoDAL.LoadAreaName(ddl);
        }
        public void LoadMiaName(DropDownList ddl,string areaId)
        {
            aMarketInfoDAL.LoadMiaName(ddl,areaId);
        }
    }
}
