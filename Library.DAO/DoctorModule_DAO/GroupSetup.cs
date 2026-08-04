using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class GroupSetup
    {
        public int GroupId { get; set; }
        public int NationalId { get; set; }

        public string CodeStr { get; set; }
        public string GroupName { get; set; }
        public string GroupCode { get; set; }

        public bool? IsActive { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }

    }
}