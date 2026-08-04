using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class LeaveApplication
    {

        public int LeaveApplicationId { get; set; }
        public string EmpName { get; set; }
        public string EmpId { get; set; }
        public string LeaveFromDate { get; set; }
        public string LeaveToDate { get; set; }
        public string LeaveBalanceId { get; set; }
        public string LeaveTypeName { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public string Reason { get; set; }
        public int Days { get; set; }
        public string ApprovalStatus { get; set; }

    }
}