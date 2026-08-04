using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class PrescriptionMasterDAO
    {
        public int PrescriptionId { get; set; }

        public DateTime? PrescriptionDate { get; set; }

        public int? PrescriptionTypeId { get; set; }

        public int? DoctorId { get; set; }
        public int? ChemberId { get; set; }

        public string ImagePath { get; set; }

        public string ImageName { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string ApprovalStatus { get; set; }

        public int? ApprovedBy { get; set; }

        public DateTime? ApprovedDate { get; set; }
        public string ImageString { get; set; }

        public List<PrescriptionProductDetailDAO> PrescriptionProductDetailDAOs { get; set; }
    }
}