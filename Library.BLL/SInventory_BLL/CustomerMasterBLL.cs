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
    public class CustomerMasterBLL
    {
        CustomerMasterDAL aCustomerMasterDAL = new CustomerMasterDAL();
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
        public string CustMasterCodeGenerator(int id)
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
            code = "" + Id;
            return code;
        }

        public DataTable FixedCustMasterReport(bool fixedBusiness)
        {
            return aCustomerMasterDAL.FixedCustomerMasterReport(fixedBusiness);
        }

        public DataTable RegularCustMasterReport(bool regularCustomer)
        {
            return aCustomerMasterDAL.RegularCustomerMasterReport(regularCustomer);
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
        public bool DeleteRequisition(int ordID)
        {
            return aCustomerMasterDAL.DeleteRequisition(ordID);
        }
        public bool UpdateBacktoReturnPage(int ordID)
        {
            return aCustomerMasterDAL.UpdateBacktoReturnPage(ordID);
        }
        public DataTable LoadCustomerMaster(string cust)
        {
            return aCustomerMasterDAL.LoadCustomerMasterView(cust);
        }

        public DataTable LoadOrderView(string Ord)
        {
            return aCustomerMasterDAL.LoadOrderView(Ord);
        }

        public DataTable CustMasterReport(string ComUnitId)
        {
            return aCustomerMasterDAL.CustomerMasterReport(ComUnitId);
        }
        public DataTable CustMasterReport()
        {
            return aCustomerMasterDAL.CustomerMasterReport();
        }

        public CustomerMaster CustomerMasterEditLoad(string CustomerMasterId)
        {
            return aCustomerMasterDAL.CustomerMasterEditLoad(CustomerMasterId);
        }

        public DataTable Customer(string customerId)
        {
            return aCustomerMasterDAL.Customer(customerId);
        }
        public DataTable CustomerPayment(string customerId)
        {
            return aCustomerMasterDAL.CustomerPayment(customerId);
        }
        public DataTable Customerorder(string customerCode)
        {
            return aCustomerMasterDAL.Customerorder(customerCode);
        }

        public void LoadMarketName(DropDownList ddl,string areaId)
        {
            aCustomerMasterDAL.LoadMarketName(ddl,areaId);
        }

        public void LoadAreaName(DropDownList ddl,string regionId)
        {
            aCustomerMasterDAL.LoadAreaName(ddl,regionId);
        }
        public void LoadAreaName2(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadAreaName2(ddl);
        }
        public void LoadCompanyUnit(DropDownList ddl,string regionId)
        {
            aCustomerMasterDAL.LoadCompanyUnit(ddl,regionId);
        }
        
        public void LoadDistrictName(DropDownList ddl,string comUnitId)
        {
            aCustomerMasterDAL.LoadDistrictName(ddl,comUnitId);
        }
        public void LoadRegionname(DropDownList ddl,string id)
        {
            aCustomerMasterDAL.LoadRegionname(ddl,id);
        }
        public void LoadRegionname(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadRegionname(ddl);
        }
        public void LoadCategoryName(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadCategoryName(ddl);
        }
        public void LoadMiaName(DropDownList ddl,string areaId)
        {
            aCustomerMasterDAL.LoadMiaName(ddl,areaId);
        }
        public void LoadDcDropDownList(DropDownList ddl,string custMasterId)
        {
            aCustomerMasterDAL.LoadDcDropDownList(ddl,custMasterId);
        }
        public void LoadDcDropDownList(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadDcDropDownList(ddl);
        }
        //
        public void LoadMarketNameById(DropDownList ddl, string areaId)
        {
            aCustomerMasterDAL.LoadMarketNameById(ddl, areaId);
        }

        public void LoadAreaNameById(DropDownList ddl, string regionId)
        {
            aCustomerMasterDAL.LoadAreaNameById(ddl, regionId);
        }
        public void LoadCompanyUnitById(DropDownList ddl, string regionId)
        {
            aCustomerMasterDAL.LoadCompanyUnitById(ddl, regionId);
        }

        public void LoadDistrictNameById(DropDownList ddl, string comUnitId)
        {
            aCustomerMasterDAL.LoadDistrictNameById(ddl, comUnitId);
        }
        public void LoadRegionnameById(DropDownList ddl, string id)
        {
            aCustomerMasterDAL.LoadRegionnameById(ddl, id);
        }
        public void LoadRegionnameById(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadRegionnameById(ddl);
        }
        public void LoadCategoryNameById(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadCategoryNameById(ddl);
        }
        public void LoadMiaNameById(DropDownList ddl, string areaId)
        {
            aCustomerMasterDAL.LoadMiaNameById(ddl, areaId);
        }
        public void LoadDcDropDownListById(DropDownList ddl, string custMasterId)
        {
            aCustomerMasterDAL.LoadDcDropDownListById(ddl, custMasterId);
        }
        public void LoadDcDropDownListById(DropDownList ddl)
        {
            aCustomerMasterDAL.LoadDcDropDownListById(ddl);
        }
    }
}
