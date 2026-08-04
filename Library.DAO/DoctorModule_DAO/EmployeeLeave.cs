using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class EmployeeLeave
    {
        public int LeaveTypeId { get; set; }

        public string LeaveTypeName { get; set; }
        public int? LeaveDays { get; set; }
        public int? EntryBy { get; set; }
        public DateTime? EntryDate { get; set; }
        public int? UpdateBy { get; set; }
        public DateTime? UpdateDate { get; set; }
        public int? ApproveBy { get; set; }
        public DateTime? ApproveDate { get; set; }
        public bool? IsActive { get; set; }
        public int? InactiveBy { get; set; }
        public DateTime? InactiveDate { get; set; }

        //passing view

        public string EMPEntryBy { get; set; }

        public string EMPUpdateBy { get; set; }

        public string EntryDatee { get; set; }

        public string UpdateDatee { get; set; }


        public string EMPActiveInactiveBy { get; set; }

        public string InactiveDatee { get; set; }


        //public int LeaveTypeId { get; set; }

        //public string LeaveTypeName { get; set; }

        //public int? LeaveDays { get; set; }

        //public int? EntryBy { get; set; }

        //public DateTime? EntryDate { get; set; }

        //public int? UpdateBy { get; set; }

        //public DateTime? UpdateDate { get; set; }

        //public int? ApproveBy { get; set; }

        //public DateTime? ApproveDate { get; set; }

        //public bool? IsActive { get; set; }

        //public int? InactiveBy { get; set; }

        //public DateTime? InactiveDate { get; set; }

    }
}