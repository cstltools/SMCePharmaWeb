using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class Area
    {
        public int AreaId { get; set; }
        public string AreaCode { get; set; }
        public string CodeStr { get; set; }
        public string AreaName { get; set; }
        public int ZoneId { get; set; }
        public bool? IsActive { get; set; }
        public DateTime? AcOrInAcDate { get; set; }
        public string CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public string UpdatedBy { get; set; }
        public DateTime? UpdatedDate { get; set; }
        public string Remarks { get; set; }
        public string DistrictId { get; set; }
        public int GroupId { get; set; }
    }
}