using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ASMInfo
    {
        public Int32 ASMId { get; set; }
        public Int32 CompanyId { get; set; }
        public Int32 AreaId { get; set; }
        public Int32 EmployeeId { get; set; }
        public bool IsActive { get; set; }
        public DateTime ActiveDate { get; set; }
        public DateTime InActiveDate { get; set; }
        public string InActiveBy { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public string Vacant { get; set; }
        public Int32 GroupId { get; set; }
        public Int32 RegionId { get; set; }
        public string ActiveDateStr { get; set; }

    }
}