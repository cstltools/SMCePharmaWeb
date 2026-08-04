using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class TargetSetupDAO
    {
        public int FakeId { get; set; }
        public int MiaTargetId { get; set; }

        public decimal? TargetQty { get; set; }

        public int ProductId { get; set; }

      

        public string Period { get; set; }

        public string Year { get; set; }
       // public List<TargetSetupDetailsList> TargetSetupDetailsDAO { get; set; }
    }

    public class TargetSetupDetailsList
    {
        public int MiaTargetId { get; set; }

        public decimal? MiaTargetAmount { get; set; }

        public string MiaCode { get; set; }

        public string MiaName { get; set; }

        public string Period { get; set; }

        public string Year { get; set; }
    }
}