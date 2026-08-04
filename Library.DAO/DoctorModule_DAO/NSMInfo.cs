using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorModule_DAO
{
    public class NSMInfo
    {

        public Int32 NSMId { get; set; }
        public Int32 CompanyId { get; set; }
        public Int32 GroupId { get; set; }
        public Int32 EmployeeId { get; set; }
        public bool IsActive { get; set; }
        public DateTime ActiveDate { get; set; }
        public string ActiveDateStr { get; set; }
        public DateTime InActiveDate { get; set; }
        public string InActiveBy { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public string Vacant { get; set; }
    }public class NSMHeadInfo
    {

        public Int32 National_NSMId { get; set; }
        public Int32 CompanyId { get; set; }
        public Int32 NationalId { get; set; }
        public Int32 EmployeeId { get; set; }
        public bool IsActive { get; set; }
        public DateTime ActiveDate { get; set; }
        public string ActiveDateStr { get; set; }
        public DateTime InActiveDate { get; set; }
        public string InActiveBy { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public string Vacant { get; set; }
    }
}
