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
    public class ExcelUpForCustTagChangeDAL
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
       public bool CustomerXLDataGridToDbByRow(String BRANCH, String BRANCHDES, String CustomerCode, String CUSTOMERNAME, String ADDRESS1,
           String ADDRESS2, String CITY, String CONTACTPERSON, String CONTACTNUMBER, String MIOCode, String MIOName, String TerritoryCode, String FECode, String FEName, String DZSMCode,
            String DZSMName, String SHIPPINGCOND, String SHIPPINGPOINT, String MarketName, String TERMOFPAYMENT, string Migo)
        {
            string insertQuery = @"insert into tblCustomerMasterTagChangeExcelFileDetail (MasterID, BRANCH, BRANCHDES, CustomerCode, CUSTOMERNAME, ADDRESS1,ADDRESS2, CITY, CONTACTPERSON, CONTACTNUMBER, MIOCode, MIOName, TerritoryCode, FECode, FEName, DZSMCode,DZSMName, SHIPPINGCOND, SHIPPINGPOINT, MarketName, TERMOFPAYMENT,Verifyed) 
            values (@MasterID,@BRANCH,@BRANCHDES,@CustomerCode,@CUSTOMERNAME,@ADDRESS1,@ADDRESS2,@CITY,@CONTACTPERSON,@CONTACTNUMBER,@MIOCode,@MIOName,@TerritoryCode,@FECode,@FEName,@DZSMCode,@DZSMName,@SHIPPINGCOND,@SHIPPINGPOINT,@MarketName,@TERMOFPAYMENT,@Verifyed)";
            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@MasterID", SInventorySql.DbValue(Migo)),
                new SqlParameter("@BRANCH", SInventorySql.DbValue(BRANCH)),
                new SqlParameter("@BRANCHDES", SInventorySql.DbValue(BRANCHDES)),
                new SqlParameter("@CustomerCode", SInventorySql.DbValue(CustomerCode)),
                new SqlParameter("@CUSTOMERNAME", SInventorySql.DbValue(CUSTOMERNAME)),
                new SqlParameter("@ADDRESS1", SInventorySql.DbValue(ADDRESS1)),
                new SqlParameter("@ADDRESS2", SInventorySql.DbValue(ADDRESS2)),
                new SqlParameter("@CITY", SInventorySql.DbValue(CITY)),
                new SqlParameter("@CONTACTPERSON", SInventorySql.DbValue(CONTACTPERSON)),
                new SqlParameter("@CONTACTNUMBER", SInventorySql.DbValue(CONTACTNUMBER)),
                new SqlParameter("@MIOCode", SInventorySql.DbValue(MIOCode)),
                new SqlParameter("@MIOName", SInventorySql.DbValue(MIOName)),
                new SqlParameter("@TerritoryCode", SInventorySql.DbValue(TerritoryCode)),
                new SqlParameter("@FECode", SInventorySql.DbValue(FECode)),
                new SqlParameter("@FEName", SInventorySql.DbValue(FEName)),
                new SqlParameter("@DZSMCode", SInventorySql.DbValue(DZSMCode)),
                new SqlParameter("@DZSMName", SInventorySql.DbValue(DZSMName)),
                new SqlParameter("@SHIPPINGCOND", SInventorySql.DbValue(SHIPPINGCOND)),
                new SqlParameter("@SHIPPINGPOINT", SInventorySql.DbValue(SHIPPINGPOINT)),
                new SqlParameter("@MarketName", SInventorySql.DbValue(MarketName)),
                new SqlParameter("@TERMOFPAYMENT", SInventorySql.DbValue(TERMOFPAYMENT)),
                new SqlParameter("@Verifyed", false)
            });
        }

       public bool SaveMigoDAL(MigoMasterDAO aMigoMasterDAO)
                                                      
       {
           string insertQuery = @"insert into tblMIGOMaster (MigoMasterID,MogoCode,ManufacId,MogoDocumentDate,StockUpload,EntryBy,EntryDate) 
            values (@MigoMasterID,@MogoCode,@ManufacId,@MogoDocumentDate,@StockUpload,@EntryBy,@EntryDate)";
                           
           return SInventorySql.Execute(insertQuery, MigoMasterParameters(aMigoMasterDAO));
       }
        public bool SaveCustomerUploadMasterDAL(MigoMasterDAO aMigoMasterDAO)
        {
            string insertQuery = @"insert into tblCustomerMasterTagChangeExcelFileMaster (CustomerTagChangeExcelFileMasterID,CustomerTagChangeExcelFileCode,ManufacId,CustomerTagChangeExcelFileDocumentDate,Transfer,EntryBy,EntryDate,VerifyedAll) 
            values (@MigoMasterID,@MogoCode,@ManufacId,@MogoDocumentDate,@StockUpload,@EntryBy,@EntryDate,@VerifyedAll)";

            List<SqlParameter> parameters = MigoMasterParameters(aMigoMasterDAO);
            parameters.Add(new SqlParameter("@VerifyedAll", false));
            return SInventorySql.Execute(insertQuery, parameters);
        }
        public bool VerifyCustomerDAL(string id)
        {
            string insertQuery = @"exec sp_VerifyCustomerTagList @CustomerTagChangeExcelFileMasterID";

            return SInventorySql.Execute(insertQuery, new List<SqlParameter>
            {
                new SqlParameter("@CustomerTagChangeExcelFileMasterID", SInventorySql.DbValue(id))
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
        
       public DataTable LoadMigoReport(string fromdate,string todate)
       {
           string query = @"SELECT r.ComUnitId,R.ComUnitCode ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,
T.ExpDate,T.PackSize,T.BatchNo,SUM(t.Quantity) AS TotalQuantity,T.UnitPrice,SUM(T.PriceAmount) TotalPriceAmount,UP.VATAmountPerUnit,SUM(T.VATAmount)TotalVATAmount 
,SUM(TotalPriceAmount) AS TotalPriceAmountwithVat,
M.ItemNo,M.OrderDocNo,M.OrderDocDate,M.VATChallan,M.InvoiceNo,CONVERT(NVARCHAR,M.InvoiceDate,103) AS InvoiceDate ,M.TransportNo,M.CaseNoofShipper,R.ReqNo,R.ReqDate,M.DeliveryDocNo,M.DeliveryDocDate
FROM dbo.tblStockInTransfar T
INNER JOIN dbo.tblProduct P ON T.ProductCode = P.ProductCode
LEFT JOIN dbo.tblRequisition R ON T.ReqId = R.ReqId
LEFT JOIN dbo.tblCentralStore W ON T.ReceiveId = W.ReceiveId
LEFT JOIN  dbo.tblMIGODetail M ON W.MigoDetailID = M.MigoDetailID
INNER JOIN dbo.tblUnitPrice UP ON T.ProductCode = UP.ProductCode
  WHERE R.ReqDate BETWEEN @FromDate AND @ToDate GROUP BY M.ItemNo,M.OrderDocNo,M.OrderDocDate,M.VATChallan,M.InvoiceNo,M.InvoiceDate,M.TransportNo,M.CaseNoofShipper,R.ReqNo,R.ReqDate,M.DeliveryDocNo,M.DeliveryDocDate,r.ComUnitId,R.ComUnitCode  ,R.ComUnitName ,P.ProductCode,P.ProductName ,M.MfgDate,T.ExpDate,T.PackSize,T.BatchNo,T.UnitPrice ,UP.VATAmountPerUnit,T.ReceiveDate";

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

       public DataTable LoadOrderDetail(string fromdate, string todate)
       {
           string query = @"SELECT (MIOCode+'-'+MIOName)MIOCode,(SalesCentre+'-'+SalesCentreName)SalesCentre,* FROM dbo.tblOrderListDetail
            LEFT JOIN dbo.tblOrderListMaster ON dbo.tblOrderListDetail.OrderMasterID = dbo.tblOrderListMaster.OrderMasterID WHERE DocumentDate BETWEEN @FromDate AND @ToDate ORDER BY tblOrderListDetail.SalesCentre";

           return SInventorySql.GetDataTable(query, DateRangeParameters(fromdate, todate));
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
        public DataTable LoadCustomer(string parameter)
        {
            string manufacId = ExtractFilterValue(parameter);
            string query = @"SELECT  * FROM dbo.tblCustomerMasterTagChangeExcelFileMaster LEFT JOIN dbo.tblManufacturer ON tblCustomerMasterTagChangeExcelFileMaster.ManufacId = tblManufacturer.ManufacId  Where tblCustomerMasterTagChangeExcelFileMaster.Transfer=0";
            List<SqlParameter> parameters = new List<SqlParameter>();
            if (!string.IsNullOrWhiteSpace(manufacId))
            {
                query += " and tblCustomerMasterTagChangeExcelFileMaster.ManufacId = @ManufacId";
                parameters.Add(new SqlParameter("@ManufacId", SInventorySql.DbValue(manufacId)));
            }
            return SInventorySql.GetDataTable(query, parameters);
        }
        public DataTable LoadCustomer(int MigoMasterID)
        {
            string query = @"SELECT  * FROM dbo.tblCustomerMasterTagChangeExcelFileMaster   Where tblCustomerMasterTagChangeExcelFileMaster.CustomerTagChangeExcelFileMasterID= @CustomerTagChangeExcelFileMasterID";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerTagChangeExcelFileMasterID", MigoMasterID)
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
            string query = @"DELETE FROM dbo.tblCustomerMasterTagChangeExcelFileMaster WHERE CustomerTagChangeExcelFileMasterID = @CustomerTagChangeExcelFileMasterID";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@CustomerTagChangeExcelFileMasterID", MigoMasterID)
            });
        }
        public bool DeleteCustomerDetailData(int MigoMasterID)
        {
            string query = @"DELETE FROM dbo.tblCustomerMasterTagChangeExcelFileDetail WHERE MasterID = @MasterID";
            return SInventorySql.Execute(query, new List<SqlParameter>
            {
                new SqlParameter("@MasterID", MigoMasterID)
            });
        }
        public int TransfarCustomer_DAL(int id)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@CustomerTagChangeExcelFileMasterID", id));
            return aCommonInternalDal.RunStoreProcedure("sp_CustomerTransferTagChange", aSqlParameterList, "SSIDB");
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
            string query = @"SELECT COUNT(*)A FROM dbo.tblCustomerMasterTagChangeExcelFileDetail WHERE MasterID=@MasterID AND Verifyed=@Verifyed";
            return SInventorySql.GetDataTable(query, new List<SqlParameter>
            {
                new SqlParameter("@MasterID", SInventorySql.DbValue(masterId)),
                new SqlParameter("@Verifyed", verifyed)
            });
        }

        private static DataTable GetVerificationReport(string masterId, bool verifyed)
        {
            string query = @"SELECT BRANCH AS ComUnitCode,BRANCHDES AS ComUnitName,CustomerCode AS CustomerCode,CUSTOMERNAME AS CustomerName,ADDRESS1 AS Address,ADDRESS2 AS Addrees2,CITY AS City,CONTACTPERSON AS ConPerson,CONTACTNUMBER AS CellNo,MIOCode AS MiaCode,MIOName AS MiaName,TerritoryCode AS  AreaCode,FECode AS DistrictCode,FEName,DZSMCode AS RegionCode,DZSMName,SHIPPINGCOND AS ShippingCond,SHIPPINGPOINT AS MarketCode,MarketName,TERMOFPAYMENT AS TermOfPayment FROM dbo.tblCustomerMasterTagChangeExcelFileDetail WHERE MasterID=@MasterID AND Verifyed=@Verifyed";
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
