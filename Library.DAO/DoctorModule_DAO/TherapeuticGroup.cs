using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class TherapeuticGroup
    {
        public int TherapeuticGroupId { get; set; }

        public string TherapeuticGroupCode { get; set; }

        public string TherapeuticGroupName { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }

    public class  ProductLineDAO
    {
        public int ProductLineID { get; set; }

       

        public string LineName { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsActive { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }

}