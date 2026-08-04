using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorMaster_Dao
{
   public class PatientTypeDao
    {
        public int PatientTypeId { get; set; }

        public string PatientType { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public string EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public bool? IsDelate { get; set; }

        public string DeleteBy { get; set; }

        public DateTime? DeleteDate { get; set; }
    }
}
