using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
   public class ProformaOrInvoiceReturnBLL_daaw
    {
       ProformaOrInvoiceReturn aInvoiceReturn = new ProformaOrInvoiceReturn();

        public DataTable SelectInvoiceID(int Invoice)
        {
            return aInvoiceReturn.SelectInvoiceID2(Invoice);
        }
        public bool chkProforma(string Proforma)
       {
           try
           {
               if (aInvoiceReturn.HasProforma(Proforma))
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           { }
       }

        public bool chkProformaFortoday(string Proforma)
        {
            try
            {
                if (aInvoiceReturn.HasProformafORtoday(Proforma))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public bool chkProformaOther(string Proforma)
       {
           try
           {
               if (aInvoiceReturn.HasProformaOther(Proforma))
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           { }
       }
       public bool cHasProformaOtherSubdeport(string Proforma)
       {
           try
           {
               if (aInvoiceReturn.HasProformaOtherSubdeport(Proforma))
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           { }
       }
       public bool chkProformaSub(string Proforma)
       {
           try
           {
               if (aInvoiceReturn.HasProformaSub(Proforma))
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           { }
       }
       public bool chkInvoice(string Invoice)
       {
           try
           {
               if (aInvoiceReturn.HasInvoice(Invoice))
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           { }
       }

        public bool chkInvoiceForToday(string Invoice)
        {
            try
            {
                if (aInvoiceReturn.HasInvoiceForToday(Invoice))
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public bool chkSubInvoice(string Invoice)
       {
           try
           {
               if (aInvoiceReturn.HasInvoicesSUBDEPO(Invoice))
               {
                   return true;
               }
               else
               {
                   return false;
               }
           }
           catch (Exception ex)
           {
               throw ex;
           }
           finally
           { }
       }

       public int DeleteProforma(string Invoice)
       {
           return aInvoiceReturn.DeleteProformaDal(Invoice);
       }
       public int DeleteProformaSub(string Invoice)
       {
           return aInvoiceReturn.DeleteProformaSub(Invoice);
       }
       public int DeleteDeliveyInvoice(string Invoice)
       {
           return aInvoiceReturn.DeleteDeliveyInvoiceDal(Invoice);
       }
       public DataTable LoadDetailID(string Invoice)
       {
           return aInvoiceReturn.LoadDetailID(Invoice);
       }
       public DataTable LoadStock(string Invoice)
       {
           return aInvoiceReturn.LoadStock(Invoice);
       }
       public int SubdepoDeleteDeliveyInvoiceDal(string Invoice)
       {
           return aInvoiceReturn.SubdepoDeleteDeliveyInvoiceDal(Invoice);
       }
    }
}
