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
    public class StockUOMDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveStockUOM(StockUOM aStockUOM)
        {
            string insertQuery = @"insert into tblStockUOM (StockUOMId,StockUOMName) 
            values (@StockUOMId,@StockUOMName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@StockUOMId", aStockUOM.StockUOMId),
                new SqlParameter("@StockUOMName", SInventorySql.DbValue(aStockUOM.StockUOMName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasStockUOMName(StockUOM aStockUOM)
        {
            string query = "select top 1 StockUOMId from tblStockUOM where StockUOMName = @StockUOMName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@StockUOMName", SInventorySql.DbValue(aStockUOM.StockUOMName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadStockUOM()
        {
            string query = @"SELECT * from tblStockUOM ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public StockUOM StockUOMEditLoad(string ID)
        {
            string query = "select * from tblStockUOM where StockUOMId = @StockUOMId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@StockUOMId", SInventorySql.DbValue(ID))
            };
            DataTable stockUomTable = SInventorySql.GetDataTable(query, parameters);
            StockUOM aStockUOM = new StockUOM();
            if (stockUomTable.Rows.Count > 0)
            {
                DataRow row = stockUomTable.Rows[0];
                aStockUOM.StockUOMId = Int32.Parse(row["StockUOMId"].ToString());
                aStockUOM.StockUOMName = row["StockUOMName"].ToString();
            }
            return aStockUOM;
        }

        public bool UpdateStockUOMInfo(StockUOM aStockUOM)
        {

            string query = @"UPDATE tblStockUOM SET StockUOMName=@StockUOMName WHERE StockUOMId=@StockUOMId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@StockUOMName", SInventorySql.DbValue(aStockUOM.StockUOMName)),
                new SqlParameter("@StockUOMId", aStockUOM.StockUOMId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
