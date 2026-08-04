using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.PromoAlloc_DAO
{
    public class PromoMIOTagMaster
    {
        public int MIOTagId { get; set; }
        public int? PromoGroupId { get; set; }

        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }
        public string UpdateBy { get; set; }
        public DateTime UpdateDate { get; set; }
        public List<PromoMIOTagDetail> adetail { get; set; }

    }
    public class PromoMIOTagDetail
    {
        public int PromoMIOTagDetailId { get; set; }
        public int MIOTagMasterId { get; set; }
        public int? MIOId { get; set; }
        public int? EmpInfoId { get; set; }



    }
}
