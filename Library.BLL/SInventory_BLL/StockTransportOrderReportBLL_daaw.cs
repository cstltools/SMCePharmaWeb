using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.SInventory_DAL;

namespace Library.BLL.SInventory_BLL
{
   public class StockTransportOrderReportBLL_daaw
    {
       StockTransportOrderReportDAL_daaw aStockTransportOrderReportDal = new StockTransportOrderReportDAL_daaw();
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
