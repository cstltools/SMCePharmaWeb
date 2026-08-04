using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class MarketInfoDAL
    {
        public bool SaveMarketInfo(MarketInfo aMarketInfo)
        {
            string insertQuery = @"insert into tblMarket (MarketId,MarketCode,MarketName) 
            values (@MarketId,@MarketCode,@MarketName)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@MarketId", aMarketInfo.MarketId),
                new SqlParameter("@MarketCode", SInventorySql.DbValue(aMarketInfo.MarketCode)),
                new SqlParameter("@MarketName", SInventorySql.DbValue(aMarketInfo.MarketName))
            });
        }

        public bool HasMarketName(MarketInfo aMarketInfo)
        {
            string query = "select * from tblMarket where MarketCode = @MarketCode";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@MarketCode", SInventorySql.DbValue(aMarketInfo.MarketCode))
            });
        }

        public DataTable LoadMarketCiew()
        {
            string query = @"SELECT  * FROM dbo.tblMarket
          ";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }

        public MarketInfo MarketInfoEditLoad(string MarketId)
        {
            string query = @"SELECT  * FROM dbo.tblMarket
                 where MarketId = @MarketId";
            DataTable marketTable = SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MarketId", SInventorySql.DbValue(MarketId))
            });
            MarketInfo aMarketInfo = new MarketInfo();
            if (marketTable.Rows.Count > 0)
            {
                DataRow marketRow = marketTable.Rows[0];
                aMarketInfo.MarketId = Int32.Parse(marketRow["MarketId"].ToString());
                aMarketInfo.MarketCode = marketRow["MarketCode"].ToString();
                aMarketInfo.MarketName = marketRow["MarketName"].ToString();
                //aMarketInfo.AreaId = Convert.ToInt32(dataReader["AreaId"].ToString());
                //aMarketInfo.MiaId = Convert.ToInt32(dataReader["MiaId"].ToString());
                //aMarketInfo.DistrictId = Convert.ToInt32(dataReader["DistrictId"].ToString());
                //aMarketInfo.ComUnitId = Convert.ToInt32(dataReader["ComUnitId"].ToString());
                //aMarketInfo.RegionId = Convert.ToInt32(dataReader["RegionId"].ToString());
                //aMarketInfo.CompanyId = Convert.ToInt32(dataReader["CompanyId"].ToString());
            }
            return aMarketInfo;
        }

        public bool UpdateCustCategoryInfo(MarketInfo aMarketInfo)
        {
            string query = @"UPDATE tblMarket SET MarketName=@MarketName,MarketCode=@MarketCode WHERE MarketId=@MarketId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@MarketName", SInventorySql.DbValue(aMarketInfo.MarketName)),
                new SqlParameter("@MarketCode", SInventorySql.DbValue(aMarketInfo.MarketCode)),
                new SqlParameter("@MarketId", aMarketInfo.MarketId)
            });
        }

        public void LoadAreaName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblArea ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaId", queryStr);
        }
        public void LoadMiaName(DropDownList ddl,string areaId)
        {
            string queryStr = "select * from tblMIAInfo where AreaId=@AreaId";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
            {
                new SqlParameter("@AreaId", SInventorySql.DbValue(areaId))
            });
            ddl.DataTextField = "MiaName";
            ddl.DataValueField = "MiaId";
            ddl.DataBind();
        }
    }
}
