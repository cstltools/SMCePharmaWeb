using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class dadtlsOrderInfoDetail
    {
        public int OrderDetailId { get; set; }
        public int ProductId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public decimal Quantity { get; set; }
        public decimal TradePrice { get; set; }
        public decimal TotalTradePrice { get; set; }
        public int OrderId { get; set; }
        public int OrderListDetailId { get; set; }
        public string Status { get; set; }

       public string IsgiftProduct { get; set; }
       public string IsCampaignProduct { get; set; }
    }
}

