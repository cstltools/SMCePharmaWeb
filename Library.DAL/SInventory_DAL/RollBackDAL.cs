using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class RollBackDAL
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        private static SqlParameter Parameter(string name, object value)
        {
            return new SqlParameter(name, SInventorySql.DbValue(value));
        }

        public DataTable GetStockInTransfer(string reqId)
        {
            const string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId = @ReqId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                Parameter("@ReqId", reqId)
            });
        }
        public bool UpdatePickingInformationOnRequisitionDAL(string id)
        {
            string query = @"UPDATE tblRequisition SET  CreatePicking=NULL,PickingDate=NULL,PickingNo=NULL, " +
                              " TruckNo=NULL,DriverName=NULL,TotalPrice=NULL,TotalVAT=NULL ," +
                              " GrandTotalPrice=NULL WHERE ReqId = @ReqId";


            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@ReqId", id)
            });
        }
        public bool UpdateIssueInformationOnRequisitionChildDAL(string id)
        {
            string query = @" UPDATE tblRequsitionChild SET IssueQty=NULL,UnitPrice=NULL,PriceAmount=NULL, " +
                           " VATAmount=NULL,TotalPrice=NULL,IsPicking=NULL,CaseQty=NULL,MusakVATAmount=NULL,MusakTotalPrice=NULL   WHERE ReqChildId = @ReqChildId";

            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@ReqChildId", id)
            });
        }
        public bool UpdateCentralStockStockOut(decimal quantity, string receiveId)
        {
            const string query = @"UPDATE dbo.tblCentralStore SET Quantity = Quantity + @Quantity WHERE ReceiveId = @ReceiveId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@Quantity", quantity),
                Parameter("@ReceiveId", receiveId)
            });
        }
        public bool DeleteStockInTransfer(string id)
        {
            const string query = @"DELETE FROM dbo.tblStockInTransfar WHERE ReqId = @ReqId";

            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@ReqId", id)
            });
        }
        public DataTable GetAllStockRcvByDcDAL()
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE Submit='OK' AND (ReceiveIssue IS NULL OR ReceiveIssue ='') ";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>());
        }
        public bool UpdateReqDetailIssueStatusDAL(string Reqid)
        {
            const string query = @"UPDATE dbo.tblRequsitionChild SET IsIssue=NULL WHERE ReqId = @ReqId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@ReqId", Reqid)
            });
        }
        public bool UpdateIssueInformationOnRequisitionDAL(string Reqid)
        {
            const string query = @"UPDATE tblRequisition SET Submit=NULL, IssueChalanNo=NULL WHERE ReqId = @ReqId";

            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                Parameter("@ReqId", Reqid)
            });
        }
    }
}
