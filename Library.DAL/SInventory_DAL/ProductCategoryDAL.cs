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
    public class ProductCategoryDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveProductCategory(ProductCategory aProductCategory)
        {
            string insertQuery = @"insert into tblProCategory (CategoryId,CategoryCode,CategoryName) 
            values (@CategoryId,@CategoryCode,@CategoryName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryId", aProductCategory.CategoryId),
                new SqlParameter("@CategoryCode", SInventorySql.DbValue(aProductCategory.CategoryCode)),
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aProductCategory.CategoryName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasCustCategoryName(ProductCategory aCategory)
        {
            string query = "select top 1 CategoryId from tblProCategory where CategoryName = @CategoryName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aCategory.CategoryName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public bool HasCustCategoryNameUp(ProductCategory aCategory)
        {
            string query = "select top 1 CategoryId from tblProCategory where CategoryName = @CategoryName AND CategoryId NOT IN (@CategoryId)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aCategory.CategoryName)),
                new SqlParameter("@CategoryId", aCategory.CategoryId)
            };

            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadCategoryView()
        {
            string query = @"SELECT * from tblProCategory ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public ProductCategory ProductCategoryEditLoad(string CategoryId)
        {
            string query = "select * from tblProCategory where CategoryId = @CategoryId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryId", SInventorySql.DbValue(CategoryId))
            };
            DataTable categoryTable = SInventorySql.GetDataTable(query, parameters);
            ProductCategory aCategory = new ProductCategory();
            if (categoryTable.Rows.Count > 0)
            {
                DataRow row = categoryTable.Rows[0];
                aCategory.CategoryId = Int32.Parse(row["CategoryId"].ToString());
                aCategory.CategoryCode = row["CategoryCode"].ToString();
                aCategory.CategoryName = row["CategoryName"].ToString();
            }
            return aCategory;
        }

        public bool UpdateProCategoryInfo(ProductCategory aCategory)
        {

            string query = @"UPDATE tblProCategory SET CategoryName=@CategoryName WHERE CategoryId=@CategoryId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aCategory.CategoryName)),
                new SqlParameter("@CategoryId", aCategory.CategoryId)
            };
            return SInventorySql.Execute(query, parameters);
        }
    }
}
