using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;


namespace Library.DAO.SInventory_Entities
{
   public class EmpGeneralInfo
    {
        public int EmpInfoId { get; set; }
        public string EmpMasterCode { get; set; } 
        public string EmpName { get; set; }
        public string ShortName { get; set; }
        public string FatherName { get; set; }
        public string MotherName { get; set; }
        public string Religion { get; set; }
        public string Nationality { get; set; }
        public string DateOfBirth { get; set; }
        public string PlaceOfBirth { get; set; }
        public string BloodGroup { get; set; }
        public string Gender { get; set; }
        public string AddressPresent { get; set; }
        public string AddressPermanent { get; set; }
        public string MedicalInformation { get; set; }
        public string PhoneNo { get; set; }
        public string CellNumber { get; set; }
        public string Email { get; set; }
        public byte[] EmpImage { get; set; }
        public byte[] SignatureImage { get; set; }
        public string MaritalStatus { get; set; }
        public string NationalIdNo { get; set; }
        public string ReferanceName { get; set; }
        public string ReferanceAddress { get; set; }
        public string ReferanceCellNo { get; set; }
        public int DesignationId { get; set; }
        public string Designation { get; set; }
        public int DepartmentId { get; set; }
        public string DeptName { get; set; }
        public DateTime JoiningDate { get; set; }
       
    }
}
