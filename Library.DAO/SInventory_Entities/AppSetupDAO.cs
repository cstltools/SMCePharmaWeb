using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class AppSetupDAO
    {
        public int AppSetupId { get; set; }
        public int SL { get; set; }
        public int UserId { get; set; }
        public string Email { get; set; }
        public string EntryBy { get; set; }
        public DateTime EntryDate { get; set; }

    }
}
