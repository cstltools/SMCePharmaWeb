using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class EmployeeInformation
    {

        public int EmpInfoId { get; set; }

        public int? CompanyId { get; set; }
        public string EmpMasterCode { get; set; }
        public string EmpName { get; set; }
        public string ShortName { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public string Religion { get; set; }
        public string Nationality { get; set; }

        public DateTime? DateOfBirth { get; set; }
        public DateTime? ProbitionEndDate { get; set; }
        public DateTime PlaceOfBirth { get; set; }
        public string BloodGroup { get; set; }
        public string Gender { get; set; }
        public string AddressPresent { get; set; }
        public string AddressPermanent { get; set; }
        public string PreCity { get; set; }
        public string PerCity { get; set; }
        public HttpPostedFileBase EmpImage { get; set; }
        public HttpPostedFileBase SignatureImage { get; set; }
        public string NationalIdNo { get; set; }
        public string CellNumber { get; set; }
        public string Email { get; set; }

        public string EmrgContactNo { get; set; }
        public string EmrgContactNoRelaton { get; set; }
        public bool? IsTempEmployeeCode { get; set; }
      
        public bool? IsProbition { get; set; }
        public string MaritalStatus { get; set; }
        public string RefName { get; set; }
        public string RefContactNo { get; set; }

        public int? DesignationId { get; set; }
        public int? DepartmentId { get; set; }
        public int? ShiftId { get; set; }
        public DateTime? JoiningDate { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public string EmployeeStatus { get; set; }


        public DateTime? JobLeftDate { get; set; }

        public string LastCompanyName { get; set; }

        public string LastJobLocation { get; set; }



    }
}