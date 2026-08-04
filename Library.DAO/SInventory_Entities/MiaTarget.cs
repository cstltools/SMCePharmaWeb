using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class MiaTarget
    {
        public int MiaTargetId { get; set; }
        public string MiaCode { get; set; }
        public string MiaName { get; set; }
        public decimal MiaTargetAmount { get; set; }
        public string Period { get; set; }
        public string Year { get; set; }
    }
}
