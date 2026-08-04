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
    public class CustomerMasterInfoBll
    {
        CustomerMasterInfoDal aCustomerMasterDAL = new CustomerMasterInfoDal();

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

        public DataTable LoadDZSMName(string dzsmId)
        {
            return  aCustomerMasterDAL.GetDZSMnameById(dzsmId);
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

        public bool SaveCustMasterInfo(CustomerMaster CustomerMaster)
        {
            try
            {
                if (!aCustomerMasterDAL.HasCustomerMastername(CustomerMaster))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    CustomerMaster.CustomerMasterId = aClsPrimaryKeyFind.PrimaryKeyMax("CustomerMasterId", "tblCustMaster");
                    //CustomerMaster.CustomerCode = CustMasterCodeGenerator(CustomerMaster.CustomerMasterId);
                    aCustomerMasterDAL.SaveCustometMasterInfo(CustomerMaster);
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

        public CustomerMaster CustomerMasterEditLoad(string CustomerMasterId)
        {
            return aCustomerMasterDAL.CustomerMasterEditLoad(CustomerMasterId);
        }

        public DataTable LoadCustomerMaster(string cust)
        {
            return aCustomerMasterDAL.LoadCustomerMasterView(cust);
        }
        public DataTable LoadCustomerMasterM(string cust)
        {
            return aCustomerMasterDAL.LoadCustomerMasterViewM(cust);
        }
        public DataTable LoadCustomerMasterM2(string cust)
        {
            return aCustomerMasterDAL.LoadCustomerMasterViewM2(cust);
        }
        public DataTable Customer(string customerId)
        {
            return aCustomerMasterDAL.Customer(customerId);
        }

        public DataTable CustomerPayment(string customerId)
        {
            return aCustomerMasterDAL.CustomerPayment(customerId);
        }

        public bool UpdateDataForCustomerMaster(CustomerMaster aCustomerMaster)
        {
            //if (!aCustomerMasterDAL.HasCustomerMastername(aCustomerMaster   ))
            {
                return aCustomerMasterDAL.UpdateCustomerMasterInfo(aCustomerMaster);
            }
            //else
            //{
            //    return false;
            //}


        }

        public DataTable LoadCustomerMasterId()
        {
            return aCustomerMasterDAL.GetCustomerMasterId();
        }

        //API Customer
        public DataTable LoadNewCustomer()
        {
           return aCustomerMasterDAL.LoadNewCustomer();
        }

        public DataTable FixedCustomerSalesReportInfo(string customerId)
        {
            return aCustomerMasterDAL.GetFixedCustomerSalesReportInfo(customerId);
        }
        public DataTable FixedCustomerSalesReportInfo2(string Parameter, string Parameter2)
        {
            return aCustomerMasterDAL.GetFixedCustomerSalesReportInfo2(Parameter, Parameter2);
        }
    }
}
