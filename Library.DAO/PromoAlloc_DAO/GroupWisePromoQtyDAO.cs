using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.PromoAlloc_DAO
{
    public class GroupWisePromoQtyDAO
    {
        public int GWPromoQtyId { get; set; }

        public int? Year { get; set; }

        public string Month { get; set; }

        public int? PromoGroupId { get; set; }

        public decimal? Qty { get; set; }

        public DateTime? Date { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ProductId { get; set; }

        public int? MIOId { get; set; }

        public int? EmpInfoId { get; set; }

        public string AllocationCode { get; set; }

        public int? TerritoryId { get; set; }

        public decimal? TransactionQTY { get; set; }


    }
}
