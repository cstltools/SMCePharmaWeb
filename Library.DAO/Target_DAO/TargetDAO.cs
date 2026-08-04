using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.Target_DAO
{
    public class TargetDAO
    {
        public int MTargetId { get; set; }
        public int Year { get; set; }
        public int Month { get; set; }
        public DateTime Date { get; set; }
        public int FinYearId { get; set; }
        public decimal Amount { get; set; }
    }
}
