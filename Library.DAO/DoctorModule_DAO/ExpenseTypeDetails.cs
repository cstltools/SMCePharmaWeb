using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class ExpenseTypeDetails
    {
        public int? ExpenseTypDetailsId { get; set; }

        public int? ExpenseTypeId { get; set; }

   

        public string FieldName { get; set; }

        public bool IsRequied { get; set; }

    }


    public class TourPurposeOtherSetup
    {
        public int TourPurposeOtherSetupId { get; set; }  // Primary Key (Auto-incremented)
        public int? VisitTypeId { get; set; }             // Foreign key or reference, nullable
        public int? TourPurposeId { get; set; }           // Foreign key or reference, nullable
        public bool? IsActive { get; set; }           // Foreign key or reference, nullable
        public string EntryBy { get; set; }               // User who entered the record
         
    }

    public class TourPurposeOtherSetupDtl
    { 
        public int TourPurposeOtherSetupId { get; set; }    // Foreign Key to tblTourPurposeOtherSetup, Nullable
        public string RoleName { get; set; }                 // Role Name
        public int? TerritoryId { get; set; }                // Nullable
        public int? AreaId { get; set; }                     // Nullable
        public int? RegionId { get; set; }                   // Nullable
        public int? GroupId { get; set; }                   // Nullable
        public int? TourTypeId { get; set; }                 // Nullable
    }
}