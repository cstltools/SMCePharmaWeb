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
    public class IngridentsBLL
    {
        IngridentsDAL aIngridentsDal=new IngridentsDAL();
        public string SaveIngridents(Ingridents aIngridents)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                aIngridents.IngridentsId = aClsPrimaryKeyFind.PrimaryKeyMax("IngridentsId", "tblIngridents");
                aIngridentsDal.SaveIngridents(aIngridents);
                return "Data Save Successfully  Ingridents is :" + aIngridents.IngridentsName;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public DataTable LoadIngridents()
        {
            return aIngridentsDal.LoadIngridents();
        }

        public Ingridents IngridentsEditLoad(string ID)
        {
            return aIngridentsDal.IngridentsEditLoad(ID);
        }

        public bool UpdateIngridentsInfo(Ingridents aIngridents)
        {
            return aIngridentsDal.UpdateIngridentsInfo(aIngridents);
        }
    }
}
