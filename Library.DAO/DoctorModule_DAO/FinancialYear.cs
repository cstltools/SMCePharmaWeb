using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class FinancialYear
    {
        public int FiscalYearId { get; set; }

        public string FiscalYearDesc { get; set; }

        public DateTime? YearFromDate { get; set; }

        public DateTime? YearTodate { get; set; }


        public string YearFromDateStr { get; set; }

        public string YearTodateStr { get; set; }
        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }
}