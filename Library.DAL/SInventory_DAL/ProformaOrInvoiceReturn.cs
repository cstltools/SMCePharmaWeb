using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
   public class ProformaOrInvoiceReturn
    {

        public DataTable SelectInvoiceID2(int Invoice)
        {
            string query = @"select InvoiceId from tblInvoice where
      OrderId=@OrderId ";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@OrderId", Invoice)
            });
        }
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();

        public bool HasProforma(string Proforma)
        {
            string query = @"
SELECT InvoiceNo 
FROM tblInvoice 
WHERE DelivaryInvoiceNo IS NULL 
  AND (IsAdjustInvoice IS NULL OR IsAdjustInvoice = 0) 
  AND InvoiceNo = @InvoiceNo ";

            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceNo", SInventorySql.DbValue(Proforma))
            });
        }

        public bool HasProformafORtoday(string Proforma)
        {
            string query = "select InvoiceNo from tblInvoice where DelivaryInvoiceNo is null and (IsAdjustInvoice is null or IsAdjustInvoice=0)  and InvoiceNo = @InvoiceNo and convert(date,InvoiceDate)=convert(date,Getdate())";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceNo", SInventorySql.DbValue(Proforma))
            });
        }
        public bool HasProformaOther(string Proforma)
        {
            string query = "select InvoiceNo from tblInvoice where  InvoiceNo = @InvoiceNo";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceNo", SInventorySql.DbValue(Proforma))
            });
        }

        public bool HasProformaOtherSubdeport(string Proforma)
        {
            string query = "select InvoiceNo from tblSubInvoiceMaster where  InvoiceNo = @InvoiceNo";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceNo", SInventorySql.DbValue(Proforma))
            });
        }


        public bool HasProformaSub(string Proforma)
        {
            string query = "select InvoiceNo from tblSubInvoiceMaster where DelivaryInvoiceNo is null and InvoiceNo = @InvoiceNo";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceNo", SInventorySql.DbValue(Proforma))
            });
        }
        //public bool HasInvoice(string Invoice)
        //{
        //    string query = "select DelivaryInvoiceNo from tblInvoice where DelivaryInvoiceNo = '" + Invoice + "'";
        //    IDataReader dataReader = aCommonInternalDal.DataContainerDataReader(query, "SSIDB");
        //    if (dataReader != null)
        //    {
        //        while (dataReader.Read())
        //        {
        //            return true;
        //        }
        //    }
        //    return false;
        //}
        public bool HasInvoice(string Invoice)
        {
            string query = "select DelivaryInvoiceNo from tblInvoice where DelivaryInvoiceNo = @DelivaryInvoiceNo  and MONTH(UpdateDate)=MONTH(Getdate())  and Year(UpdateDate)=Year(Getdate())";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@DelivaryInvoiceNo", SInventorySql.DbValue(Invoice))
            });
        }

        public bool HasInvoiceForToday(string Invoice)
        {
            string query = "select DelivaryInvoiceNo from tblInvoice where DelivaryInvoiceNo = @DelivaryInvoiceNo  and convert(date,UpdateDate)=convert(date,Getdate())";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@DelivaryInvoiceNo", SInventorySql.DbValue(Invoice))
            });
        }


        public bool HasInvoicesSUBDEPO(string Invoice)
        {
            string query = "select DelivaryInvoiceNo from tblSubInvoiceMaster where DelivaryInvoiceNo = @DelivaryInvoiceNo";
            return SInventorySql.Exists(query, new List<SqlParameter>
            {
                new SqlParameter("@DelivaryInvoiceNo", SInventorySql.DbValue(Invoice))
            });
        } 
        public int DeleteProformaDal(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceCode", Invoice));
            aSqlParameterList.Add(new SqlParameter("@User", System.Web.HttpContext.Current.Session["LoginName"].ToString()));
            return aCommonInternalDal.RunStoreProcedure("sp_Delete_ProformaInvoice", aSqlParameterList, "SSIDB");
        }
        public int DeleteProformaSub(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@InvoiceCode", Invoice));
            aSqlParameterList.Add(new SqlParameter("@User", System.Web.HttpContext.Current.Session["LoginName"].ToString()));
            return aCommonInternalDal.RunStoreProcedure("sp_Delete_ProformaInvoice_SubDeport", aSqlParameterList, "SSIDB");
        }
        public int DeleteDeliveyInvoiceDal(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@DelivaryInvoiceNo", Invoice));
            aSqlParameterList.Add(new SqlParameter("@User", System.Web.HttpContext.Current.Session["LoginName"].ToString()));

            return aCommonInternalDal.RunStoreProcedure("sp_DeleteDeliveryInvoice", aSqlParameterList, "SSIDB");
        }
        public int SubdepoDeleteDeliveyInvoiceDal(string Invoice)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@DelivaryInvoiceNo", Invoice));
            aSqlParameterList.Add(new SqlParameter("@User", System.Web.HttpContext.Current.Session["LoginName"].ToString()));

            return aCommonInternalDal.RunStoreProcedure("sp_DeleteDeliveryInvoiceSubdepo", aSqlParameterList, "SSIDB");
        }
        public DataTable LoadDetailID(string Invoice)
        {
            string query = @"select InvoiceDetailId from tblInvoice I
            inner join tblInvoiceDetail D on I.InvoiceId = D.InvoiceId
            where DelivaryInvoiceNo=@DelivaryInvoiceNo ";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@DelivaryInvoiceNo", SInventorySql.DbValue(Invoice.Trim()))
            });
        }
        public DataTable LoadStock(string InvoiceDetailID)
        {
            string query = @" select * from tblDCStoreFreeze where InvoiceDetailId=@InvoiceDetailId and StockQty<>TotalQuantity";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@InvoiceDetailId", SInventorySql.DbValue(InvoiceDetailID))
            });
        }
      
    }
}
