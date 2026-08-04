using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class ProductCategoriesBLL
    {
        ProductCategoryDAL aProductCategoryDAL = new ProductCategoryDAL();
        public string SaveProductCategory(ProductCategory ProductCategory)
        {
            try
            {
                if (!aProductCategoryDAL.HasCustCategoryName(ProductCategory))
                {


                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    ProductCategory.CategoryId = aClsPrimaryKeyFind.PrimaryKeyMax("CategoryId", "tblProCategory");
                    ProductCategory.CategoryCode = CategoryCodeGenerator(ProductCategory.CategoryId);
                    aProductCategoryDAL.SaveProductCategory(ProductCategory);
                    return "Data Save Successfully  Category Code  is :  " + ProductCategory.CategoryCode +
                           " And  Category Name is :" + ProductCategory.CategoryName;
                }
                else
                {
                    return "Already Exist";
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string CategoryCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "0" + Id;
            }
            code = "MIA-" + Id;
            return code;
        }


        public bool UpdateDataForProductCategory(ProductCategory aProductCategory)
        {
            if (!aProductCategoryDAL.HasCustCategoryNameUp(aProductCategory))
            {
                return aProductCategoryDAL.UpdateProCategoryInfo(aProductCategory);    
            }
            else
            {
                return false;
            }
            
        }

        public DataTable LoadProductCategory()
        {
            return aProductCategoryDAL.LoadCategoryView();
        }

        public ProductCategory ProductCategoryEditLoad(string ProductCategoryId)
        {
            return aProductCategoryDAL.ProductCategoryEditLoad(ProductCategoryId);
        }
    }
}
