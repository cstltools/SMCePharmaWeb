using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SubDepot_DAO
{
    public class SubDepoAdjustMentDAO
    {
        public int SubDepoStockOutId { get; set; }
        public string SubDepoStockCode { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
    }
}
