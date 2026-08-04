using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ProgramType
    {
        public int ProgramTypeId { get; set; }

        public string ProgramTypeName { get; set; }

        public string PrgmTypeCode { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }

        public bool? IsActive { get; set; }
        public bool? IsCustomer { get; set; }
        public bool? IsDoctor { get; set; }
        public bool? IsDefault { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }


    public class  SMCTypeDAO
    {
        public int SMCTypeId { get; set; }

        public string SMCType { get; set; }

        public bool? forCustomer { get; set; }

        public bool? forDotor { get; set; }

        public bool? IsActive { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public int? ApproveBy { get; set; }

        public DateTime? ApproveDate { get; set; }

        public bool? IsDefault { get; set; }

        public int? InactiveBy { get; set; }

        public DateTime? InactiveDate { get; set; }
    }
}