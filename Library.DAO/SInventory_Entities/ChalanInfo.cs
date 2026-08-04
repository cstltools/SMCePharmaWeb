using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class ChalanInfo
    {
        public int ChalanId { get; set; }
        public DateTime ChalanDate { get; set; }
        public string ChalanNo { get; set; }
        public string TrackNo { get; set; }
        public string DriverName { get; set; }
        public string FromComUnitCode { get; set; }
        public string FromComUnitName { get; set; }
        public string FromComUnitAddress { get; set; }
        public string ToComUnitCode { get; set; }
        public string ToComUnitName { get; set; }
        public string ToComUnitAddress { get; set; }
        public decimal TotalValue { get; set; }
        public decimal TotalVat { get; set; }
        public decimal GrandTotal { get; set; }
        public int ManufacId { get; set; }
        public int fromunitid { get; set; }
    }
}
