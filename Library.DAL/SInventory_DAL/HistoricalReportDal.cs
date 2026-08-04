using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;

namespace Library.DAL.SInventory_DAL
{
    public class HistoricalReportDal
    {

        private readonly ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public DataTable GetHistoricalReportInfo(string fromDate, string toDate)
        {

            const string query = @"SELECT ProductCode AS MIOName ,ProductName AS OpeningReceivableInHand ,StorageLocation AS OpeningReceivableMarketOutStanding,
                                PackSize AS OpeningReceivableFromAO ,BatchNo AS SalesOnTP,Quantity AS SalesVAT,ExpDate AS TotalSales,ReceiveDate AS CollectionFromSales,
                                ChalanNo AS DepositCashAtBank,ChalanDate AS DepositOthers,InternalNoteNo AS ClosingReceivableInHand,StockInQty AS ClosingReceivableMarketOutStanding,
                                UnitPrice AS ClosingReceivableFromAO FROM dbo.tblCentralStore";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
    }
}
