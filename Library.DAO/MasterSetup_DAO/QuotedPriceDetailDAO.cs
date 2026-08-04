using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.MasterSetup_DAO
{
 public   class QuotedPriceDetailDAO
    {
        public int QuotedPriceDetailId { get; set; }

        public int? QuotedPriceMasterId { get; set; }

        public int? ProductId { get; set; }

        public decimal? UnitPrice { get; set; }

        public decimal? Vat { get; set; }

    }
}
