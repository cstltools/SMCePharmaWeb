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
    public class RegionDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveRegionInfo(RegionInfo aRegionInfo)
        {
            string insertQuery = @"insert into tblRegion (RegionId,RegionCode,RegionName) 
            values (@RegionId,@RegionCode,@RegionName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@RegionId", aRegionInfo.RegionId),
                new SqlParameter("@RegionCode", SInventorySql.DbValue(aRegionInfo.RegionCode)),
                new SqlParameter("@RegionName", SInventorySql.DbValue(aRegionInfo.RegionName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasRegionName(RegionInfo aRegionInfo)
        {
            string query = "select top 1 RegionId from tblRegion where RegionCode = @RegionCode";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@RegionCode", SInventorySql.DbValue(aRegionInfo.RegionCode))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public void LoadCompanyName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyInfo";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "CompanyName", "CompanyId", queryStr);
        }


        public DataTable LoadRegionInfo()
        {
            string query = @"SELECT * from tblRegion
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public RegionInfo RegionInfoEditLoad(string RegionId)
        {
            string query = "select * from tblRegion where RegionId = @RegionId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@RegionId", SInventorySql.DbValue(RegionId))
            };
            DataTable regionTable = SInventorySql.GetDataTable(query, parameters);
            RegionInfo aRegionInfo = new RegionInfo();
            if (regionTable.Rows.Count > 0)
            {
                DataRow row = regionTable.Rows[0];
                aRegionInfo.RegionId = Int32.Parse(row["RegionId"].ToString());
                aRegionInfo.RegionCode = row["RegionCode"].ToString();
                aRegionInfo.RegionName = row["RegionName"].ToString();
            }
            return aRegionInfo;
        }

        public bool UpdateRegionInfo(RegionInfo aRegionInfo)
        {

            string query = @"UPDATE tblRegion SET RegionName=@RegionName,RegionCode=@RegionCode WHERE RegionId=@RegionId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@RegionName", SInventorySql.DbValue(aRegionInfo.RegionName)),
                new SqlParameter("@RegionCode", SInventorySql.DbValue(aRegionInfo.RegionCode)),
                new SqlParameter("@RegionId", aRegionInfo.RegionId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
