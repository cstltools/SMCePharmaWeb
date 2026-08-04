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
    public class StockRcvByWhDal
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable LoadMasterInfo(string reqId)
        {
            string query = @"SELECT DISTINCT ChalanNo AS IssueChalanNo,ChalanDate AS IssuChalanDate,DriverName,TrackNo AS TruckNo,ComUnitId FROM tblDepotToWHChalanInfo
                             INNER JOIN dbo.tblCompanyUnit ON tblDepotToWHChalanInfo.FromComUnitCode = ComUnitCode WHERE SChalanId = @SChalanId";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@SChalanId", SInventorySql.DbValue(reqId))
            });
        }

        public DataTable GetChallanDetailByReqId(string reqId)
        {
            string query = @"SELECT PD.ProductId,CLND.SChalanDetailsId,CLND.SChalanId,CLND.DCStoreFreezeId,CLND.DCStoreId,CLND.ProductCode,CLND.ProductName,DS.PackSize,P.Purpose,ISNULL(P.StockConditionId,0) AS StockConditionId,
                             ST.UnitPrice,CAST((ST.VATAmount/ST.Quantity) as decimal(10,2)) AS VatPerUnit,(CLND.Quantity*ST.UnitPrice) AS TotalPrice,
                             (CAST((ST.VATAmount/ST.Quantity) as decimal(10,2))*CLND.Quantity) AS TotalVat,
                             ((CLND.Quantity*ST.UnitPrice) + (CAST((ST.VATAmount/ST.Quantity) as decimal(10,2))*CLND.Quantity)) AS TotalAmount,
                             CLND.BatchNo,CLND.Quantity,DS.ExpDate,DS.ReceiveDate,DS.MfgDate FROM tblDepotToWHChalanDetail AS CLND 
                             INNER JOIN tblDepotToWHChalanInfo AS CLN ON CLN.SChalanId = CLND.SChalanId
                             INNER JOIN dbo.tblProduct AS PD ON PD.ProductCode = CLND.ProductCode
                             INNER JOIN dbo.tblDCStore AS DS ON DS.DCStoreId = CLND.DCStoreId
                             LEFT JOIN tblStockInTransfar AS ST ON ST.StockInTransfarId = DS.StockInTransfarId 
                             LEFT JOIN tblPurpose AS P ON CLND.PurposeId = P.PurposeId WHERE CLN.IsDeliver = @IsDeliver AND CLND.SChalanId = @SChalanId";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@IsDeliver", false),
                new SqlParameter("@SChalanId", SInventorySql.DbValue(reqId))
            });
        }

        public bool CentralStorStockIn(CentralStoreDao aDcStoreFreezeDao)
        {
            string insertQuery = @"INSERT INTO dbo.tblCentralStore (ProductId,ProductCode,ProductName,PackSize,BatchNo,Quantity,MfgDate,ExpDate,ReceiveDate,ChalanNo,ChalanDate,StockInQty,UnitPrice,TotalPrice,VATPerUnit,TotalVAT,TotalAmount,StockCondition,MigoDetailID,ProductStockType, DCStoreFreezeId,DCStoreId) 
            values (@ProductId,@ProductCode,@ProductName,@PackSize,@BatchNo,@Quantity,@MfgDate,@ExpDate,@ReceiveDate,@ChalanNo,@ChalanDate,@StockInQty,@UnitPrice,@TotalPrice,@VATPerUnit,@TotalVAT,@TotalAmount,@StockCondition,@MigoDetailID,@ProductStockType,@DCStoreFreezeId,@DCStoreId)";

            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@ProductId", aDcStoreFreezeDao.ProductId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(aDcStoreFreezeDao.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(aDcStoreFreezeDao.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(aDcStoreFreezeDao.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(aDcStoreFreezeDao.BatchNo)),
                new SqlParameter("@Quantity", SInventorySql.DbValue(aDcStoreFreezeDao.Quantity)),
                new SqlParameter("@MfgDate", SInventorySql.DbValue(aDcStoreFreezeDao.MfgDate)),
                new SqlParameter("@ExpDate", SInventorySql.DbValue(aDcStoreFreezeDao.ExpDate)),
                new SqlParameter("@ReceiveDate", SInventorySql.DbValue(aDcStoreFreezeDao.ReceiveDate)),
                new SqlParameter("@ChalanNo", SInventorySql.DbValue(aDcStoreFreezeDao.ChalanNo)),
                new SqlParameter("@ChalanDate", SInventorySql.DbValue(aDcStoreFreezeDao.ChalanDate)),
                new SqlParameter("@StockInQty", SInventorySql.DbValue(aDcStoreFreezeDao.StockInQty)),
                new SqlParameter("@UnitPrice", SInventorySql.DbValue(aDcStoreFreezeDao.UnitPrice)),
                new SqlParameter("@TotalPrice", SInventorySql.DbValue(aDcStoreFreezeDao.TotalPrice)),
                new SqlParameter("@VATPerUnit", SInventorySql.DbValue(aDcStoreFreezeDao.VATPerUnit)),
                new SqlParameter("@TotalVAT", SInventorySql.DbValue(aDcStoreFreezeDao.TotalVAT)),
                new SqlParameter("@TotalAmount", SInventorySql.DbValue(aDcStoreFreezeDao.TotalAmount)),
                new SqlParameter("@StockCondition", SInventorySql.DbValue(aDcStoreFreezeDao.StockCondition)),
                new SqlParameter("@MigoDetailID", SInventorySql.DbValue(aDcStoreFreezeDao.MigoDetailID)),
                new SqlParameter("@ProductStockType", SInventorySql.DbValue(aDcStoreFreezeDao.ProductStockType)),
                new SqlParameter("@DCStoreFreezeId", SInventorySql.DbValue(aDcStoreFreezeDao.DCStoreFreezeId)),
                new SqlParameter("@DCStoreId", aDcStoreFreezeDao.DCStoreId)
            });
        }

        public bool updateChallanStatus(int scId)
        {
            string query = @"UPDATE tblDepotToWHChalanInfo SET IsDeliver=@IsDeliver WHERE SChalanId = @SChalanId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@IsDeliver", "OK"),
                new SqlParameter("@SChalanId", scId)
            });
        }
    }
}
