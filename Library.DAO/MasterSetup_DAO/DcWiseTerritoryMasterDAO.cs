using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
    public class DcWiseTerritoryMasterDAO
    {
        public int DcWiseTerritoryMasterId { get; set; }

        public int? DCId { get; set; }
        public int? SubDepotId { get; set; }

        public int? GroupId { get; set; }

        public int? RegionId { get; set; }

        public int? AreaId { get; set; }

        public int? EntryBy { get; set; }

        public DateTime? EntryDate { get; set; }

        public int? UpdateBy { get; set; }

        public DateTime? UpdateDate { get; set; }




    }

    public class DcWiseTerritoryDetailDAO
    {
        public int DcWiseTerritoryDetailId { get; set; }

        public int? DcWiseTerritoryMasterId { get; set; }

        public int? TerritoryId { get; set; }
    }

}