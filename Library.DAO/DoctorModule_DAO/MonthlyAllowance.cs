using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class MonthlyAllowance
    {

        public int MonthlyAllowanceId { get; set; }

        public string MonthlyAllowanceName { get; set; }

        public decimal Allowance { get; set; }
        public int? UserRoleId { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }


    }

    public class TADADAO
    {

        public int TadaID { get; set; }

        public DateTime? TadaDate { get; set; }

        public string Remarks { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string ApprovalStatus { get; set; }

        public int? EmpInfoId { get; set; }

        public string ApprovedBy { get; set; }

        public DateTime? ApprovedDate { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public int? AreaId { get; set; }

        public int? TerritoryId { get; set; }

        public int? SubTerritoryId { get; set; }

        public int? MarketId { get; set; }

        public decimal? DAAmount { get; set; }

        public int? TourTypeId { get; set; }

        public string HotelName { get; set; }

        public string HotelPhone { get; set; }


    }
    public class MonthlyAllowanceDtlDAO
    {

        public int? EmpInfoId { get; set; }

        public int? UserRoleId { get; set; }

       


    }
}