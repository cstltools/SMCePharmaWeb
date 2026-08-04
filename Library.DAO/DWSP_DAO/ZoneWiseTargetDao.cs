using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DWSP_DAO
{
  public class ZoneWiseTargetDao
    {
        public int ZoneWTSetupId { get; set; }

        public string Year { get; set; }

        public string Month { get; set; }

        public int? GroupId { get; set; }

        public decimal? TargetAmount { get; set; }

        public int? RegionId { get; set; }

        public decimal? Amount { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
    }
}
