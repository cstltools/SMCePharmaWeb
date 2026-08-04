
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class dadtlsOrderInfoMaster
    {
        public int OrderId { get; set; }
        public string OrderCode { get; set; }
        public int ComUnitId { get; set; }
        public string ComUnitCode { get; set; }
        public string ComUnitName { get; set; }
        public string MIOCode { get; set; }
        public string MIOName { get; set; }
        public int ManufacId { get; set; }
        public string CustomerCode { get; set; }
        public string CustomerName { get; set; }
        public decimal GrossValue { get; set; }
        public DateTime SubmissionDate { get; set; }
        public bool IsInvoice { get; set; }
        public bool IsManual { get; set; }
        public string teritory { get; set; }
        public bool FCB { get; set; }
    }
}

