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
    public class StockConditionFreezeDAL
    {
        ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public DataTable LoadStockDCData(int ComUnitId)
        {
            string query = @"SELECT tblDCStore.*,DCStoreId AS nomanslandID, tblDCStore.ProductCode,tblDCStore.ProductName,tblDCStore.BatchNo,ExpDate,ReceiveDate,TotalQuantity,StockQty,tblUnitPrice.UnitPrice*StockQty AS Amount,StockCondition FROM dbo.tblDCStore
                              INNER JOIN dbo.tblUnitPrice ON tblDCStore.ProductCode = tblUnitPrice.ProductCode        
                                where  StockQty>0 and   StockCondition = 'Available' AND ComUnitId= @ComUnitId   order by tblDCStore.ProductName asc";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", ComUnitId)
            });
        }
        public DataTable LoadStockStockQtyDCData(int DCStoreId)
        {
            string query = @"SELECT tblDCStore.*,DCStoreId AS nomanslandID, tblDCStore.ProductCode,tblDCStore.ProductName,tblDCStore.BatchNo,ExpDate,ReceiveDate,TotalQuantity,StockQty,tblUnitPrice.UnitPrice*StockQty AS Amount,StockCondition FROM dbo.tblDCStore
                              INNER JOIN dbo.tblUnitPrice ON tblDCStore.ProductCode = tblUnitPrice.ProductCode        
                                where StockCondition = 'Available' AND DCStoreId= @DCStoreId";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DCStoreId", DCStoreId)
            });
        }
        public void LoadStockConditionBll(DropDownList aDownList, string userid)
        {
            //string StockCondition = "select * from tblStockCondition WHERE StockCondition<>'Available'";
            string StockCondition = "select * from tblStockCondition WHERE StockCondition<>'Available' AND StockConId IN (SELECT StockConId FROM tblStockConditionPermission where Permission=1 AND UserId=@UserId)";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDownList, "StockCondition", "StockConId", StockCondition, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(userid))
            });
        }
        public DataTable LoadWHData()
        {
            string query = @"SELECT  tblCentralStore.*,ReceiveId AS nomanslandID,tblCentralStore.ProductCode,tblCentralStore.ProductName,tblCentralStore.BatchNo,ExpDate,ReceiveDate,StockInQty AS TotalQuantity,Quantity AS StockQty,tblUnitPrice.UnitPrice*Quantity AS Amount,StockCondition
                           FROM dbo.tblCentralStore INNER JOIN dbo.tblUnitPrice ON tblCentralStore.ProductCode = tblUnitPrice.ProductCode        
                           where StockCondition = 'Available' ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadWHData(int ReceiveId)
        {
            string query = @"SELECT  tblCentralStore.*,ReceiveId AS nomanslandID,tblCentralStore.ProductCode,tblCentralStore.ProductName,tblCentralStore.BatchNo,ExpDate,ReceiveDate,StockInQty AS TotalQuantity,Quantity AS StockQty,tblUnitPrice.UnitPrice*Quantity AS Amount,StockCondition
                           FROM dbo.tblCentralStore INNER JOIN dbo.tblUnitPrice ON tblCentralStore.ProductCode = tblUnitPrice.ProductCode        
                           where StockCondition = 'Available' AND ReceiveId= @ReceiveId";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ReceiveId", ReceiveId)
            });
        }

        public bool SaveforWH(StockConditionFreezeDAO aStockConditionFreezeDAO)
        {
            string insertQuery = @"insert into tblStockConditionFreeze (StockConditionFreezeID,ReceiveId,ManufacId,FreezeQty,EntryBy,EntryDate) 
            values (@StockConditionFreezeID,@ReceiveId,@ManufacId,@FreezeQty,@EntryBy,@EntryDate)";

            return SInventorySql.Execute(insertQuery, StockConditionFreezeParameters(aStockConditionFreezeDAO));
        }
        public bool SaveforDC(StockConditionFreezeDAO aStockConditionFreezeDAO)
        {
            string insertQuery = @"insert into tblStockConditionFreeze (StockConditionFreezeID,DCStoreId,ManufacId,FreezeQty,EntryBy,EntryDate) 
            values (@StockConditionFreezeID,@DCStoreId,@ManufacId,@FreezeQty,@EntryBy,@EntryDate)";

            return SInventorySql.Execute(insertQuery, StockConditionFreezeParameters(aStockConditionFreezeDAO));
        }
        public bool UpdateCentralStore(decimal StockQty, int ReceiveId)
        {
            string query = @"UPDATE tblCentralStore SET Quantity=@StockQty WHERE ReceiveId=@ReceiveId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", StockQty),
                new SqlParameter("@ReceiveId", ReceiveId)
            });
        }
        public bool UpdateDCStore(decimal StockQty, int DCStoreId)
        {
            string query = @"UPDATE tblDCStore SET StockQty=@StockQty WHERE DCStoreId=@DCStoreId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockQty", StockQty),
                new SqlParameter("@DCStoreId", DCStoreId)
            });
        }
        //SC Picking Generate Page

        public DataTable LoadInvoice(int ComUnitId, int ManufId, int marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
        FROM tblInvoice I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
                    INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode        
        where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and tblMarket.MarketId=@MarketId and InvoiceDate=@InvoiceDate order by OrderNo";

            return SInventorySql.GetDataTable(query, InvoiceFilterParameters(ComUnitId, ManufId, marketid, invDate));
        }

        public DataTable LoadInvoice2(int ComUnitId, int ManufId, int marketid, DateTime invDate, string terr)
        {
            List<SqlParameter> parameters = InvoiceFilterParameters(ComUnitId, ManufId, marketid, invDate);
            string areaFilter = string.Empty;
            if (terr != "" && terr != "--------Select---------")
            {
                areaFilter = " and I.AreaCode=@AreaCode";
                parameters.Add(new SqlParameter("@AreaCode", SInventorySql.DbValue(terr)));
            }

            string query = @"SELECT  * 				
        FROM tblInvoice I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
                    INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode        
        where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and tblMarket.MarketId=@MarketId" + areaFilter + " and InvoiceDate=@InvoiceDate order by OrderNo";

            return SInventorySql.GetDataTable(query, parameters);
        }


        public DataTable LoadInvoiceNew(string Dcid, string invDate, string Route)
        {
            string query = @"SELECT  ord.TerritoryCode_Ord  + ' : ' +ord.TerritoryName_Ord areacode,tblD.ManufacId as TpGrandTotal,  * 				
        FROM tblInvoice I with (nolock)
        INNER JOIN (SELECT DISTINCT D.InvoiceId, sum(NetAmount)ManufacId FROM dbo.tblInvoice I  with (nolock)
                    INNER JOIN dbo.tblInvoiceDetail D  with (nolock) ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P  with (nolock) ON D.ProductCode = P.ProductCode
                    group by  D.InvoiceId   ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.tblCustMaster C  with (nolock) ON I.CustomerMasterId = C.CustomerMasterId

         INNER JOIN dbo.tblOrder ord  with (nolock) ON I.OrderId = ord.OrderId    
        where I.ComUnitId= @ComUnitId and ord.DistributionRouteId=@DistributionRouteId  and CONVERT(DATE,InvoiceDate)=@InvoiceDate order by OrderNo";

            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(Dcid)),
                new SqlParameter("@DistributionRouteId", SInventorySql.DbValue(Route)),
                new SqlParameter("@InvoiceDate", SInventorySql.DbValue(invDate))
            });
        }

        public DataTable LoadInvoiceSubdeport(int ComUnitId, int ManufId, int marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
        FROM tblSubInvoiceMaster I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
                    INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode     
        where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and tblMarket.MarketId=@MarketId and InvoiceDate=@InvoiceDate order by OrderNo";

            return SInventorySql.GetDataTable(query, InvoiceFilterParameters(ComUnitId, ManufId, marketid, invDate));
        }

        public bool SaveDCStoreFreeze(DCStoreFreezeDAO aDcStoreFreezeDao)
        {
            string insertQuery = @"insert into tblDCStoreFreeze (DCStoreFreezeId,StorageLocation,TotalQuantity,ProductCode,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,ChalanNo,ChalanDate,StockQty,DamageQty,StockRcvDate,StockCondition,Remarks,ReceiveId,StockConditionFreezeID) 
            values (@DCStoreFreezeId,@StorageLocation,@TotalQuantity,@ProductCode,@ProductName,@PackSize,@BatchNo,@ExpDate,@ReceiveDate,@ChalanNo,@ChalanDate,@StockQty,@DamageQty,@StockRcvDate,@StockCondition,@Remarks,@ReceiveId,@StockConditionFreezeID)";

            return SInventorySql.Execute(insertQuery, DcStoreFreezeParameters(aDcStoreFreezeDao));
        }

        public bool SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStoreFreezeDao)
        {
            string insertQuery = @"insert into tblDCStoreFreeze (DCStoreFreezeId,StorageLocation,TotalQuantity,ProductCode,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,ChalanNo,ChalanDate,StockQty,DamageQty,StockRcvDate,StockCondition,Remarks,ComUnitId,DCStoreId,StockConditionFreezeID) 
            values (@DCStoreFreezeId,@StorageLocation,@TotalQuantity,@ProductCode,@ProductName,@PackSize,@BatchNo,@ExpDate,@ReceiveDate,@ChalanNo,@ChalanDate,@StockQty,@DamageQty,@StockRcvDate,@StockCondition,@Remarks,@ComUnitId,@DCStoreId,@StockConditionFreezeID)";

            return SInventorySql.Execute(insertQuery, DcStoreFreezeParameters(aDcStoreFreezeDao));
        }
        public void LoadPendingTerritory(DropDownList ddl, int ComUnitId, int ManufId, int marketid, string invDate)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

            string queryStr = @"SELECT  Distinct I.AreaCode 				
        FROM tblInvoice I
        INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
                    INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
                    INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode
                    ) as tblD ON I.InvoiceId = tblD.InvoiceId  
         INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId
         INNER JOIN dbo.tblMarket ON C.MarketCode=dbo.tblMarket.MarketCode        
        where I.ComUnitId= @ComUnitId and tblD.ManufacId=@ManufacId and tblMarket.MarketId=@MarketId and InvoiceDate=@InvoiceDate ";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaCode", "AreaCode", queryStr, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", ComUnitId),
                new SqlParameter("@ManufacId", ManufId),
                new SqlParameter("@MarketId", marketid),
                new SqlParameter("@InvoiceDate", SInventorySql.DbValue(invDate))
            });
        }

        private static List<SqlParameter> StockConditionFreezeParameters(StockConditionFreezeDAO stockConditionFreeze)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@StockConditionFreezeID", stockConditionFreeze.StockConditionFreezeID),
                new SqlParameter("@ReceiveId", stockConditionFreeze.ReceiveId),
                new SqlParameter("@DCStoreId", stockConditionFreeze.DCStoreId),
                new SqlParameter("@ManufacId", stockConditionFreeze.ManufacId),
                new SqlParameter("@FreezeQty", stockConditionFreeze.FreezeQty),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(stockConditionFreeze.EntryBy)),
                new SqlParameter("@EntryDate", stockConditionFreeze.EntryDate)
            };
        }

        private static List<SqlParameter> InvoiceFilterParameters(int comUnitId, int manufId, int marketId, DateTime invoiceDate)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", comUnitId),
                new SqlParameter("@ManufacId", manufId),
                new SqlParameter("@MarketId", marketId),
                new SqlParameter("@InvoiceDate", invoiceDate)
            };
        }

        private static List<SqlParameter> DcStoreFreezeParameters(DCStoreFreezeDAO dcStoreFreeze)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@DCStoreFreezeId", dcStoreFreeze.DCStoreFreezeId),
                new SqlParameter("@StorageLocation", SInventorySql.DbValue(dcStoreFreeze.StorageLocation)),
                new SqlParameter("@TotalQuantity", dcStoreFreeze.TotalQuantity),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(dcStoreFreeze.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(dcStoreFreeze.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(dcStoreFreeze.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(dcStoreFreeze.BatchNo)),
                new SqlParameter("@ExpDate", dcStoreFreeze.ExpDate),
                new SqlParameter("@ReceiveDate", dcStoreFreeze.ReceiveDate),
                new SqlParameter("@ChalanNo", SInventorySql.DbValue(dcStoreFreeze.ChalanNo)),
                new SqlParameter("@ChalanDate", dcStoreFreeze.ChalanDate),
                new SqlParameter("@StockQty", dcStoreFreeze.StockQty),
                new SqlParameter("@DamageQty", dcStoreFreeze.DamageQty),
                new SqlParameter("@StockRcvDate", dcStoreFreeze.StockRcvDate),
                new SqlParameter("@StockCondition", SInventorySql.DbValue(dcStoreFreeze.StockCondition)),
                new SqlParameter("@Remarks", SInventorySql.DbValue(dcStoreFreeze.remarks)),
                new SqlParameter("@ReceiveId", dcStoreFreeze.ReceiveId),
                new SqlParameter("@ComUnitId", dcStoreFreeze.ComUnitId),
                new SqlParameter("@DCStoreId", dcStoreFreeze.DCStoreId),
                new SqlParameter("@StockConditionFreezeID", dcStoreFreeze.StockConditionFreezeID)
            };
        }
    }
}
 //public void LoadTerritory(DropDownList ddl)
 //       {
 //           ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
 //           string queryStr = "select * from tblArea";
 //           aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaCode", "AreaId", queryStr);
 //       }
