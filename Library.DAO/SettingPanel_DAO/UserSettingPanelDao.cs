using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SettingPanel_DAO
{
    public class UserSettingPanelDao
    {
        public int UserSettingPanelId { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? Todate { get; set; }
        public string Criteria { get; set; }
        public string CriteriaRemarks { get; set; }
    }
}
