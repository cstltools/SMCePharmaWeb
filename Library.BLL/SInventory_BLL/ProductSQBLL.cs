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
    public class ProductSQBLL
    {
        ProductSQDAL aProductSQDal=new ProductSQDAL();
        public string SaveProductSQ(ProductSQ aProductSQ)
        {
            try
            {
                if (!aProductSQDal.HasProductSQName(aProductSQ))
                {


                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aProductSQ.ProductBrandId = aClsPrimaryKeyFind.PrimaryKeyMax("ProductBrandId", "tblProductSQ");
                    //aProductSQ.ProductSQName = ManufacturerCodeGenerator(aManufacturer.ManufacId);
                    aProductSQDal.SaveProductSQ(aProductSQ);
                    return "Data Save Successfully  Brand is :" + aProductSQ.ProductSQName;
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

        public DataTable LoadProductSQ()
        {
            return aProductSQDal.LoadProductSQ();
        }

        public ProductSQ ProductSQEditLoad(string ID)
        {
            return aProductSQDal.ProductSQEditLoad(ID);
        }
        public void LoadIngrident(DropDownList ddl)
        {
            aProductSQDal.LoadIngrident(ddl);
        }
        public bool UpdateProductSQInfo(ProductSQ aProductSQ)
        {
            if (!aProductSQDal.HasProductSQNameUp(aProductSQ  ))
            {
                return aProductSQDal.UpdateProductSQInfo(aProductSQ);    
            }
            else
            {
                return false;
            }
            
        }
        
    }
}
