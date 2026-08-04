using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class ShippingCartonSize
    {
        public int CaseId { get; set; }
        public string ProductCode { get; set; }
        public string CaseQty { get; set; }
        public string PcsPerCase { get; set; }
    }
}
