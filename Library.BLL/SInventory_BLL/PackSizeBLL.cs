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
    public class PackSizeBLL
    {
        PackSizeDAL aPackSizeDal=new PackSizeDAL();
        public string SavePackSize(PackSize aPackSize)
        {
            try
            {
                if (!aPackSizeDal.HasPackSizeName(aPackSize))
                {


                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    //aPackSize.PackSizeId = aClsPrimaryKeyFind.PrimaryKeyMax("PackSizeId", "tblPackSize");
                    //aPackSize.PackSizeName = ManufacturerCodeGenerator(aManufacturer.ManufacId);
                    aPackSizeDal.SavePackSize(aPackSize);
                    return "Data Save Successfully  Pack Size is :" + aPackSize.PackSizeName;
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

        public DataTable LoadPackSize()
        {
            return aPackSizeDal.LoadPackSize();
        }

        public PackSize PackSizeEditLoad(string ID)
        {
            return aPackSizeDal.PackSizeEditLoad(ID);
        }

        public bool UpdatePackSizeInfo(PackSize aPackSize)
        {
            if (!aPackSizeDal.HasPackSizeNameUp(aPackSize))
            {
                return aPackSizeDal.UpdatePackSizeInfo(aPackSize);    
            }
            else
            {
                return false;
            }
            
        }
    }
}
