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
    public class ManufacturerBLL
    {
        ManufacturerDAL aManufacturerDal=new ManufacturerDAL();
        public string SaveManufacturer(Manufacturer aManufacturer)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                if (!aManufacturerDal.HasManufacName(aManufacturer))
                {
                    aManufacturer.ManufacId = aClsPrimaryKeyFind.PrimaryKeyMax("ManufacId", "tblManufacturer");
                    aManufacturer.ManufacCode = ManufacturerCodeGenerator(aManufacturer.ManufacId);

                    aManufacturerDal.SaveManufacturer(aManufacturer);

                    return "Data Save Successfully  Manufacturer Code  is :  " + aManufacturer.ManufacCode + " And  Manufacturer Name is :" + aManufacturer.ManufacName;
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
        public string ManufacturerCodeGenerator(int id)
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
            code = "MF-" + Id;
            return code;
        }

        public DataTable LoadManufacturer()
        {
            return aManufacturerDal.LoadManufacturer();
        }

        public Manufacturer ManufacturerEditLoad(string ID)
        {
            return aManufacturerDal.ManufacturerEditLoad(ID);
        }

        public bool UpdateManufacturerInfo(Manufacturer aManufacturer)
        {
            return aManufacturerDal.UpdateManufacturerInfo(aManufacturer);

        }
    }
}
