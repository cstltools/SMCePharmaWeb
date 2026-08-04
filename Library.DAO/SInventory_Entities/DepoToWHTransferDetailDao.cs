using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class DepoToWHTransferDetailDao
    {
        public int ChalanDetailId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public decimal Quantity { get; set; }
        public string BatchNo { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal Value { get; set; }
        public decimal Vat { get; set; }
        public decimal ValueWVat { get; set; }
        public int ChalanId { get; set; }
        public int DCStoreId { get; set; }
        public int DCStoreFreezeId { get; set; }
        public int PurposeId { get; set; }
    }
}
