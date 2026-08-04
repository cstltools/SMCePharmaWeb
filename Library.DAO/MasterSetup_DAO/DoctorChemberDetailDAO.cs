using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
  public  class DoctorChemberDetailDAO
    {
        public int ChemberId { get; set; }

        public int? ChamberTypeId { get; set; }

        public int? DoctorId { get; set; }

        public string Name { get; set; }

        public string Phone { get; set; }

        public string Address { get; set; }
    }


    public class DoctorSpecialDayDAO
    {
        public int SpecialDayInt { get; set; }

        public int? DoctorId { get; set; }

        public int? SpecialDayId { get; set; }

        public DateTime? SpecialDate { get; set; }
    }

    public class  DoctorContactDetailDAO
    {
        public int ContactId { get; set; }

        public int? DoctorId { get; set; }

        public string ContactType { get; set; }

        public string Contact { get; set; }

        public int? ContactTypeId { get; set; }

    }

}
