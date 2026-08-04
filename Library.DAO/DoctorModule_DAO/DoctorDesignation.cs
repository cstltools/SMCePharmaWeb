using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class DoctorDesignation
    {

        public int DesignationId { get; set; }

        public string DesignationName { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }
    }
}