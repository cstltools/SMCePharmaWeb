using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CentralStoreDao
    {
        public int ReceiveId { get; set; }
        public String StorageLocation { get; set; }
        public int ProductId { get; set; }
        public String ProductCode { get; set; }
        public String ProductName { get; set; }
        public String PackSize { get; set; }
        public String BatchNo { get; set; }


        public decimal Quantity { get; set; }
        public DateTime MfgDate { get; set; }
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
        public int MigoDetailID { get; set; }
        public String DeveloperRemarks { get; set; }
        public String ProductStockType { get; set; }
        public String InternalNoteNo { get; set; }
        public int DCStoreFreezeId { get; set; }
        public int DCStoreId { get; set; }


    }
}
