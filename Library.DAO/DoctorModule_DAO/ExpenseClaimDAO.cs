using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ExpenseClaimDAO
    {
        public int ExpenseClaimID { get; set; }

        public int ExpenseTypeId { get; set; }
        public int EmpInfoId { get; set; }
        public decimal Amount { get; set; }
        public string Remarks { get; set; }
        public string ImageName { get; set; }
        public string ImagePath { get; set; }




        public DateTime? ExpenseDate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }

    }
}