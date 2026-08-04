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
    public class ProductSQDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveProductSQ(ProductSQ aProductSQ)
        {
            string insertQuery = @"insert into tblProductSQ (ProductBrandId,ProductSQName,IngridentsId) 
            values (@ProductBrandId,@ProductSQName,@IngridentsId)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductBrandId", aProductSQ.ProductBrandId),
                new SqlParameter("@ProductSQName", SInventorySql.DbValue(aProductSQ.ProductSQName)),
                new SqlParameter("@IngridentsId", aProductSQ.IngridentsId)
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }
        public void LoadIngrident(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM tblIngridents";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "IngridentsName", "IngridentsId", queryStr);
        }
        public bool HasProductSQName(ProductSQ aProductSQ)
        {
            string query = "select top 1 ProductBrandId from tblProductSQ where ProductSQName = @ProductSQName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductSQName", SInventorySql.DbValue(aProductSQ.ProductSQName))
            };
            return SInventorySql.Exists(query, parameters);
        }


        public bool HasProductSQNameUp(ProductSQ aProductSQ)
        {


            string query = "select top 1 ProductBrandId from tblProductSQ where ProductSQName = @ProductSQName AND ProductBrandId NOT IN (@ProductBrandId)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductSQName", SInventorySql.DbValue(aProductSQ.ProductSQName)),
                new SqlParameter("@ProductBrandId", aProductSQ.ProductBrandId)
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadProductSQ()
        {
            string query = @"SELECT * from tblProductSQ
            LEFT JOIN dbo.tblIngridents ON dbo.tblProductSQ.IngridentsId = dbo.tblIngridents.IngridentsId ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public ProductSQ ProductSQEditLoad(string ID)
        {
            string query = "select * from tblProductSQ where ProductBrandId = @ProductBrandId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductBrandId", SInventorySql.DbValue(ID))
            };
            DataTable productSqTable = SInventorySql.GetDataTable(query, parameters);
            ProductSQ aProductSQ = new ProductSQ();
            if (productSqTable.Rows.Count > 0)
            {
                DataRow row = productSqTable.Rows[0];
                aProductSQ.ProductBrandId = Int32.Parse(row["ProductBrandId"].ToString());
                aProductSQ.ProductSQName = row["ProductSQName"].ToString();
                aProductSQ.IngridentsId = Convert.ToInt32(row["IngridentsId"].ToString());
            }
            return aProductSQ;
        }

        public bool UpdateProductSQInfo(ProductSQ aProductSQ)
        {

            string query = @"UPDATE tblProductSQ SET ProductSQName=@ProductSQName,IngridentsId=@IngridentsId WHERE ProductBrandId=@ProductBrandId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductSQName", SInventorySql.DbValue(aProductSQ.ProductSQName)),
                new SqlParameter("@IngridentsId", aProductSQ.IngridentsId),
                new SqlParameter("@ProductBrandId", aProductSQ.ProductBrandId)
            };
            return SInventorySql.Execute(query, parameters);
        }
        public bool DeleteProductBrand(string id)
        {
            string query = @"DELETE FROM dbo.tblProductSQ WHERE ProductBrandId=@ProductBrandId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@ProductBrandId", SInventorySql.DbValue(id))
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
