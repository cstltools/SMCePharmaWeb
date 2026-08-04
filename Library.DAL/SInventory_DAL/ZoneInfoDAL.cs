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
    public class ZoneInfoDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveZoneInfo(ZoneInfo aZoneInfo)
        {
            string insertQuery = @"insert into tblZone (ZoneId,ZoneCode,ZoneName,ComUnitId,ComUnitName) 
            values (@ZoneId,@ZoneCode,@ZoneName,@ComUnitId,@ComUnitName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ZoneId", aZoneInfo.ZoneId),
                new SqlParameter("@ZoneCode", SInventorySql.DbValue(aZoneInfo.ZoneCode)),
                new SqlParameter("@ZoneName", SInventorySql.DbValue(aZoneInfo.ZoneName)),
                new SqlParameter("@ComUnitId", aZoneInfo.ComUnitId),
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(aZoneInfo.ComUnitName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasZoneName(ZoneInfo aZoneInfo)
        {
            string query = "select top 1 ZoneId from tblZone where ZoneName = @ZoneName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ZoneName", SInventorySql.DbValue(aZoneInfo.ZoneName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public void LoadCompanyUnit(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }


        public DataTable LoadZoneInfo()
        {
            string query = @"SELECT * from tblZone ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public ZoneInfo ZoneEditLoad(string zoneId)
        {
            string query = "select * from tblZone where ZoneId = @ZoneId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ZoneId", SInventorySql.DbValue(zoneId))
            };
            DataTable zoneTable = SInventorySql.GetDataTable(query, parameters);
            ZoneInfo aZoneInfo = new ZoneInfo();
            if (zoneTable.Rows.Count > 0)
            {
                DataRow row = zoneTable.Rows[0];
                aZoneInfo.ZoneId = Int32.Parse(row["ZoneId"].ToString());
                aZoneInfo.ZoneCode = row["ZoneCode"].ToString();
                aZoneInfo.ZoneName = row["ZoneName"].ToString();
                aZoneInfo.ComUnitId = Convert.ToInt32(row["ComUnitId"].ToString());
            }
            return aZoneInfo;
        }

        public bool UpdateZoneInfo(ZoneInfo aZoneInfo)
        {

            string query = @"UPDATE tblZone SET ZoneName=@ZoneName,ComUnitName=@ComUnitName,ComUnitId=@ComUnitId WHERE ZoneId=@ZoneId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ZoneName", SInventorySql.DbValue(aZoneInfo.ZoneName)),
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(aZoneInfo.ComUnitName)),
                new SqlParameter("@ComUnitId", aZoneInfo.ComUnitId),
                new SqlParameter("@ZoneId", aZoneInfo.ZoneId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
   
}
