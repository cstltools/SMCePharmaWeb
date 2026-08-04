using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Runtime.Serialization.Formatters;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class UnitPriceBLL
    {
        ProductUnitPriceDAL aProductUnitPriceDAL = new ProductUnitPriceDAL();
        public bool SaveUnitPrice(ProductUnitPrice ProductUnitPrice)
        {
            try
            {
                if (!aProductUnitPriceDAL.HasProductName(ProductUnitPrice))
                {


                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    ProductUnitPrice.UnitPriceId = aClsPrimaryKeyFind.PrimaryKeyMax("UnitPriceId", "tblUnitPrice");
                    aProductUnitPriceDAL.SaveProductUnitPrice(ProductUnitPrice);
                    return true;
                }
                else
                {
                    return false;
                }
                //else
                //{



                //    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                //    ProductUnitPrice  aProductUnitPrice=new ProductUnitPrice();
                //    aProductUnitPrice = aProductUnitPriceDAL.ProductUnitPriceEditLoadProduct(ProductUnitPrice.ProductId.ToString());
                    
                //    aProductUnitPrice.ActiveDate = ProductUnitPrice.ActiveDate;

                //    aProductUnitPrice.UnitPriceUpdateId = aClsPrimaryKeyFind.PrimaryKeyMax("UnitPriceUpdateId", "tblUnitPriceUpdate");
                    
                //    aProductUnitPriceDAL.SaveProductUnitPriceUpdate(aProductUnitPrice);

                //    aProductUnitPriceDAL.DeleteProduct(ProductUnitPrice.ProductId.ToString());

                    
                //    ProductUnitPrice.UnitPriceId = aClsPrimaryKeyFind.PrimaryKeyMax("UnitPriceId", "tblUnitPrice");
                //    aProductUnitPriceDAL.SaveProductUnitPrice(ProductUnitPrice);


                //    return true;


                //}

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public DataTable LoadProductPriceReportInfo()
        {
            return aProductUnitPriceDAL.GetProductPriceReportInfo();
        }
        public bool SaveUnitPriceEdit(ProductUnitPrice ProductUnitPrice)
        {
            try
            {
                //if (!aProductUnitPriceDAL.HasProductName(ProductUnitPrice))
                {


                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    ProductUnitPrice.UnitPriceId = aClsPrimaryKeyFind.PrimaryKeyMax("UnitPriceId", "tblUnitPrice");
                    aProductUnitPriceDAL.SaveProductUnitPrice(ProductUnitPrice);
                    return true;
                }
                //else
                //{
                //    return false;
                //}
                

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        
        public bool UpdateDataForProductUnitPrice(ProductUnitPrice aProductUnitPrice)
        {
            if (!aProductUnitPriceDAL.HasProductName(aProductUnitPrice))
            {
                return aProductUnitPriceDAL.UpdateCustCategoryInfo(aProductUnitPrice);    
            }
            else
            {
                return false;
            }
            
        }

        public DataTable LoadProductUnitPrice()
        {
            return aProductUnitPriceDAL.LoadUnitPriceView();
        }

        public ProductUnitPrice ProductUnitPriceEditLoad(string ProductUnitPriceId)
        {
            return aProductUnitPriceDAL.ProductUnitPriceEditLoad(ProductUnitPriceId);
        }
        public DataTable ProductInfo(string productId)
        {
            return aProductUnitPriceDAL.LoadProduct(productId);
        }

        public bool UpdateActive(DateTime inactivedate, string unitpriceId)
        {
            return aProductUnitPriceDAL.UpdateActive(inactivedate, unitpriceId);
        }

        public DataTable TotalUnitPriceReportBLL()
        {
            return aProductUnitPriceDAL.TotalUnitPriceReport();
        }
    }
}
