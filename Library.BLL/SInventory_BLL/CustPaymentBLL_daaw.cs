using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class CustPaymentBLL_daaw
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        CustPaymentDAL_daaw aCustPaymentDal=new CustPaymentDAL_daaw();

        public bool RejectInvoiceDAPaymentCollection(int invoiceId, int appLogId)
        {
            return aCustPaymentDal.RejectInvoiceDAPaymentCollection(invoiceId, appLogId);
        }

        public bool UpdateAdjustment(int invoiceId)
        {
            return aCustPaymentDal.UpdateAdjustment(invoiceId);
        }
        public bool UpdateInvoiceFinalPayment(int invoiceId,decimal PaymentAmount,string ptStatus, string PaymentBy)
        {
            return aCustPaymentDal.UpdateInvoiceFinalPayment(invoiceId, PaymentAmount, ptStatus, PaymentBy);
        }
        public bool SaveCustPayment(CustPayment_daaw aCustPayment,List<CustPaymentDetail_daaw> aPaymentDetailList )
        {
            try
            {

                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                aCustPayment.CustPayId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayId", "tblCustomerPay");
                aCustPaymentDal.SaveCustPayment(aCustPayment);
                foreach (var custPaymentDetail in aPaymentDetailList)
                {
                    custPaymentDetail.CustPayId = aCustPayment.CustPayId;
                    SaveCustDetail(custPaymentDetail);
                }
                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public bool SaveCustPaymentWithRollback(CustPayment_daaw aCustPayment, List<CustPaymentDetail_daaw> aPaymentDetailList)
        {
            try
            {
                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                aCustPayment.CustPayId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayId", "tblCustomerPay");

                int custPayDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayDetailId", "tblCustPayDetail");
                foreach (CustPaymentDetail_daaw custPaymentDetail in aPaymentDetailList)
                {
                    custPaymentDetail.CustPayId = aCustPayment.CustPayId;
                    custPaymentDetail.CustPayDetailId = custPayDetailId++;
                    if (string.IsNullOrWhiteSpace(custPaymentDetail.CollectionReceptNo))
                    {
                        custPaymentDetail.CollectionReceptNo = "DACP-" + custPaymentDetail.CustPayDetailId;
                    }
                }

                return aCustPaymentDal.SaveCustPaymentWithRollback(aCustPayment, aPaymentDetailList);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public bool SaveCustPayment(CustPayment_daaw aCustPayment, CustPaymentDetail_daaw custPaymentDetail)
        {
            try
            {

                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                aCustPayment.CustPayId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayId", "tblCustomerPay");


                DataTable dt = aCustPaymentDal.Existence(custPaymentDetail.InvoiceId.ToString(), custPaymentDetail.PaymentAmount.ToString());


                if( dt.Rows.Count > 0 )
                {

                  

                }
                else
                {
                      aCustPaymentDal.SaveCustPayment(aCustPayment);
                    custPaymentDetail.CustPayId = aCustPayment.CustPayId;
                    SaveCustDetail(custPaymentDetail);
                }

                
                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public bool SubdeportSaveCustPayment(CustPayment_daaw aCustPayment, CustPaymentDetail_daaw custPaymentDetail)
        {
            try
            {

                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                aCustPayment.CustPayId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayId", "tblCustomerPay");
                aCustPaymentDal.SaveCustPayment(aCustPayment);

                custPaymentDetail.CustPayId = aCustPayment.CustPayId;
                SubdeportSaveCustDetail(custPaymentDetail);

                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public bool UpdateInvoicePaymentAmount(string amount, string status, string id)
        {
            return aCustPaymentDal.UpdateInvoicePaymentAmount(amount, status, id);
        }
        public bool SubdeportUpdateInvoicePaymentAmount(string amount, string status, string id)
        {
            return aCustPaymentDal.SubdeportUpdateInvoicePaymentAmount(amount, status, id);
        }
      
        public DataTable GetPrevAmount(string invoiceId)
        {
            return aCustPaymentDal.GetPrevAmount(invoiceId);
        }
        public bool SaveCustDetail(CustPaymentDetail_daaw aCustPaymentDetail)
        {
            try
            {

                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                aCustPaymentDetail.CustPayDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayDetailId", "tblCustPayDetail");
                if (string.IsNullOrWhiteSpace(aCustPaymentDetail.CollectionReceptNo))
                {
                    aCustPaymentDetail.CollectionReceptNo = "DACP-" + aCustPaymentDetail.CustPayDetailId;
                }
                aCustPaymentDal.SaveCustDetail(aCustPaymentDetail);

                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public bool SubdeportSaveCustDetail(CustPaymentDetail_daaw aCustPaymentDetail)
        {
            try
            {

                ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();

                aCustPaymentDetail.CustPayDetailId = aClsPrimaryKeyFind.PrimaryKeyMax("CustPayDetailId", "tblCustPayDetail");
                aCustPaymentDal.SubdeportSaveCustDetail(aCustPaymentDetail);

                return true;

            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public void LoadSC(DropDownList ddl)
        {
            aCustPaymentDal.LoadSC(ddl);
        }
        public void LoadSC(DropDownList ddl, string userId)
        {
            aCustPaymentDal.LoadSC(ddl,userId);
        }
        public void LoadManufac(DropDownList ddl)
        {
            aCustPaymentDal.LoadManufac(ddl);
            
        }
        
        public void LoadCustomerMaster(DropDownList ddl, string marketId)
        {
            aCustPaymentDal.LoadCustomerMaster(ddl,marketId);
        }
        public void LoadMarket(DropDownList ddl, string comunitId)
        {
            aCustPaymentDal.LoadMarket(ddl,comunitId);
        }
        public void PaymentTypeLoadBLL(DropDownList aDropDownList)
        {
            aCustPaymentDal.PaymentTypeLoad(aDropDownList);
        }
        public DataTable LoadInvoice(string comUnitId, string customerId, string marketId)
        {
            return aCustPaymentDal.LoadInvoice(comUnitId, customerId, marketId);
        }

        public DataTable LoadInvoice(string comUnitId, string marketId)
        {
            return aCustPaymentDal.LoadInvoice(comUnitId, marketId);
        }
        public DataTable LoadSubDeportInvoice(string comUnitId, string marketId)
        {
            return aCustPaymentDal.LoadSubDeportInvoice(comUnitId, marketId);
        }
        public CustomerMaster CustomerLoad(string aCustomerMaster)
        {
            return aCustPaymentDal.CustomerLoad(aCustomerMaster);
        }
        public CustomerMaster DetailCustomerLoad(string aCustomerMaster)
        {
            return aCustPaymentDal.DetailCustomerLoad(aCustomerMaster);
        }
        public Product DetailProductLoad(string aProduct)
        {
            return aCustPaymentDal.DetailProductLoad(aProduct);
        }
    }
}
