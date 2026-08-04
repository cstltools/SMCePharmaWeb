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
    public class ShippingCartonSizeBLL
    {
        ShippingCartonSizeDAL aShippingCartonSizeDal=new ShippingCartonSizeDAL();
        public bool SaveShippingCartonSize(ShippingCartonSize aShippingCartonSize)
        {
            try
            {
              //  if (!aShippingCartonSizeDal.HasPcsPerCase(aShippingCartonSize))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aShippingCartonSize.CaseId = aClsPrimaryKeyFind.PrimaryKeyMax("CaseId", "tblProductCase");
                    aShippingCartonSizeDal.SaveShippingCartonSize(aShippingCartonSize);
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

        public DataTable LoadShippingCartonSize()
        {
            return aShippingCartonSizeDal.LoadShippingCartonSize();
        }
        public void LoadProduct(DropDownList ddl)
        {
            aShippingCartonSizeDal.LoadProduct(ddl);
        }
        public ShippingCartonSize ShippingCartonSizeEditLoad(string ID)
        {
            return aShippingCartonSizeDal.ShippingCartonSizeEditLoad(ID);
        }

        public bool UpdateShippingCartonSizeInfo(ShippingCartonSize aShippingCartonSize)
        {
           // if (!aShippingCartonSizeDal.HasPcsPerCase(aShippingCartonSize))
            {
                return aShippingCartonSizeDal.UpdateShippingCartonSizeInfo(aShippingCartonSize);    
            }
            //else
            //{
            //    return false;

            //}
            
        }
    }
}
