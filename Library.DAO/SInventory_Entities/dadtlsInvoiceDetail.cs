using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Library.DAO.SInventory_Entities
{
    public class dadtlsInvoiceDetail
    {
        public int InvoiceDetailId { get; set; }
        public string ProductCode { get; set; }
        public string ProductName { get; set; }
        public string PackSize { get; set; }
        public string BatchNo { get; set; }
        public DateTime ReceiveDate { get; set; }
        public DateTime ExpDate { get; set; }
        public decimal CostPrice { get; set; }
        public decimal UnitPrice { get; set; }
        public decimal UnitVatAmount { get; set; }
        public decimal Quantity { get; set; }
        public decimal PreviousQuantity { get; set; }
        public string DeliveryStatus { get; set; }
        public decimal BonusQuantity { get; set; }
        public decimal TotalQuantity { get; set; }
        public decimal TotalPrice { get; set; }
        public decimal TotalPriceVatAmount { get; set; }
        public decimal DiscountPercentage { get; set; }
        public decimal DiscountAmount { get; set; }
        public decimal NetAmount { get; set; }
        public string ReturnReason { get; set; }
        public int InvoiceId { get; set; }
        public int DCStoreId { get; set; }
        public int OrderDetailsId { get; set; }
        public int ReturnDetailsId { get; set; }
        public int ReturnInvoiceId { get; set; }
        public decimal SpecialAmount { get; set; }
        public decimal SpecialAmountPer { get; set; }
        public decimal AdjustmentAmount { get; set; }
        public string Campaign { get; set; }
        public string IsgiftProduct { get; set; }


        public string CampaignType { get; set; }
        public bool IsCampaignProductforInv { get; set; }
        public bool ISGiftProductforInv { get; set; }
        //InvoiceDetailId ,
        //  ProductCode ,
        //  ProductName ,
        //  PackSize ,
        //  BatchNo ,
        //  ReceiveDate ,
        //  ExpDate ,
        //  CostPrice ,
        //  UnitPrice ,
        //  UnitVatAmount ,
        //  Quantity ,
        //  BonusQuantity ,
        //  TotalQuantity ,
        //  TotalPrice ,
        //  TotalPriceVatAmount ,
        //  DiscountPercentage ,
        //  DiscountAmount ,
        //  NetAmount ,
        //  InvoiceId
       
    }
}

