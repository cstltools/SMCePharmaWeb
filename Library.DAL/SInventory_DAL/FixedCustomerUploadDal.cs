using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class FixedCustomerUploadDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public int SaveFixedCustomer(string date, string code)
        {
            var aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@date", date));
            aSqlParameterlist.Add(new SqlParameter("@code", code));

            return aCommonInternalDal.SaveAction("sp_I_FixedCustomer", aSqlParameterlist, "@FcID");
        }

        public bool UpdateFixedCustomer(string code)
        {
            var aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@code", code));

            return aCommonInternalDal.UpdateAction("sp_UD_FixedCustomer", aSqlParameterlist);
        }

        public bool UpdateRegularCustomer(string code)
        {
            var aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@code", code));

            return aCommonInternalDal.UpdateAction("sp_UD_RegularCustomer", aSqlParameterlist);
        }
    }
}
