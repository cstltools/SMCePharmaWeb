using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class IngridentsDAL
    {
        public bool SaveIngridents(Ingridents aIngridents)
        {
            string insertQuery = @"insert into tblIngridents (IngridentsId,IngridentsName,IngridentsType) 
            values (@IngridentsId,@IngridentsName,@IngridentsType)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IngridentsId", aIngridents.IngridentsId),
                new SqlParameter("@IngridentsName", SInventorySql.DbValue(aIngridents.IngridentsName)),
                new SqlParameter("@IngridentsType", SInventorySql.DbValue(aIngridents.IngridentsType))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasIngridentsName(Ingridents aIngridents)
        {
            string query = "select top 1 IngridentsId from tblIngridents where IngridentsName = @IngridentsName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IngridentsName", SInventorySql.DbValue(aIngridents.IngridentsName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadIngridents()
        {
            string query = @"SELECT * from tblIngridents ";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }

        public Ingridents IngridentsEditLoad(string ID)
        {
            string query = "select * from tblIngridents where IngridentsId = @IngridentsId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IngridentsId", SInventorySql.DbValue(ID))
            };
            DataTable ingridientsTable = SInventorySql.GetDataTable(query, parameters);
            Ingridents aIngridents = new Ingridents();
            if (ingridientsTable.Rows.Count > 0)
            {
                DataRow row = ingridientsTable.Rows[0];
                aIngridents.IngridentsId = Int32.Parse(row["IngridentsId"].ToString());
                aIngridents.IngridentsName = row["IngridentsName"].ToString();
                aIngridents.IngridentsType = row["IngridentsType"].ToString();
            }
            return aIngridents;
        }

        public bool UpdateIngridentsInfo(Ingridents aIngridents)
        {

            string query = @"UPDATE tblIngridents SET IngridentsName=@IngridentsName,IngridentsType=@IngridentsType WHERE IngridentsId=@IngridentsId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@IngridentsName", SInventorySql.DbValue(aIngridents.IngridentsName)),
                new SqlParameter("@IngridentsType", SInventorySql.DbValue(aIngridents.IngridentsType)),
                new SqlParameter("@IngridentsId", aIngridents.IngridentsId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
