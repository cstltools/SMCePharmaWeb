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
    public class ProTypeDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveProType(ProType aProType)
        {
           
                string insertQuery = @"insert into tblProType (ProTypeId,ProTypeName) 
            values (@ProTypeId,@ProTypeName)";
                List<SqlParameter> parameters = new List<SqlParameter>
                {
                    new SqlParameter("@ProTypeId", aProType.ProTypeId),
                    new SqlParameter("@ProTypeName", SInventorySql.DbValue(aProType.ProTypeName))
                };
                return SInventorySql.Execute(insertQuery, parameters);
            
           
        }

        public bool HasProTypeName(ProType aProType)
        {
            string query = "select top 1 ProTypeId from tblProType where ProTypeName = @ProTypeName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProTypeName", SInventorySql.DbValue(aProType.ProTypeName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public bool HasProTypeNameUp(ProType aProType)
        { 

            string query = "select top 1 ProTypeId from tblProType where ProTypeName = @ProTypeName AND ProTypeId NOT IN (@ProTypeId)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProTypeName", SInventorySql.DbValue(aProType.ProTypeName)),
                new SqlParameter("@ProTypeId", aProType.ProTypeId)
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadProType()
        {
            string query = @"SELECT * from tblProType ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public ProType ProTypeEditLoad(string ID)
        {
            string query = "select * from tblProType where ProTypeId = @ProTypeId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProTypeId", SInventorySql.DbValue(ID))
            };
            DataTable proTypeTable = SInventorySql.GetDataTable(query, parameters);
            ProType aProType = new ProType();
            if (proTypeTable.Rows.Count > 0)
            {
                DataRow row = proTypeTable.Rows[0];
                aProType.ProTypeId = Int32.Parse(row["ProTypeId"].ToString());
                aProType.ProTypeName = row["ProTypeName"].ToString();
            }
            return aProType;
        }

        public bool UpdateProTypeInfo(ProType aProType)
        {

            string query = @"UPDATE tblProType SET ProTypeName=@ProTypeName WHERE ProTypeId=@ProTypeId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProTypeName", SInventorySql.DbValue(aProType.ProTypeName)),
                new SqlParameter("@ProTypeId", aProType.ProTypeId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
