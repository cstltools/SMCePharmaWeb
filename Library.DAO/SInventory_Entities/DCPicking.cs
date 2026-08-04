using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
   public class DCPicking
    {
       public int DCPicId { get; set; }
       public string DCPicNo { get; set; }
       public DateTime DCPicDate { get; set; }
       public int ComUnitId { get; set; }
       public int AreaId { get; set; }
       public string ComUnitCode { get; set; }

    }
}
