using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
    public class DAInfoDao
    {

        public int DAId { get; set; }
        public String NID { get; set; }
        public String Name { get; set; }
        public String Address { get; set; }
        public String PhoneNo { get; set; }
        public String EmergencyContactNo { get; set; }
        public String ReferenceName { get; set; }
        public String ReferencePhone { get; set; }
        public String Remarks { get; set; }
        public int? ComUnitId { get; set; }
        public DateTime? JoiningDate { get; set; }
        public bool IsActive { get; set; }
        public DateTime? ActiveDate { get; set; }
        public DateTime? InactiveDate { get; set; }
        public int EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public int UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }

    }
}
