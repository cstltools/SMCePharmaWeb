using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
   public class CustMasterInfoDAO
    {


        public int CustomerMasterId { get; set; }

        public string CustomerCode { get; set; }

        public int? CategoryId { get; set; }

        public string CustomerName { get; set; }

        public string Address { get; set; }

        public string CellNo { get; set; }

        public int? MarketId { get; set; }
        public int? TerritoryId { get; set; }
        public int? SubTerritoryId { get; set; }

        public string Addrees2 { get; set; }

        public string City { get; set; }

        public string ConPerson { get; set; }

        public string ShippingCond { get; set; }

        public string MarketCode { get; set; }

        public string MarketName { get; set; }

        public string MIACode { get; set; }

        public string MIAName { get; set; }

        public string AreaCode { get; set; }

        public string DisCode { get; set; }

        public string FEName { get; set; }

        public string ComUnitCode { get; set; }

        public string ComUnitName { get; set; }

        public string RegionCode { get; set; }

        public string DZSMName { get; set; }

        public string TermOfPayment { get; set; }

        public string CustomerCodeOld { get; set; }

        public DateTime? UploadDate { get; set; }

        public bool? ExcelUpload { get; set; }

        public bool? FixedCustomer { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string Type { get; set; }

        public int? ComUnitId { get; set; }

        public bool? IsActive { get; set; }

        public string InActiveDate { get; set; }

        public string CustomerStation { get; set; }

        public string Division { get; set; }

        public string District { get; set; }

        public string Thana { get; set; }

        public string Upazila { get; set; }

        public string CustomerType { get; set; }
        public string Email { get; set; }

        public int? AITGLId { get; set; }

        public int? CustomerTypeId { get; set; }

        public int? DistrictId { get; set; }

        public int? DivisionId { get; set; }

        public int? ThanaId { get; set; }

        public int? StationTypeId { get; set; }
        public int? DZSMStationTypeId { get; set; }
        public int? NSMStationTypeId { get; set; }

        public string CreateBy { get; set; }

        public DateTime? CreateDate { get; set; }

        public bool? IsVatApplicable { get; set; }

        public int? DistributionRouteId { get; set; }

        public string OwnerName { get; set; }

        public string VoterID { get; set; }

        public string TradeLicense { get; set; }

        public string DrugLicense { get; set; }

        public string PharmacyCouncilCertificate { get; set; }

        public string BCDS { get; set; }
        public string Reamrks { get; set; }

        public int? ProgramTypeId { get; set; }

        public int? ApproveBy { get; set; }

        public string ApproveDate { get; set; }

        public string ActionStatus { get; set; }
    }

    public class CustomerSaveAppLog_DAO
    {

        public int? CustomerApprovalId { get; set; }
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



    public class CustomerAppLog_DAO
    {

        public int CustomerApprovalId { get; set; }
        public int? CustomerMasterId { get; set; }
        public int? EmpInfoId { get; set; }

        public string Date { get; set; }

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



        public int? RoleTypeId { get; set; }

        public int? ToRoleTypeId { get; set; }

        public int? MenuId { get; set; }

        public string TerritoryName { get; set; }
        public string TerritoryCode { get; set; }
        public string AreaCode { get; set; }




        public string ApprovalStatus { get; set; }
        public string EmpMasterCode { get; set; }
        public string EmpName { get; set; }



        public int MIOEmpId { get; set; }
        public int ASMEMPId { get; set; }
        public int RSMEMPId { get; set; }
        public int NSMEMPId { get; set; }
        

    }


    public class OrderSaveApprovalLogDAO
    {

        public int? OrderApprovalId { get; set; }
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
        public String ApproveByApp { get; set; }
        public DateTime? ApproveDateApp { get; set; }
        public TimeSpan? ApproveTimeApp { get; set; }
        public int? MenuId { get; set; }

    }


    public class AttendanceLog
    {

        public int? ApprovalId { get; set; }
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
        public string EntryByS { get; set; }
        public DateTime? EntryDateS { get; set; }
        public TimeSpan? EntryTimeS { get; set; }
        public String ApproveByS { get; set; }
        public DateTime? ApproveDateS { get; set; }
        public TimeSpan? ApproveTimeS { get; set; }
        public String EntryByApp { get; set; }
        public DateTime? EntryDateApp { get; set; }
        public TimeSpan? EntryTimeApp { get; set; }
        public String ApproveByApp { get; set; }
        public DateTime? ApproveDateApp { get; set; }
        public TimeSpan? ApproveTimeApp { get; set; }
        public int? MenuId { get; set; }

    }



    public class LeaveApplo_Save
    {

        public int? LeaveApprovalId { get; set; }
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
        public String ApproveByS { get; set; }
        public DateTime? ApproveDateS { get; set; }
        public TimeSpan? ApproveTimeS { get; set; }
        public int? EntryByApp { get; set; }
        public DateTime? EntryDateApp { get; set; }
        public TimeSpan? EntryTimeApp { get; set; }
        public String ApproveByApp { get; set; }
        public DateTime? ApproveDateApp { get; set; }
        public TimeSpan? ApproveTimeApp { get; set; }
        public int? MenuId { get; set; }

    }
}
