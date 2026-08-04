using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAL.SubDepot_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SubDepot_BLL
{
    public class SubDepotBLL
    {
        SubDepotDAL _aCompanyUnitDal = new SubDepotDAL();
        public bool SaveSalesCenter(CompanyUnit companyUnit)
        {
            try
            {
                //ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
               // companyUnit.ComUnitId = aClsPrimaryKeyFind.PrimaryKeyMax("ComUnitId", "tblCompanyUnit");
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

        public DataTable LoadZoneInfo()
        {
            return _aCompanyUnitDal.LoadZoneInfo();
        }

        public DataTable LoadSubDepotById(string id)
        {
            return _aCompanyUnitDal.LoadSubDepotById(id);
        }

        public string CodeGenerator(string init)
        {
            string code = string.Empty;
            string Id="";
            DataTable dt = _aCompanyUnitDal.GetId();
            if (dt.Rows.Count>0)
            {
                Id = dt.Rows[0]["ID"].ToString();
            }
            if (Id.Length == 1)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "0" + Id;
            }
            if (Id.Length == 3)
            {
                Id =  Id;
            }
            code = init + Id;
            return code;
        }
        public void CompanyNameLoad(DropDownList dropDownList)
        {
            _aCompanyUnitDal.LoadCompanyName(dropDownList);
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
