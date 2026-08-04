using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class CWMonthlyInventoryReportDal
    {
        private readonly ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetCWMonthlyInventoryReport(string fromDate, string toDate)
        {

            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();

            aSqlParameterlist.Add(new SqlParameter("@fromDate", fromDate));
            aSqlParameterlist.Add(new SqlParameter("@toDate", toDate));

            return aCommonInternalDal.GetDataTableAction("sp_WHBeenCard", aSqlParameterlist, "SSIDB");

            //string query = "SELECT P.ProductCode as ProductCode,P.ProductName as ProductName ,P.PackSize as BaseUnit," +
            //               "   ISNULL(vTblCSSIN.StockInQty,0)ReceiveFromProduction,ISNULL(vTblCSOB.Quantity,0)OpeningStock," +
            //               "   ISNULL(vTblIssue.IssueQty,0)TotalIssued,((ISNULL(vTblCSOB.Quantity,0)+ISNULL(vTblCSSIN.StockInQty,0))-ISNULL(vTblIssue.IssueQty,0)) ClosingStock," +
            //               "   ISNULL(vTblIssueBArisal.IssueQty,0) as Barishal,ISNULL(vTblIssueBogura.IssueQty,0) as Bogura,ISNULL(vTblIssueChattogram.IssueQty,0) as Chottogram," +
            //               "   ISNULL(vTblIssueCumilla.IssueQty,0) as Cumilla,ISNULL(vTblIssueKustia.IssueQty,0) as Kushtia,ISNULL(vTblIssueKhulna.IssueQty,0) as Khulna," +
            //               "   ISNULL(vTblIssueMymensingh.IssueQty,0) as Mymensingh,ISNULL(vTblIssueRajshahi.IssueQty,0) as Rajshahi,ISNULL(vTblIssueRangpur.IssueQty,0) as Rangpur," +
            //               "   ISNULL(vTblIssueSylhet.IssueQty,0) as Sylhet ,ISNULL(vTblIssueDhaka.IssueQty,0) as Dhaka_West,ISNULL(vTblStockOut.StockOutQty,0) as OtherIsueSample ," +
            //               "   ISNULL(vTblFreez.Freez,0) as OtherIsueDamage FROM dbo.tblProduct P  with(nolock)  LEFT JOIN (SELECT ProductCode,SUM(Quantity)Quantity,(sum(Quantity)*UnitPrice) as OpAmount" +
            //               "    FROM dbo.tblCentralStore_OpeninigBalance  with(nolock) WHERE CSOpeninigBalanceDate='01-Jan-2019' GROUP BY ProductCode,UnitPrice) vTblCSOB ON vTblCSOB.ProductCode = P.ProductCode" +
            //               "    LEFT JOIN (SELECT tblCentralStore.ProductCode,SUM(tblCentralStore.StockInQty)StockInQty FROM dbo.tblCentralStore with(nolock) inner join tblWHStockInDetail on tblCentralStore.MigoDetailID=tblWHStockInDetail.WHStockInDetailID inner join tblWHStockInMaster on tblWHStockInMaster.WHStockInMasterID=tblWHStockInDetail.WHStockInMasterID  WHERE WHStockInDate  " +
            //               "      between '" + fromDate + "' and '" + toDate +
            //               "' GROUP BY ProductCode) vTblCSSIN ON vTblCSSIN.ProductCode = P.ProductCode " +
            //               "    LEFT JOIN (SELECT RC.ProductCode,SUM(ST.PickingQty) IssueQty FROM dbo.tblRequisition R  with(nolock) INNER JOIN dbo.tblRequsitionChild RC ON RC.ReqId = R.ReqId " +
            //               "    INNER JOIN dbo.tblStockInTransfar ST ON ST.ReqChildId = RC.ReqChildId WHERE R.PickingDate between '" +
            //               fromDate + "' and '" + toDate + "' " +
            //               "    GROUP BY RC.ProductCode) vTblIssue ON vTblIssue.ProductCode = P.ProductCode LEFT JOIN (SELECT  ProductCode,sum(ID.DeliveryQuantity)as saleQty,sum(TotalPrice) as saleAmount " +
            //               "    FROM dbo.tblInvoice I  with(nolock) INNER JOIN dbo.tblInvoiceDetail ID ON ID.InvoiceId = I.InvoiceId where ID.DeliveryStatus IN ('Full','Partial') and I.UpdateDate " +
            //               "    between '" + fromDate + "' and '" + toDate +
            //               "' group by ProductCode)Vtblsale ON Vtblsale.ProductCode = P.ProductCode LEFT JOIN (SELECT RC.ProductCode,SUM(ST.PickingQty) IssueQty " +
            //               "    FROM dbo.tblRequisition R  with(nolock) INNER JOIN dbo.tblRequsitionChild RC ON RC.ReqId = R.ReqId INNER JOIN dbo.tblStockInTransfar ST ON ST.ReqChildId = RC.ReqChildId " +
            //               "    WHERE R.PickingDate between '" + fromDate + "' and '" + toDate +
            //               "' and ComUnitId=1  GROUP BY RC.ProductCode)vTblIssueBArisal ON vTblIssueBArisal.ProductCode = P.ProductCode LEFT JOIN (SELECT RC1.ProductCode,SUM(ST1.PickingQty) IssueQty FROM dbo.tblRequisition R1  with(nolock) INNER JOIN dbo.tblRequsitionChild RC1 ON RC1.ReqId = R1.ReqId INNER JOIN dbo.tblStockInTransfar ST1 ON ST1.ReqChildId = RC1.ReqChildId WHERE R1.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=2  GROUP BY RC1.ProductCode)vTblIssueBogura ON vTblIssueBogura.ProductCode = P.ProductCode LEFT JOIN (SELECT RC2.ProductCode,SUM(ST2.PickingQty) IssueQty FROM dbo.tblRequisition R2  with(nolock) INNER JOIN dbo.tblRequsitionChild RC2 ON RC2.ReqId = R2.ReqId INNER JOIN dbo.tblStockInTransfar ST2 ON ST2.ReqChildId = RC2.ReqChildId WHERE R2.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=3  GROUP BY RC2.ProductCode)vTblIssueChattogram ON vTblIssueChattogram.ProductCode = P.ProductCode LEFT JOIN (SELECT RC3.ProductCode,SUM(ST3.PickingQty) IssueQty FROM dbo.tblRequisition R3  with(nolock) INNER JOIN dbo.tblRequsitionChild RC3 ON RC3.ReqId = R3.ReqId INNER JOIN dbo.tblStockInTransfar ST3 ON ST3.ReqChildId = RC3.ReqChildId WHERE R3.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=4  GROUP BY RC3.ProductCode)vTblIssueCumilla ON vTblIssueCumilla.ProductCode = P.ProductCode LEFT JOIN (SELECT RC4.ProductCode,SUM(ST4.PickingQty) IssueQty FROM dbo.tblRequisition R4  with(nolock) INNER JOIN dbo.tblRequsitionChild RC4 ON RC4.ReqId = R4.ReqId INNER JOIN dbo.tblStockInTransfar ST4 ON ST4.ReqChildId = RC4.ReqChildId WHERE R4.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=6  GROUP BY RC4.ProductCode)vTblIssueKustia ON vTblIssueKustia.ProductCode = P.ProductCode LEFT JOIN (SELECT RC5.ProductCode,SUM(ST5.PickingQty) IssueQty FROM dbo.tblRequisition R5  with(nolock) INNER JOIN dbo.tblRequsitionChild RC5 ON RC5.ReqId = R5.ReqId INNER JOIN dbo.tblStockInTransfar ST5 ON ST5.ReqChildId = RC5.ReqChildId WHERE R5.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=7 GROUP BY RC5.ProductCode)vTblIssueKhulna ON vTblIssueKhulna.ProductCode = P.ProductCode LEFT JOIN (SELECT RC6.ProductCode,SUM(ST6.PickingQty) IssueQty FROM dbo.tblRequisition R6  with(nolock) INNER JOIN dbo.tblRequsitionChild RC6 ON RC6.ReqId = R6.ReqId INNER JOIN dbo.tblStockInTransfar ST6 ON ST6.ReqChildId = RC6.ReqChildId WHERE R6.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=8  GROUP BY RC6.ProductCode)vTblIssueMymensingh ON vTblIssueMymensingh.ProductCode = P.ProductCode LEFT JOIN (SELECT RC7.ProductCode,SUM(ST7.PickingQty) IssueQty FROM dbo.tblRequisition R7  with(nolock) INNER JOIN dbo.tblRequsitionChild RC7 ON RC7.ReqId = R7.ReqId INNER JOIN dbo.tblStockInTransfar ST7 ON ST7.ReqChildId = RC7.ReqChildId WHERE R7.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=9  GROUP BY RC7.ProductCode)vTblIssueRajshahi ON vTblIssueRajshahi.ProductCode = P.ProductCode LEFT JOIN (SELECT RC8.ProductCode,SUM(ST8.PickingQty) IssueQty FROM dbo.tblRequisition R8  with(nolock) INNER JOIN dbo.tblRequsitionChild RC8 ON RC8.ReqId = R8.ReqId INNER JOIN dbo.tblStockInTransfar ST8 ON ST8.ReqChildId = RC8.ReqChildId WHERE R8.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=10  GROUP BY RC8.ProductCode)vTblIssueRangpur ON vTblIssueRangpur.ProductCode = P.ProductCode LEFT JOIN (SELECT RC9.ProductCode,SUM(ST9.PickingQty) IssueQty FROM dbo.tblRequisition R9  with(nolock) INNER JOIN dbo.tblRequsitionChild RC9 ON RC9.ReqId = R9.ReqId INNER JOIN dbo.tblStockInTransfar ST9 ON ST9.ReqChildId = RC9.ReqChildId WHERE R9.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=11  GROUP BY RC9.ProductCode)vTblIssueSylhet ON vTblIssueSylhet.ProductCode = P.ProductCode LEFT JOIN (SELECT RC10.ProductCode,SUM(ST10.PickingQty) IssueQty FROM dbo.tblRequisition R10  with(nolock) INNER JOIN dbo.tblRequsitionChild RC10 ON RC10.ReqId = R10.ReqId INNER JOIN dbo.tblStockInTransfar ST10 ON ST10.ReqChildId = RC10.ReqChildId WHERE R10.PickingDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' and ComUnitId=12  GROUP BY RC10.ProductCode)vTblIssueDhaka ON vTblIssueDhaka.ProductCode = P.ProductCode LEFT JOIN (SELECT ProductId,SUM(Qty)StockOutQty FROM dbo.tblWHStockOutDetail  with(nolock) inner join tblWHStockOutMaster on tblWHStockOutDetail.WHStockOutMasterID=tblWHStockOutMaster.WHStockOutMasterID WHERE WHStockOutDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' GROUP BY ProductId) vTblStockOut ON vTblStockOut.ProductId = P.ProductId LEFT JOIN (SELECT ProductId,SUM(TotalQuantity)Freez FROM dbo.tblWhStoreFreeze  with(nolock) inner join tblWhStockConditionFreeze on tblWhStoreFreeze.WhStockConditionFreezeID=tblWhStockConditionFreeze.WhStockConditionFreezeID WHERE EntryDate between '" +
            //               fromDate + "' and '" + toDate +
            //               "' GROUP BY ProductId)vTblFreez ON vTblFreez.ProductId = P.ProductId ";
            
            
            //return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
