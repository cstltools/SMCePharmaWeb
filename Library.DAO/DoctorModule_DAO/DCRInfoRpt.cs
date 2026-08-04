using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class DCRInfoRpt
    {
        public int DcrId { get; set; }

       

        public int? TourTypeId { get; set; }

        public int? ChemberId { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public string UpdateDate { get; set; }

        public bool? IsApproved { get; set; }

        public string Remarks { get; set; }

        public int? DoctorId { get; set; }

        public int? DocTPDetailsId { get; set; }
        public string DoctorName { get; set; }
        public string TourTypeName { get; set; }
        public string Type { get; set; }
        public string ProductName { get; set; }
        public string EmpName { get; set; }
        public string DcrDate { get; set; }
        public string ChamberName { get; set; }








    }
}