using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class ChallanReportViewDAL
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public void WareHouseLoad(DropDownList aDownList)
        {
            string wareHouse = "select * from tblWearhouse";
            aCommonInternalDal.LoadDropDownValue(aDownList, "WearhouseName", "WearhouseId", wareHouse, "SSIDB");
        }

        public void LoadmanufacturerName(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "select * from tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }

        public void DCLoad(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitId", dc, "SSIDB");
        }

        public void ProductLoad(DropDownList aDownList)
        {
            string dc = "SELECT (ProductCode+':'+ProductName)Pro,* FROM dbo.tblProduct";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Pro", "ProductId", dc, "SSIDB");
        }

        public void SubdeportLoad(DropDownList aDownList, string ComUnitId)
        {
            string dc = "select SubDepotId, (SubDepotCode+':'+SubDepotName) as Com from dbo.tblSubDepot WHERE ComUnitId=@ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDownList, "Com", "SubDepotId", dc, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId))
            });
        }

        public void DCLoad(DropDownList aDownList, string comUnitId)
        {
            string queryStr = @"select ComUnitId, ComUnitName from tblCompanyUnit
WHERE ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDownList, "ComUnitName", "ComUnitId", queryStr, new List<SqlParameter>
            {
                new SqlParameter("@UserId", SInventorySql.DbValue(comUnitId == null ? null : comUnitId.Trim()))
            });
        }

        public bool UpdateManufacturerInfo(Requesition aRequesition)
        {
            string query = @"UPDATE tblRequisition SET ReqNo=@ReqNo,ReqDate=@ReqDate,WarehouseId=@WarehouseId,WearhouseName=@WearhouseName,
ComUnitId=@ComUnitId,ComUnitCode=@ComUnitCode,UpdateBy=@UpdateBy,UpdateDate=@UpdateDate,ComUnitName=@ComUnitName
WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, RequisitionParameters(aRequesition));
        }

        public bool SaveReuqisitionDAL(Requesition aRequesition)
        {
            string query = @"INSERT INTO dbo.tblRequisition
(ReqId,ReqNo,ReqDate,WarehouseId,WearhouseName,ComUnitId,ComUnitCode,ManufacId,EntryBy,EntryDate,ComUnitName)
VALUES (@ReqId,@ReqNo,@ReqDate,@WarehouseId,@WearhouseName,@ComUnitId,@ComUnitCode,@ManufacId,@EntryBy,@EntryDate,@ComUnitName)";
            return SInventorySql.Execute(query, RequisitionParameters(aRequesition));
        }

        public bool DeleteRequisition(string reqId)
        {
            string query = @"DELETE FROM dbo.tblRequisition WHERE ReqId=@ReqId;
DELETE FROM dbo.tblRequsitionChild WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
            });
        }

        public bool DeleteRequisitionDtls(string reqId)
        {
            string query = @"DELETE FROM dbo.tblRequsitionChild WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
            });
        }

        public bool SaveReuqisitionChildDAL(RequsitionChild aRequsitionChild)
        {
            string query = @"INSERT INTO dbo.tblRequsitionChild
(ReqChildId,ProductCode,ProductName,PackSize,ReqQty,ReqId)
VALUES (@ReqChildId,@ProductCode,@ProductName,@PackSize,@ReqQty,@ReqId)";
            return SInventorySql.Execute(query, RequisitionChildParameters(aRequsitionChild));
        }

        public DataTable GetAllNonSubmitReqDAL()
        {
            string query = @"select * from tblRequisition
LEFT JOIN dbo.tblManufacturer ON tblRequisition.ManufacId = tblManufacturer.ManufacId
where (Submit is null or Submit = '') and (CreatePicking is not null or CreatePicking != '')";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetAllNonPickReqDAL()
        {
            string query = @"select * from tblRequisition
left JOIN dbo.tblManufacturer ON tblRequisition.ManufacId = tblManufacturer.ManufacId
where CreatePicking is null or CreatePicking = ''";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetRequisitionView()
        {
            string query = @"SELECT ReqNo,ReqDate,WearhouseName,ComUnitCode,ComUnitName,SUM(ReqQty)AS Qty,dbo.tblRequisition.ReqId FROM dbo.tblRequisition
LEFT JOIN dbo.tblRequsitionChild ON dbo.tblRequisition.ReqId = dbo.tblRequsitionChild.ReqId
WHERE CreatePicking IS NULL GROUP BY ReqNo,ReqDate,WearhouseName,ComUnitCode,ComUnitName,tblRequisition.ReqId";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool UpdateSalesCenter(Requesition aCompanyUnit)
        {
            string query = @"UPDATE tblRequisition SET SubmitDate=@IssuChalanDate,PickingDate=@IssuChalanDate,IssuChalanDate=@IssuChalanDate,
DriverName=@DriverName,TruckNo=@TruckNo WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, RequisitionParameters(aCompanyUnit));
        }

        public Requesition SalesCenterEditLoad(string ComUnitId)
        {
            return LoadRequisitionIssueInfo(ComUnitId);
        }

        public Requesition CheckAlreadyDone(string ComUnitId)
        {
            return LoadRequisitionIssueInfo(ComUnitId);
        }

        public DataTable GetDataInfoByIdDAL(Int32 id)
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE ReqId=@ReqId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ReqId", id)
            });
        }

        public DataTable GetDataInfoByIdBllDtls(Int32 id)
        {
            string query = @"select ProductName,0 CStock,reqQty Quantity,* from tblRequsitionChild where ReqId=@ReqId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ReqId", id)
            });
        }

        public DataTable GetRequisitionDetailByReqIdDAL(string reqId)
        {
            string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public DataTable GetPickingDataForIssueDAL(string reqId)
        {
            string query = @"SELECT RC.*,ISNULL(VCS.TotalCurrentStockQty,0) AS CurrentStockQty,ISNULL(U.UnitPrice,0) AS ProductUnitPrice
FROM dbo.tblRequsitionChild RC
LEFT JOIN View_CentralStoreCurrentStock VCS ON RC.ProductCode=VCS.ProductCode
LEFT JOIN dbo.tblUnitPrice U ON RC.ProductCode=U.ProductCode
where VCS.StockCondition = 'Available' and ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public DataTable GetRequisitionInfoByReqIdDAL(string reqId)
        {
            string query = @"SELECT * FROM tblRequisition where ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public DataTable GetRequisitionInfofromTransferDAL(string reqId)
        {
            string query = @"SELECT ReqId FROM tblStockInTransfar where ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public DataTable ChallanExistsDAL(string reqId)
        {
            string query = @"SELECT Submit FROM tblRequisition where Submit = 'OK' and ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public bool UpdateIssueInformationOnRequisitionDAL(Requesition aRequesition)
        {
            string query = @"UPDATE tblRequisition SET Submit=@Submit,SubmitDate=@SubmitDate,IssueChalanNo=@IssueChalanNo,IssuChalanDate=@IssuChalanDate,
TruckNo=@TruckNo,DriverName=@DriverName,TotalPrice=@TotalPrice,TotalVAT=@TotalVAT,GrandTotalPrice=@GrandTotalPrice
WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, RequisitionParameters(aRequesition));
        }

        public bool UpdatePickingInformationOnRequisitionDAL(Requesition aRequesition)
        {
            string query = @"UPDATE tblRequisition SET CreatePicking=@CreatePicking,IssuChalanDate=@IssuChalanDate,IssueChalanNo=@IssueChalanNo,
SubmitDate=@SubmitDate,PickingDate=@PickingDate,Submit=@Submit,PickingNo=@PickingNo,TruckNo=@TruckNo,DriverName=@DriverName,
TotalPrice=@TotalPrice,TotalVAT=@TotalVAT,GrandTotalPrice=@GrandTotalPrice WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, RequisitionParameters(aRequesition));
        }

        public bool UpdateIssueInformationOnRequisitionChildDAL(RequsitionChild aRequsitionChild)
        {
            string query = @"UPDATE tblRequsitionChild SET IssueQty=@IssueQty,UnitPrice=@UnitPrice,PriceAmount=@PriceAmount,
VATAmount=@VATAmount,TotalPrice=@TotalPrice,IsPicking=@IsPicking,CaseQty=@CaseQty,MusakVATAmount=@MusakVATAmount,
MusakTotalPrice=@MusakTotalPrice,IsIssue='OK' WHERE ReqChildId=@ReqChildId";
            return SInventorySql.Execute(query, RequisitionChildParameters(aRequsitionChild));
        }

        public DataTable GetCurrentStockofCentralStock(string productCode)
        {
            string query = @"SELECT * FROM dbo.tblCentralStore WHERE ProductCode=@ProductCode AND Quantity>0 ORDER BY ExpDate";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(productCode == null ? null : productCode.Trim()))
            });
        }

        public bool UpdateCentralStockStockOut(decimal quantity, string receiveId)
        {
            string query = @"UPDATE dbo.tblCentralStore SET Quantity=@Quantity WHERE ReceiveId=@ReceiveId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@Quantity", quantity),
                new SqlParameter("@ReceiveId", SInventorySql.DbValue(receiveId))
            });
        }

        public bool StockInTransfarInsertDAL(StockInTransfar aStockInTransfar)
        {
            string query = @"INSERT INTO dbo.tblStockInTransfar
(StockInTransfarId,ReqId,ReqChildId,ProductCode,ProductName,PackSize,BatchNo,Quantity,UnitPrice,PriceAmount,VATAmount,TotalPriceAmount,ExpDate,MfgDate,ReceiveDate,PickingQty,ReceiveId,IsIssue)
VALUES (@StockInTransfarId,@ReqId,@ReqChildId,@ProductCode,@ProductName,@PackSize,@BatchNo,@Quantity,@UnitPrice,@PriceAmount,@VATAmount,@TotalPriceAmount,@ExpDate,@MfgDate,@ReceiveDate,@PickingQty,@ReceiveId,'OK')";
            return SInventorySql.Execute(query, StockInTransfarParameters(aStockInTransfar));
        }

        public bool ReqDetailUpdateAfterIssue(int rcId, decimal totalQuantity, decimal totalPriceAmount, decimal totalVATAmount, decimal totalPriceAmountSum)
        {
            string query = @"UPDATE dbo.tblRequsitionChild SET IssueQty=@IssueQty,PriceAmount=@PriceAmount,VATAmount=@VATAmount,TotalPrice=@TotalPrice WHERE ReqChildId=@ReqChildId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@IssueQty", totalQuantity),
                new SqlParameter("@PriceAmount", totalPriceAmount),
                new SqlParameter("@VATAmount", totalVATAmount),
                new SqlParameter("@TotalPrice", totalPriceAmountSum),
                new SqlParameter("@ReqChildId", rcId)
            });
        }

        public bool UpdateStockTransfarInfoUpdateDAL(StockInTransfar aStockInTransfar)
        {
            string query = @"UPDATE dbo.tblStockInTransfar SET Quantity=@Quantity,PriceAmount=@PriceAmount,VATAmount=@VATAmount,
TotalPriceAmount=@TotalPriceAmount,IsIssue=@IsIssue WHERE StockInTransfarId=@StockInTransfarId";
            return SInventorySql.Execute(query, StockInTransfarParameters(aStockInTransfar));
        }

        public bool UpdateReqDetailIssueStatusDAL(StockInTransfar aStockInTransfar)
        {
            string query = @"UPDATE dbo.tblRequsitionChild SET IsIssue='OK' WHERE ReqChildId=@ReqChildId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@ReqChildId", aStockInTransfar.ReqChildId)
            });
        }

        public DataTable GetAllStockRcvByDcDAL(string comUnitId)
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE Submit='OK' AND (ReceiveIssue IS NULL OR ReceiveIssue ='') AND ComUnitId=@ComUnitId";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(comUnitId))
            });
        }

        public DataTable GetStockInTransfarByReqIdDAL(string reqId)
        {
            string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE IsTransfared is null and ReqId=@ReqId";
            return ReqIdTable(query, reqId == null ? null : reqId.Trim());
        }

        public bool DCStockInDAL(DCStockNew aDcStockNew)
        {
            string query = @"INSERT INTO dbo.tblDCStore
(DCStoreId,StorageLocation,ProductCode,ProductName,PackSize,BatchNo,TotalQuantity,ExpDate,MfgDate,ReceiveDate,ChalanNo,ChalanDate,ComUnitId,StockQty,DamageQty,StockRcvDate,ReqId,ReqChildId,StockCondition,StockInTransfarId)
VALUES (@DCStoreId,@StorageLocation,@ProductCode,@ProductName,@PackSize,@BatchNo,@TotalQuantity,@ExpDate,@MfgDate,@ReceiveDate,@ChalanNo,@ChalanDate,@ComUnitId,@StockQty,@DamageQty,@StockRcvDate,@ReqId,@ReqChildId,'Available',@StockInTransfarId)";
            return SInventorySql.Execute(query, DcStockParameters(aDcStockNew));
        }

        public bool StockInTransfarStatusUpdate(string stockInTransfarId)
        {
            string query = @"UPDATE dbo.tblStockInTransfar SET IsTransfared='OK' WHERE StockInTransfarId=@StockInTransfarId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@StockInTransfarId", SInventorySql.DbValue(stockInTransfarId == null ? null : stockInTransfarId.Trim()))
            });
        }

        public bool UpdateReceiveIssueStatus(string reqId, DateTime rcvDate)
        {
            string query = @"UPDATE dbo.tblRequisition SET ReceiveIssue='OK',ReceiveIssueDate=@ReceiveIssueDate WHERE ReqId=@ReqId";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@ReceiveIssueDate", rcvDate),
                new SqlParameter("@ReqId", SInventorySql.DbValue(reqId == null ? null : reqId.Trim()))
            });
        }

        public DataTable StockTransportOrderGridDataDAL(DateTime date)
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE ReqDate=@ReqDate order by ReqId desc";
            return SInventorySql.GetDataTable(query, new List<SqlParameter> { new SqlParameter("@ReqDate", date) });
        }

        public DataTable ChallanReportDAL(DateTime date)
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE Submit='OK' AND SubmitDate=@SubmitDate order by ReqId desc";
            return SInventorySql.GetDataTable(query, new List<SqlParameter> { new SqlParameter("@SubmitDate", date) });
        }

        public DataTable ChallanReportDAL2(DateTime date, DateTime todate, string unit)
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE ComUnitId=@ComUnitId and Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate order by ReqNo asc";
            return DateRangeTable(query, date, todate, unit);
        }

        public DataTable ChallanReportDAL2(DateTime date, DateTime todate)
        {
            string query = @"SELECT * FROM dbo.tblRequisition WHERE Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate order by ReqNo asc";
            return DateRangeTable(query, date, todate, null);
        }

        public bool SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStoreFreezeDao)
        {
            string insertQuery = @"insert into tblDCStoreFreeze
(DCStoreFreezeId,StorageLocation,TotalQuantity,ProductCode,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,ChalanNo,ChalanDate,StockQty,DamageQty,StockRcvDate,StockCondition,ComUnitId,DCStoreId)
values (@DCStoreFreezeId,@StorageLocation,@TotalQuantity,@ProductCode,@ProductName,@PackSize,@BatchNo,@ExpDate,@ReceiveDate,@ChalanNo,@ChalanDate,@StockQty,@DamageQty,@StockRcvDate,@StockCondition,@ComUnitId,@DCStoreId)";
            return SInventorySql.Execute(insertQuery, DcStoreFreezeParameters(aDcStoreFreezeDao));
        }

        public DataTable DCStoreReport(string reqId)
        {
            string query = @"SELECT tblUnitPrice.UnitPrice,tblUnitPrice.VATAmountPerUnit,tblProduct.ProductName,*
FROM dbo.tblDCStore
LEFT JOIN dbo.tblCompanyUnit ON dbo.tblDCStore.ComUnitId = dbo.tblCompanyUnit.ComUnitId
LEFT JOIN dbo.tblProduct ON dbo.tblDCStore.ProductCode = dbo.tblProduct.ProductCode
LEFT JOIN dbo.tblUnitPrice ON dbo.tblDCStore.ProductCode = dbo.tblUnitPrice.ProductCode
LEFT JOIN dbo.tblStockInTransfar ON tblDCStore.StockInTransfarId = dbo.tblStockInTransfar.StockInTransfarId
LEFT JOIN dbo.tblCentralStore ON dbo.tblStockInTransfar.ReceiveId = dbo.tblCentralStore.ReceiveId
LEFT JOIN dbo.tblMIGODetail ON dbo.tblCentralStore.MigoDetailID = dbo.tblMIGODetail.MigoDetailID
WHERE tblDCStore.ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public DataTable GetStockInTransfer(string reqId)
        {
            string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId=@ReqId";
            return ReqIdTable(query, reqId);
        }

        public void SubdeportCodeLoad(DropDownList aDownList, string ComUnitId)
        {
            string dc = "select SubDepotId, (SubDepotCode+':'+SubDepotName) as Com from dbo.tblSubDepot WHERE ComUnitId=@ComUnitId";
            aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDownList, "Com", "SubDepotCode", dc, new List<SqlParameter>
            {
                new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId))
            });
        }

        public void DCCodeLoad(DropDownList aDownList)
        {
            string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
            aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitCode", dc, "SSIDB");
        }

        public DataTable ChallanDetailReportDAL2(DateTime date, DateTime todate, string unit)
        {
            string query = ChallanDetailReportQuery("WHERE ComUnitId=@ComUnitId and Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate");
            return DateRangeTable(query, date, todate, unit);
        }

        public DataTable ChallanDetailReportDAL2(DateTime date, DateTime todate)
        {
            string query = ChallanDetailReportQuery("WHERE Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate");
            return DateRangeTable(query, date, todate, null);
        }

        public DataTable ChallanSummaryReportDAL2(DateTime date, DateTime todate, string unit)
        {
            string query = ChallanSummaryReportQuery("WHERE ComUnitId=@ComUnitId and Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate");
            return DateRangeTable(query, date, todate, unit);
        }

        public DataTable ChallanSummaryReportDAL2(DateTime date, DateTime todate)
        {
            string query = ChallanSummaryReportQuery("WHERE Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate");
            return DateRangeTable(query, date, todate, null);
        }

        private Requesition LoadRequisitionIssueInfo(string reqId)
        {
            string query = @"SELECT mas.IssuChalanDate, mas.DriverName, mas.TruckNo, * FROM dbo.tblRequisition mas where mas.ReqId=@ReqId";
            DataTable table = ReqIdTable(query, reqId);
            Requesition requisition = new Requesition();
            if (table.Rows.Count == 0)
                return requisition;

            DataRow row = table.Rows[0];
            requisition.ReqId = Int32.Parse(row["ReqId"].ToString());
            requisition.DriverName = row["DriverName"].ToString();
            requisition.TruckNo = row["TruckNo"].ToString();
            requisition.IssuChalanDate = Convert.ToDateTime(row["IssuChalanDate"]);
            return requisition;
        }

        private DataTable ReqIdTable(string query, string reqId)
        {
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
            });
        }

        private DataTable DateRangeTable(string query, DateTime fromDate, DateTime toDate, string unit)
        {
            List<SqlParameter> parameters = new List<SqlParameter>
            {
                new SqlParameter("@FromDate", fromDate),
                new SqlParameter("@ToDate", toDate)
            };

            if (unit != null)
                parameters.Add(new SqlParameter("@ComUnitId", SInventorySql.DbValue(unit)));

            return SInventorySql.GetDataTable(query, parameters);
        }

        private static string ChallanDetailReportQuery(string whereClause)
        {
            return @"SELECT IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode,R.ComUnitName,P.ProductCode,P.ProductName,M.MfgDate,
T.ExpDate,T.PackSize,T.BatchNo,SUM(t.Quantity) AS TotalQuantity,T.UnitPrice,SUM(T.PriceAmount) TotalPriceAmount,UP.VATAmountPerUnit,SUM(T.VATAmount)TotalVATAmount,
SUM(TotalPriceAmount) AS TotalPriceAmountwithVat,R.ReqNo,R.ReqDate
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
" + whereClause + @"
group by IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode,R.ComUnitName,P.ProductCode,P.ProductName,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice,UP.VATAmountPerUnit,R.ReqNo,R.ReqDate
order by ReqNo asc";
        }

        private static string ChallanSummaryReportQuery(string whereClause)
        {
            return @"SELECT P.ProductCode,P.ProductName,SUM(t.Quantity) AS TotalQuantity,SUM(T.PriceAmount) TotalPriceAmount,SUM(T.VATAmount)TotalVATAmount,
SUM(TotalPriceAmount) AS TotalPriceAmountwithVat
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
" + whereClause + @"
group by P.ProductCode,P.ProductName";
        }

        private List<SqlParameter> RequisitionParameters(Requesition r)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ReqId", r.ReqId),
                new SqlParameter("@ReqNo", SInventorySql.DbValue(r.ReqNo)),
                new SqlParameter("@ReqDate", r.ReqDate),
                new SqlParameter("@WarehouseId", r.WarehouseId),
                new SqlParameter("@WearhouseName", SInventorySql.DbValue(r.WearhouseName)),
                new SqlParameter("@ComUnitId", r.ComUnitId),
                new SqlParameter("@ComUnitCode", SInventorySql.DbValue(r.ComUnitCode)),
                new SqlParameter("@ComUnitName", SInventorySql.DbValue(r.ComUnitName)),
                new SqlParameter("@Submit", SInventorySql.DbValue(r.Submit)),
                new SqlParameter("@SubmitDate", r.SubmitDate),
                new SqlParameter("@IssueChalanNo", SInventorySql.DbValue(r.IssueChalanNo)),
                new SqlParameter("@IssuChalanDate", r.IssuChalanDate),
                new SqlParameter("@TruckNo", SInventorySql.DbValue(r.TruckNo)),
                new SqlParameter("@DriverName", SInventorySql.DbValue(r.DriverName)),
                new SqlParameter("@TotalPrice", r.TotalPrice),
                new SqlParameter("@TotalVAT", r.TotalVAT),
                new SqlParameter("@GrandTotalPrice", r.GrandTotalPrice),
                new SqlParameter("@ReceiveIssue", SInventorySql.DbValue(r.ReceiveIssue)),
                new SqlParameter("@ReceiveIssueDate", r.ReceiveIssueDate),
                new SqlParameter("@CreatePicking", SInventorySql.DbValue(r.CreatePicking)),
                new SqlParameter("@PickingNo", SInventorySql.DbValue(r.PickingNo)),
                new SqlParameter("@PickingDate", r.PickingDate),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(r.EntryBy)),
                new SqlParameter("@EntryDate", r.EntryDate),
                new SqlParameter("@UpdateBy", SInventorySql.DbValue(r.UpdateBy)),
                new SqlParameter("@UpdateDate", r.UpdateDate),
                new SqlParameter("@ManufacId", r.ManufacId)
            };
        }

        private List<SqlParameter> RequisitionChildParameters(RequsitionChild c)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@ReqChildId", c.ReqChildId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(c.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(c.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(c.PackSize)),
                new SqlParameter("@ReqQty", c.ReqQty),
                new SqlParameter("@ReqId", c.ReqId),
                new SqlParameter("@IssueQty", c.IssueQty),
                new SqlParameter("@UnitPrice", c.UnitPrice),
                new SqlParameter("@PriceAmount", c.PriceAmount),
                new SqlParameter("@VATAmount", c.VATAmount),
                new SqlParameter("@TotalPrice", c.TotalPrice),
                new SqlParameter("@IsIssue", SInventorySql.DbValue(c.IsIssue)),
                new SqlParameter("@CaseQty", c.CaseQty),
                new SqlParameter("@MusakVATAmount", c.MusakVATAmount),
                new SqlParameter("@MusakTotalPrice", c.MusakTotalPrice),
                new SqlParameter("@IsPicking", SInventorySql.DbValue(c.IsPicking))
            };
        }

        private List<SqlParameter> StockInTransfarParameters(StockInTransfar s)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@StockInTransfarId", s.StockInTransfarId),
                new SqlParameter("@ReqId", s.ReqId),
                new SqlParameter("@ReqChildId", s.ReqChildId),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(s.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(s.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(s.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(s.BatchNo)),
                new SqlParameter("@Quantity", s.Quantity),
                new SqlParameter("@UnitPrice", s.UnitPrice),
                new SqlParameter("@PriceAmount", s.PriceAmount),
                new SqlParameter("@VATAmount", s.VATAmount),
                new SqlParameter("@TotalPriceAmount", s.TotalPriceAmount),
                new SqlParameter("@ExpDate", s.ExpDate),
                new SqlParameter("@MfgDate", s.MfgDate),
                new SqlParameter("@ReceiveDate", s.ReceiveDate),
                new SqlParameter("@IsTransfared", SInventorySql.DbValue(s.IsTransfared)),
                new SqlParameter("@IsIssue", SInventorySql.DbValue(s.IsIssue)),
                new SqlParameter("@PickingQty", s.PickingQty),
                new SqlParameter("@ReceiveId", s.ReceiveId)
            };
        }

        private List<SqlParameter> DcStockParameters(DCStockNew s)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@DCStoreId", s.DCStoreId),
                new SqlParameter("@StorageLocation", SInventorySql.DbValue(s.StorageLocation)),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(s.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(s.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(s.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(s.BatchNo)),
                new SqlParameter("@TotalQuantity", s.TotalQuantity),
                new SqlParameter("@ExpDate", s.ExpDate),
                new SqlParameter("@MfgDate", SInventorySql.DbValue(s.mfgdate)),
                new SqlParameter("@ReceiveDate", s.ReceiveDate),
                new SqlParameter("@ChalanNo", SInventorySql.DbValue(s.ChalanNo)),
                new SqlParameter("@ChalanDate", s.ChalanDate),
                new SqlParameter("@ComUnitId", s.ComUnitId),
                new SqlParameter("@StockQty", s.StockQty),
                new SqlParameter("@DamageQty", s.DamageQty),
                new SqlParameter("@StockRcvDate", s.StockRcvDate),
                new SqlParameter("@ReqId", SInventorySql.DbValue(s.ReqId)),
                new SqlParameter("@ReqChildId", SInventorySql.DbValue(s.ReqChildId)),
                new SqlParameter("@StockInTransfarId", SInventorySql.DbValue(s.StockInTransfarId))
            };
        }

        private List<SqlParameter> DcStoreFreezeParameters(DCStoreFreezeDAO d)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@DCStoreFreezeId", d.DCStoreFreezeId),
                new SqlParameter("@StorageLocation", SInventorySql.DbValue(d.StorageLocation)),
                new SqlParameter("@TotalQuantity", d.TotalQuantity),
                new SqlParameter("@ProductCode", SInventorySql.DbValue(d.ProductCode)),
                new SqlParameter("@ProductName", SInventorySql.DbValue(d.ProductName)),
                new SqlParameter("@PackSize", SInventorySql.DbValue(d.PackSize)),
                new SqlParameter("@BatchNo", SInventorySql.DbValue(d.BatchNo)),
                new SqlParameter("@ExpDate", d.ExpDate),
                new SqlParameter("@ReceiveDate", d.ReceiveDate),
                new SqlParameter("@ChalanNo", SInventorySql.DbValue(d.ChalanNo)),
                new SqlParameter("@ChalanDate", d.ChalanDate),
                new SqlParameter("@StockQty", d.StockQty),
                new SqlParameter("@DamageQty", d.DamageQty),
                new SqlParameter("@StockRcvDate", d.StockRcvDate),
                new SqlParameter("@StockCondition", SInventorySql.DbValue(d.StockCondition)),
                new SqlParameter("@ComUnitId", d.ComUnitId),
                new SqlParameter("@DCStoreId", d.DCStoreId)
            };
        }
    }
}
