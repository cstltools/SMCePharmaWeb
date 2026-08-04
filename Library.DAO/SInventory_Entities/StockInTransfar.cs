using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class StockInTransfar
    {
       public int StockInTransfarId { get; set; }
       public int ReqId { get; set; }
       public int ReqChildId { get; set; }
       public string ProductCode { get; set; }
       public string ProductName { get; set; }
       public string PackSize { get; set; }
       public string BatchNo { get; set; }
       public decimal Quantity { get; set; }
       public decimal UnitPrice { get; set; }
       public decimal PriceAmount { get; set; }
       public decimal VATAmount { get; set; }
       public decimal TotalPriceAmount { get; set; }
       public DateTime ExpDate { get; set; }
       public DateTime ReceiveDate { get; set; }
       public string IsTransfared { get; set; }
       public string IsIssue { get; set; }
       public decimal PickingQty { get; set; }
       public int ReceiveId { get; set; }
       public DateTime MfgDate { get; set; }
    }
}
