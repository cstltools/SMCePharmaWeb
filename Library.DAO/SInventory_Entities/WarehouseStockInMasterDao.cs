using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class WarehouseStockInMasterDao
    {
        public Int32 WHStockInMasterID { get; set; }
        public String WHStockInCode { get; set; }
        public Int32 ManufacId { get; set; }
        public DateTime WHStockInDate { get; set; }
        public Int32 TotalQuantity { get; set; }
        public Decimal TotalVat { get; set; }
        public Decimal TotalValue { get; set; }
        public String ChallanNo { get; set; }
        public DateTime ChallanDate { get; set; }
        public String ReferenceNo { get; set; }
        public String ReferenceDate { get; set; }
        public String Remarks { get; set; }
        public String Status { get; set; }
        public String EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public String UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public String ApproveBy { get; set; }
        public DateTime ApproveDate { get; set; }
        public Int32 WHStockOutMasterID { get; set; }
        public string Reason { get; set; }
        public int SupplierId { get; set; }

    }
}
