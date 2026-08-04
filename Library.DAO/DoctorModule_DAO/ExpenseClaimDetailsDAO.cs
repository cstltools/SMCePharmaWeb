using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.DataLayer
{
    public class ExpenseClaimDetailsDAO
    {
        public int ExpenseDetailId { get; set; }

        public int? ExpenseClaimID { get; set; }

        public int? ExpenseTypDetailsId { get; set; }

        public string ValueText { get; set; }
    }
}