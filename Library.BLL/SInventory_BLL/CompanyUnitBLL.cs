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
    public class CompanyUnitBLL
    {
        CompanyUnitDAL _aCompanyUnitDal = new CompanyUnitDAL();
        public bool SaveSalesCenter(CompanyUnit companyUnit)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                companyUnit.ComUnitId = aClsPrimaryKeyFind.PrimaryKeyMax("ComUnitId", "tblCompanyUnit");
                //companyUnit.ComUnitCode = SalesCodeGenerator(companyUnit.ComUnitId);
                _aCompanyUnitDal.SaveDataForSalesCenter(companyUnit);
                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string SalesCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "0" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "" + Id;
            }
            code = "BD" + Id;
            return code;
        }


        public bool UpdateDataForSalesCenter(CompanyUnit aCompanyUnit)
        {
            return _aCompanyUnitDal.UpdateSalesCenter(aCompanyUnit);
        }

        public DataTable LoadSalesCenter()
        {
            return _aCompanyUnitDal.LoadSalesCenter();
        }

        public CompanyUnit SalesCenterEditLoad(string ComUnitId)
        {
            return _aCompanyUnitDal.SalesCenterEditLoad(ComUnitId);
        }

        public void LoadCompanyName(DropDownList ddl)
        {
            _aCompanyUnitDal.LoadCompanyName(ddl);
        }

        public void LoadRegionName(DropDownList ddl)
        {
            _aCompanyUnitDal.LoadRegionName(ddl);
        }

    }
}
