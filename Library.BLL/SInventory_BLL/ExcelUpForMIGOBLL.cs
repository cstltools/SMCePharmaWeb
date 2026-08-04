using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAL.SInventory_DAL;
using Library.DAO.SInventory_Entities;

namespace Library.BLL.SInventory_BLL
{
    public class ExcelUpForMIGOBLL
    {
        ExcelUpForMIGODAL aExcelUpForMIGODAL = new ExcelUpForMIGODAL();
        public void XLDataGridToDbByRow(String ShipToParty,String PONo,DateTime PODate,String ItemNo,String OrderDocNo,
                                                         DateTime OrderDocDate, String DeliveryDocNo, DateTime DeliveryDocDate, String LMID, String LMIDDescription, String Batch, DateTime ExpDate, DateTime MfgDate, decimal Qty, String VATChallan,
                                                        String BilltoParty, String InvoiceNo, DateTime InvoiceDate, String CaseNoofShipper, decimal VAT, decimal Amount, decimal Total, String TransportNo, int MigoMasterID)
        {
            aExcelUpForMIGODAL.XLDataGridToDbByRow(ShipToParty, PONo, PODate, ItemNo, OrderDocNo,
                                                          OrderDocDate, DeliveryDocNo, DeliveryDocDate, LMID, LMIDDescription, Batch, ExpDate, MfgDate, Qty, VATChallan,
                                                          BilltoParty, InvoiceNo, InvoiceDate, CaseNoofShipper, VAT, Amount, Total, TransportNo, MigoMasterID);
        }
        public void CustomerXLDataGridToDbByRow(String BRANCH,String BRANCHDES,String CustomerCode,String CUSTOMERNAME,String ADDRESS1,
            String  ADDRESS2,String CITY,String CONTACTPERSON,String CONTACTNUMBER,String MIOCode,String MIOName,String TerritoryCode,String FECode,String FEName,String DZSMCode,
            String DZSMName, String SHIPPINGCOND, String SHIPPINGPOINT, String MarketName, String TERMOFPAYMENT, string Migo)
        {
            aExcelUpForMIGODAL.CustomerXLDataGridToDbByRow(BRANCH, BRANCHDES, CustomerCode, CUSTOMERNAME, ADDRESS1,
                ADDRESS2, CITY, CONTACTPERSON, CONTACTNUMBER, MIOCode, MIOName, TerritoryCode, FECode, FEName, DZSMCode,
                DZSMName, SHIPPINGCOND, SHIPPINGPOINT, MarketName, TERMOFPAYMENT, Migo);
        }
        public int SaveMigo(MigoMasterDAO aMigoMasterDAO)
        {
            try
            {
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    //int MigoMasterID = 0;
                    aMigoMasterDAO.MigoMasterID = aClsPrimaryKeyFind.PrimaryKeyMax("MigoMasterID", "tblMIGOMaster");
                    aMigoMasterDAO.MogoCode = MigoMasterCodeGenerator(aMigoMasterDAO.MigoMasterID);
                    aExcelUpForMIGODAL.SaveMigoDAL(aMigoMasterDAO);
                    return aMigoMasterDAO.MigoMasterID;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }
        public bool VerifyCustomerBLL(string id)
        {
            return aExcelUpForMIGODAL.VerifyCustomerDAL(id);
        }
        public int SaveCustomerUploadMasterDAL(MigoMasterDAO aMigoMasterDAO)
        {
            try
            {
                {
                    ClsPrimaryKeyFind aClsPrimaryKeyFind = new ClsPrimaryKeyFind();
                    //int MigoMasterID = 0;
                    aMigoMasterDAO.MigoMasterID = aClsPrimaryKeyFind.PrimaryKeyMax("CustomerMasterExcelFileMasterID", "tblCustomerMasterExcelFileMaster");
                    aMigoMasterDAO.MogoCode = CustomerMasterCodeGenerator(aMigoMasterDAO.MigoMasterID);
                    aExcelUpForMIGODAL.SaveCustomerUploadMasterDAL(aMigoMasterDAO);
                    return aMigoMasterDAO.MigoMasterID;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            finally
            { }
        }

        public string MigoMasterCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "00" + Id;
            }
            code = "MIGO-" + Id;
            return code;
        }
        public string CustomerMasterCodeGenerator(int id)
        {
            string code = string.Empty;
            string Id = id.ToString();
            if (Id.Length == 1)
            {
                Id = "000" + Id;
            }
            if (Id.Length == 2)
            {
                Id = "00" + Id;
            }
            code = "CMEF-" + Id;
            return code;
        }

        public DataTable LoadMigo()
        {
            return aExcelUpForMIGODAL.LoadMigo();
        }
        public DataTable LoadMigo(string id)
        {
            return aExcelUpForMIGODAL.LoadMigo(id);
        }
        public DataTable LoadMigobyID(int id)
        {
            return aExcelUpForMIGODAL.LoadMigobyID(id);
        }
        public DataTable LoadCustomer(int id)
        {
            return aExcelUpForMIGODAL.LoadCustomer(id);
        }
        public void LoadmanufacturerName(DropDownList ddl)
        {
            aExcelUpForMIGODAL.LoadmanufacturerName(ddl);
        }
        public bool DeleteData(int id)
        {
           return aExcelUpForMIGODAL.DeleteData(id);
        }
        public bool DeleteDetailData(int id)
        {
            return aExcelUpForMIGODAL.DeleteDetailData(id);
        }
        public DataTable LoadMigoDate(string parameter)
        {
            return aExcelUpForMIGODAL.LoadMigoDate(parameter);
        }
        public DataTable LoadCustomer(string parameter)
        {
            return aExcelUpForMIGODAL.LoadCustomer(parameter);
        }
        public DataTable LoadMigoReport(string fromdate, string todate)
        {
            return aExcelUpForMIGODAL.LoadMigoReport(fromdate, todate);
        }
        public DataTable LoadMainMigoReport(string fromdate, string todate)
        {
            return aExcelUpForMIGODAL.LoadMainMigoReport(fromdate, todate);
        }
        public DataTable LoadOrderDetail(string fromdate, string todate,string customercode,string orderno)
        {
            return aExcelUpForMIGODAL.LoadOrderDetail(fromdate, todate,customercode,orderno);
        }
        public int TransfarMigobyID_BLL(int id)
        {
            return aExcelUpForMIGODAL.TransfarMigobyID_DAL(id);
        }
        public int TransfarCustomer_BLL(int id)
        {
            return aExcelUpForMIGODAL.TransfarCustomer_DAL(id);
        }



        public bool DeleteCustomerData(int id)
        {
            return aExcelUpForMIGODAL.DeleteCustomerData(id);
        }
        public bool DeleteCustomerDetailData(int id)
        {
            return aExcelUpForMIGODAL.DeleteCustomerDetailData(id);
        }
        public DataTable GetVerifyedData(string masterId)
        {
            return aExcelUpForMIGODAL.GetVerifyedData(masterId);
        }
        public DataTable GetUnVerifyedData(string masterId)
        {
            return aExcelUpForMIGODAL.GetUnVerifyedData(masterId);
        }
        public DataTable ReportVerifyedData(string masterId)
        {
            return aExcelUpForMIGODAL.ReportVerifyedData(masterId);
        }
        public DataTable ReportUnVerifyedData(string masterId)
        {
            return aExcelUpForMIGODAL.ReportUnVerifyedData(masterId);
        }
    }
}
