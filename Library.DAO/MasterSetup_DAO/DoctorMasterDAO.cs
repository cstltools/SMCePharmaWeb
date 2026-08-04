using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
   public class DoctorMasterDAO
    {

        public int DoctorId { get; set; }

        public string DoctorCode { get; set; }

        public string DoctorName { get; set; }

        public string SecondaryCode { get; set; }

        public int? DesignationId { get; set; }

        public int? DegreeId { get; set; }

        public string Gender { get; set; }

        public int? Speciality { get; set; }

        public int? ProgramType { get; set; }

        public string Remarks { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public DateTime? InactiveDate { get; set; }

        public string InactiveBy { get; set; }

        public bool? IsDelate { get; set; }

        public string DeleteBy { get; set; }

        public DateTime? DeleteDate { get; set; }

        public int? DivisionId { get; set; }

        public int? DistrictId { get; set; }

        public int? ThanaId { get; set; }

        public bool? IsFromApp { get; set; }

        public string ApprovalStatus { get; set; }

        public string ApprovedBy { get; set; }

        public DateTime? ApprovedDate { get; set; }

        public string UPCode { get; set; }

        public int? DoctorTypeId { get; set; }

        public int? TerritoryId { get; set; }

        public int? SubTerritoryId { get; set; }
        public int? ProgramTypeId { get; set; }
        public int? SMCTypeId { get; set; }

        public int? MarketId { get; set; }
        public int? StationTypeId { get; set; }
        public int? DoctorCategoryId { get; set; }

        public string UnionName { get; set; }
        public string Reamrks { get; set; }

        
    }



    public class SaveDoctorAppLog_DAO
    {
        public int? DoctorApprovalId { get; set; }

        public DateTime? Date { get; set; }

        public int? FromEmpId { get; set; }

        public int? ToEmpId { get; set; }

        public int? TableId { get; set; }

        public string Status { get; set; }

        public string Comments { get; set; }

        public string Type { get; set; }

        public int? Step { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public int? AreaId { get; set; }

        public int? TerritoryId { get; set; }

        public int? ToGroupId { get; set; }

        public int? ToRegionId { get; set; }

        public int? ToAreaId { get; set; }

        public int? ToTerritoryId { get; set; }

        public int? EntryByS { get; set; }

        public DateTime? EntryDateS { get; set; }

        public TimeSpan? EntryTimeS { get; set; }

        public int? ApproveByS { get; set; }

        public DateTime? ApproveDateS { get; set; }

        public TimeSpan? ApproveTimeS { get; set; }

        public int? EntryByApp { get; set; }

        public DateTime? EntryDateApp { get; set; }

        public TimeSpan? EntryTimeApp { get; set; }

        public int? ApproveByApp { get; set; }

        public DateTime? ApproveDateApp { get; set; }

        public TimeSpan? ApproveTimeApp { get; set; }

        public int? RoleTypeId { get; set; }

        public int? ToRoleTypeId { get; set; }
        public int? MenuId { get; set; }

    }
}
