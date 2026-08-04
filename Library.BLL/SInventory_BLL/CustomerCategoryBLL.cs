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
    public class CustomerCategoryBLL
    {
        CustomerCategoryDAL aCustomerCategoryDAL = new CustomerCategoryDAL();
        public string SaveDataForCustomerCategory(CustomerCategory aCustomerCategory)
        {
            try
            {
                if (!aCustomerCategoryDAL.HasCustCategoryName(aCustomerCategory))
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                    aCustomerCategory.CategoryId = aClsPrimaryKeyFind.PrimaryKeyMax("CategoryId", "tblCustCategory");
                    aCustomerCategory.CategoryCode = CustomerCategoryCodeGenerator(aCustomerCategory.CategoryId);
                    aCustomerCategoryDAL.SaveCustomerCategory(aCustomerCategory);
                    return "Data Save Successfully CustomerCategory Code is :" + aCustomerCategory.CategoryCode + " And CustomerCategory Name is : " + aCustomerCategory.CategoryName;
                }
                else
                {
                    return "CustomerCategory Name already exist";
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public string CustomerCategoryCodeGenerator(int id)
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
            code = "CUS-" + Id;
            return code;
        }

        public bool UpdateDataForCusCategory(CustomerCategory aCategory)
        {
            return aCustomerCategoryDAL.UpdateCustCategoryInfo(aCategory);
        }

        public DataTable LoadCustCaegory()
        {
            return aCustomerCategoryDAL.LoadCustCategoryView();
        }

        public CustomerCategory CustCategoryInfoEditLoad(string custId)
        {
            return aCustomerCategoryDAL.CustomerCategoryEditLoad(custId);
        }

        //Stock Adjustment
        public DataTable LoadAdjustment()
        {
            return aCustomerCategoryDAL.LoadAdjustment();
        }
    }
}
