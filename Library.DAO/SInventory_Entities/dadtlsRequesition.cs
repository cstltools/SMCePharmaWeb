using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public  class dadtlsRequesition
    {
       public int ReqId { get; set; }
       public string ReqNo { get; set; }
       public DateTime ReqDate { get; set; }
       public int WarehouseId { get; set; }
       public string WearhouseName { get; set; }
       public int ComUnitId { get; set; }
       public string ComUnitCode { get; set; }
       public string ComUnitName { get; set; }
       public string Submit { get; set; }
       public DateTime SubmitDate { get; set; }
       public string IssueChalanNo { get; set; }
       public DateTime IssuChalanDate { get; set; }
       public string TruckNo { get; set; }
       public string DriverName { get; set; }
       public decimal TotalPrice { get; set; }
       public decimal TotalVAT { get; set; }
       public decimal GrandTotalPrice { get; set; }
       public string ReceiveIssue { get; set; }
       public DateTime ReceiveIssueDate { get; set; }
       public string CreatePicking { get; set; }
       public string PickingNo { get; set; }
       public DateTime PickingDate { get; set; }

       public string EntryBy { get; set; }
       public DateTime EntryDate { get; set; }
       public string UpdateBy { get; set; }
       public DateTime UpdateDate { get; set; }
       public int ManufacId { get; set; }

        public bool IsFromBatch { get; set; }


    }
}

