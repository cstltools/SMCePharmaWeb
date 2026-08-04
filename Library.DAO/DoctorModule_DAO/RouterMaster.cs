using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class RouterMaster
    {
        public int RouterMasterId { get; set; }

        public string RouterName { get; set; }

        public string RouterCode { get; set; }

        public bool IsActive { get; set; }

        public int EntryBy { get; set; }

        public DateTime EntryDate { get; set; }

        public int UpdateBy { get; set; }

        public DateTime UpdateDate { get; set; }

        public List<RouterDetails> RouterDetails { get; set; } 
    }
}