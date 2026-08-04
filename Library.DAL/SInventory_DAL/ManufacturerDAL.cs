using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class ManufacturerDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveManufacturer(Manufacturer aManufacturer)
        {
            string insertQuery = @"insert into tblManufacturer (ManufacId,ManufacName,ManufacAddress,ManufacCode) 
            values (@ManufacId,@ManufacName,@ManufacAddress,@ManufacCode)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ManufacId", aManufacturer.ManufacId),
                new SqlParameter("@ManufacName", SInventorySql.DbValue(aManufacturer.ManufacName)),
                new SqlParameter("@ManufacAddress", SInventorySql.DbValue(aManufacturer.ManufacAddress)),
                new SqlParameter("@ManufacCode", SInventorySql.DbValue(aManufacturer.ManufacCode))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasManufacName(Manufacturer aManufacturer)
        {
            string query = "select top 1 ManufacId from tblManufacturer where ManufacName = @ManufacName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ManufacName", SInventorySql.DbValue(aManufacturer.ManufacName))
            };
            return SInventorySql.Exists(query, parameters);
        }

      

        public DataTable LoadManufacturer()
        {
            string query = @"SELECT * from tblManufacturer ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public Manufacturer ManufacturerEditLoad(string ID)
        {
            string query = "select * from tblManufacturer where ManufacId = @ManufacId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ManufacId", SInventorySql.DbValue(ID))
            };
            DataTable manufacturerTable = SInventorySql.GetDataTable(query, parameters);
            Manufacturer aManufacturer = new Manufacturer();
            if (manufacturerTable.Rows.Count > 0)
            {
                DataRow row = manufacturerTable.Rows[0];
                aManufacturer.ManufacId = Int32.Parse(row["ManufacId"].ToString());
                aManufacturer.ManufacName = row["ManufacName"].ToString();
                aManufacturer.ManufacAddress = row["ManufacAddress"].ToString();
                aManufacturer.ManufacCode = row["ManufacCode"].ToString();
            }
            return aManufacturer;
        }

        public bool UpdateManufacturerInfo(Manufacturer aManufacturer)
        {
            if (!HasManufacNameUp(aManufacturer)) { 
            string query = @"UPDATE tblManufacturer SET ManufacName=@ManufacName,ManufacAddress=@ManufacAddress WHERE ManufacId=@ManufacId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ManufacName", SInventorySql.DbValue(aManufacturer.ManufacName)),
                new SqlParameter("@ManufacAddress", SInventorySql.DbValue(aManufacturer.ManufacAddress)),
                new SqlParameter("@ManufacId", aManufacturer.ManufacId)
            };
            return SInventorySql.Execute(query, parameters);
            }
            else
            {
                return false;
            }
        }


        public bool HasManufacNameUp(Manufacturer aManufacturer)
        {
            string query = "select top 1 ManufacId from tblManufacturer where ManufacName = @ManufacName AND ManufacId NOT IN (@ManufacId)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ManufacName", SInventorySql.DbValue(aManufacturer.ManufacName)),
                new SqlParameter("@ManufacId", aManufacturer.ManufacId)
            };
            return SInventorySql.Exists(query, parameters);
        }
    }
}
