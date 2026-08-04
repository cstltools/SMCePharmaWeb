using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class MileageClaimDAO
    {
        public int MileageClaimId { get; set; }

        public DateTime? MileageDate { get; set; }

        public int? TransportId { get; set; }
        public int? GroupId { get; set; }
        public int? RegionId { get; set; }
        public int? AreaId { get; set; }
        public int? TerritoryId { get; set; }
        public int? SubTerritoryId { get; set; }

        public decimal? MileageInKM { get; set; }

        public decimal? MeterReading { get; set; }

        public decimal? AllowedMileageInKM { get; set; }

        public int? SMId { get; set; }

        public string Remarks { get; set; }
       

        public int? EmpInfoId { get; set; }

        public string ApprovalStatus { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdatedBy { get; set; }

        public DateTime? UpdatedDate { get; set; }

        public int? ApprovedBy { get; set; }

        public DateTime? ApprovedDate { get; set; }

        public int? MarketId { get; set; }

        public int? TourTypeId { get; set; }

        public string MileageImage { get; set; }

        public string ImagePreName { get; set; }
        public string ImageString { get; set; }

        public HttpPostedFileWrapper ImageName { get; set; }
    }



    public class ExpenseClaimDAOTT
    {
        public int ExpenseClaimID { get; set; }

        public int ExpenseTypeId { get; set; }
        public int EmpInfoId { get; set; }
        public decimal Amount { get; set; }
        public string Remarks { get; set; }
   
        public string ImagePath { get; set; }

        public string ApprovalStatus { get; set; }


        public DateTime? ExpenseDate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }
        public string ImagePreName { get; set; }
        public string ImageString { get; set; }

        public HttpPostedFileWrapper ImageName { get; set; }


        public int ExpenseTypDetailsId { get; set; }
        public string FieldName { get; set; }
        public string ValueText { get; set; }

    }
}