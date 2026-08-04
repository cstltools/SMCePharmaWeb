using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class DcStockOutDetailsDao
    {

       public int DcStockOutDetailsId { get; set; }
       public int DcStockOutMasterId { get; set; }
       public int DcStoreId { get; set; }
       public string ProductCode { get; set; }
       public string ProductName { get; set; }
       public int StackOutQty { get; set; }
       public string PackSize { get; set; }
       public string BatchNo { get; set; }
       public DateTime ExpDate { get; set; }
       public DateTime ReceiveDate { get; set; }

    }
}
