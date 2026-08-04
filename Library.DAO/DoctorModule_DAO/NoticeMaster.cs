using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class NoticeMaster
    {
        public int NoticeId { get; set; }
        public string NoticeTitle { get; set; }
        public string Announcement { get; set; }
        public DateTime? FromDate { get; set; }
        public DateTime? ToDate { get; set; }
        public DateTime EntryDate { get; set; }
        public string EntryBy { get; set; }
        public bool IsActive { get; set; }
        public bool IsReaded { get; set; }
        public int CompanyId { get; set; }
        public bool IsPublish { get; set; }
        public DateTime UpdateDate { get; set; }
        public string UpdateBy { get; set; }
        public string file { get; set; }
        public string filename { get; set; }
        public string ImageString { get; set; }
        public List<NoticeMarketDetails> NoticeMarketDetails { get; set; }
       // public List<NoticeImage> aImageList { get; set; }

    }
}