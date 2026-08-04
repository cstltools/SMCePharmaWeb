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
    public class CustomerLedgerBLL
    {
        CustomerLedgerDAL aCustomerLedgerDAL = new CustomerLedgerDAL();

        public DataTable CustomerLedgerBll(string Cid,string f ,string t)
        {
            return aCustomerLedgerDAL.CustomerLedgerDal(Cid,f,t);
        }
        public DataTable CustomerLedgerBllNew(string Cid,string f ,string t)
        {
            return aCustomerLedgerDAL.CustomerLedgerDalNew(Cid,f,t);
        }
    }
}
