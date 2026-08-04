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
    public class DistrictDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveDistrictInfo(DistrictInfo aDistrictInfo)
        {
            string insertQuery = @"insert into tblDistrict (DistrictId,DistrictCode,DistrictName) 
            values (@DistrictId,@DistrictCode,@DistrictName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DistrictId", aDistrictInfo.DistrictId),
                new SqlParameter("@DistrictCode", SInventorySql.DbValue(aDistrictInfo.DistrictCode)),
                new SqlParameter("@DistrictName", SInventorySql.DbValue(aDistrictInfo.DistrictName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasDistrictName(DistrictInfo aDistrict)
        {
            string query = "select top 1 DistrictId from tblDistrict where DistrictCode = @DistrictCode";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DistrictCode", SInventorySql.DbValue(aDistrict.DistrictCode))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadDistrictView()
        {
            string query = @"SELECT * from tblDistrict
                            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDistrict.ComUnitId = dbo.tblCompanyUnit.ComUnitId
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DistrictInfo DistrictInfoEditLoad(string DistrictId)
        {
            string query = @"SELECT * from tblDistrict
                            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDistrict.ComUnitId = dbo.tblCompanyUnit.ComUnitId
                            LEFT JOIN dbo.tblRegion ON dbo.tblCompanyUnit.RegionId = dbo.tblRegion.RegionId
                            LEFT JOIN dbo.tblCompanyInfo ON dbo.tblRegion.CompanyId = dbo.tblCompanyInfo.CompanyId where DistrictId = @DistrictId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DistrictId", SInventorySql.DbValue(DistrictId))
            };
            DataTable districtTable = SInventorySql.GetDataTable(query, parameters);
            DistrictInfo aDistrict = new DistrictInfo();
            if (districtTable.Rows.Count > 0)
            {
                DataRow row = districtTable.Rows[0];
                aDistrict.DistrictId = Int32.Parse(row["DistrictId"].ToString());
                aDistrict.DistrictCode = row["DistrictCode"].ToString();
                aDistrict.DistrictName = row["DistrictName"].ToString();
            }
            return aDistrict;
        }

        public bool UpdateDistrictInfo(DistrictInfo aDistrict)
        {

            string query = @"UPDATE tblDistrict SET DistrictName=@DistrictName,DistrictCode=@DistrictCode WHERE DistrictId=@DistrictId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@DistrictName", SInventorySql.DbValue(aDistrict.DistrictName)),
                new SqlParameter("@DistrictCode", SInventorySql.DbValue(aDistrict.DistrictCode)),
                new SqlParameter("@DistrictId", aDistrict.DistrictId)
            };
            return SInventorySql.Execute(query, parameters);
        }

        public void LoadCompanyUnit(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }

        public void LoadZoneByComUnit(DropDownList ddl,string comUnitId)
        {
            string queryStr = "select ZoneId,ZoneName from tblZone where ComUnitId = @ComUnitId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId))
            };
            ddl.DataTextField = "ZoneName";
            ddl.DataValueField = "ZoneId";
            ddl.DataSource = SInventorySql.GetDataTable(queryStr, parameters);
            ddl.DataBind();
            ddl.Items.Insert(0, new ListItem("--------Select---------", String.Empty));
            ddl.SelectedIndex = 0;
        }
    }
}
