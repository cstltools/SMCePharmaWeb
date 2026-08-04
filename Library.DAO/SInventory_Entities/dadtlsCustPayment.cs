using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class dadtlsCustPayment
    {
        public int CustPayId { get; set; }
        public int MarketId { get; set; }
        public int DistributionRouteId { get; set; }
        public int CustomerMasterId { get; set; }
        
        public DateTime PaymentDate { get; set; }
        public decimal PaymentAmount { get; set; }
        public string PayType { get; set; }
        public string RefNo { get; set; }
        public DateTime? RefDate { get; set; }
        public string CreateBy { get; set; }
        public DateTime CreateDate { get; set; }
        public string    UpdateBy { get; set; }
        public int ComUnitId { get; set; }
        public DateTime UpdateDate { get; set; }
    }
}

