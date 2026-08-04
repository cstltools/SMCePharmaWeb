using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class Employee_ShiftInfosDAO
    {
        public int ShiftId { get; set; }

        public string ShiftText { get; set; }

        public string ShiftInTime { get; set; }
        

        public string ShiftOutTime { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
    }
}