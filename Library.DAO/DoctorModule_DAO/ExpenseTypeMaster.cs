using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ExpenseTypeMaster
    {
        public int ExpenseTypeId { get; set; }
        public int? RoleType_xp { get; set; }
        public string ExpenseTypeName { get; set; }
        public string RoleTypeMult { get; set; }
        public string EmpNameMult { get; set; }

        public decimal? ExpenseAmount { get; set; }
        public bool ImageRequired { get; set; }
        public bool IsActive { get; set; }
        public bool? isFixed { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }

        public List<ExpenseTypeDetails> ExpenseTypeDetails { get; set; }

    }
}