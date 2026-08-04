using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class B2BTransferViewDal
    {

        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

       

        public DataTable GetB2bTransferInfo(string prameter)
        {
            string query = @"SELECT ChalanId,ChalanNo,ChalanDate,FromComUnitName,ToComUnitName,TotalValue,TotalVat,GrandTotal,
                             CASE WHEN IsDeliver = 'True' THEN 'Received' ELSE 'Pending' END AS Status
                             FROM dbo.tblChalanInfo WHERE ChalanId IS NOT NULL " + prameter + " ORDER BY Status";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool DeleteChallanMasterById(int chalanId)
        {
            string query = @"DELETE FROM dbo.tblChalanInfo WHERE ChalanId = @ChalanId";
            var parameters = new List<SqlParameter>
            {
                new SqlParameter("@ChalanId", chalanId)
            };
            return SInventorySql.Execute(query, parameters);
        }

        //public bool DeleteChallanDetailById(int chalanId)
        //{
        //    string query = @"DELETE FROM dbo.tblChalanDetail WHERE ChalanId = " + chalanId;
        //    return aCommonInternalDal.DeleteDataByDeleteCommand(query, "SSIDB");
        //}


        public bool DeleteChallanDetailById(int chalanId)
        {
            var aSqlParameters = new List<SqlParameter>();

            aSqlParameters.Add(new SqlParameter("@chalanId", chalanId));

            return aCommonInternalDal.DeleteAction("sp_Del_B2BDelete", aSqlParameters);
        }
    }
}
