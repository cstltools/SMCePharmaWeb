using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class PrescriptionMaster
    {
        public int PrescriptionId { get; set; }

        public DateTime PrescriptionDate { get; set; }
        public string PrescriptionDateString { get; set; }

        public int PrescriptionTypeId { get; set; }

        public int DoctorId { get; set; }

        public string ImageString { get; set; }
        public int? ChemberId { get; set; }

        public string PrescriptionType { get; set; }
        public string DoctorName { get; set; }

        public HttpPostedFileWrapper ImageName { get; set; }

        public int SessionUser { get; set; }
        public int EntryBy { get; set; }

        public DateTime EntryDate { get; set; }

        public int UpdateBy { get; set; }

        public DateTime UpdateDate { get; set; }

        public bool IsFromApp { get; set; }
        public List<ProductVM> aProList { get; set; }

        public string ImagePreName { get; set; }
        public string ApprovalStatus { get; set; }

    }
}