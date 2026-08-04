using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SalesSolution.Web.Models
{
    public class NoticeImage
    {
        public int NoticeImageId { get; set; }

        public int NoticeId { get; set; }

        public HttpPostedFileBase ImageName { get; set; }

        public string ImagePath { get; set; }

    }
}