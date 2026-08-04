using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class CustomerLedgerDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public DataTable CustomerLedgerDal(string CustomerID, string f, string t)
        {
          
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            if(f=="")
            {
                f = null;
            }
            if(t == "")
            {
                t = null;
            }

            aSqlParameterlist.Add(new SqlParameter("@Cust", CustomerID));
            aSqlParameterlist.Add(new SqlParameter("@fromdate", f ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@todate", t ?? (object)DBNull.Value));

            return aCommonInternalDal.GetDataTableAction("sp_CustomerLedger", aSqlParameterlist, "SSIDB");
        } public DataTable CustomerLedgerDalNew(string CustomerID, string f, string t)
        {
          
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            if(f=="")
            {
                f = null;
            }
            if(t == "")
            {
                t = null;
            }

            aSqlParameterlist.Add(new SqlParameter("@Cust", CustomerID));
            aSqlParameterlist.Add(new SqlParameter("@fromdate", f ?? (object)DBNull.Value));
            aSqlParameterlist.Add(new SqlParameter("@todate", t ?? (object)DBNull.Value));

            return aCommonInternalDal.GetDataTableAction("sp_CustomerLedgerNew", aSqlParameterlist, "SSIDB");
        }
    }
}
