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
    public class StockUOMBLL
    {
        StockUOMDAL aStockUOMDal=new StockUOMDAL();
        public string SaveStockUOM(StockUOM aStockUOM)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                aStockUOM.StockUOMId = aClsPrimaryKeyFind.PrimaryKeyMax("StockUOMId", "tblStockUOM");
                //aStockUOM.StockUOMName = ManufacturerCodeGenerator(aManufacturer.ManufacId);
                aStockUOMDal.SaveStockUOM(aStockUOM);
                return "Data Save Successfully  UOM is :" + aStockUOM.StockUOMName;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public DataTable LoadStockUOM()
        {
            return aStockUOMDal.LoadStockUOM();
        }

        public StockUOM StockUOMEditLoad(string ID)
        {
            return aStockUOMDal.StockUOMEditLoad(ID);
        }

        public bool UpdateStockUOMInfo(StockUOM aStockUOM)
        {
            if (!aStockUOMDal.HasStockUOMName(aStockUOM))
            {


                return aStockUOMDal.UpdateStockUOMInfo(aStockUOM);
            }
            else
            {
                return false;
            }
        }
    }
}
