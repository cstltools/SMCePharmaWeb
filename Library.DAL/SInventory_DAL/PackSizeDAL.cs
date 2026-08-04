using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class PackSizeDAL
    {
        public bool SavePackSize(PackSize aPackSize)
        {
            string insertQuery = @"insert into tblPackSize (PackSizeName) 
            values (@PackSizeName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@PackSizeName", SInventorySql.DbValue(aPackSize.PackSizeName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasPackSizeName(PackSize aPackSize)
        {
            string query = "select top 1 PackSizeId from tblPackSize where PackSizeName = @PackSizeName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@PackSizeName", SInventorySql.DbValue(aPackSize.PackSizeName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public bool HasPackSizeNameUp(PackSize aPackSize)
        {
            

            string query = "select top 1 PackSizeId from tblPackSize where PackSizeName = @PackSizeName AND PackSizeId NOT IN (@PackSizeId)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@PackSizeName", SInventorySql.DbValue(aPackSize.PackSizeName)),
                new SqlParameter("@PackSizeId", aPackSize.PackSizeId)
            };
            return SInventorySql.Exists(query, parameters);
        }


        public DataTable LoadPackSize()
        {
            string query = @"SELECT * from tblPackSize ";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }

        public PackSize PackSizeEditLoad(string ID)
        {
            string query = "select * from tblPackSize where PackSizeId = @PackSizeId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@PackSizeId", SInventorySql.DbValue(ID))
            };
            DataTable packSizeTable = SInventorySql.GetDataTable(query, parameters);
            PackSize aPackSize = new PackSize();
            if (packSizeTable.Rows.Count > 0)
            {
                DataRow row = packSizeTable.Rows[0];
                aPackSize.PackSizeId = Int32.Parse(row["PackSizeId"].ToString());
                aPackSize.PackSizeName = row["PackSizeName"].ToString();
            }
            return aPackSize;
        }

        public bool UpdatePackSizeInfo(PackSize aPackSize)
        {

            string query = @"UPDATE tblPackSize SET PackSizeName=@PackSizeName WHERE PackSizeId=@PackSizeId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@PackSizeName", SInventorySql.DbValue(aPackSize.PackSizeName)),
                new SqlParameter("@PackSizeId", aPackSize.PackSizeId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
