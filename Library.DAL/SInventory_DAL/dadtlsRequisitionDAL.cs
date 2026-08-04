using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    
   public class dadtlsRequisitionDAL
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
           string dc = "select SubDepotId, (SubDepotCode+':'+SubDepotName) as Com from dbo.tblSubDepot WHERE ComUnitId='" + ComUnitId + "'";
           aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "SubDepotId", dc, "SSIDB");
       }
       public void DCLoad(DropDownList aDownList,string comUnitId)
       {

           string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                                      " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId='" + comUnitId.Trim() + "')";


           aCommonInternalDal.LoadDropDownValueWithoutDataBase(aDownList, "ComUnitName", "ComUnitId", queryStr);
       }


       public bool UpdateManufacturerInfo(dadtlsRequesition aRequesition)
       {

           string query = @"UPDATE tblRequisition SET ReqNo='" + aRequesition.ReqNo + "',ReqDate='" + aRequesition.ReqDate + "' " +


                          ", WarehouseId='" + aRequesition.WarehouseId + "'" +
                          ", WearhouseName='" + aRequesition.WearhouseName + "'" +
                          ", ComUnitId='" + aRequesition.ComUnitId + "'" +
                          ", ComUnitCode='" + aRequesition.ComUnitCode + "'" +
                          ", UpdateBy='" + aRequesition.UpdateBy + "'" +
                          ", UpdateDate='" + aRequesition.UpdateDate + "'" +
                          ", ComUnitName='" + aRequesition.ComUnitName + "'" +

                          
                          "" +

                          " WHERE ReqId=" + aRequesition.ReqId + "";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }
       public bool SaveReuqisitionDAL(dadtlsRequesition aRequesition)
       {
           string query = @" INSERT INTO dbo.tblRequisition "+
     "   ( ReqId , "+
       "    ReqNo , "+
       "    ReqDate , "+
       "    WarehouseId , "+
       "    WearhouseName , "+
      "     ComUnitId , "+
      "     ComUnitCode , " +

       "     ManufacId , " +
        "     EntryBy , " +
         "     EntryDate , " +


       "    ComUnitName , " +

     " IsFromBatch   ) " +
 "   VALUES  ( " + aRequesition.ReqId + " , " +
      "     '" + aRequesition.ReqNo + "' , " +
      "     '" + aRequesition.ReqDate + "' , " +
      "      " + aRequesition.WarehouseId + " , " +
     "       '" + aRequesition.WearhouseName + "' , " +
     "       " + aRequesition.ComUnitId + ", " +
     "      '" + aRequesition.ComUnitCode + "' , " +

         "      " + aRequesition.ManufacId + " , " +
           "      '" + aRequesition.EntryBy + "' , " +
             "      '" + aRequesition.EntryDate + "' , " +
     "       '" + aRequesition.ComUnitName + "', " +
     "       '" + aRequesition.IsFromBatch + "'      )";


           return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
       }
       public bool DeleteRequisition(string reqId)
       {
           string query = @"DELETE FROM dbo.tblRequisition WHERE ReqId='" + reqId + "'  DELETE FROM dbo.tblRequsitionChild WHERE ReqId='" + reqId + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public bool DeleteRequisitionDtls(string reqId)
       {
           string query = @"  DELETE FROM dbo.tblRequsitionChild WHERE ReqId='" + reqId + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public bool SaveReuqisitionChildDAL(dadtlsRequsitionChild aRequsitionChild)
       {
           string query = @" INSERT INTO dbo.tblRequsitionChild "+
      "  ( ReqChildId , "+
        "   ProductCode , "+
        "   ProductName , "+
         "   PackSize , " +
        "   ReqQty , "+
        "   ReqId ,"+
             "   BatchNO " +
      "   ) " +
   "   VALUES  ( " + aRequsitionChild.ReqChildId + " , " +
     "      '" + aRequsitionChild.ProductCode + "' , " +
     "      '" + aRequsitionChild.ProductName + "', " +
      "      '" + aRequsitionChild.PackSize + "', " +
     "     " + aRequsitionChild.ReqQty + " , " +
     "      " + aRequsitionChild.ReqId + " ," + "      '" + aRequsitionChild.BatchNo + "' " +
     "    )";
           return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
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
 
 WHERE ReqId ="+id;
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }

       public DataTable GetDataInfoByIdBllDtls(Int32 id)
       {
           string query = @"select ProductName,0 CStock,reqQty Quantity, * from tblRequsitionChild where ReqId=" + id;
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable GetRequisitionDetailByReqIdDAL(string reqId)
       {
           //string query = @"SELECT RC.*,ISNULL(VCS.TotalCurrentStockQty,0) AS CurrentStockQty , ISNULL(U.UnitPrice,0) AS ProductUnitPrice FROM dbo.tblRequsitionChild RC " +
           //                 " LEFT JOIN View_CentralStoreCurrentStock VCS ON RC.ProductCode=VCS.ProductCode "+
           //                 " LEFT JOIN dbo.tblUnitPrice U ON RC.ProductCode=U.ProductCode " +
           //                  " where ReqId = '" + reqId + "'";
           string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId = '" + reqId + "'";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }

       public DataTable GetPickingDataForIssueDAL(string reqId)
       {
           string query = @"SELECT RC.BatchNO BatchNO,  RC.*,ISNULL(VCS.TotalCurrentStockQty,0) AS CurrentStockQty , ISNULL(U.UnitPrice,0) AS ProductUnitPrice FROM dbo.tblRequsitionChild RC " +
                            " LEFT JOIN View_CentralStoreCurrentStock VCS ON RC.ProductCode=VCS.ProductCode " +
                            " LEFT JOIN dbo.tblUnitPrice U ON RC.ProductCode=U.ProductCode " +
                             " where VCS.StockCondition = 'Available' and ReqId = '" + reqId + "'";
           
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable GetRequisitionInfoByReqIdDAL(string reqId)
       {
           string query = @"SELECT * FROM tblRequisition " +
                            
                             " where ReqId = '" + reqId + "'";

           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable GetRequisitionInfofromTransferDAL(string reqId)
       {
           string query = @"SELECT ReqId FROM tblStockInTransfar " +

                             " where ReqId = '" + reqId + "'";

           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable ChallanExistsDAL(string reqId)
       {
           string query = @"SELECT Submit FROM tblRequisition  " +

                            // " where Submit = '" + "OK" + "'"; and 

                                   " where Submit = 'OK' and ReqId = '" + reqId + "'";

           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public bool UpdateIssueInformationOnRequisitionDAL(dadtlsRequesition aRequesition)
       {
           string query = @"UPDATE tblRequisition SET  Submit='" + aRequesition.Submit + "',SubmitDate='" + aRequesition.SubmitDate + "',IssueChalanNo='" + aRequesition.IssueChalanNo + "',IssuChalanDate='" + aRequesition.IssuChalanDate + "', " +
                           " TruckNo='" + aRequesition.TruckNo + "',DriverName='" + aRequesition.DriverName + "',TotalPrice='" + aRequesition.TotalPrice + "',TotalVAT='" + aRequesition.TotalVAT + "' ," +
                           " GrandTotalPrice='" + aRequesition.GrandTotalPrice + "' WHERE ReqId='" + aRequesition.ReqId + "'";
          

           return aCommonInternalDal.UpdateDataByUpdateCommand(query,"SSIDB");
       }

       public bool UpdatePickingInformationOnRequisitionDAL(dadtlsRequesition aRequesition)
       {
           string query = @"UPDATE tblRequisition SET  CreatePicking='" + aRequesition.CreatePicking + "',IssuChalanDate='" + aRequesition.IssuChalanDate + "',IssueChalanNo='" + aRequesition.IssueChalanNo + "',SubmitDate='" + aRequesition.SubmitDate + "',PickingDate='" + aRequesition.PickingDate + "',Submit='" + aRequesition.Submit + "',PickingNo='" + aRequesition.PickingNo + "', " +
                             " TruckNo='" + aRequesition.TruckNo + "',DriverName='" + aRequesition.DriverName + "',TotalPrice='" + aRequesition.TotalPrice + "',TotalVAT='" + aRequesition.TotalVAT + "' ," +
                             " GrandTotalPrice='" + aRequesition.GrandTotalPrice + "' WHERE ReqId='" + aRequesition.ReqId + "'";
          

           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public bool UpdateIssueInformationOnRequisitionChildDAL(dadtlsRequsitionChild aRequsitionChild)
       {
           string query = @" UPDATE tblRequsitionChild SET IssueQty='" + aRequsitionChild.IssueQty + "',UnitPrice='" + aRequsitionChild.UnitPrice + "',PriceAmount='" + aRequsitionChild.PriceAmount + "', " +
                          " VATAmount='" + aRequsitionChild.VATAmount + "',TotalPrice='" + aRequsitionChild.TotalPrice + "',IsPicking='" + aRequsitionChild.IsPicking + "',CaseQty='" + aRequsitionChild.CaseQty + "',MusakVATAmount='" + aRequsitionChild.MusakVATAmount + "',MusakTotalPrice='" + aRequsitionChild.MusakTotalPrice + "',IsIssue='OK'   WHERE ReqChildId='" + aRequsitionChild.ReqChildId + "'";

           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public DataTable GetCurrentStockofCentralStock(string productCode)
       {
           string query = @" SELECT * FROM dbo.tblCentralStore WHERE ProductCode='" + productCode.Trim() + "' AND Quantity>0 ORDER BY ExpDate ";
           return aCommonInternalDal.DataContainerDataTable(query,"SSIDB");
       }

        public DataTable GetCurrentStockofCentralStockByBatch(string productCode, string BatchNO)
        {
            string query = @" SELECT * FROM dbo.tblCentralStore WHERE ProductCode='" + productCode.Trim() + "' AND Quantity>0 and BatchNO='" + BatchNO+"'";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public bool UpdateCentralStockStockOut(decimal quantity, string receiveId)
       {
           string query = @"UPDATE dbo.tblCentralStore SET Quantity='" + quantity + "' WHERE ReceiveId='" + receiveId + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public bool StockInTransfarInsertDAL(StockInTransfar aStockInTransfar)
       {

           string query = @"INSERT INTO dbo.tblStockInTransfar "+
    "    ( StockInTransfarId , "+
        "    ReqId , "+
        "    ReqChildId , "+
        "    ProductCode , "+
        "    ProductName , "+
         "   PackSize , "+
          "   BatchNo , "+
          "  Quantity , "+
         "   UnitPrice , "+
         "   PriceAmount , "+
         "   VATAmount , "+
          "  TotalPriceAmount , "+
          "  ExpDate , "+
          "  MfgDate , " +
         "   ReceiveDate ,"+
         "   PickingQty,ReceiveId,IsIssue " +
        "  ) "+
      " VALUES  ( '" + aStockInTransfar.StockInTransfarId + "' , " +
        "    '" + aStockInTransfar.ReqId + "'  ,  " +
        "    '" + aStockInTransfar.ReqChildId + "' ,  " +
       "     '" + aStockInTransfar.ProductCode + "'  ,  " +
       "    '" + aStockInTransfar.ProductName + "'  ,  " +
       "     '" + aStockInTransfar.PackSize + "'  , " +
       "    '" + aStockInTransfar.BatchNo + "' , " +
       "     '" + aStockInTransfar.Quantity + "'  ,  " +
       "     '" + aStockInTransfar.UnitPrice + "'  ,  " +
        "    '" + aStockInTransfar.PriceAmount + "'  ,  " +
        "    '" + aStockInTransfar.VATAmount + "'  ,  " +
         "   '" + aStockInTransfar.TotalPriceAmount + "'  ,  " +
        "    '" + aStockInTransfar.ExpDate + "'  , " +
          "    '" + aStockInTransfar.MfgDate + "'  , " +
        "    '" + aStockInTransfar.ReceiveDate + "'   , " +
         "    '" + aStockInTransfar.PickingQty + "'  ,  " +
         "    '" + aStockInTransfar.ReceiveId + "'    " +
       "  ,'OK' )";

           return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
       }

       public bool ReqDetailUpdateAfterIssue(int rcId, decimal totalQuantity, decimal totalPriceAmount, decimal totalVATAmount, decimal totalPriceAmountSum)
       {
           string query = @"UPDATE dbo.tblRequsitionChild SET IssueQty='" + totalQuantity + "',PriceAmount='" + totalPriceAmount + "',VATAmount='" + totalVATAmount + "',TotalPrice='" + totalPriceAmountSum + "' WHERE ReqChildId='" + rcId.ToString() + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }
       public bool UpdateStockTransfarInfoUpdateDAL(StockInTransfar aStockInTransfar)
       {

           string query = @"UPDATE dbo.tblStockInTransfar SET Quantity='" + aStockInTransfar.Quantity + "', PriceAmount='" + aStockInTransfar.PriceAmount + "',VATAmount='" + aStockInTransfar.VATAmount + "', TotalPriceAmount='" + aStockInTransfar.TotalPriceAmount + "', IsIssue='" + aStockInTransfar.IsIssue + "' WHERE StockInTransfarId='" + aStockInTransfar.StockInTransfarId + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public bool UpdateReqDetailIssueStatusDAL(StockInTransfar aStockInTransfar)
       {
           string query = @"UPDATE dbo.tblRequsitionChild SET IsIssue='OK' WHERE ReqChildId='" + aStockInTransfar.ReqChildId + "' ";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }

       public DataTable GetAllStockRcvByDcDAL(string comUnitId)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE Submit='OK' AND (ReceiveIssue IS NULL OR ReceiveIssue ='') AND ComUnitId='" + comUnitId + "'";

           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }

       public DataTable GetStockInTransfarByReqIdDAL(string reqId)
       {
           string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE IsTransfared is null and ReqId='" + reqId.Trim() + "'";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }

       public bool DCStockInDAL(DCStockNew aDcStockNew)
       {
           string query = @"
 

INSERT INTO dbo.tblDCStore " +
      "  ( DCStoreId , "+
        "    StorageLocation , "+
        "    ProductCode , "+
        "    ProductName , "+
        "    PackSize , "+
        "    BatchNo , "+
        "    TotalQuantity , "+
        "    ExpDate , "+
          "    MfgDate , " +
        "    ReceiveDate , "+
        "    ChalanNo , "+
        "    ChalanDate , "+
         "   ComUnitId , "+
        "    StockQty , "+
        "    DamageQty , "+
        "    StockRcvDate , "+
        "    ReqId , "+
        "    ReqChildId , "+
         "    StockCondition, " +
        "    StockInTransfarId "+
       "   ) "+
       "   VALUES  ( '" + aDcStockNew.DCStoreId + "' , " +
       "     '" + aDcStockNew.StorageLocation + "' , " +
       "     '" + aDcStockNew.ProductCode + "' ,  " +
       "    '" + aDcStockNew.ProductName + "' , " +
       "    '" + aDcStockNew.PackSize + "' , " +
       "    '" + aDcStockNew.BatchNo + "' , " +
        "    '" + aDcStockNew.TotalQuantity + "' ,  " +
        "    '" + aDcStockNew.ExpDate + "' ,  " +
           "    '" + aDcStockNew.mfgdate + "' ,  " +
       "     '" + aDcStockNew.ReceiveDate + "' , " +
       "    '" + aDcStockNew.ChalanNo + "' , " +
       "    '" + aDcStockNew.ChalanDate + "', " +
       "    '" + aDcStockNew.ComUnitId + "' , " +
        "    '" + aDcStockNew.StockQty + "', " +
        "    '" + aDcStockNew.DamageQty + "' , " +
        "   '" + aDcStockNew.StockRcvDate + "' , " +
        "   '" + aDcStockNew.ReqId + "' , " +
       "    '" + aDcStockNew.ReqChildId + "', " +
          "    'Available', " +
      "      '" + aDcStockNew.StockInTransfarId + "'  " +
     "     )";
           return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
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
				   (  '"+ DCStoreId + "',       GETDATE(),     '" + Id + "',   '" + Type + "',    '" + MainQty + "'  )  ";
            return aCommonInternalDal.SaveDataByInsertCommand(query, "SSIDB");
        }

        public bool StockInTransfarStatusUpdate(string stockInTransfarId)
       {
           string query = @"UPDATE dbo.tblStockInTransfar SET IsTransfared='OK' WHERE StockInTransfarId='" + stockInTransfarId.Trim() + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }
       public bool UpdateReceiveIssueStatus(string reqId,DateTime rcvDate)
       {
           string query = @"

UPDATE dbo.tblRequisition SET ReceiveIssue='OK',ReceiveIssueDate='" + rcvDate + "' WHERE ReqId='" + reqId.Trim() + "'";
           return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
       }


       //Report Submit='OK' AND SubmitDate='" + date + "' order by ReqId desc";
       public DataTable StockTransportOrderGridDataDAL(DateTime date)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE  ReqDate='" + date + "' order by ReqId desc";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable ChallanReportDAL(DateTime date)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE  Submit='OK' AND SubmitDate='" + date + "' order by ReqId desc";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable ChallanReportDAL2(DateTime date,DateTime todate,string unit)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE ComUnitId='" + unit + "' and Submit='OK' AND SubmitDate BETWEEN '" + date + "' and '" + todate + "'   order by ReqNo asc";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable ChallanReportDAL2(DateTime date, DateTime todate)
       {
           string query = @"SELECT * FROM dbo.tblRequisition WHERE  Submit='OK' AND SubmitDate BETWEEN '" + date + "' and '" + todate + "'   order by ReqNo asc";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public bool SaveDCStoreFreeze2(DCStoreFreezeDAO aDcStoreFreezeDao)
       {
           string insertQuery = @"insert into tblDCStoreFreeze (DCStoreFreezeId,StorageLocation,TotalQuantity,ProductCode,ProductName,PackSize,BatchNo,ExpDate,ReceiveDate,ChalanNo,ChalanDate,StockQty,DamageQty,StockRcvDate,StockCondition,ComUnitId,DCStoreId) 
            values (" + aDcStoreFreezeDao.DCStoreFreezeId + ",'" + aDcStoreFreezeDao.StorageLocation + "','" + aDcStoreFreezeDao.TotalQuantity + "','" + aDcStoreFreezeDao.ProductCode + "','" + aDcStoreFreezeDao.ProductName + "','" + aDcStoreFreezeDao.PackSize + "','" + aDcStoreFreezeDao.BatchNo + "','" + aDcStoreFreezeDao.ExpDate + "','" + aDcStoreFreezeDao.ReceiveDate + "','" + aDcStoreFreezeDao.ChalanNo + "','" + aDcStoreFreezeDao.ChalanDate + "','" + aDcStoreFreezeDao.StockQty + "','" + aDcStoreFreezeDao.DamageQty + "','" + aDcStoreFreezeDao.StockRcvDate + "','" + aDcStoreFreezeDao.StockCondition + "'," + aDcStoreFreezeDao.ComUnitId + "," + aDcStoreFreezeDao.DCStoreId  + ")";

           return aCommonInternalDal.SaveDataByInsertCommand(insertQuery, "SSIDB");
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
         WHERE tblDCStore.ReqId='" + reqId + "'";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable GetStockInTransfer(string reqId)
       {
           string query = @"SELECT * FROM dbo.tblStockInTransfar WHERE ReqId='" + reqId + "'";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }



       public void SubdeportCodeLoad(DropDownList aDownList, string ComUnitId)
       {
           string dc = "select SubDepotId, (SubDepotCode+':'+SubDepotName) as Com from dbo.tblSubDepot WHERE ComUnitId='" + ComUnitId + "'";
           aCommonInternalDal.LoadDropDownValue(aDownList, "Com", "SubDepotCode", dc, "SSIDB");
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
WHERE ComUnitId='" + unit + "' and Submit='OK' AND SubmitDate BETWEEN '" + date + "' and '" + todate + "' group by IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice,UP.VATAmountPerUnit ,R.ReqNo,R.ReqDate  order by ReqNo asc";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
WHERE Submit='OK' AND SubmitDate BETWEEN '" + date + "' and '" + todate + "' group by IssueChalanNo,SubmitDate,r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice,UP.VATAmountPerUnit ,R.ReqNo,R.ReqDate  order by ReqNo asc";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
WHERE P.GroupId=1 and ComUnitId='" + unit + "' and Submit='OK' AND SubmitDate BETWEEN '" + date + "' and '" + todate + "' group by P.ProductCode,P.ProductName ";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
WHERE Submit='OK' AND SubmitDate BETWEEN '" + date + "' and '" + todate + "' group by P.ProductCode,P.ProductName ";
           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
    }
}

