using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
    public class MultiCustomerEditBLL
    {
        MultiCustomerEditDAL aMultiCustomerEditDal=new MultiCustomerEditDAL();

        public bool UpdateDataForCustomer(string parameter, string customerId)
        {
            return aMultiCustomerEditDal.UpdateDataForCustomer(parameter, customerId);
        }
        public DataTable LoadCusteomer(string parameter)
        {
            return aMultiCustomerEditDal.LoadCusteomer(parameter);
        }
        public DataTable CHeckInvice(string custimerId)
        {
            return aMultiCustomerEditDal.CHeckInvice(custimerId);
        }
    }
}
