using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class ProductBLL
    {
        ProductDAL aProductDAL = new ProductDAL();
        public bool SaveProduct(Product Product)
        {
            try
            {
                if (!aProductDAL.HasProductName(Product))
                {


                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    Product.ProductId = aClsPrimaryKeyFind.PrimaryKeyMax("ProductId", "tblProduct");
                    //Product.ProductCode = ProductCodeGenerator(Product.ProductId);
                    aProductDAL.SaveDataForProduct(Product);
                    return true;
                }
                else
                {
                    return false;
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string ProductCodeGenerator(int id)
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
            code = "372" + Id;
            return code;
        }


        public bool UpdateDataForProduct(Product aProduct)
        {
            //if (!aProductDAL.HasProductName(aProduct))
            {
                return aProductDAL.UpdateProduct(aProduct);    
            }
            //else
            //{
            //    return false;
            //}
            
        }

        public DataTable LoadProduct()
        {
            return aProductDAL.LoadProduct();
        }

        public Product ProductEditLoad(string ProductId)
        {
            return aProductDAL.ProductEditLoad(ProductId);
        }

        public void LoadProductCategory(DropDownList ddl)
        {
            aProductDAL.LoadCategoryName(ddl);
        }
        public void LoadManufac(DropDownList ddl)
        {
            aProductDAL.LoadManufac(ddl);
        }
        public void LoadPackSize(DropDownList ddl)
        {
            aProductDAL.LoadPackSize(ddl);
        }
        public void LoadStockUOM(DropDownList ddl)
        {
            aProductDAL.LoadStockUOM(ddl);
        }
        public void LoadType(DropDownList ddl)
        {
            aProductDAL.LoadType(ddl);
        }
        public void LoadIngrident(DropDownList ddl)
        {
            aProductDAL.LoadIngrident(ddl);
        }
        public void LoadProductSQ(DropDownList ddl)
        {
            aProductDAL.LoadProductSQ(ddl);
        }
        public void LoadTherapeuticGroup(DropDownList ddl)
        {
            aProductDAL.LoadTherapeuticGroup(ddl);
        }

        public void LoadGenericGroup(DropDownList ddl)
        {
            aProductDAL.LoadGenericGroup(ddl);
        }

        public void LoadProductType_new(DropDownList ddl)
        {
            aProductDAL.LoadProductType_new(ddl);
        }
        public void LoadShippingCartonSize(DropDownList ddl)
        {
            aProductDAL.LoadShippingCartonSize(ddl);
        }
        public DataTable ProductPriceDetailWithCaseBLL(string productCode)
        {
            return aProductDAL.ProductPriceDetailWithCase(productCode);
        }
    }
}
