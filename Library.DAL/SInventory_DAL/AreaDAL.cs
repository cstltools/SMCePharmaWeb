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
    public class AreaDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveAreaInfo(AreaInfo areaInfo)
        {
            string insertQuery = @"insert into tblArea (AreaId,AreaCode,AreaName) 
            values (@AreaId,@AreaCode,@AreaName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@AreaId", areaInfo.AreaId),
                new SqlParameter("@AreaCode", SInventorySql.DbValue(areaInfo.AreaCode)),
                new SqlParameter("@AreaName", SInventorySql.DbValue(areaInfo.AreaName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }
        public bool HasAreaName(AreaInfo areaInfo)
        {
            string query = "select top 1 AreaId from tblArea where AreaCode = @AreaCode";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@AreaCode", SInventorySql.DbValue(areaInfo.AreaCode))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadAreaView()
        {
            string query = @"SELECT * FROM dbo.tblArea
                            LEFT JOIN dbo.tblDistrict ON dbo.tblArea.DistrictId = dbo.tblDistrict.DistrictId
                            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDistrict.ComUnitId = dbo.tblCompanyUnit.ComUnitId
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId ";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadSummaryProductcodewiseGyash(DateTime f, DateTime t,string Dc)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@FromDate", f));
            aSqlParameterList.Add(new SqlParameter("@ToDate", t));
            aSqlParameterList.Add(new SqlParameter("@DCID", Dc));
            return aCommonInternalDal.GetDataTableAction("sp_GET_InvoiceWiseDetailsSalesReport", aSqlParameterList, "SSIDB");

           // return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        
        public AreaInfo AreaEditLoad(string areaId)
        {
            string query = @"SELECT * FROM dbo.tblArea
                            LEFT JOIN dbo.tblDistrict ON dbo.tblArea.DistrictId = dbo.tblDistrict.DistrictId
                            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDistrict.ComUnitId = dbo.tblCompanyUnit.ComUnitId
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId
                             where AreaId = @AreaId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@AreaId", SInventorySql.DbValue(areaId))
            };
            DataTable areaTable = SInventorySql.GetDataTable(query, parameters);
            AreaInfo areaInfo = new AreaInfo();
            if (areaTable.Rows.Count > 0)
            {
                DataRow row = areaTable.Rows[0];
                areaInfo.AreaId = Int32.Parse(row["AreaId"].ToString());
                areaInfo.AreaName = row["AreaName"].ToString();
                areaInfo.AreaCode = row["AreaCode"].ToString();
            }
            return areaInfo;
        }

        public bool UpdateAreaInfo(AreaInfo areaInfo)
        {
            string query = @"UPDATE tblArea SET AreaName=@AreaName,AreaCode=@AreaCode WHERE AreaId=@AreaId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@AreaName", SInventorySql.DbValue(areaInfo.AreaName)),
                new SqlParameter("@AreaCode", SInventorySql.DbValue(areaInfo.AreaCode)),
                new SqlParameter("@AreaId", areaInfo.AreaId)
            };
            return SInventorySql.Execute(query, parameters);
        }
        public void LoadDistrictName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblDistrict";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistrictName", "DistrictId", queryStr);
        }
    }
}
