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
    public class ProductDiscountBLL
    {
        ProductDiscountDAL aProductDiscountDal=new ProductDiscountDAL();
        public bool SaveProductDiscount(ProductDiscount aProductDiscount)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                aProductDiscount.DiscountId = aClsPrimaryKeyFind.PrimaryKeyMax("DiscountId", "tblProductDiscount");
                aProductDiscountDal.SaveProductDiscount(aProductDiscount);
                return true;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public bool HasProductDiscountName(ProductDiscount aProductDiscount)
        {
            return aProductDiscountDal.HasProductDiscountName(aProductDiscount);
        }

        public DataTable LoadProductDiscount()
        {
            return aProductDiscountDal.LoadProductDiscount();
        }

        public ProductDiscount ProductDiscountEditLoad(string ID)
        {
            return aProductDiscountDal.ProductDiscountEditLoad(ID);
        }
        public DataTable LoadProductDiscount(string fromdate, string todate)
        {
            return aProductDiscountDal.LoadProductDiscount(fromdate, todate);
        }
        public bool UpdateProductDiscountInfo(ProductDiscount aProductDiscount)
        {
            return aProductDiscountDal.UpdateProductDiscountInfo(aProductDiscount);
        }
        public void LoadCustomerMaster(DropDownList ddl,string marketId)
        {
            aProductDiscountDal.LoadCustomerMaster(ddl,marketId);
        }
        public void LoadSalesCenter(DropDownList ddl)
        {
            aProductDiscountDal.LoadSalesCenter(ddl);
        }
        public void LoadArea(DropDownList ddl, string comUnitId)
        {
            aProductDiscountDal.LoadArea(ddl,comUnitId);
        }
        public void LoadMarket(DropDownList ddl, string areaId)
        {
            aProductDiscountDal.LoadMarket(ddl,areaId);
        }
    }
}
