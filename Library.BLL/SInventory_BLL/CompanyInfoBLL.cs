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
    public class CompanyInfoBLL
    {
        CompanyInfoDAL aCompanyInfoDal = new CompanyInfoDAL();
        public bool SaveCompanyInfoData(CompanyInformation aCompanyInfo)
        {
            try
            {
                if (!aCompanyInfoDal.HasCompanyName(aCompanyInfo))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aCompanyInfo.CompanyId = aClsPrimaryKeyFind.PrimaryKeyMax("CompanyId", "tblCompanyInfo");
                    aCompanyInfo.CompanyCode = CompanyCodeGenerator(aCompanyInfo.CompanyId);
                    aCompanyInfoDal.SaveDataForCompanyInfo(aCompanyInfo);
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public string CompanyCodeGenerator(int id)
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
            code = "COMP-" + Id;
            return code;
        }


        public bool UpdateDataForCompanyInfo(CompanyInformation aCompanyInfo)
        {
            return aCompanyInfoDal.UpdateCompanyInfo(aCompanyInfo);
        }

        public DataTable LoadCompanyInfo()
        {
            return aCompanyInfoDal.LoadCompanyInfo();
        }

        public CompanyInformation CompanyInfoEditLoad(string companyInfoId)
        {
            return aCompanyInfoDal.CompanyInfoEditLoad(companyInfoId);
        }

    }
}
