using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ThanaDao
    {
        public int ThanaId { get; set; }

        public int? district_id { get; set; }

        public string ThanaName { get; set; }

        public string ThanaName_BN { get; set; }

        public string ThanaCode { get; set; }

        public string url { get; set; }

        public string CreatedBy { get; set; }

        public DateTime? CreatedDate { get; set; }

        public bool? IsActive { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }
    }
}