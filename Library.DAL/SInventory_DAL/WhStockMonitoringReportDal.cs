using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class WhStockMonitoringReportDal
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetWhStokMonitoringInformation(DateTime fromDate, DateTime toDate)
        {
            string query = "SELECT P.ProductCode,P.ProductName,ISNULL(vTblCSSIN.StockInQty,0)StockInQty,ISNULL(vTblCSOB.Quantity,0)OpeningStockQty,ISNULL(vTblCSOB.OpAmount,0)OpAmount,ISNULL(vTblIssue.IssueQty,0)IssueQty,((ISNULL(vTblCSOB.Quantity,0)+ISNULL(vTblCSSIN.StockInQty,0))-ISNULL(vTblIssue.IssueQty,0)) ClosingBal,ISNULL(Vtblsale.saleQty,0) as saleQty ,ISNULL(Vtblsale.saleAmount,0) as saleAmount , 0 as ClosingAmount FROM dbo.tblProduct P  with(nolock) LEFT JOIN (SELECT ProductCode,SUM(Quantity)Quantity,(sum(Quantity)*UnitPrice) as OpAmount FROM dbo.tblCentralStore_OpeninigBalance  with(nolock) WHERE CSOpeninigBalanceDate='" + fromDate + "' GROUP BY ProductCode,UnitPrice) vTblCSOB ON vTblCSOB.ProductCode = P.ProductCode LEFT JOIN (SELECT ProductCode,SUM(StockInQty)StockInQty FROM dbo.tblCentralStore  with(nolock) WHERE ReceiveDate BETWEEN '" + fromDate + "' AND '" + toDate + "' GROUP BY ProductCode) vTblCSSIN ON vTblCSSIN.ProductCode = P.ProductCode LEFT JOIN (SELECT RC.ProductCode,SUM(ST.PickingQty) IssueQty FROM dbo.tblRequisition R  with(nolock) INNER JOIN dbo.tblRequsitionChild RC ON RC.ReqId = R.ReqId INNER JOIN dbo.tblStockInTransfar ST ON ST.ReqChildId = RC.ReqChildId WHERE R.PickingDate BETWEEN '" + fromDate + "' AND '" + toDate +  "' GROUP BY RC.ProductCode) vTblIssue ON vTblIssue.ProductCode = P.ProductCode LEFT JOIN (SELECT  ProductCode,sum(ID.DeliveryQuantity)as saleQty,sum(TotalPrice) as saleAmount FROM dbo.tblInvoice I  with(nolock) INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId where ID.DeliveryStatus IN ('Full','Partial') and I.UpdateDate BETWEEN '" + fromDate + "' AND '" + toDate + "' group by ProductCode)Vtblsale ON Vtblsale.ProductCode = P.ProductCode";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetWhStokMonitoringReportInformation(DateTime fromDate, DateTime toDate)
        {
            string query = "SELECT P.ProductCode,P.ProductName,ISNULL(vTblCSSIN.StockInQty,0)StockInQty,ISNULL(vTblCSOB.Quantity,0)OpeningStockQty,ISNULL(vTblCSOB.OpAmount,0)OpAmount,ISNULL(vTblIssue.IssueQty,0)IssueQty,((ISNULL(vTblCSOB.Quantity,0)+ISNULL(vTblCSSIN.StockInQty,0))-ISNULL(vTblIssue.IssueQty,0)) ClosingBal,ISNULL(Vtblsale.saleQty,0) as saleQty ,ISNULL(Vtblsale.saleAmount,0) as saleAmount , 0 as ClosingAmount FROM dbo.tblProduct P  with(nolock) LEFT JOIN (SELECT ProductCode,SUM(Quantity)Quantity,(sum(Quantity)*UnitPrice) as OpAmount FROM dbo.tblCentralStore_OpeninigBalance  with(nolock) WHERE CSOpeninigBalanceDate='" + fromDate  + "' GROUP BY ProductCode,UnitPrice) vTblCSOB ON vTblCSOB.ProductCode = P.ProductCode LEFT JOIN (SELECT ProductCode,SUM(StockInQty)StockInQty FROM dbo.tblCentralStore  with(nolock) WHERE ReceiveDate BETWEEN '" + fromDate + "' AND '" + toDate + "' GROUP BY ProductCode) vTblCSSIN ON vTblCSSIN.ProductCode = P.ProductCode LEFT JOIN (SELECT RC.ProductCode,SUM(ST.PickingQty) IssueQty FROM dbo.tblRequisition R  with(nolock) INNER JOIN dbo.tblRequsitionChild RC ON RC.ReqId = R.ReqId INNER JOIN dbo.tblStockInTransfar ST ON ST.ReqChildId = RC.ReqChildId WHERE R.PickingDate BETWEEN '" + fromDate + "' AND '" + toDate + "' GROUP BY RC.ProductCode) vTblIssue ON vTblIssue.ProductCode = P.ProductCode LEFT JOIN (SELECT  ProductCode,sum(ID.DeliveryQuantity)as saleQty,sum(TotalPrice) as saleAmount FROM dbo.tblInvoice I  with(nolock) INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId where ID.DeliveryStatus IN ('Full','Partial') and I.UpdateDate BETWEEN '" + fromDate + "' AND '" + toDate + "' group by ProductCode)Vtblsale ON Vtblsale.ProductCode = P.ProductCode";
            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
