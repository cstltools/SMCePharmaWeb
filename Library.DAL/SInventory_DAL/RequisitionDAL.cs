using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    
   public class RequisitionDAL
    {
       ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

       public void LoadAllInvoice(DropDownList aDownList)
       {
           string dc = " select InvoiceId,InvoiceNo from tblInvoice with (nolock) where InvoiceDate between '7/1/2020' and '7/1/2020' ";
           aCommonInternalDal.LoadDropDownValue(aDownList, "InvoiceNo", "InvoiceId", dc, "SSIDB");
       }
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
           BindDropDown(aDownList, SInventorySql.GetDataTable(dc, new List<SqlParameter>
           {
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId))
           }), "Com", "SubDepotId", true);
       }
       public void DCLoad(DropDownList aDownList,string comUnitId)
       {

           string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                                      " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";


           BindDropDown(aDownList, SInventorySql.GetDataTable(queryStr, new List<SqlParameter>
           {
               new SqlParameter("@UserId", SInventorySql.DbValue(comUnitId.Trim()))
           }), "ComUnitName", "ComUnitId", true);
       }


       public bool UpdateManufacturerInfo(Requesition aRequesition)
       {

           string query = @"UPDATE tblRequisition SET ReqNo=@ReqNo,ReqDate=@ReqDate,WarehouseId=@WarehouseId,WearhouseName=@WearhouseName,ComUnitId=@ComUnitId,ComUnitCode=@ComUnitCode,UpdateBy=@UpdateBy,UpdateDate=@UpdateDate,ComUnitName=@ComUnitName WHERE ReqId=@ReqId";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqNo", SInventorySql.DbValue(aRequesition.ReqNo)),
               new SqlParameter("@ReqDate", SInventorySql.DbValue(aRequesition.ReqDate)),
               new SqlParameter("@WarehouseId", SInventorySql.DbValue(aRequesition.WarehouseId)),
               new SqlParameter("@WearhouseName", SInventorySql.DbValue(aRequesition.WearhouseName)),
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(aRequesition.ComUnitId)),
               new SqlParameter("@ComUnitCode", SInventorySql.DbValue(aRequesition.ComUnitCode)),
               new SqlParameter("@UpdateBy", SInventorySql.DbValue(aRequesition.UpdateBy)),
               new SqlParameter("@UpdateDate", SInventorySql.DbValue(aRequesition.UpdateDate)),
               new SqlParameter("@ComUnitName", SInventorySql.DbValue(aRequesition.ComUnitName)),
               new SqlParameter("@ReqId", SInventorySql.DbValue(aRequesition.ReqId))
           });
       }
       public bool SaveReuqisitionDAL(Requesition aRequesition)
       {
           string query = @"INSERT INTO dbo.tblRequisition (ReqId,ReqNo,ReqDate,WarehouseId,WearhouseName,ComUnitId,ComUnitCode,ManufacId,EntryBy,EntryDate,ComUnitName,IsFromBatch)
                            VALUES (@ReqId,@ReqNo,@ReqDate,@WarehouseId,@WearhouseName,@ComUnitId,@ComUnitCode,@ManufacId,@EntryBy,@EntryDate,@ComUnitName,@IsFromBatch)";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(aRequesition.ReqId)),
               new SqlParameter("@ReqNo", SInventorySql.DbValue(aRequesition.ReqNo)),
               new SqlParameter("@ReqDate", SInventorySql.DbValue(aRequesition.ReqDate)),
               new SqlParameter("@WarehouseId", SInventorySql.DbValue(aRequesition.WarehouseId)),
               new SqlParameter("@WearhouseName", SInventorySql.DbValue(aRequesition.WearhouseName)),
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(aRequesition.ComUnitId)),
               new SqlParameter("@ComUnitCode", SInventorySql.DbValue(aRequesition.ComUnitCode)),
               new SqlParameter("@ManufacId", SInventorySql.DbValue(aRequesition.ManufacId)),
               new SqlParameter("@EntryBy", SInventorySql.DbValue(aRequesition.EntryBy)),
               new SqlParameter("@EntryDate", SInventorySql.DbValue(aRequesition.EntryDate)),
               new SqlParameter("@ComUnitName", SInventorySql.DbValue(aRequesition.ComUnitName)),
               new SqlParameter("@IsFromBatch", SInventorySql.DbValue(aRequesition.IsFromBatch))
           });
       }
       public bool DeleteRequisition(string reqId)
       {
           string query = @"DELETE FROM dbo.tblRequisition WHERE ReqId=@ReqId  DELETE FROM dbo.tblRequsitionChild WHERE ReqId=@ReqId";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }

       public bool DeleteRequisitionDtls(string reqId)
       {
           string query = @"  DELETE FROM dbo.tblRequsitionChild WHERE ReqId=@ReqId";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }

       public bool SaveReuqisitionChildDAL(RequsitionChild aRequsitionChild)
       {
           string query = @"INSERT INTO dbo.tblRequsitionChild (ReqChildId,ProductCode,ProductName,PackSize,ReqQty,ReqId,BatchNO)
                            VALUES (@ReqChildId,@ProductCode,@ProductName,@PackSize,@ReqQty,@ReqId,@BatchNO)";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqChildId", SInventorySql.DbValue(aRequsitionChild.ReqChildId)),
               new SqlParameter("@ProductCode", SInventorySql.DbValue(aRequsitionChild.ProductCode)),
               new SqlParameter("@ProductName", SInventorySql.DbValue(aRequsitionChild.ProductName)),
               new SqlParameter("@PackSize", SInventorySql.DbValue(aRequsitionChild.PackSize)),
               new SqlParameter("@ReqQty", SInventorySql.DbValue(aRequsitionChild.ReqQty)),
               new SqlParameter("@ReqId", SInventorySql.DbValue(aRequsitionChild.ReqId)),
               new SqlParameter("@BatchNO", SInventorySql.DbValue(aRequsitionChild.BatchNo))
           });
       }
       public DataTable GetAllNonSubmitReqDAL()
       {
           string query = @"select * from tblRequisition LEFT JOIN dbo.tblManufacturer ON tblRequisition.ManufacId = tblManufacturer.ManufacId  where (Submit is null or Submit = '') and (CreatePicking is not null or CreatePicking != '')";
           return aCommonInternalDal.DataContainerDataTable(query,"SSIDB");
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
 WHERE CreatePicking IS NULL GROUP BY ReqNo,ReqDate,WearhouseName,ComUnitCode,ComUnitName,tblRequisition.ReqId
";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }

       public DataTable GetDataInfoByIdDAL(Int32 id)
       {
           string query = @"SELECT * FROM dbo.tblRequisition
 
 WHERE ReqId =@ReqId";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", id)
           });
       }

       public DataTable GetDataInfoByIdBllDtls(Int32 id)
       {
           string query = @"select ProductName,0 CStock,reqQty Quantity, * from tblRequsitionChild where ReqId=@ReqId";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", id)
           });
       }
       public DataTable GetRequisitionDetailByReqIdDAL(string reqId)
       {
           //string query = @"SELECT RC.*,ISNULL(VCS.TotalCurrentStockQty,0) AS CurrentStockQty , ISNULL(U.UnitPrice,0) AS ProductUnitPrice FROM dbo.tblRequsitionChild RC " +
           //                 " LEFT JOIN View_CentralStoreCurrentStock VCS ON RC.ProductCode=VCS.ProductCode "+
           //                 " LEFT JOIN dbo.tblUnitPrice U ON RC.ProductCode=U.ProductCode " +
           //                  " where ReqId = '" + reqId + "'";
           string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId = @ReqId";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }

       public DataTable GetPickingDataForIssueDAL(string reqId)
       {
           string query = @"SELECT RC.BatchNO BatchNO,  RC.*,ISNULL(VCS.TotalCurrentStockQty,0) AS CurrentStockQty , ISNULL(U.UnitPrice,0) AS ProductUnitPrice FROM dbo.tblRequsitionChild RC " +
                            " LEFT JOIN View_CentralStoreCurrentStock VCS ON RC.ProductCode=VCS.ProductCode " +
                            " LEFT JOIN dbo.tblUnitPrice U ON RC.ProductCode=U.ProductCode " +
                             " where VCS.StockCondition = 'Available' and ReqId = @ReqId";
           
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }
       public DataTable GetRequisitionInfoByReqIdDAL(string reqId)
       {
           string query = @"SELECT * FROM tblRequisition " +
                            
                             " where ReqId = @ReqId";

           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }
       public DataTable GetRequisitionInfofromTransferDAL(string reqId)
       {
           string query = @"SELECT ReqId FROM tblStockInTransfar " +

                             " where ReqId = @ReqId";

           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }
       public DataTable ChallanExistsDAL(string reqId)
       {
           string query = @"SELECT Submit FROM tblRequisition  " +

                            // " where Submit = '" + "OK" + "'"; and 

                                   " where Submit = 'OK' and ReqId = @ReqId";

           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }
       public bool UpdateIssueInformationOnRequisitionDAL(Requesition aRequesition)
       {
           string query = @"UPDATE tblRequisition SET Submit=@Submit,SubmitDate=@SubmitDate,IssueChalanNo=@IssueChalanNo,IssuChalanDate=@IssuChalanDate,TruckNo=@TruckNo,DriverName=@DriverName,TotalPrice=@TotalPrice,TotalVAT=@TotalVAT,GrandTotalPrice=@GrandTotalPrice WHERE ReqId=@ReqId";
          
           return SInventorySql.Execute(query, RequisitionIssueParameters(aRequesition));
       }

       public bool UpdatePickingInformationOnRequisitionDAL(Requesition aRequesition)
       {
           string query = @"UPDATE tblRequisition SET CreatePicking=@CreatePicking,IssuChalanDate=@IssuChalanDate,IssueChalanNo=@IssueChalanNo,SubmitDate=@SubmitDate,PickingDate=@PickingDate,Submit=@Submit,PickingNo=@PickingNo,TruckNo=@TruckNo,DriverName=@DriverName,TotalPrice=@TotalPrice,TotalVAT=@TotalVAT,GrandTotalPrice=@GrandTotalPrice WHERE ReqId=@ReqId";
          
           List<SqlParameter> parameters = RequisitionIssueParameters(aRequesition);
           parameters.Add(new SqlParameter("@CreatePicking", SInventorySql.DbValue(aRequesition.CreatePicking)));
           parameters.Add(new SqlParameter("@PickingDate", SInventorySql.DbValue(aRequesition.PickingDate)));
           parameters.Add(new SqlParameter("@PickingNo", SInventorySql.DbValue(aRequesition.PickingNo)));
           return SInventorySql.Execute(query, parameters);
       }

       public bool UpdateIssueInformationOnRequisitionChildDAL(RequsitionChild aRequsitionChild)
       {
           string query = @"UPDATE tblRequsitionChild SET IssueQty=@IssueQty,UnitPrice=@UnitPrice,PriceAmount=@PriceAmount,VATAmount=@VATAmount,TotalPrice=@TotalPrice,IsPicking=@IsPicking,CaseQty=@CaseQty,MusakVATAmount=@MusakVATAmount,MusakTotalPrice=@MusakTotalPrice,IsIssue='OK' WHERE ReqChildId=@ReqChildId";

           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@IssueQty", SInventorySql.DbValue(aRequsitionChild.IssueQty)),
               new SqlParameter("@UnitPrice", SInventorySql.DbValue(aRequsitionChild.UnitPrice)),
               new SqlParameter("@PriceAmount", SInventorySql.DbValue(aRequsitionChild.PriceAmount)),
               new SqlParameter("@VATAmount", SInventorySql.DbValue(aRequsitionChild.VATAmount)),
               new SqlParameter("@TotalPrice", SInventorySql.DbValue(aRequsitionChild.TotalPrice)),
               new SqlParameter("@IsPicking", SInventorySql.DbValue(aRequsitionChild.IsPicking)),
               new SqlParameter("@CaseQty", SInventorySql.DbValue(aRequsitionChild.CaseQty)),
               new SqlParameter("@MusakVATAmount", SInventorySql.DbValue(aRequsitionChild.MusakVATAmount)),
               new SqlParameter("@MusakTotalPrice", SInventorySql.DbValue(aRequsitionChild.MusakTotalPrice)),
               new SqlParameter("@ReqChildId", SInventorySql.DbValue(aRequsitionChild.ReqChildId))
           });
       }

       public DataTable GetCurrentStockofCentralStock(string productCode)
       {
           string query = @" SELECT * FROM dbo.tblCentralStore WHERE ProductCode=@ProductCode AND Quantity>0 ORDER BY ExpDate ";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ProductCode", SInventorySql.DbValue(productCode.Trim()))
           });
       }

        public DataTable GetCurrentStockofCentralStockByBatch(string productCode, string BatchNO)
        {
            string query = @" SELECT * FROM dbo.tblCentralStore WHERE ProductCode=@ProductCode AND Quantity>0 and BatchNO=@BatchNO";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@ProductCode", SInventorySql.DbValue(productCode.Trim())),
                new SqlParameter("@BatchNO", SInventorySql.DbValue(BatchNO))
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

           string query = @"INSERT INTO dbo.tblStockInTransfar (StockInTransfarId,ReqId,ReqChildId,ProductCode,ProductName,PackSize,BatchNo,Quantity,UnitPrice,PriceAmount,VATAmount,TotalPriceAmount,ExpDate,MfgDate,ReceiveDate,PickingQty,ReceiveId,IsIssue)
                            VALUES (@StockInTransfarId,@ReqId,@ReqChildId,@ProductCode,@ProductName,@PackSize,@BatchNo,@Quantity,@UnitPrice,@PriceAmount,@VATAmount,@TotalPriceAmount,@ExpDate,@MfgDate,@ReceiveDate,@PickingQty,@ReceiveId,'OK')";

           return SInventorySql.Execute(query, StockInTransfarParameters(aStockInTransfar, true));
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

           string query = @"UPDATE dbo.tblStockInTransfar SET Quantity=@Quantity, PriceAmount=@PriceAmount,VATAmount=@VATAmount, TotalPriceAmount=@TotalPriceAmount, IsIssue=@IsIssue WHERE StockInTransfarId=@StockInTransfarId";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@Quantity", SInventorySql.DbValue(aStockInTransfar.Quantity)),
               new SqlParameter("@PriceAmount", SInventorySql.DbValue(aStockInTransfar.PriceAmount)),
               new SqlParameter("@VATAmount", SInventorySql.DbValue(aStockInTransfar.VATAmount)),
               new SqlParameter("@TotalPriceAmount", SInventorySql.DbValue(aStockInTransfar.TotalPriceAmount)),
               new SqlParameter("@IsIssue", SInventorySql.DbValue(aStockInTransfar.IsIssue)),
               new SqlParameter("@StockInTransfarId", SInventorySql.DbValue(aStockInTransfar.StockInTransfarId))
           });
       }

       public bool UpdateReqDetailIssueStatusDAL(StockInTransfar aStockInTransfar)
       {
           string query = @"UPDATE dbo.tblRequsitionChild SET IsIssue='OK' WHERE ReqChildId=@ReqChildId ";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqChildId", SInventorySql.DbValue(aStockInTransfar.ReqChildId))
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
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId.Trim()))
           });
       }

       public bool DCStockInDAL(DCStockNew aDcStockNew)
       {
           string query = @"
 

INSERT INTO dbo.tblDCStore (DCStoreId,StorageLocation,ProductCode,ProductName,PackSize,BatchNo,TotalQuantity,ExpDate,MfgDate,ReceiveDate,ChalanNo,ChalanDate,ComUnitId,StockQty,DamageQty,StockRcvDate,ReqId,ReqChildId,StockCondition,StockInTransfarId)
VALUES (@DCStoreId,@StorageLocation,@ProductCode,@ProductName,@PackSize,@BatchNo,@TotalQuantity,@ExpDate,@MfgDate,@ReceiveDate,@ChalanNo,@ChalanDate,@ComUnitId,@StockQty,@DamageQty,@StockRcvDate,@ReqId,@ReqChildId,'Available',@StockInTransfarId)";
           return SInventorySql.Execute(query, DcStockParameters(aDcStockNew));
       }


        public bool DCStockInTransDAL(int DCStoreId, int Id, string Type, decimal MainQty)
        {
            string query = @"	INSERT INTO dbo.tblDCStoreTransaction
				   (
				       DCStoreId,
				       Date,
				       Id,
				       Type,
				       Quantity
				   )
				   VALUES
				   (  @DCStoreId,       GETDATE(),     @Id,   @Type,    @Quantity  )  ";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@DCStoreId", DCStoreId),
                new SqlParameter("@Id", Id),
                new SqlParameter("@Type", SInventorySql.DbValue(Type)),
                new SqlParameter("@Quantity", MainQty)
            });
        }

        public bool StockInTransfarStatusUpdate(string stockInTransfarId)
       {
           string query = @"UPDATE dbo.tblStockInTransfar SET IsTransfared='OK' WHERE StockInTransfarId=@StockInTransfarId";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@StockInTransfarId", SInventorySql.DbValue(stockInTransfarId.Trim()))
           });
       }
       public bool UpdateReceiveIssueStatus(string reqId,DateTime rcvDate)
       {
           string query = @"

UPDATE dbo.tblRequisition SET ReceiveIssue='OK',ReceiveIssueDate=@ReceiveIssueDate WHERE ReqId=@ReqId";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@ReceiveIssueDate", rcvDate),
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId.Trim()))
           });
       }


       //Report Submit='OK' AND SubmitDate='" + date + "' order by ReqId desc";
       public DataTable StockTransportOrderGridDataDAL(DateTime date)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE  ReqDate=@ReqDate order by ReqId desc";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqDate", date)
           });
       }
       public DataTable ChallanReportDAL(DateTime date)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE  Submit='OK' AND SubmitDate=@SubmitDate order by ReqId desc";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@SubmitDate", date)
           });
       }
       public DataTable ChallanReportDAL2(DateTime date,DateTime todate,string unit)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE ComUnitId=@ComUnitId and Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate   order by ReqNo asc";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(unit)),
               new SqlParameter("@FromDate", date),
               new SqlParameter("@ToDate", todate)
           });
       }
       public DataTable ChallanReportDAL2(DateTime date, DateTime todate)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE  Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate   order by ReqNo asc";
           return SInventorySql.GetDataTable(query, DateRangeParameters(date, todate));
       }
       public bool SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStoreFreezeDao)
       {
           string insertQuery = @"insert into tblDCStoreFreeze (DCStoreFreezeId,StorageLocation,TotalQuantity,ProductCode,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,ChalanNo,ChalanDate,StockQty,DamageQty,StockRcvDate,StockCondition,ComUnitId,DCStoreId) 
            values (@DCStoreFreezeId,@StorageLocation,@TotalQuantity,@ProductCode,@ProductName,@PackSize,@BatchNo,@ExpDate,@ReceiveDate,@ChalanNo,@ChalanDate,@StockQty,@DamageQty,@StockRcvDate,@StockCondition,@ComUnitId,@DCStoreId)";

           return SInventorySql.Execute(insertQuery, new List<SqlParameter>
           {
               new SqlParameter("@DCStoreFreezeId", SInventorySql.DbValue(aDcStoreFreezeDao.DCStoreFreezeId)),
               new SqlParameter("@StorageLocation", SInventorySql.DbValue(aDcStoreFreezeDao.StorageLocation)),
               new SqlParameter("@TotalQuantity", SInventorySql.DbValue(aDcStoreFreezeDao.TotalQuantity)),
               new SqlParameter("@ProductCode", SInventorySql.DbValue(aDcStoreFreezeDao.ProductCode)),
               new SqlParameter("@ProductName", SInventorySql.DbValue(aDcStoreFreezeDao.ProductName)),
               new SqlParameter("@PackSize", SInventorySql.DbValue(aDcStoreFreezeDao.PackSize)),
               new SqlParameter("@BatchNo", SInventorySql.DbValue(aDcStoreFreezeDao.BatchNo)),
               new SqlParameter("@ExpDate", SInventorySql.DbValue(aDcStoreFreezeDao.ExpDate)),
               new SqlParameter("@ReceiveDate", SInventorySql.DbValue(aDcStoreFreezeDao.ReceiveDate)),
               new SqlParameter("@ChalanNo", SInventorySql.DbValue(aDcStoreFreezeDao.ChalanNo)),
               new SqlParameter("@ChalanDate", SInventorySql.DbValue(aDcStoreFreezeDao.ChalanDate)),
               new SqlParameter("@StockQty", SInventorySql.DbValue(aDcStoreFreezeDao.StockQty)),
               new SqlParameter("@DamageQty", SInventorySql.DbValue(aDcStoreFreezeDao.DamageQty)),
               new SqlParameter("@StockRcvDate", SInventorySql.DbValue(aDcStoreFreezeDao.StockRcvDate)),
               new SqlParameter("@StockCondition", SInventorySql.DbValue(aDcStoreFreezeDao.StockCondition)),
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(aDcStoreFreezeDao.ComUnitId)),
               new SqlParameter("@DCStoreId", SInventorySql.DbValue(aDcStoreFreezeDao.DCStoreId))
           });
       }
       ///////////////////////////////////////////////////////////////////////////////
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
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }
       public DataTable GetStockInTransfer(string reqId)
       {
           string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId=@ReqId";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ReqId", SInventorySql.DbValue(reqId))
           });
       }



       public void SubdeportCodeLoad(DropDownList aDownList, string ComUnitId)
       {
           string dc = "select SubDepotId, (SubDepotCode+':'+SubDepotName) as Com from dbo.tblSubDepot WHERE ComUnitId=@ComUnitId";
           BindDropDown(aDownList, SInventorySql.GetDataTable(dc, new List<SqlParameter>
           {
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(ComUnitId))
           }), "Com", "SubDepotCode", true);
       }
       public void DCCodeLoad(DropDownList aDownList)
       {
           string dc = "select ComUnitId, (ComUnitCode+':'+ComUnitName) as Com from dbo.tblCompanyUnit";
           aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "ComUnitCode", dc, "SSIDB");
       }
       public DataTable ChallanDetailReportDAL2(DateTime date, DateTime todate, string unit)
       {
           string query = @"SELECT IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,
T.ExpDate,T.PackSize,T.BatchNo,SUM(t.Quantity) AS TotalQuantity,T.UnitPrice,SUM(T.PriceAmount) TotalPriceAmount,UP.VATAmountPerUnit,SUM(T.VATAmount)TotalVATAmount 
,SUM(TotalPriceAmount) AS TotalPriceAmountwithVat,R.ReqNo,R.ReqDate
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
WHERE ComUnitId=@ComUnitId and Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate group by IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice,UP.VATAmountPerUnit ,R.ReqNo,R.ReqDate  order by ReqNo asc";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(unit)),
               new SqlParameter("@FromDate", date),
               new SqlParameter("@ToDate", todate)
           });
       }
       public DataTable ChallanDetailReportDAL2(DateTime date, DateTime todate)
       {
           string query = @"SELECT IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,
T.ExpDate,T.PackSize,T.BatchNo,SUM(t.Quantity) AS TotalQuantity,T.UnitPrice,SUM(T.PriceAmount) TotalPriceAmount,UP.VATAmountPerUnit,SUM(T.VATAmount)TotalVATAmount 
,SUM(TotalPriceAmount) AS TotalPriceAmountwithVat,R.ReqNo,R.ReqDate
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
WHERE Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate group by IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice,UP.VATAmountPerUnit ,R.ReqNo,R.ReqDate  order by ReqNo asc";
           return SInventorySql.GetDataTable(query, DateRangeParameters(date, todate));
       }
        ///////////////////////////////////////////////////////////////////////////////
       public DataTable ChallanSummaryReportDAL2(DateTime date, DateTime todate, string unit)
       {
           string query = @"SELECT P.ProductCode,P.ProductName ,SUM(t.Quantity) AS TotalQuantity,SUM(T.PriceAmount) TotalPriceAmount,SUM(T.VATAmount)TotalVATAmount 
,SUM(TotalPriceAmount) AS TotalPriceAmountwithVat
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
WHERE P.GroupId=1 and ComUnitId=@ComUnitId and Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate group by P.ProductCode,P.ProductName ";
           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(unit)),
               new SqlParameter("@FromDate", date),
               new SqlParameter("@ToDate", todate)
           });
       }
       public DataTable ChallanSummaryReportDAL2(DateTime date, DateTime todate)
       {
           string query = @"SELECT P.ProductCode,P.ProductName ,SUM(t.Quantity) AS TotalQuantity,SUM(T.PriceAmount) TotalPriceAmount,SUM(T.VATAmount)TotalVATAmount 
,SUM(TotalPriceAmount) AS TotalPriceAmountwithVat
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
WHERE Submit='OK' AND SubmitDate BETWEEN @FromDate and @ToDate group by P.ProductCode,P.ProductName ";
           return SInventorySql.GetDataTable(query, DateRangeParameters(date, todate));
       }

       private static void BindDropDown(DropDownList dropDownList, DataTable dataTable, string textField, string valueField, bool insertDefault)
       {
           dropDownList.DataSource = dataTable;
           dropDownList.DataTextField = textField;
           dropDownList.DataValueField = valueField;
           dropDownList.DataBind();
           if (insertDefault)
           {
               dropDownList.Items.Insert(0, new ListItem("--------Select---------", string.Empty));
           }
       }

       private static List<SqlParameter> DateRangeParameters(DateTime fromDate, DateTime toDate)
       {
           return new List<SqlParameter>
           {
               new SqlParameter("@FromDate", fromDate),
               new SqlParameter("@ToDate", toDate)
           };
       }

       private static List<SqlParameter> RequisitionIssueParameters(Requesition requisition)
       {
           return new List<SqlParameter>
           {
               new SqlParameter("@Submit", SInventorySql.DbValue(requisition.Submit)),
               new SqlParameter("@SubmitDate", SInventorySql.DbValue(requisition.SubmitDate)),
               new SqlParameter("@IssueChalanNo", SInventorySql.DbValue(requisition.IssueChalanNo)),
               new SqlParameter("@IssuChalanDate", SInventorySql.DbValue(requisition.IssuChalanDate)),
               new SqlParameter("@TruckNo", SInventorySql.DbValue(requisition.TruckNo)),
               new SqlParameter("@DriverName", SInventorySql.DbValue(requisition.DriverName)),
               new SqlParameter("@TotalPrice", SInventorySql.DbValue(requisition.TotalPrice)),
               new SqlParameter("@TotalVAT", SInventorySql.DbValue(requisition.TotalVAT)),
               new SqlParameter("@GrandTotalPrice", SInventorySql.DbValue(requisition.GrandTotalPrice)),
               new SqlParameter("@ReqId", SInventorySql.DbValue(requisition.ReqId))
           };
       }

       private static List<SqlParameter> StockInTransfarParameters(StockInTransfar stockInTransfar, bool includeInsertFields)
       {
           return new List<SqlParameter>
           {
               new SqlParameter("@StockInTransfarId", SInventorySql.DbValue(stockInTransfar.StockInTransfarId)),
               new SqlParameter("@ReqId", SInventorySql.DbValue(stockInTransfar.ReqId)),
               new SqlParameter("@ReqChildId", SInventorySql.DbValue(stockInTransfar.ReqChildId)),
               new SqlParameter("@ProductCode", SInventorySql.DbValue(stockInTransfar.ProductCode)),
               new SqlParameter("@ProductName", SInventorySql.DbValue(stockInTransfar.ProductName)),
               new SqlParameter("@PackSize", SInventorySql.DbValue(stockInTransfar.PackSize)),
               new SqlParameter("@BatchNo", SInventorySql.DbValue(stockInTransfar.BatchNo)),
               new SqlParameter("@Quantity", SInventorySql.DbValue(stockInTransfar.Quantity)),
               new SqlParameter("@UnitPrice", SInventorySql.DbValue(stockInTransfar.UnitPrice)),
               new SqlParameter("@PriceAmount", SInventorySql.DbValue(stockInTransfar.PriceAmount)),
               new SqlParameter("@VATAmount", SInventorySql.DbValue(stockInTransfar.VATAmount)),
               new SqlParameter("@TotalPriceAmount", SInventorySql.DbValue(stockInTransfar.TotalPriceAmount)),
               new SqlParameter("@ExpDate", SInventorySql.DbValue(stockInTransfar.ExpDate)),
               new SqlParameter("@MfgDate", SInventorySql.DbValue(stockInTransfar.MfgDate)),
               new SqlParameter("@ReceiveDate", SInventorySql.DbValue(stockInTransfar.ReceiveDate)),
               new SqlParameter("@PickingQty", SInventorySql.DbValue(stockInTransfar.PickingQty)),
               new SqlParameter("@ReceiveId", SInventorySql.DbValue(stockInTransfar.ReceiveId))
           };
       }

       private static List<SqlParameter> DcStockParameters(DCStockNew dcStock)
       {
           return new List<SqlParameter>
           {
               new SqlParameter("@DCStoreId", SInventorySql.DbValue(dcStock.DCStoreId)),
               new SqlParameter("@StorageLocation", SInventorySql.DbValue(dcStock.StorageLocation)),
               new SqlParameter("@ProductCode", SInventorySql.DbValue(dcStock.ProductCode)),
               new SqlParameter("@ProductName", SInventorySql.DbValue(dcStock.ProductName)),
               new SqlParameter("@PackSize", SInventorySql.DbValue(dcStock.PackSize)),
               new SqlParameter("@BatchNo", SInventorySql.DbValue(dcStock.BatchNo)),
               new SqlParameter("@TotalQuantity", SInventorySql.DbValue(dcStock.TotalQuantity)),
               new SqlParameter("@ExpDate", SInventorySql.DbValue(dcStock.ExpDate)),
               new SqlParameter("@MfgDate", SInventorySql.DbValue(dcStock.mfgdate)),
               new SqlParameter("@ReceiveDate", SInventorySql.DbValue(dcStock.ReceiveDate)),
               new SqlParameter("@ChalanNo", SInventorySql.DbValue(dcStock.ChalanNo)),
               new SqlParameter("@ChalanDate", SInventorySql.DbValue(dcStock.ChalanDate)),
               new SqlParameter("@ComUnitId", SInventorySql.DbValue(dcStock.ComUnitId)),
               new SqlParameter("@StockQty", SInventorySql.DbValue(dcStock.StockQty)),
               new SqlParameter("@DamageQty", SInventorySql.DbValue(dcStock.DamageQty)),
               new SqlParameter("@StockRcvDate", SInventorySql.DbValue(dcStock.StockRcvDate)),
               new SqlParameter("@ReqId", SInventorySql.DbValue(dcStock.ReqId)),
               new SqlParameter("@ReqChildId", SInventorySql.DbValue(dcStock.ReqChildId)),
               new SqlParameter("@StockInTransfarId", SInventorySql.DbValue(dcStock.StockInTransfarId))
           };
       }
    }
}
