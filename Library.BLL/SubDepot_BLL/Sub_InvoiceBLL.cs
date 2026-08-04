using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAL.SubDepot_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SubDepot_BLL
{
    public class Sub_InvoiceBLL
    {
      //  Invoice aInv=new Invoice();
        Sub_InvoiceDAL aInvoiceDal = new Sub_InvoiceDAL();
        ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

        public void CreateConnection()
        {
            aInvoiceDal.CreateConnection_DAL();
        }
        public DataTable GetWarning(string aDropDownList)
        {
            return aInvoiceDal.GetWarning(aDropDownList);
        }
        public void CloseAllConnection()
        {
            aInvoiceDal.CloseAllConnection_DAL();
        }

        public int SaveFullInvoice(string InvoiceNo, string updateby, string updatedate)
        {
            return aInvoiceDal.SaveFullInvoice(InvoiceNo, updateby, updatedate);
        }
        public int SaveFullProformaInvoice(string InvoiceNo, string updateby, string updatedate)
        {
            return aInvoiceDal.SaveFullProformaInvoice(InvoiceNo, updateby, updatedate);
        }
        public int SaveRejectInvoice(string InvoiceNo, string updateby, string updatedate, string reason)
        {
            return aInvoiceDal.SaveRejectInvoice(InvoiceNo, updateby, updatedate, reason);
        }

        public bool SaveInvoice(Invoice aInvoice, out int invoiceId, out string invoiceNo)
        {
            invoiceId = aClsPrimaryKeyFind.PrimaryKeyMax("invoiceId", "tblSubInvoiceMaster");
            aInvoice.InvoiceId = invoiceId;
            invoiceNo = InvoiceNoGenerator(aInvoice.ComUnitId, aInvoice.ComUnitCode);
            aInvoice.InvoiceNo = invoiceNo;
            
            return aInvoiceDal.SaveDataForInvoice(aInvoice);
        }
        public bool SaveReturnInvoice(Invoice aInvoice, out int invoiceId, out string invoiceNo)
        {
            invoiceId = aClsPrimaryKeyFind.PrimaryKeyMax("ReturnInvoiceId", "tblReturnInvoice");
            aInvoice.InvoiceId = invoiceId;
            invoiceNo = ReturnInvoiceNoGenerator(aInvoice.ComUnitId, aInvoice.ComUnitCode);
            aInvoice.InvoiceNo = invoiceNo;

            return aInvoiceDal.SaveDataForReturnInvoice(aInvoice);
        }
        public bool SaveReturnInvoice(InvoiceDetail aInvoiceDetail)
        {
            aInvoiceDetail.InvoiceDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("ReuturnInvoiceDetailId", "tblReturnInvoiceDetail");
            return aInvoiceDal.SaveDataForReturnInvoiceDetails(aInvoiceDetail);
        }
        public bool SaveDCStoreFreeze(DCStockNew aStockNew)
        {
            aStockNew.DCStoreFreezeId = aClsPrimaryKeyFind.PrimaryKeyMax("SDStoreFreezeId", "tblSubDepotStoreFreeze");
            return aInvoiceDal.DCStockInDAL(aStockNew);
        }
        public DataTable DCInfoWithDCId(string dcstoreId)
        {
            return aInvoiceDal.DCInfoWithDCId(dcstoreId);
        }
        public bool SaveInvoiceDetails(List<InvoiceDetail> aInvoiceList,string ScomUnitId)
        {
            
            foreach (var invoiceDetail in aInvoiceList)
            {
                UpdateDCStock(invoiceDetail, ScomUnitId);
            }
            return true;
        }

        public bool UpdateOrder(string status, string id)
        {
            return aInvoiceDal.UpdateOrder(status, id);
        }
        private void UpdateDCStock(InvoiceDetail aInvoiceDetail, string ScomUnitId)
        {
            DataTable aTableBatchQty = new DataTable();
            aTableBatchQty = aInvoiceDal.BatchWiseProductQty(aInvoiceDetail.ProductCode, ScomUnitId);
            decimal restQty = 0;
            decimal restBonusQty = 0;
            decimal restBonusQty1 = 0;
            decimal restBonusQtyOverFlow = 0;
            decimal restQty1 = 0;
            decimal bonusQty = 0;
            decimal totalQty = 0;
            decimal qty = 0;
            bool restBonusQtyBool = false;
            bool bonusQtyZero = false;
            totalQty = aInvoiceDetail.Quantity + aInvoiceDetail.BonusQuantity;
            bonusQty = aInvoiceDetail.BonusQuantity;
            string dCStoreId = string.Empty;
            for (int i = 0; i < aTableBatchQty.Rows.Count; i++)
            {
                restBonusQtyBool = false;
                decimal stockQty = 0;
                dCStoreId = aTableBatchQty.Rows[i]["SubDCStoreId"].ToString().Trim();
                stockQty = Convert.ToDecimal(aTableBatchQty.Rows[i]["StockQty"].ToString().Trim());


                if (restQty1!=0)
                {
                    restQty = stockQty + restQty1;
                }
                else
                {
                   //////////////////////////bonus calculation////////
                    if (restBonusQty1!=0)
                    {
                        if (restBonusQty1<0)
                        {
                            bonusQty = (restBonusQty1*-1);
                        }
                        else
                        {
                            bonusQty = restBonusQty1;
                        }
                        
                    }
                        if (bonusQty >= stockQty)
                        {
                            restBonusQty = stockQty - bonusQty;
                            restBonusQty1 = restBonusQty;
                            restBonusQtyBool = true;
                            if (restBonusQty==0)
                            {
                                restBonusQtyOverFlow = bonusQty;
                            }
                            else
                            {
                                restBonusQtyOverFlow = stockQty;
                            }

              ////////////////////////////////end//////////////////////

                        }

                        else
                        {
                            restQty = stockQty - totalQty;
                            qty = totalQty - bonusQty;
                        }

                }



                if (restQty < 0 || restBonusQtyBool==true)
                {
                   
                    restQty1 = restQty;

                    if (restBonusQtyBool == true)
                    {
                        InvoiceDetailInsertBLL(aTableBatchQty, i, 0, restBonusQtyOverFlow, aInvoiceDetail, ScomUnitId,dCStoreId);
                    }
                    else
                    {
                        InvoiceDetailInsertBLL(aTableBatchQty, i, stockQty - bonusQty, bonusQty, aInvoiceDetail, ScomUnitId,dCStoreId);
                    }
                    aInvoiceDal.UpdateDCStoreQuantity(dCStoreId, 0);
                    bonusQty = 0;
                 
                }
                else
                {
                    if (restQty1<0)
                    {
                        decimal resQt = 0;
                        resQt = restQty1;
                        qty = resQt*-1;
                    }
                   
                    InvoiceDetailInsertBLL(aTableBatchQty, i, qty, bonusQty, aInvoiceDetail, ScomUnitId,dCStoreId);
                    aInvoiceDal.UpdateDCStoreQuantity(dCStoreId, restQty);
                    break;
                }
            }
        }
        private void InvoiceDetailInsertBLL(DataTable aTableBatchQty, int index, decimal qty, decimal bonusQty, InvoiceDetail aInvoiceDetail, string comUnitId,string dcstoreId)
        {
            DataTable ProductInfoDataTable = new DataTable();
            ProductInfoDataTable = ProductInfo(comUnitId, aInvoiceDetail.ProductCode);
            decimal discountPer = 0;
            //discountPer = ProductDiscount(aInvoiceDetail.ProductCode, qty.ToString());
            decimal vatper = 0;
            vatper = Convert.ToDecimal(ProductInfoDataTable.Rows[0]["VATPercentage"].ToString());
            InvoiceDetail aDetailForInsert = new InvoiceDetail();

            aDetailForInsert.InvoiceDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("InvoiceDetailId", "tblSubInvoiceDetail");
            aDetailForInsert.ProductCode = aInvoiceDetail.ProductCode;
            aDetailForInsert.ProductName = aInvoiceDetail.ProductName;
            aDetailForInsert.PackSize = aInvoiceDetail.PackSize;
            aDetailForInsert.BatchNo = aTableBatchQty.Rows[index]["BatchNo"].ToString();
            aDetailForInsert.ReceiveDate = Convert.ToDateTime(aTableBatchQty.Rows[index]["ReceiveDate"].ToString());
            aDetailForInsert.ExpDate = Convert.ToDateTime(aTableBatchQty.Rows[index]["ExpDate"].ToString());
            aDetailForInsert.CostPrice = Convert.ToDecimal(ProductInfoDataTable.Rows[0]["CostPrice"].ToString());
            aDetailForInsert.UnitPrice = aInvoiceDetail.UnitPrice; 
                //**Convert.ToDecimal(ProductInfoDataTable.Rows[0]["UnitPrice"].ToString());
            aDetailForInsert.UnitVatAmount = Convert.ToDecimal(aInvoiceDetail.UnitVatAmount);
            aDetailForInsert.Quantity = qty;
            aDetailForInsert.OrderDetailsId = aInvoiceDetail.OrderDetailsId;
            aDetailForInsert.BonusQuantity = bonusQty;
            aDetailForInsert.TotalQuantity = qty + bonusQty;
            //aDetailForInsert.TotalPrice = qty*aDetailForInsert.UnitPrice;
            DataTable dt = new DataTable();
            dt = aInvoiceDal.Isgift(aDetailForInsert.OrderDetailsId);
            if (Convert.ToBoolean(dt.Rows[0]["ISGiftProduct"].ToString()) == true)
            {
                aDetailForInsert.TotalPrice =
                    0;
            }
            else
            {
                aDetailForInsert.TotalPrice = qty * aDetailForInsert.UnitPrice;
            }
            aDetailForInsert.DiscountPercentage = aInvoiceDetail.DiscountPercentage;
            aDetailForInsert.DiscountAmount = aDetailForInsert.TotalPrice * (aInvoiceDetail.DiscountPercentage / 100);
            aDetailForInsert.SpecialAmount = aDetailForInsert.TotalPrice * (aInvoiceDetail.SpecialAmountPer / 100);


            //DataTable dt = new DataTable();
            //dt = aInvoiceDal.Isgift(aDetailForInsert.OrderDetailsId);


            if (Convert.ToBoolean(dt.Rows[0]["ISGiftProduct"].ToString()) == true)
            {
                aDetailForInsert.TotalPriceVatAmount =
                    0;
            }
            else
            {
                aDetailForInsert.TotalPriceVatAmount =
               aInvoiceDetail.UnitVatAmount * qty;
            }

            //(aDetailForInsert.TotalPrice) * (vatper / 100);

            if (Convert.ToBoolean(dt.Rows[0]["ISGiftProduct"].ToString()) == true)
            {
                aDetailForInsert.NetAmount = 0;
            }
            else
            {
                aDetailForInsert.NetAmount = (aDetailForInsert.TotalPrice - aDetailForInsert.DiscountAmount - aDetailForInsert.SpecialAmount) +
                                        aDetailForInsert.TotalPriceVatAmount;
            }
            //aDetailForInsert.TotalPriceVatAmount = 
            //    aInvoiceDetail.UnitVatAmount*qty;
            //    //(aDetailForInsert.TotalPrice) * (vatper / 100);
                                                   
            
            //aDetailForInsert.NetAmount = (aDetailForInsert.TotalPrice - aDetailForInsert.DiscountAmount-aDetailForInsert.SpecialAmount) +
            //                             aDetailForInsert.TotalPriceVatAmount;
            ////aDetailForInsert.NetAmount = aInvoiceDetail.NetAmount;
            

            aDetailForInsert.InvoiceId = aInvoiceDetail.InvoiceId;
            aDetailForInsert.Campaign = aInvoiceDetail.Campaign;
            aDetailForInsert.DCStoreId = Convert.ToInt32(dcstoreId);
            aDetailForInsert.CampaignType = aInvoiceDetail.CampaignType;



            aDetailForInsert.IsCampaignProductforInv = aInvoiceDetail.IsCampaignProductforInv;
            aDetailForInsert.ISGiftProductforInv = aInvoiceDetail.ISGiftProductforInv;

            aInvoiceDal.SaveDataForInvoiceDetails(aDetailForInsert);
        }
        private void ReturnInvoiceDetailInsertBLL(DataTable aTableBatchQty, int index, decimal qty, decimal bonusQty, InvoiceDetail aInvoiceDetail, string comUnitId, string dcstoreId)
        {
            DataTable ProductInfoDataTable = new DataTable();
            ProductInfoDataTable = ProductInfo(comUnitId, aInvoiceDetail.ProductCode);
            decimal discountPer = 0;
            discountPer = ProductDiscount(aInvoiceDetail.ProductCode, qty.ToString());


            InvoiceDetail aDetailForInsert = new InvoiceDetail();

            aDetailForInsert.InvoiceDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("InvoiceDetailId", "tblInvoiceDetail");
            aDetailForInsert.ProductCode = aInvoiceDetail.ProductCode;
            aDetailForInsert.ProductName = aInvoiceDetail.ProductName;
            aDetailForInsert.PackSize = aInvoiceDetail.PackSize;
            aDetailForInsert.BatchNo = aTableBatchQty.Rows[index]["BatchNo"].ToString();
            aDetailForInsert.ReceiveDate = Convert.ToDateTime(aTableBatchQty.Rows[index]["ReceiveDate"].ToString());
            aDetailForInsert.ExpDate = Convert.ToDateTime(aTableBatchQty.Rows[index]["ExpDate"].ToString());
            aDetailForInsert.CostPrice = Convert.ToDecimal(ProductInfoDataTable.Rows[0]["CostPrice"].ToString());
            aDetailForInsert.UnitPrice = Convert.ToDecimal(ProductInfoDataTable.Rows[0]["UnitPrice"].ToString());
            aDetailForInsert.UnitVatAmount = Convert.ToDecimal(aInvoiceDetail.UnitVatAmount);
            aDetailForInsert.Quantity = qty;
            aDetailForInsert.OrderDetailsId = aInvoiceDetail.OrderDetailsId;
            aDetailForInsert.BonusQuantity = bonusQty;
            aDetailForInsert.TotalQuantity = qty + bonusQty;
            aDetailForInsert.TotalPrice = qty * aDetailForInsert.UnitPrice;
            aDetailForInsert.TotalPriceVatAmount = aInvoiceDetail.TotalPriceVatAmount;
            aDetailForInsert.DiscountPercentage = aInvoiceDetail.DiscountPercentage;
            aDetailForInsert.DiscountAmount = aInvoiceDetail.DiscountAmount;
            aDetailForInsert.NetAmount = (aDetailForInsert.TotalPrice - aDetailForInsert.DiscountAmount) +
                                         aDetailForInsert.TotalPriceVatAmount;

            aDetailForInsert.InvoiceId = aInvoiceDetail.InvoiceId;
            aDetailForInsert.DCStoreId = Convert.ToInt32(dcstoreId);

            aInvoiceDal.SaveDataForInvoiceDetails(aDetailForInsert);
        }

        //public string InvoiceNoForShow()
        //{
        //    string InvoiceNo = "";
        //    InvoiceNo = InvoiceNoGenerator(aClsPrimaryKeyFind.PrimaryKeyMax("invoiceId", "tblInvoice"));
        //    return InvoiceNo;
        //}

        public string InvoiceNoGenerator(int id,string comCode)
        {
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceDal.InvoiceNoCount(id.ToString());



            string code = string.Empty;
            string Id = Convert.ToString(Convert.ToInt32(aDataTable.Rows[0][0].ToString().Trim())+1);

            if (Id.Length == 1)
            {
                Id = "0000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 7)
            {
                Id = "0" + Id;
            }
            code = "S-INV-" + comCode.Trim() + "-" + Id;
            return code;
        }
        public string ReturnInvoiceNoGenerator(int id, string comCode)
        {
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceDal.ReturnInvoiceNoCount(id.ToString());



            string code = string.Empty;
            string Id = Convert.ToString(Convert.ToInt32(aDataTable.Rows[0][0].ToString().Trim()) + 1);

            if (Id.Length == 1)
            {
                Id = "0000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 7)
            {
                Id = "0" + Id;
            }
            code = "INV-" + comCode.Trim() + "-" + Id;
            return code;
        }
        public string DelInvoiceNoGenerator(int id, string comCode)
        {
            DataTable aDataTable = new DataTable();
            aDataTable = aInvoiceDal.InvoiceNoCount(id.ToString());



            string code = string.Empty;
            string Id = Convert.ToString(Convert.ToInt32(aDataTable.Rows[0][0].ToString().Trim()) + 1);

            if (Id.Length == 1)
            {
                Id = "0000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 7)
            {
                Id = "0" + Id;
            }
            code = "DEL-INV-" + comCode.Trim() + "-" + Id;
            return code;
        }
       public DataTable ProductInfo(string comUnitId, string productCode)
       {
           return aInvoiceDal.ProductInfoDAL(comUnitId, productCode);
       }
       public DataTable ProductFocBonusQtyBLL(string invoiceDate, string productCode, int qty)
       {
           return aInvoiceDal.ProductFocBonusQtyDAL(invoiceDate,productCode,qty);
       }
        //public bool UpdateDataForInvoice(ChalanInfo aInvoice)
        //{
        //    return aInvoiceDal.UpdateaInvoice(aInvoice);
        //}
       public DataTable LoadProductQty(string orderid, string productCode)
       {
           return aInvoiceDal.LoadProductQty(orderid, productCode);
       }
        public DataTable LoadstockReceive()
        {
            return aInvoiceDal.LoadInvoiceView();
        }
        public DataTable CustomerMaster(string CustomerMasterId)
        {
            return aInvoiceDal.LoadCustomerMaster(CustomerMasterId);
        }

        public DataTable ProductInfo(string productId)
        {
            return aInvoiceDal.LoadProduct(productId);
        }
        public void PaymentTypeLoadBLL(DropDownList aDropDownList)
        {
            aInvoiceDal.PaymentTypeLoad(aDropDownList);
        }
        public void ReturnReason(DropDownList aDropDownList)
        {
            aInvoiceDal.ReturnReason(aDropDownList);
        }
        public DataTable GetReason()
        {
            return  aInvoiceDal.GetReason();
        }
        public decimal ProductDiscount(string productCode, string qty)
        {
            decimal discount = 0;
           DataTable aTable = new DataTable();
            aTable = aInvoiceDal.DiscountofProduct(productCode, qty);
            if (aTable.Rows.Count>0)
            {
                discount = Convert.ToDecimal(aTable.Rows[0]["DiscountPercentage"].ToString());
            }
            return discount;
        }
        public void UpdateInvoice(Invoice aInvoice,out string invoiceno)
        {
            //invoiceno = DelInvoiceNoGenerator(aInvoice.ComUnitId, aInvoice.ComUnitCode);
            //aInvoice.DelivaryInvoiceNo = invoiceno;
            invoiceno = aInvoice.InvoiceNo;
            aInvoiceDal.UpdateInvoice(aInvoice);
        }
        public void UpdateInvoiceDetail(InvoiceDetail aInvoiceDetail)
        {
            aInvoiceDal.UpdateInvoiceDetail(aInvoiceDetail);
        }
         //public DataTable InvoiceMainDataForReportBLL(string invNo)
         //{
         //    return aInvoiceDal.InvoiceMainDataForReport(invNo);
         //}
         //public DataTable InvoiceDetailDataForReportBLL(string invNo)
         //{
         //    return aInvoiceDal.InvoiceDetailDataForReport(invNo);
         //}
         public DataTable InvoiceDetailDataForReportBLL(int Dcid, int ManufId, int marketid, DateTime invDate)
         {
             return aInvoiceDal.InvoiceDetailDataForReport(Dcid, ManufId, marketid, invDate);
         }
         //public DataTable ReturnInvoiceMainDataForReportBLL(string invNo)
         //{
         //    return aInvoiceDal.ReturnInvoiceMainDataForReport(invNo);
         //}
         //public DataTable ReturnInvoiceDetailDataForReportBLL(string invNo)
         //{
         //    return aInvoiceDal.ReturnInvoiceDetailDataForReport(invNo);
         //}

        public string InvoiceNoCollectionFormate(string text)
        {
            string collection = "";
            if (text!="")
            {

                if (text.Contains(':'))
                {
                    string[] idCollection = text.Split(':');

                    foreach (string  item in idCollection)
                    {
                        collection = collection+"'" + item + "',";
                    }

                }
                else
                {
                    collection = "'" + text + "',";
                }
            }
            return collection.TrimEnd(',');
        }


        public DataTable AllInvoiceForPrintingBLL(string ComUnitId, string  InvoiceDate)
        {
            return aInvoiceDal.AllInvoiceForPrintingDAL(ComUnitId, Convert.ToDateTime(InvoiceDate));
        }

        public DataTable InvoiceForDCPickingBLL(string ComUnitId, string InvoiceDate)
        {
            return aInvoiceDal.InvoiceForDCPickingDAL(ComUnitId, Convert.ToDateTime(InvoiceDate));
        }

        public string DcPickingDetailSaveBLL(List<DCPickingDetail> aDcPickingDetailsList)
         {
             foreach (var aDcPickingDetail in aDcPickingDetailsList)
            {
                aDcPickingDetail.DCPicDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("DCPicDetailId", "tblDCPickingDetail");
                aInvoiceDal.DcPickingDetailSaveDAL(aDcPickingDetail);
            }
            
             return "Create Piking Successfully";
         }

        public int DcPickingSaveBLL(DCPicking aDcPicking)
        {
            int DCPicId = 0;
            DCPicId = aClsPrimaryKeyFind.PrimaryKeyMax("DCPicId", "tblDCPicking");
            aDcPicking.DCPicId = DCPicId;
            aDcPicking.DCPicNo = DCPIKNoGenerator(aDcPicking.ComUnitId, aDcPicking.ComUnitCode);
            aInvoiceDal.DcPickingSaveDAL(aDcPicking);
            return DCPicId;
        }
        public string DCPIKNoGenerator(int id, string ComUnitCode)
        {
            DataTable aTable = new DataTable();
            aTable = aInvoiceDal.DcPickingNoCount(id.ToString());

            string code = string.Empty;
            string Id = Convert.ToString(Convert.ToInt32(aTable.Rows[0][0].ToString().Trim())+1);

            if (Id.Length == 1)
            {
                Id = "0000000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "000000" + Id;
            }
            if (Id.Length == 3)
            {
                Id = "00000" + Id;
            }
            if (Id.Length == 4)
            {
                Id = "0000" + Id;
            }
            if (Id.Length == 5)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 6)
            {
                Id = "00" + Id;
            }
            if (Id.Length == 7)
            {
                Id = "0" + Id;
            }
            code = "DPK-" + ComUnitCode.Trim()+"-" + Id;
            return code;
        }


        public DataTable AllPickingForReportListBLL(string comUnitId,DateTime pickDate)
        {
            return aInvoiceDal.AllPickingForReportList(comUnitId, pickDate);
        }

        public DataTable DCPickingReportMainDataBLL(string dcPickingNo)
        {
            
            return aInvoiceDal.DCPickingReportMainDataDAL(dcPickingNo);
        }
        public DataTable  DCPickingReportDetailDataBLL(string dcPickingNo)
        {
            return aInvoiceDal.DCPickingReportDetailDataDAL(dcPickingNo);
        }

         public void AreaDropDownLoad(DropDownList dropDownList, string comUnitId)
         {
             aInvoiceDal.AreaDropDownLoad(dropDownList, comUnitId);
         }
         public DataTable MarketPickinReport(string SC, int MarketID, int ManufacID, DateTime InvDate)
         {
             return aInvoiceDal.MarketPickinReport(SC, MarketID, ManufacID, InvDate);
         }

         public DataTable DeliveryInvoiceMainDataForReportBLL(string invNo)
         {
             return aInvoiceDal.DeliveryInvoiceMainDataForReportDAL(invNo);
         }
         public DataTable DeliveryInvoiceDetailDataForReportBLL(string invNo)
         {
             return aInvoiceDal.DeliveryInvoiceDetailDataForReportDAL(invNo);
         }
         public DataTable ProformaReportBLL(string districtId, DateTime fromDate, DateTime toDate)
         {

             return aInvoiceDal.ProformaReportDAl(districtId, fromDate, toDate);
         }
         public DataTable ProformaReportBLL( DateTime fromDate, DateTime toDate)
         {

             return aInvoiceDal.ProformaReportDAl(fromDate, toDate);
         }
         ///////////////////////////////////////////////////////////////////////////////
         public DataTable InvoiceMainDataForReportBLL(string invNo)
         {
             return aInvoiceDal.InvoiceMainDataForReport(invNo);
         }
         public DataTable InvoiceMainDataForReportBLL2(string invNo)
         {
             return aInvoiceDal.InvoiceMainDataForReport2(invNo);
         }

        public DataTable InvoiceMainDataForReportBLL2SubDepot(string invNo)
        {
            return aInvoiceDal.InvoiceMainDataForReport2SubDepo(invNo);
        }
        ///////////////////////////////////////////////////////////////////////////////
        public DataTable InvoiceDetailDataForReportBLL(string invNo)
         {
             return aInvoiceDal.InvoiceDetailDataForReport(invNo);
         }
         public DataTable InvoiceDetailDataForReportBLL2(string invNo)
         {
             return aInvoiceDal.InvoiceDetailDataForReport2(invNo);
         }
         ///////////////////////////////////////////////////////////////////////////////
         public DataTable ReturnInvoiceMainDataForReportBLL(string invNo)
         {
             return aInvoiceDal.ReturnReturnInvoiceMainDataForReport(invNo);
         }
         ///////////////////////////////////////////////////////////////////////////////
         public DataTable ReturnInvoiceDetailDataForReportBLL(string invNo)
         {
             return aInvoiceDal.ReturnReturnInvoiceDetailDataForReport(invNo);
         }
        ///////////////////////////////////////////////////////////////////////////////
         public DataTable DelivaryInvoiceMainDataForReport(string invNo)
         {
             return aInvoiceDal.DelivaryInvoiceMainDataForReport(invNo);
         }
         ///////////////////////////////////////////////////////////////////////////////
         public DataTable DelivaryInvoiceDetailDataForReport(string invNo)
         {
             return aInvoiceDal.DelivaryInvoiceDetailDataForReport(invNo);
         }
         public DataTable MarketPickinReport(string SC, int MarketID, int ManufacID, DateTime InvDate, string parameter)
         {
             return aInvoiceDal.MarketPickinReport(SC, MarketID, ManufacID, InvDate, parameter);
         }
         public DataTable IntransitBll(string districtId, DateTime fromDate, DateTime toDate)
         {

             return aInvoiceDal.IntransitReportDAl(districtId, fromDate, toDate);
         }
         public DataTable IntransitBll(DateTime fromDate, DateTime toDate)
         {

             return aInvoiceDal.IntransitReportDAl( fromDate, toDate);
         }
         public int DeleteInvoice(string Invoice)
         {
             return aInvoiceDal.DeleteInvoice(Invoice);
         }
         public DataTable LoadOrderExistsBll(string orderid)
         {
             return aInvoiceDal.LoadOrderExistsDal(orderid);
         }
    }
}
