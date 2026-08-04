using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
namespace Library.DAL.SInventory_DAL
{
  public  class StockTransportOrderReportDAL
    {
      private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

      public DataTable CompanyInformation()
      {
          string query = @"SELECT CompanyName , Address ,ContactNo ,  FaxNo  FROM tblCompanyInfo WHERE CompanyId='1' ";
          return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
      }
      public DataTable StockTransportOrderReportMainData(string reqId)
      {
          string query = @"SELECT R.ReqId,R.ReqNo,R.ReqDate,R.IssueChalanNo,R.IssuChalanDate,WH.WearhouseCode, "+
                            " WH.WearhouseName,WH.Address AS WHAddress , "+
                            " CU.ComUnitCode,CU.ComUnitName,CU.Address AS CUAddress,R.TruckNo,R.DriverName,R.PickingNo,R.PickingDate " +
                            " FROM dbo.tblRequisition R "+
                            " LEFT JOIN dbo.tblWearhouse WH ON R.WarehouseId = WH.WearhouseId "+
                            " LEFT JOIN dbo.tblCompanyUnit CU ON R.ComUnitId=CU.ComUnitId WHERE R.ReqId=@ReqId ";
          return SInventorySql.GetDataTable(query, ReqIdParameters(reqId));
      }

      //public DataTable StockTransportOrderReportDetailData(string reqId)
      //{
      //    string query = @"SELECT RC.ReqId,RC.ProductCode,(RC.ProductName+' '+RC.PackSize) as ProductName ,RC.CaseQty,ST.BatchNo,RC.ReqQty as Quantity,ST.PriceAmount,ST.VATAmount,ST.TotalPriceAmount,ST.PickingQty  FROM dbo.tblRequsitionChild RC" +
                        
      //                    " left JOIN dbo.tblStockInTransfar ST ON RC.ReqChildId = ST.ReqChildId " +
      //                    " WHERE  RC.ReqId='" + reqId.Trim() + "' ";
      //    //string query = @"SELECT ST.ReqId,ST.ProductCode,(ST.ProductName+' '+ST.PackSize) as ProductName ,RC.CaseQty,RC.BatchNo,ST.Quantity,ST.PriceAmount,ST.VATAmount, " +
      //    //                  " ST.TotalPriceAmount,ST.PickingQty FROM dbo.tblRequsitionChild RC " +
      //    //                  " left JOIN dbo.tblStockInTransfar ST ON RC.ReqChildId = ST.ReqChildId "+
      //    //                  " WHERE  RC.ReqId='" + reqId.Trim() + "' ";
      //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
      //}
      public DataTable StockTransportOrderReportDetailData(string reqId)
      {
          string query = @"SELECT RC.ReqId,RC.ProductCode,(RC.ProductName+' '+RC.PackSize) AS ProductName ,RC.CaseQty,ST.BatchNo,ST.PickingQty AS Quantity,ST.PriceAmount,ST.VATAmount,ST.TotalPriceAmount,ST.PickingQty,PD.ProductId, SUOM.StockUOMName, ST.ExpDate 
                           FROM dbo.tblRequsitionChild RC
                           INNER JOIN dbo.tblProduct AS PD ON PD.ProductCode = RC.ProductCode
                           INNER JOIN dbo.tblStockUOM AS SUOM ON SUOM.StockUOMId = PD.StockUOMId
                           LEFT JOIN dbo.tblStockInTransfar ST ON RC.ReqChildId = ST.ReqChildId WHERE  RC.ReqId = @ReqId ";
          //string query = @"SELECT ST.ReqId,ST.ProductCode,(ST.ProductName+' '+ST.PackSize) as ProductName ,RC.CaseQty,RC.BatchNo,ST.Quantity,ST.PriceAmount,ST.VATAmount, " +
          //                  " ST.TotalPriceAmount,ST.PickingQty FROM dbo.tblRequsitionChild RC " +
          //                  " left JOIN dbo.tblStockInTransfar ST ON RC.ReqChildId = ST.ReqChildId "+
          //                  " WHERE  RC.ReqId='" + reqId.Trim() + "' ";
          return SInventorySql.GetDataTable(query, ReqIdParameters(reqId));
      }

      private static List<SqlParameter> ReqIdParameters(string reqId)
      {
          return new List<SqlParameter>
          {
              new SqlParameter("@ReqId", SInventorySql.DbValue(reqId == null ? null : reqId.Trim()))
          };
      }
    }
}
