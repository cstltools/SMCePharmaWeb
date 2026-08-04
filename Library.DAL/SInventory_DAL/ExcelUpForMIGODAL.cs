using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.InternalCls;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
   public  class ExcelUpForMIGODAL
    {
       private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
       public bool XLDataGridToDbByRow(String ShipToParty, String PONo, DateTime PODate, String ItemNo, String OrderDocNo,
                                                         DateTime OrderDocDate, String DeliveryDocNo, DateTime DeliveryDocDate, String LMID, String LMIDDescription, String Batch, DateTime ExpDate, DateTime MfgDate, decimal Qty, String VATChallan,
                                                        String BilltoParty, String InvoiceNo, DateTime InvoiceDate, String CaseNoofShipper, decimal VAT, decimal Amount, decimal Total, String TransportNo, int MigoMasterID)
       {
           string insertQuery = @"insert into tblMIGODetail ( MigoMasterID, PONo, PODate, ItemNo, OrderDocNo,OrderDocDate, DeliveryDocNo, DeliveryDocDate, LMID, LMIDDescription, Batch, ExpDate, MfgDate, Qty, VATChallan,BilltoParty, InvoiceNo, InvoiceDate, CaseNoofShipper, VAT, Amount, Total, TransportNo,ShipToParty) 
            values (@MigoMasterID,@PONo,@PODate,@ItemNo,@OrderDocNo,@OrderDocDate,@DeliveryDocNo,@DeliveryDocDate,@LMID,@LMIDDescription,@Batch,@ExpDate,@MfgDate,@Qty,@VATChallan,@BilltoParty,@InvoiceNo,@InvoiceDate,@CaseNoofShipper,@VAT,@Amount,@Total,@TransportNo,@ShipToParty)";
           return SInventorySql.Execute(insertQuery, new List<SqlParameter>
           {
               new SqlParameter("@MigoMasterID", MigoMasterID),
               new SqlParameter("@PONo", SInventorySql.DbValue(PONo)),
               new SqlParameter("@PODate", PODate),
               new SqlParameter("@ItemNo", SInventorySql.DbValue(ItemNo)),
               new SqlParameter("@OrderDocNo", SInventorySql.DbValue(OrderDocNo)),
               new SqlParameter("@OrderDocDate", OrderDocDate),
               new SqlParameter("@DeliveryDocNo", SInventorySql.DbValue(DeliveryDocNo)),
               new SqlParameter("@DeliveryDocDate", DeliveryDocDate),
               new SqlParameter("@LMID", SInventorySql.DbValue(LMID)),
               new SqlParameter("@LMIDDescription", SInventorySql.DbValue(LMIDDescription)),
               new SqlParameter("@Batch", SInventorySql.DbValue(Batch)),
               new SqlParameter("@ExpDate", ExpDate),
               new SqlParameter("@MfgDate", MfgDate),
               new SqlParameter("@Qty", Qty),
               new SqlParameter("@VATChallan", SInventorySql.DbValue(VATChallan)),
               new SqlParameter("@BilltoParty", SInventorySql.DbValue(BilltoParty)),
               new SqlParameter("@InvoiceNo", SInventorySql.DbValue(InvoiceNo)),
               new SqlParameter("@InvoiceDate", InvoiceDate),
               new SqlParameter("@CaseNoofShipper", SInventorySql.DbValue(CaseNoofShipper)),
               new SqlParameter("@VAT", VAT),
               new SqlParameter("@Amount", Amount),
               new SqlParameter("@Total", Total),
               new SqlParameter("@TransportNo", SInventorySql.DbValue(TransportNo)),
               new SqlParameter("@ShipToParty", SInventorySql.DbValue(ShipToParty))
           });
       }
       public Int32 CustomerXLDataGridToDbByRow(String BRANCH, String BRANCHDES, String CustomerCode, String CUSTOMERNAME, String ADDRESS1,
           String ADDRESS2, String CITY, String CONTACTPERSON, String CONTACTNUMBER, String MIOCode, String MIOName, String TerritoryCode, String FECode, String FEName, String DZSMCode,
           String DZSMName, String SHIPPINGCOND, String SHIPPINGPOINT, String MarketName, String TERMOFPAYMENT, string Migo)
        {
            List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
            aSqlParameterlist.Add(new SqlParameter("@Migo", Migo));
            aSqlParameterlist.Add(new SqlParameter("@BRANCH", BRANCH));
            aSqlParameterlist.Add(new SqlParameter("@BRANCHDES", BRANCHDES));
            aSqlParameterlist.Add(new SqlParameter("@CustomerCode", CustomerCode));
            aSqlParameterlist.Add(new SqlParameter("@CUSTOMERNAME", CUSTOMERNAME));
            aSqlParameterlist.Add(new SqlParameter("@ADDRESS1", ADDRESS1));
            aSqlParameterlist.Add(new SqlParameter("@ADDRESS2", ADDRESS2));
            aSqlParameterlist.Add(new SqlParameter("@CITY", CITY));
            aSqlParameterlist.Add(new SqlParameter("@CONTACTPERSON", CONTACTPERSON));
            aSqlParameterlist.Add(new SqlParameter("@CONTACTNUMBER", CONTACTNUMBER));
            aSqlParameterlist.Add(new SqlParameter("@MIOCode", MIOCode));
            aSqlParameterlist.Add(new SqlParameter("@MIOName", MIOName));
            aSqlParameterlist.Add(new SqlParameter("@TerritoryCode", TerritoryCode));
            aSqlParameterlist.Add(new SqlParameter("@FECode", FECode));
            aSqlParameterlist.Add(new SqlParameter("@FEName", FEName));
            aSqlParameterlist.Add(new SqlParameter("@DZSMCode", DZSMCode));
            aSqlParameterlist.Add(new SqlParameter("@DZSMName", DZSMName));
            aSqlParameterlist.Add(new SqlParameter("@SHIPPINGCOND", SHIPPINGCOND));
            aSqlParameterlist.Add(new SqlParameter("@SHIPPINGPOINT", SHIPPINGPOINT));
            aSqlParameterlist.Add(new SqlParameter("@MarketName", MarketName));
            aSqlParameterlist.Add(new SqlParameter("@TERMOFPAYMENT", TERMOFPAYMENT));
            aSqlParameterlist.Add(new SqlParameter("@Verifyed", "False"));

            return aCommonInternalDal.SaveAction("sp_I_Customer", aSqlParameterlist, "@DetailID");
        }

       public bool SaveMigoDAL(MigoMasterDAO aMigoMasterDAO)
                                                      
       {
           string insertQuery = @"insert into tblMIGOMaster (MigoMasterID,MogoCode,ManufacId,MogoDocumentDate,StockUpload,EntryBy,EntryDate) 
            values (@MigoMasterID,@MogoCode,@ManufacId,@MogoDocumentDate,@StockUpload,@EntryBy,@EntryDate)";
                           
           return SInventorySql.Execute(insertQuery, MigoMasterParameters(aMigoMasterDAO));
       }
        public bool SaveCustomerUploadMasterDAL(MigoMasterDAO aMigoMasterDAO)
        {
            string insertQuery = @"insert into tblCustomerMasterExcelFileMaster (CustomerMasterExcelFileMasterID,CustomerMasterExcelFileCode,ManufacId,CustomerMasterExcelFileDocumentDate,Transfer,EntryBy,EntryDate,VerifyedAll) 
            values (@MigoMasterID,@MogoCode,@ManufacId,@MogoDocumentDate,@StockUpload,@EntryBy,@EntryDate,@VerifyedAll)";

            List<SqlParameter> parameters = MigoMasterParameters(aMigoMasterDAO);
            parameters.Add(new SqlParameter("@VerifyedAll", false));
            return SInventorySql.Execute(insertQuery, parameters);
        }
        public bool VerifyCustomerDAL(string id)
        {
            string insertQuery = @"exec sp_VerifyCustomer @CustomerMasterExcelFileMasterID";

            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@CustomerMasterExcelFileMasterID", SInventorySql.DbValue(id))
            });
        }
       public void LoadmanufacturerName(DropDownList ddl)
       {
           ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
           string queryStr = "select * from tblManufacturer";
           aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
       }
       public DataTable LoadMigo()
       {
           string query = @"SELECT TOP 10 * FROM dbo.tblMIGOMaster
INNER JOIN dbo.tblManufacturer ON tblMIGOMaster.ManufacId = tblManufacturer.ManufacId
where StockUpload=0 
ORDER BY MogoDocumentDate DESC ";

           return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
       }
       public DataTable LoadMigobyID(int MigoMasterID)
       {
           string query = @"SELECT StockUpload,MigoMasterID FROM dbo.tblMIGOMaster
           left JOIN dbo.tblManufacturer ON tblMIGOMaster.ManufacId = tblManufacturer.ManufacId
           where MigoMasterID = @MigoMasterID"; 

           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@MigoMasterID", MigoMasterID)
           });
       }

       public DataTable LoadMigoReport(string fromdate, string todate)
       {
           string query = @"SELECT r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,
T.ExpDate,T.PackSize,T.BatchNo,SUM(t.Quantity) AS TotalQuantity,T.UnitPrice,SUM(T.PriceAmount) TotalPriceAmount,UP.VATAmountPerUnit,SUM(T.VATAmount)TotalVATAmount 
,SUM(TotalPriceAmount) AS TotalPriceAmountwithVat,R.ReqNo,R.ReqDate
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN dbo.tblWHStockInDetail M ON W.MigoDetailID = M.WHStockInDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
WHERE R.ReqDate BETWEEN @FromDate AND @ToDate GROUP BY R.ReqNo,R.ReqDate,r.ComUnitId,R.ComUnitCode  ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice ,UP.VATAmountPerUnit,T.ReceiveDate";

           return SInventorySql.GetDataTable(query, DateRangeParameters(fromdate, todate));
       }


       public DataTable LoadMainMigoReport(string fromdate, string todate)
       {
           string query = @"SELECT pp.ProductName AS LMIDDescription,CONVERT(NVARCHAR,D.PODate,103)PODate,CONVERT(NVARCHAR,D.OrderDocDate,103)OrderDocDate,CONVERT(NVARCHAR,D.DeliveryDocDate,103)DeliveryDocDate,
          CONVERT(NVARCHAR,D.MfgDate,103)MfgDate,CONVERT(NVARCHAR,D.ExpDate,103)ExpDate,CONVERT(NVARCHAR,D.InvoiceDate,103)InvoiceDate,* 
             FROM dbo.tblMIGODetail D
           INNER JOIN dbo.tblMIGOMaster  M ON D.MigoMasterID=M.MigoMasterID
           LEFT JOIN dbo.tblProduct PP ON D.LMID = pp.ProductCode
           WHERE M.MogoDocumentDate BETWEEN @FromDate AND @ToDate";
           return SInventorySql.GetDataTable(query, DateRangeParameters(fromdate, todate));
       }

       public DataTable LoadOrderDetail(string fromdate, string todate,string custcode,string orderno)
       {
           string query = @"SELECT (MIOCode+'-'+MIOName)MIOCode,(SalesCentre+'-'+SalesCentreName)SalesCentre,* FROM dbo.tblOrderListDetail
            LEFT JOIN dbo.tblOrderListMaster ON dbo.tblOrderListDetail.OrderMasterID = dbo.tblOrderListMaster.OrderMasterID WHERE (DocumentDate BETWEEN @FromDate AND @ToDate)
            AND OrderCode=ISNULL(@OrderCode,OrderCode) AND CustomerID=ISNULL(@CustomerID,CustomerID) ORDER BY tblOrderListDetail.SalesCentre";

           List<SqlParameter> parameters = DateRangeParameters(fromdate, todate);
           parameters.Add(new SqlParameter("@OrderCode", string.IsNullOrEmpty(orderno) ? (object)DBNull.Value : orderno));
           parameters.Add(new SqlParameter("@CustomerID", string.IsNullOrEmpty(custcode) ? (object)DBNull.Value : custcode));
           return SInventorySql.GetDataTable(query, parameters);
       }
       
       public bool DeleteData(int MigoMasterID)
       {
           string query = @"DELETE FROM dbo.tblMIGOMaster WHERE MigoMasterID = @MigoMasterID"; 
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@MigoMasterID", MigoMasterID)
           });
       }
       public bool DeleteDetailData(int MigoMasterID)
       {
           string query = @"DELETE FROM dbo.tblMIGODetail WHERE MigoMasterID = @MigoMasterID";
           return SInventorySql.Execute(query, new List<SqlParameter>
           {
               new SqlParameter("@MigoMasterID", MigoMasterID)
           });
       }
       public DataTable LoadMigo(string MigoMasterID)
       {
           string query = @"SELECT  * FROM dbo.tblMIGODetail

        WHERE MigoMasterID = @MigoMasterID";

           return SInventorySql.GetDataTable(query, new List<SqlParameter>
           {
               new SqlParameter("@MigoMasterID", SInventorySql.DbValue(MigoMasterID))
           });
       }

       public DataTable LoadMigoDate(string parameter)
       {
           List<SqlParameter> parameters;
           string filter = BuildMigoDateFilter(parameter, out parameters);
           string query = @"SELECT  * FROM dbo.tblMIGOMaster  left JOIN dbo.tblManufacturer ON tblMIGOMaster.ManufacId = tblManufacturer.ManufacId Where StockUpload=0" + filter;
           return SInventorySql.GetDataTable(query, parameters);
       }
        public DataTable LoadCustomer(string parameter)
        {
            string manufacId = ExtractFilterValue(parameter);
            string query = @"SELECT  * FROM dbo.tblCustomerMasterExcelFileMaster LEFT JOIN dbo.tblManufacturer ON tblCustomerMasterExcelFileMaster.ManufacId = tblManufacturer.ManufacId  Where tblCustomerMasterExcelFileMaster.Transfer=0";
            List<SqlParameter> parameters = new List<SqlParameter>();
            if (!string.IsNullOrWhiteSpace(manufacId))
            {
                query += " and tblCustomerMasterExcelFileMaster.ManufacId = @ManufacId";
                parameters.Add(new SqlParameter("@ManufacId", SInventorySql.DbValue(manufacId)));
            }
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable LoadCustomer(int MigoMasterID)
        {
            string query = @"SELECT  * FROM dbo.tblCustomerMasterExcelFileMaster   Where tblCustomerMasterExcelFileMaster.CustomerMasterExcelFileMasterID= @CustomerMasterExcelFileMasterID";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerMasterExcelFileMasterID", MigoMasterID)
            });
        }
       public int TransfarMigobyID_DAL(int id)
       {
           List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
           aSqlParameterList.Add(new SqlParameter("@MigoMasterID_In", id));
           return aCommonInternalDal.RunStoreProcedure("sp_StockInMIGOtoCentralStore", aSqlParameterList, "SSIDB");
       }


        public bool DeleteCustomerData(int MigoMasterID)
        {
            string query = @"DELETE FROM dbo.tblCustomerMasterExcelFileMaster WHERE CustomerMasterExcelFileMasterID = @CustomerMasterExcelFileMasterID";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerMasterExcelFileMasterID", MigoMasterID)
            });
        }
        public bool DeleteCustomerDetailData(int MigoMasterID)
        {
            string query = @"DELETE FROM dbo.tblCustomerMasterExcelFileDetail WHERE MasterID = @MasterID";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@MasterID", MigoMasterID)
            });
        }
        public int TransfarCustomer_DAL(int id)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@CustomerMasterExcelFileMasterID", id));
            return aCommonInternalDal.RunStoreProcedure("sp_CustomerTransfer", aSqlParameterList, "SSIDB");
        }
        public DataTable GetVerifyedData(string masterId)
        {
            return GetVerificationCount(masterId, true);
        }
        public DataTable GetUnVerifyedData(string masterId)
        {
            return GetVerificationCount(masterId, false);
        }
        public DataTable ReportVerifyedData(string masterId)
        {
            return GetVerificationReport(masterId, true);
        }
        public DataTable ReportUnVerifyedData(string masterId)
        {
            return GetVerificationReport(masterId, false);
        }

        private static List<SqlParameter> MigoMasterParameters(MigoMasterDAO migoMaster)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@MigoMasterID", migoMaster.MigoMasterID),
                new SqlParameter("@MogoCode", SInventorySql.DbValue(migoMaster.MogoCode)),
                new SqlParameter("@ManufacId", migoMaster.ManufacId),
                new SqlParameter("@MogoDocumentDate", migoMaster.MogoDocumentDate),
                new SqlParameter("@StockUpload", migoMaster.StockUpload),
                new SqlParameter("@EntryBy", SInventorySql.DbValue(migoMaster.EntryBy)),
                new SqlParameter("@EntryDate", migoMaster.EntryDate)
            };
        }

        private static List<SqlParameter> DateRangeParameters(string fromdate, string todate)
        {
            return new List<SqlParameter>
            {
                new SqlParameter("@FromDate", SInventorySql.DbValue(fromdate)),
                new SqlParameter("@ToDate", SInventorySql.DbValue(todate))
            };
        }

        private static DataTable GetVerificationCount(string masterId, bool verifyed)
        {
            string query = @"SELECT COUNT(*)A FROM dbo.tblCustomerMasterExcelFileDetail WHERE MasterID=@MasterID AND Verifyed=@Verifyed";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MasterID", SInventorySql.DbValue(masterId)),
                new SqlParameter("@Verifyed", verifyed)
            });
        }

        private static DataTable GetVerificationReport(string masterId, bool verifyed)
        {
            string query = @"SELECT BRANCH AS ComUnitCode,BRANCHDES AS ComUnitName,CustomerCode AS CustomerCode,CUSTOMERNAME AS CustomerName,ADDRESS1 AS Address,ADDRESS2 AS Addrees2,CITY AS City,CONTACTPERSON AS ConPerson,CONTACTNUMBER AS CellNo,MIOCode AS MiaCode,MIOName AS MiaName,TerritoryCode AS  AreaCode,FECode AS DistrictCode,FEName,DZSMCode AS RegionCode,DZSMName,SHIPPINGCOND AS ShippingCond,SHIPPINGPOINT AS MarketCode,MarketName,TERMOFPAYMENT AS TermOfPayment FROM dbo.tblCustomerMasterExcelFileDetail WHERE MasterID=@MasterID AND Verifyed=@Verifyed";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MasterID", SInventorySql.DbValue(masterId)),
                new SqlParameter("@Verifyed", verifyed)
            });
        }

        private static string BuildMigoDateFilter(string parameter, out List<SqlParameter> parameters)
        {
            parameters = new List<SqlParameter>();
            if (string.IsNullOrWhiteSpace(parameter))
            {
                return string.Empty;
            }

            List<string> values = ExtractQuotedValues(parameter);
            string filter = string.Empty;
            int valueIndex = 0;

            if (parameter.IndexOf("ManufacId", StringComparison.OrdinalIgnoreCase) >= 0 && values.Count > valueIndex)
            {
                filter += " and tblMIGOMaster.ManufacId = @ManufacId";
                parameters.Add(new SqlParameter("@ManufacId", SInventorySql.DbValue(values[valueIndex])));
                valueIndex++;
            }

            if (parameter.IndexOf("MogoDocumentDate", StringComparison.OrdinalIgnoreCase) >= 0 && values.Count >= valueIndex + 2)
            {
                filter += " and MogoDocumentDate between @FromDate and @ToDate";
                parameters.Add(new SqlParameter("@FromDate", SInventorySql.DbValue(values[valueIndex])));
                parameters.Add(new SqlParameter("@ToDate", SInventorySql.DbValue(values[valueIndex + 1])));
            }

            return filter;
        }

        private static string ExtractFilterValue(string parameter)
        {
            List<string> values = ExtractQuotedValues(parameter);
            return values.Count > 0 ? values[0] : null;
        }

        private static List<string> ExtractQuotedValues(string parameter)
        {
            List<string> values = new List<string>();
            if (string.IsNullOrWhiteSpace(parameter))
            {
                return values;
            }

            int start = 0;
            while (start < parameter.Length)
            {
                start = parameter.IndexOf("'", start, StringComparison.Ordinal);
                if (start < 0)
                {
                    break;
                }

                int end = parameter.IndexOf("'", start + 1, StringComparison.Ordinal);
                if (end < 0)
                {
                    values.Add(parameter.Substring(start + 1).Trim());
                    break;
                }

                values.Add(parameter.Substring(start + 1, end - start - 1).Trim());
                start = end + 1;
            }

            return values;
        }
    }
}
