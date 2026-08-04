using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class PrescriptionProductDetailDAO
    {
        public int PresDetailId { get; set; }

        public int? PrescriptionId { get; set; }

        public int? ProductId { get; set; }
    }
}