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
    public class ImportedApiCustomerBll
    {
        ImportedApiCustomerDal aCustomerMasterDAL = new ImportedApiCustomerDal();

        //API Customer
        public DataTable LoadNewCustomer()
        {
            return aCustomerMasterDAL.LoadNewCustomer();
        }


        public void LoadCategoryName(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadCategoryName(ddl);
        }

        public void LoadDistributionCenterName(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadCompanyUnit(ddl);
        }

        public void LoadDZSMInfo(DropDownList ddl)
        {
            aCustomerMasterDAL.GetDZSMname(ddl);
        }

        public void LoadFEInfo(DropDownList ddl)
        {
            aCustomerMasterDAL.GetFEInfo(ddl);
        }

        public void LoadTerritoryInfo(DropDownList ddl)
        {
            aCustomerMasterDAL.GetTerritoryInfo(ddl);
        }

        public void LoadMiaInfo(DropDownList ddl)
        {
            aCustomerMasterDAL.GetMiaInfo(ddl);
        }

        public void LoadMaketInfo(DropDownList ddl)
        {
            aCustomerMasterDAL.GetMaketInfo(ddl);
        }

        public CustomerMaster CustomerMasterEditLoad(string customerId)
        {
            return aCustomerMasterDAL.CustomerMasterEditLoad(customerId);
        }

        public DataTable LoadDZSMName(string dzsmId)
        {
            return aCustomerMasterDAL.GetDZSMnameById(dzsmId);
        }

        public DataTable LoadFEName(string feId)
        {
            return aCustomerMasterDAL.GetFEnameById(feId);
        }

        public DataTable LoadTeritoryName(string teritoryId)
        {
            return aCustomerMasterDAL.GetTeritorynameById(teritoryId);
        }

        public DataTable LoadMiaName(string miaId)
        {
            return aCustomerMasterDAL.GetMiaNameById(miaId);
        }

        public DataTable LoadMarketName(string marketId)
        {
            return aCustomerMasterDAL.GetMarketNameById(marketId);
        }

        public bool UpdateApiCustomerInfo(CustomerMaster aCustomerMaster)
        {
            return aCustomerMasterDAL.UpdateApiCustomerInformation(aCustomerMaster);
        }

        public CustomerMaster ApiCustomerInformation(string customermasterid)
        {
            return aCustomerMasterDAL.ApiCustomerInformation(customermasterid);
        }

        public bool SaveApiCustomerInfo(CustomerMaster aCustomerMaster)
        {

            try
            {
                if (!aCustomerMasterDAL.HasCustomerMastername(aCustomerMaster))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    aCustomerMaster.CustomerMasterId = aClsPrimaryKeyFind.PrimaryKeyMax("CustomerMasterId", "tblCustMaster");
                    aCustomerMasterDAL.SaveApiCustomerInformation(aCustomerMaster);
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

        public bool UpdateApiCustomer(int customerMasterId)
        {
            return aCustomerMasterDAL.UpdateApiCustomerInfo(customerMasterId);
        }
    }
}
