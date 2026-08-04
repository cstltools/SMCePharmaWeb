using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
   public class StockTransportOrderReportBLL
    {
       StockTransportOrderReportDAL aStockTransportOrderReportDal = new StockTransportOrderReportDAL();
       public DataTable StockTransportOrderReportMainDataBLL(string reqId)
       {
           return aStockTransportOrderReportDal.StockTransportOrderReportMainData(reqId);
       }

       public DataTable StockTransportOrderReportDetailDataBLL(string reqId)
       {
           return aStockTransportOrderReportDal.StockTransportOrderReportDetailData(reqId);
       }
       public DataTable CompanyInfoBLL()
       {
           return aStockTransportOrderReportDal.CompanyInformation();
       }
    }
}
