using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.DoctorModule_DAO
{
    public class LeaveConfigDAO
    {
        public int LeaveConfigId { get; set; }

        public string LeaveName { get; set; }

        public bool? CountGovtLeave { get; set; }

        public bool? CountEmployeeHoliday { get; set; }

        public bool? EligbleforProbationEmployee { get; set; }

        public int? LeaveTypeId { get; set; }
        public int? DayNameId { get; set; }

        public int? EntryBy { get; set; }
        public bool? IsActive { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }

        public string EmpList { get; set; }

    }


    public class LeaveConfigCountDtl
    {
        public int LeaveConfigCountId { get; set; }

        public int? LeaveConfigId { get; set; }

        public int? JoiningDateCountId { get; set; }

        public string DaysPerMonthly { get; set; }

    }
    }
