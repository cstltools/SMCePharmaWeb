using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class WHStockInToCenteralStore
    {
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public decimal Quantity { get; set; }
        public DateTime ExpDate { get; set; }
        public DateTime ReceiveDate { get; set; }

        public String ChalanNo { get; set; }
        public DateTime ChalanDate { get; set; }

        public decimal StockInQty { get; set; }

        public decimal UnitPrice { get; set; }
        public decimal TotalPrice { get; set; }

        public decimal VATPerUnit { get; set; }
        public decimal TotalVAT { get; set; }

        public decimal TotalAmount { get; set; }
        public String StockCondition { get; set; }

        public DateTime MfgDate { get; set; }
        public Int32 MigoDetailID { get; set; }


        public String ProductStockType { get; set; }
        public Int32 ProductId { get; set; }
    }
}
