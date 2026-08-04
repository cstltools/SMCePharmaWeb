using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorModule_DAO
{
  public  class PrescriptionTypeDao
    {
        public int PrescriptionTypeId { get; set; }

        public string PrescriptionTypename { get; set; }

        public string PrescriptionType { get; set; }
        public string ActivedateString { get; set; }

        public bool? IsActive { get; set; }

        public DateTime? Activedate { get; set; }

        public int EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public string UpdateBy { get; set; }

        public DateTime? UpdatedDate { get; set; }
    }
}
