using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
  public class dadtlsRequsitionChild
    {
      public int ReqChildId { get; set; }
      public string ProductCode { get; set; }
      public string ProductName { get; set; }
      public string PackSize { get; set; }
      public string BatchNo { get; set; }
        public decimal ReqQty { get; set; }
      public int ReqId { get; set; }
      public decimal IssueQty { get; set; }
      public decimal UnitPrice { get; set; }
      public decimal PriceAmount { get; set; }
      public decimal VATAmount { get; set; }
      public decimal TotalPrice { get; set; }
      public string IsIssue { get; set; }
      public decimal CaseQty { get; set; }
      public decimal MusakVATAmount { get; set; }
      public decimal MusakTotalPrice { get; set; }
      public string IsPicking { get; set; }
    }
}

