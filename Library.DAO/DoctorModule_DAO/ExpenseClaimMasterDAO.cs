using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.DataLayer
{
    public class ExpenseClaimMasterDAO
    {
        public int ExpenseClaimID { get; set; }

        public int? ExpenseTypeId { get; set; }

        public DateTime? ExpenseDate { get; set; }

        public int? EmpInfoId { get; set; }

        public decimal? Amount { get; set; }

        public string Remarks { get; set; }

        public string ImageName { get; set; }

        public string ImagePath { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string ApprovalStatus { get; set; }
        public string ImageBase64String { get; set; }

        public bool? IsFromApp { get; set; }

        public int? ApprovedBy { get; set; }

        public DateTime? ApprovedDate { get; set; }

        public List<ExpenseClaimDetailsDAO> ExpenseClaimDetailsDAOs { get; set; }
    }
}