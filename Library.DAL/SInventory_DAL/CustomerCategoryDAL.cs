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
    public class CustomerCategoryDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public bool SaveCustomerCategory(CustomerCategory aCustomerCategory)
        {
            string insertQuery = @"insert into tblCustCategory (CategoryId,CategoryCode,CategoryName) 
            values (@CategoryId,@CategoryCode,@CategoryName)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryId", aCustomerCategory.CategoryId),
                new SqlParameter("@CategoryCode", SInventorySql.DbValue(aCustomerCategory.CategoryCode)),
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aCustomerCategory.CategoryName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }

        public bool HasCustCategoryName(CustomerCategory aCategory)
        {
            string query = "select top 1 CategoryId from tblCustCategory where CategoryName = @CategoryName";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aCategory.CategoryName))
            };
            return SInventorySql.Exists(query, parameters);
        }

        public DataTable LoadAdjustment()
        {
            string query = @"SELECT * from tblAdjustmentType ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadCustCategoryView()
        {
            string query = @"SELECT * from tblCustCategory ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public CustomerCategory CustomerCategoryEditLoad(string categoryId)
        {
            string query = "select * from tblCustCategory where CategoryId = @CategoryId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryId", SInventorySql.DbValue(categoryId))
            };
            DataTable categoryTable = SInventorySql.GetDataTable(query, parameters);
            CustomerCategory aCategory = new CustomerCategory();
            if (categoryTable.Rows.Count > 0)
            {
                DataRow row = categoryTable.Rows[0];
                aCategory.CategoryId = Int32.Parse(row["CategoryId"].ToString());
                aCategory.CategoryCode = row["CategoryCode"].ToString();
                aCategory.CategoryName = row["CategoryName"].ToString();
            }
            return aCategory;
        }

        public bool UpdateCustCategoryInfo(CustomerCategory aCategory)
        {

            string query = @"UPDATE tblCustCategory SET CategoryName=@CategoryName WHERE CategoryId=@CategoryId";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@CategoryName", SInventorySql.DbValue(aCategory.CategoryName)),
                new SqlParameter("@CategoryId", aCategory.CategoryId)
            };
            return SInventorySql.Execute(query, parameters);
        }


        public bool SaveAdjustment(CustomerCategory aCustomerCategory)
        {
            string insertQuery = @"insert into tblAdjustmentType (AdjustmentType) 
            values (@AdjustmentType)";
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@AdjustmentType", SInventorySql.DbValue(aCustomerCategory.CategoryName))
            };
            return SInventorySql.Execute(insertQuery, parameters);
        }
    }
}
