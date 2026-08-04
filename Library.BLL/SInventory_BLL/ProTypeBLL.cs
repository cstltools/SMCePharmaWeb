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
    public class ProTypeBLL
    {
        ProTypeDAL aProTypeDal=new ProTypeDAL();
        public string SaveProType(ProType aProType)
        {
            try
            {

                if (!aProTypeDal.HasProTypeName(aProType))
                {

                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aProType.ProTypeId = aClsPrimaryKeyFind.PrimaryKeyMax("ProTypeId", "tblProType");
                    aProTypeDal.SaveProType(aProType);
                    return "Data Save Successfully  Type Name is :" + aProType.ProTypeName;
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

        public DataTable LoadProType()
        {
            return aProTypeDal.LoadProType();
        }

        public ProType ProTypeEditLoad(string ID)
        {
            return aProTypeDal.ProTypeEditLoad(ID);
        }

        public bool UpdateProTypeInfo(ProType aProType)
        {
            if (!aProTypeDal.HasProTypeNameUp(aProType))
            {
                return aProTypeDal.UpdateProTypeInfo(aProType);    
            }
            else
            {
                return false;
            }
            
        }
    }
}
