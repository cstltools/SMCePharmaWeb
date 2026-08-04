using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;

namespace Library.DAO.UserRoleDAO
{
    public class ApprovalMapMaster
    {
        public int? ApprovalMapMasterId { get; set; }
        public int? MenuId { get; set; }
        public string MenuName { get; set; }
        public int? FromRoleId { get; set; }

        public List<ApprovalMapDetail> ApprovalMapDetails { get; set; }

    }

    public class ApprovalMapDetail
    {
        public int? ApprovalMapDetailId { get; set; }
        public int? ApprovalMapMasterId { get; set; }
        public int? ToRoleId { get; set; }
        public int? Order { get; set; }
    }
}
