using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class PrescriptionType
    {
        public int PrescriptionTypeId { get; set; }

        public string PrescriptionTypename { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public int EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }

        
    }
}