using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class CustomerMaster
    {
        public int CustomerMasterId { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public string Address { get; set; }
        public string CellNo { get; set; }
        public int MarketId { get; set; }
        public string MarketName { get; set; }
        public int AreaId { get; set; }
        public string AreaName { get; set; }
        public int ComUnitId { get; set; }
        public string ComUnitName { get; set; }
        public int DistrictId { get; set; }
        public string DistrictName { get; set; }
        public int RegionId { get; set; }
        public string RegionName { get; set; }
        public int CategoryId { get; set; }
        public string  CategoryName { get; set; }
        public int MiaId { get; set; }
        public string MiaName { get; set; }
        public string PaymentType { get; set; }
        public int ZoneId { get; set; }
        public string ZoneName { get; set; }
        
    }
}
