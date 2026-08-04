using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAL.MAIN_FUNCTION;
using Library.DAO.SInventory_Entities;

namespace Library.DAL.SInventory_DAL
{
    public class OrderInfoDALSalesReturn
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        DB_Manager aDbManager = new DB_Manager();
        private DataAccessManager  accessManager = new DataAccessManager ();
        private static readonly HashSet<string> FilterColumns = new HashSet<string>(StringComparer.OrdinalIgnoreCase)
        {
            "tblOrder.ComUnitId",
            "dbo.tblCompanyUnit.ComUnitId",
            "ComUnitId",
            "ManufacId",
            "MarketId",
            "dbo.tblMarket.MarketId",
            "DistributionRouteId",
            "tblOrder.DistributionRouteId",
            "InvoiceDate",
            "UpdateDate"
        };

        private static readonly Regex FilterRegex = new Regex(
            @"(?<column>(?:[A-Za-z_][A-Za-z0-9_]*\.)?[A-Za-z_][A-Za-z0-9_]*)\s*=\s*'?(?<value>[^'\s]+)'?",
            RegexOptions.Compiled);

        private static SqlParameter Param(string name, object value)
        {
            return new SqlParameter(name, SInventorySql.DbValue(value));
        }

        private static DataTable GetDataTable(string query, params SqlParameter[] parameters)
        {
            return SInventorySql.GetDataTable(query, new List<SqlParameter>(parameters));
        }

        private static void BindDropDown(DropDownList ddl, DataTable dataTable, string textField, string valueField)
        {
            ddl.DataSource = dataTable;
            ddl.DataTextField = textField;
            ddl.DataValueField = valueField;
            ddl.DataBind();
        }

        private static string BuildFilterClause(string fragment, List<SqlParameter> parameters)
        {
            List<string> conditions = new List<string>();
            foreach (Match match in FilterRegex.Matches(fragment ?? string.Empty))
            {
                string column = match.Groups["column"].Value;
                if (!FilterColumns.Contains(column))
                {
                    continue;
                }

                string parameterName = "@filter" + parameters.Count;
                conditions.Add(column + "=" + parameterName);
                parameters.Add(Param(parameterName, match.Groups["value"].Value));
            }

            return conditions.Count == 0 ? string.Empty : " AND " + string.Join(" AND ", conditions);
        }

        public Int32 GenerateSubInvoiceByOrderId(int orderId, int userId, string batchno)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderId", orderId));
            aSqlParameterList.Add(new SqlParameter("@UserId", userId));
            aSqlParameterList.Add(new SqlParameter("@BatchNo1", batchno));
            return aCommonInternalDal.RunStoreProcedure("sp_Process_SubDepoProformaInvoiceByOrderId", aSqlParameterList, "SSIDB");
        }
        public DataTable LoadPaymentInvSPWithPaymentAmount(string param, string PaymentAmount, string CollectionBy)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@param", param));
                aSqlParameters.Add(new SqlParameter("@PaymentAmount", PaymentAmount));
                aSqlParameters.Add(new SqlParameter("@CollectionBy", CollectionBy));


                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_GET_PaymentInvSPPaymentAmount", aSqlParameters);



                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable LoadSubInvoiceBatchId()
        {
            string query = @"select 
                                --case when CHARINDEX('-',BatchNo)>0 
                                --     then SUBSTRING(BatchNo,1,CHARINDEX('-',BatchNo)-1) 
                                --     else BatchNo end RouteId,
		                             MAX(CONVERT(INT, 
                                CASE WHEN CHARINDEX('-',BatchNo)>0 
                                     THEN SUBSTRING(BatchNo,CHARINDEX('-',BatchNo)+1,len(BatchNo))  
                                     ELSE NULL END))+1 as BatchNoInt
                            from dbo.tblSubInvoiceMasterBatch";

            return GetDataTable(query);
        }
        public DataTable LoadInvoiceReturn(string invoiceId)
        {
            string query = @"SELECT '0' as SubDCStoreId,*,tblInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,tblInvoiceDetail.UnitPrice,tblInvoiceDetail.UnitVatAmount,tblInvoiceDetail.TotalQuantity AS Quantity,tblInvoiceDetail.TotalPrice,tblInvoiceDetail.TotalPriceVatAmount AS VAT
,tblInvoiceDetail.DiscountPercentage,tblInvoiceDetail.DiscountAmount,tblInvoiceDetail.NetAmount AS NetPrice,
'0'BonusQty,tblInvoiceDetail.TotalQuantity AS TotalQty,ISNULL(tblReturnInvoiceDetail.TotalQuantity,0) AS TQty FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
			LEFT JOIN dbo.tblReturnInvoiceDetail ON dbo.tblReturnInvoiceDetail.InvoiceDetailId=dbo.tblInvoiceDetail.InvoiceDetailId WHERE dbo.tblInvoice.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceId));
        }

        public DataTable LoadDoctorOrderForOrderCreation(string comunitId)
        {
            //            string query = @"SELECT * FROM dbo.tblOrder
            //            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            //            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            //            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            //            WHERE IsInvoice = 0 and   V.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND IsInvoice =0  AND (TerritoryCode<>'BL-141' or TerritoryCode<>'BL-142' or TerritoryCode<>'BL-144' or TerritoryCode<>'BL-145' or TerritoryCode<>'kL-137' or TerritoryCode <> 'KL-131' OR TerritoryCode <> 'KL-132' OR TerritoryCode <> 'KL-133' OR TerritoryCode <> 'KL-134' OR TerritoryCode <> 'KL-135' OR TerritoryCode <> 'KL-136' OR TerritoryCode <> 'KL-171' OR TerritoryCode <> 'KL-173' OR TerritoryCode <> 'KL-174' )";

            string query = @"SELECT * FROM dbo.tblOrder_Doctorrequirement
            left JOIN dbo. tblDoctorMaster V ON dbo.tblOrder_Doctorrequirement.DoctorId = V.DoctorId
            left JOIN dbo.tblCompanyUnit ON dbo.tblOrder_Doctorrequirement.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
           
            WHERE tblOrder_Doctorrequirement.ComUnitId=@ComUnitId AND IsInvoice =0  ";

            return GetDataTable(query, Param("@ComUnitId", comunitId));
        }
        public Int32 GenerateInvoiceByOrderId(int orderId, int userId, string batchno, string DANameId)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderId", orderId));
            aSqlParameterList.Add(new SqlParameter("@UserId", userId));
            aSqlParameterList.Add(new SqlParameter("@BatchNo1", batchno));
            aSqlParameterList.Add(new SqlParameter("@DANameId", DANameId));
            return aCommonInternalDal.RunStoreProcedure("sp_Process_ProformaInvoiceByOrderId", aSqlParameterList, "SSIDB");
        }
        public DataTable LoadSubInvoiceReturn(string invoiceId)
        {
            string query = @"SELECT SubDCStoreId AS DCStoreId,*,tblSubInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,tblSubInvoiceDetail.UnitPrice,tblSubInvoiceDetail.UnitVatAmount,tblSubInvoiceDetail.TotalQuantity AS Quantity,tblSubInvoiceDetail.TotalPrice,tblSubInvoiceDetail.TotalPriceVatAmount AS VAT
,tblSubInvoiceDetail.DiscountPercentage,tblSubInvoiceDetail.DiscountAmount,tblSubInvoiceDetail.NetAmount AS NetPrice,
'0'BonusQty,tblSubInvoiceDetail.TotalQuantity AS TotalQty,ISNULL(tblReturnInvoiceDetail.TotalQuantity,0) AS TQty FROM dbo.tblSubInvoiceMaster
            LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblSubInvoiceDetail.InvoiceId
            LEFT JOIN dbo.tblProduct ON dbo.tblSubInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
			LEFT JOIN dbo.tblReturnInvoiceDetail ON dbo.tblReturnInvoiceDetail.InvoiceDetailId=dbo.tblSubInvoiceDetail.InvoiceDetailId WHERE dbo.tblSubInvoiceMaster.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceId));
        }
//        public DataTable SubLoadInvoice(string invoiceId)
//        {
//            string query = @"SELECT *,UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,DiscountAmount,NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty 
//            FROM dbo.tblSubInvoiceMaster
//            LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblSubInvoiceDetail.InvoiceId
//            LEFT JOIN dbo.tblProduct ON dbo.tblSubInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
//            LEFT JOIN dbo.tblCustMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblSubInvoiceDetail.InvoiceId='" + invoiceId + "'";

//            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
//        }

        public DataTable LoadOrder(string comunitId,string manufacId,string marketId)
        {
            string query = @"SELECT * FROM dbo.tblOrder
            LEFT JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
          LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            LEFT JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  WHERE V.ComUnitId=@ComUnitId AND ManufacId=@ManufacId AND dbo.tblMarket.MarketId=@MarketId AND IsInvoice =0 ";

            return GetDataTable(query, Param("@ComUnitId", comunitId), Param("@ManufacId", manufacId), Param("@MarketId", marketId));
        }
        public void LoadMarketByInvoice(DropDownList ddl, string comunitId)
        {
//            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
//            string queryStr = @"	  SELECT Distinct tblMarket.MarketId,tblInvoice.MarketCode,tblInvoice.MarketName FROM dbo.tblOrder
//         --   left JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
//         --   left JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
//            left JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
//			left JOIN dbo.tblMarket ON tblInvoice.MarketCode = dbo.tblMarket.MarketCode
//          WHERE  TpGrandTotal>0 AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='') and tblOrder.ComUnitId='" + comunitId + "'";
//            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);

            string queryStr = @"SELECT Distinct tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
          WHERE  TpGrandTotal>0 AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='') and tblOrder.ComUnitId=@ComUnitId";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comunitId)), "MarketName", "MarketId");
        }
        public void SubdeportLoadMarketByInvoice(DropDownList ddl, string comunitId)
        {
            string queryStr = @"SELECT Distinct tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            inner JOIN dbo.tblSubInvoiceMaster ON dbo.tblOrder.OrderId=dbo.tblSubInvoiceMaster.OrderId 
          WHERE  TpGrandTotal>0 AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='') and tblOrder.ComUnitId=@ComUnitId";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comunitId)), "MarketName", "MarketId");
        }
        public DataTable LoadOrderForOrderCreation(string comunitId, string manufacId, string marketId)
        {
            //            string query = @"SELECT * FROM dbo.tblOrder
            //            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            //            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            //            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            //            WHERE IsInvoice = 0 and   V.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND IsInvoice =0  AND (TerritoryCode<>'BL-141' or TerritoryCode<>'BL-142' or TerritoryCode<>'BL-144' or TerritoryCode<>'BL-145' or TerritoryCode<>'kL-137' or TerritoryCode <> 'KL-131' OR TerritoryCode <> 'KL-132' OR TerritoryCode <> 'KL-133' OR TerritoryCode <> 'KL-134' OR TerritoryCode <> 'KL-135' OR TerritoryCode <> 'KL-136' OR TerritoryCode <> 'KL-171' OR TerritoryCode <> 'KL-173' OR TerritoryCode <> 'KL-174' )";


            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@comunitId", comunitId));
                aSqlParameters.Add(new SqlParameter("@manufacId", manufacId));


                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_LoadOrderListForOrderCreation", aSqlParameters);



                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }

            //string query = @"SELECT '10' DueAmount, tblCustomerType.CustomerType,tblMarket.MarketName,* FROM dbo.tblOrder  With (NOLOCK) 
            //inner JOIN tblcustmaster V  With (NOLOCK)  ON dbo.tblOrder.CustomerCode = V.CustomerCode
            //inner JOIN dbo.tblCompanyUnit  With (NOLOCK)  ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            //inner JOIN dbo.tblMarket  With (NOLOCK)  ON tblOrder.MarketId = dbo.tblMarket.MarketId
            //inner JOIN tblCustomerType  With (NOLOCK)  ON tblOrder.CustTypeId = dbo.tblCustomerType.CustomerTypeId  
            //WHERE IsInvoice = 0 and OrderType='Regular' and   tblOrder.ComUnitId='" + comunitId + "' AND tblOrder.DistributionRouteId='" + manufacId + "'  AND IsInvoice =0  and  IsPrepareforInvoice=1  and  tblOrder.ActionStatus='2' and  tblOrder.IsSubDepo =0";

            //return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable subDepoOrderLoad(string comunitId, string manufacId, string root)
        {
            string query = @"SELECT * FROM dbo.tblOrder
            inner JOIN dbo. tblCustMaster V ON dbo.tblOrder.CustomerMasterId = V.CustomerMasterId
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitId=dbo.tblCompanyUnit.ComUnitId
            inner JOIN dbo.tblMarket ON tblOrder.MarketId = dbo.tblMarket.MarketId  
            WHERE IsInvoice = 0 and  tblOrder.IsSubDepo =1 and  tblOrder.ComUnitId=@ComUnitId AND ManufacId=@ManufacId  AND tblOrder.DistributionRouteId=@DistributionRouteId  ";

            //  )


            //AND(TerritoryCode = 'BL-141' or TerritoryCode = 'BL-142' or TerritoryCode = 'BL-144' or TerritoryCode = 'BL-145' or TerritoryCode = 'kL-137' or TerritoryCode = 'KL-131' OR TerritoryCode = 'KL-132' OR TerritoryCode = 'KL-133' OR TerritoryCode = 'KL-134' OR TerritoryCode = 'KL-135' OR TerritoryCode = 'KL-136' OR TerritoryCode = 'KL-171' OR TerritoryCode = 'KL-173' OR TerritoryCode = 'KL-174')

            return GetDataTable(query, Param("@ComUnitId", comunitId), Param("@ManufacId", manufacId), Param("@DistributionRouteId", root));
        }
        public DataTable LoadInvoiceBatchId()
        {
            string query = @"select 
                                --case when CHARINDEX('-',BatchNo)>0 
                                --     then SUBSTRING(BatchNo,1,CHARINDEX('-',BatchNo)-1) 
                                --     else BatchNo end RouteId,
		                             MAX(CONVERT(INT, 
                                CASE WHEN CHARINDEX('-',BatchNo)>0 
                                     THEN SUBSTRING(BatchNo,CHARINDEX('-',BatchNo)+1,len(BatchNo))  
                                     ELSE NULL END))+1 as BatchNoInt
                            from dbo.tblInvoiceBatch";

            return GetDataTable(query);
        }
        public DataTable LoadOrderWithInvoice(string comunitId, string manufacId, string marketId)
        {
            string query = @"              
            SELECT tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder
            
            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId=@ComUnitId AND tblOrder.DistributionRouteId=@DistributionRouteId  AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='')  order by InvoiceDate asc";

            return GetDataTable(query, Param("@ComUnitId", comunitId), Param("@DistributionRouteId", manufacId));
//            string query = @"              
//            SELECT * FROM dbo.tblOrder
//            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
//            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
//            inner JOIN dbo.tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
//            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
//            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo=''  order by InvoiceDate asc";

//            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable LoadOrderWithInvoice(string param)
        {
            List<SqlParameter> parameters = new List<SqlParameter>();
            string query = @"            
            SELECT case when  MONTH(CONVERT(date,tblInvoice.InvoiceDate))=  MONTH(CONVERT(date,GETDATE())) then 'True' else 'False' end chkStatus ,tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder With (nolock)
            
            inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            inner JOIN dbo. tblCustMaster  V   With (nolock)  ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                       inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId  
            WHERE  TpGrandTotal>0     " + BuildFilterClause(param, parameters) + "  ";

            return SInventorySql.GetDataTable(query, parameters);
            //            string query = @"              
            //            SELECT * FROM dbo.tblOrder
            //            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            //            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            //            inner JOIN dbo.tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
            //            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            //            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo=''  order by InvoiceDate asc";

            //            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");


        }

        public DataTable LoadOrderWithInvoiceSP(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@param", param));
                

                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList_New", aSqlParameters);



                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
            public DataTable CheckInvoiceCustpayment(decimal PaymentAmount, int InvoiceId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@PaymentAmount", PaymentAmount));
                aSqlParameters.Add(new SqlParameter("@InvoiceId", InvoiceId));
                

                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_Check_Duplicate_InvoiceFinalPayment", aSqlParameters);



                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
           public DataTable LoadPaymentInvSP(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@param", param));
                

                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_GET_PaymentInvSP", aSqlParameters);



                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        
           public DataTable LoadPaymentInvSPTPVATAmt(string InvoiceId , decimal PayAmount)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@InvoiceId", InvoiceId));
                aSqlParameters.Add(new SqlParameter("@PayAmount", PayAmount)); 

                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_GET_PaymentInvSPTPVATAmt", aSqlParameters);



                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }


        public DataTable LoadSummaryList(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@param", param));


                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                dt = accessManager.GetDataTable("sp_LoadingSummary", aSqlParameters);


                return dt;
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable LoadDistributionRoute(string comunitId)
        {
            string query = @"              
         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName

from tblOrder
inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
where IsInvoice=0 and ComUnitId=@ComUnitId";
//            string query = @"              
//           select dcMas.RouteInformationMasterId from tblDcWiseTerritoryMaster mas
//inner join tblDcWiseTerritoryDetail dtl on mas.DcWiseTerritoryMasterId=dtl.DcWiseTerritoryMasterId
//inner join tblTerritory st on st.TerritoryId=dtl.TerritoryId
//inner join tblSubTerritory subt on subt.SubTerritoryId=st.TerritoryId
//
//inner join tblMarket mr on subt.SubTerritoryId=mr.MarketId
//inner join tblRouteInformationMarketDetail dcRoute on dcRoute.MarketId=mr.MarketId
//inner join tblRouteInformationMaster dcMas on dcRoute.RouteInformationMasterId=dcMas.RouteInformationMasterId 
//where mas.DCId="+ comunitId;

            return GetDataTable(query, Param("@ComUnitId", comunitId));
            //            string query = @"              
            //            SELECT * FROM dbo.tblOrder
            //            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            //            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            //            inner JOIN dbo.tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId
            //            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            //            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo=''  order by InvoiceDate asc";

            //            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable SubDeportLoadOrderWithInvoice(string comunitId, string manufacId, string marketId)
        {
            string query = @"              
            SELECT * FROM dbo.tblOrder
            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            inner JOIN dbo.tblSubInvoiceMaster ON dbo.tblOrder.OrderId=dbo.tblSubInvoiceMaster.OrderId 
            inner JOIN dbo.tblCompanyUnit ON dbo.tblSubInvoiceMaster.ComUnitId=dbo.tblCompanyUnit.ComUnitId
            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId=@ComUnitId AND ManufacId=@ManufacId AND dbo.tblMarket.MarketId=@MarketId AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='')";

            return GetDataTable(query, Param("@ComUnitId", comunitId), Param("@ManufacId", manufacId), Param("@MarketId", marketId));
        }
       
        public DataTable SubLoadInvoice(string invoiceId)
        {
            string query = @"
			SELECT tblSubInvoiceDetail.DiscountAmount,tblOrderDetail.ISGiftProduct,tblOrderDetail.IsCampaignProduct,*,tblSubInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,tblSubInvoiceDetail.UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,tblSubInvoiceDetail.NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty 
            FROM dbo.tblSubInvoiceMaster
            LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblSubInvoiceDetail.InvoiceId
			 LEFT JOIN tblOrderDetail ON dbo.tblOrderDetail.OrderDetailId = dbo.tblSubInvoiceDetail.OrderDetailsId
            LEFT JOIN dbo.tblProduct ON dbo.tblSubInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblSubInvoiceDetail.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceId));
        }
        public DataTable LoadDelivaryInvoice(string invoiceno,string comunitId)
        {
            string query = @"SELECT UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,UnitVatAmount,DeliveryQuantity AS Quantity,DeliveryTotalPrice AS TotalPrice,DeliveryTotalPriceVatAmount AS VAT,DiscountPercentage,DeliveryDiscountAmount AS DiscountAmount,DeliveryNetAmount AS NetPrice,'0'BonusQty,DeliveryTotalQuantity AS TotalQty,tblInvoiceDetail.DelivarySpecialAmount as SpecialAmount,* FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE DelivaryInvoiceNo=@DelivaryInvoiceNo AND ComUnitId=@ComUnitId";

            return GetDataTable(query, Param("@DelivaryInvoiceNo", invoiceno), Param("@ComUnitId", comunitId));
        }
        public DataTable GetQty(string invoicedetailId)
        {
            string query = @"SELECT SUM(TotalQuantity) AS Qty FROM dbo.tblReturnInvoiceDetail WHERE InvoiceDetailId=@InvoiceDetailId";

            return GetDataTable(query, Param("@InvoiceDetailId", invoicedetailId));
        }
        public DataTable LoadOrderWithDetail()
        {
            string query = @"SELECT * FROM dbo.tblOrder
            LEFT JOIN dbo.tblCustMaster ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            
			where IsInvoice='0'";

            return GetDataTable(query);
        }
        public DataTable LoadOrderWithDetail(string orderid)
        {
            string query = @"SELECT (case when  tblOrderDetail.DiscountAmount>0 then 0  else 1 END)IsCampaignProduct,tblOrderDetail.IsSpDis,tblOrderDetail.CampaignName,* FROM dbo.tblOrder
            LEFT JOIN dbo.tblCustMaster ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            LEFT JOIN dbo.tblMarket ON dbo.tblCustMaster.MarketId = dbo.tblMarket.MarketId
            LEFT JOIN dbo.tblOrderDetail ON dbo.tblOrder.OrderId=dbo.tblOrderDetail.OrderId
            inner JOIN dbo.tblProduct ON dbo.tblOrderDetail.ProductId = dbo.tblProduct.ProductId            
            WHERE tblOrder.OrderId=@OrderId";

            return GetDataTable(query, Param("@OrderId", orderid));
        }


        public DataTable LoadOrderWithDetailIDCheck(string orderid, string DetailsId)
        {
            string query = @"SELECT  * FROM dbo.tblOrderDetail dtl
           WHERE dtl.OrderId=@OrderId and dtl.OrderDetailId=@OrderDetailId";

            return GetDataTable(query, Param("@OrderId", orderid), Param("@OrderDetailId", DetailsId));
        }

        public DataTable LoadInvoiceWithDetailIDCheck(string orderid, int DetailsId)
        {
            string query = @"	   SELECT  dtl.OrderDetailId FROM dbo.tblOrderDetail dtl 
           WHERE dtl.OrderId=@OrderId and dtl.OrderDetailId=@OrderDetailId  order by dtl.OrderDetailId asc";

            return GetDataTable(query, Param("@OrderId", orderid), Param("@OrderDetailId", DetailsId));
        }


        public DataTable LoadDetalIdByMasCheck(string orderid)
        {
            string query = @"select   InvDtl.OrderDetailsId from tblInvoiceDetail InvDtl
		   inner join tblInvoice Inv on InvDtl.InvoiceId=Inv.InvoiceId

           WHERE Inv.OrderId=@OrderId    order by InvDtl.OrderDetailsId asc";

            return GetDataTable(query, Param("@OrderId", orderid));
        }

        public DataTable GetInvoNOGetByInvoID(string orderid)
        {
            string query = @"select Inv.InvoiceNo, Inv.InvoiceId  from tblInvoice Inv where Inv.OrderId=@OrderId";

            return GetDataTable(query, Param("@OrderId", orderid));
        }

        public DataTable GetInvoNOGetByInvoNo(string InvoNo)
        {
            string query = @"select Inv.InvoiceNo, Inv.InvoiceId , Inv.OrderId   from tblInvoice Inv where Inv.InvoiceNo=@InvoiceNo";

            return GetDataTable(query, Param("@InvoiceNo", InvoNo));
        }


        public DataTable GetInvoNOGetByBatchNo(string batchNO)
        {
            string query = @"select IV.InvoiceNo, IV.InvoiceId , IV.OrderId from tblInvoice IV with (nolock) WHERE IV.BatchNo=@BatchNo";

            return GetDataTable(query, Param("@BatchNo", batchNO));
        }
        public DataTable GetCustomerCredit(string cid)
        {
            string query = @"SELECT ISNULL(SUM(Amount),0)Amount FROM [dbo].[tblReturnAmount] WHERE CustomerId=@CustomerId";

            return GetDataTable(query, Param("@CustomerId", cid));
        }
        public DataTable LoadOffer(string InvoiceNo)
        {
            string query = @"select InvoiceId,InvoiceNo,ProductOffer,OldTradePolicy from tblInvoice WHERE tblInvoice.InvoiceNo=@InvoiceNo";

            return GetDataTable(query, Param("@InvoiceNo", InvoiceNo));
        }
        public DataTable LoadCampaign(string InvoiceNo)
        {
            string query = @"select Campaign from tblInvoice INNER JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId WHERE tblInvoice.InvoiceNo=@InvoiceNo";

            return GetDataTable(query, Param("@InvoiceNo", InvoiceNo));
        }
        public DataTable LoadCampaignDtls(string InvoiceNo)
        {
            string query = @"select distinct DiscountPercentage from tbl_BonusCampaignNewDetail dtl
inner join tbl_BonusCampaignNewMaster mas on mas.CampgainMasterId=dtl.CampaignMasterId
where LTRIM(RTRIM(mas.CampaignName))=@CampaignName";

            return GetDataTable(query, Param("@CampaignName", InvoiceNo));
        }
        public DataTable LoadCampaignsub(string InvoiceNo)
        {
            string query = @"select Campaign from tblSubInvoiceMaster INNER JOIN dbo.tblSubInvoiceDetail ON tblSubInvoiceDetail.InvoiceId = tblSubInvoiceMaster.InvoiceId WHERE tblSubInvoiceMaster.InvoiceNo=@InvoiceNo";

            return GetDataTable(query, Param("@InvoiceNo", InvoiceNo));
        }
        public DataTable subLoadOffer(string InvoiceNo)
        {
            string query = @"select InvoiceId,InvoiceNo,ProductOffer,OldTradePolicy from tblSubInvoiceMaster WHERE tblSubInvoiceMaster.InvoiceNo=@InvoiceNo";

            return GetDataTable(query, Param("@InvoiceNo", InvoiceNo));
        }
        public DataTable LoadOrderExistsDal(string orderid)
        {
            string query = @"SELECT * FROM dbo.tblInvoice
            WHERE tblInvoice.OrderId=@OrderId";

            return GetDataTable(query, Param("@OrderId", orderid));
        }
        public DataTable GetTradeTerm(string amount, int CustTypeId, string PaymentType, string SubmissionDate)
        {

            string query = string.Empty;

            // Parse the submission date
            DateTime submissionDate = DateTime.Parse("13-Dec-2024"); // Your condition date
            DateTime currentSubmissionDate = DateTime.Parse(SubmissionDate); // Replace with actual value

            // Conditional logic for query selection
            if (currentSubmissionDate <= submissionDate)
            {
                // Use the first query
                query = @"SELECT * FROM dbo.tblTradePolicyNew WHERE @Amount BETWEEN MinAmount AND MaxAmount";
            }
            else
            {
                // Use the second query
                query = @"SELECT * FROM dbo.tblTradePolicyNew2 WHERE @Amount BETWEEN MinAmount AND MaxAmount   and PaymentType=@PaymentType and CustomerType=@CustomerType";
            }
           
           
               

            return GetDataTable(query, Param("@Amount", amount), Param("@PaymentType", PaymentType), Param("@CustomerType", CustTypeId));
        }


        public DataTable GetParcentFromOrderDetails(string amount)
        {
            string query = @"select * from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId  WHERE dtl.OrderDetailId=@OrderDetailId";

            return GetDataTable(query, Param("@OrderDetailId", amount));
        }
        public DataTable GetParcentFromOrderDetailsMasterID(string OrderId)
        {
            string query = @"select * from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId  WHERE mas.OrderId=@OrderId";

            return GetDataTable(query, Param("@OrderId", OrderId));
        }
        public DataTable GetTradeTermOld(string amount)
        {
            string query = @"SELECT * FROM dbo.tblTradePolicy WHERE @Amount BETWEEN MinAmount AND MaxAmount";

            return GetDataTable(query, Param("@Amount", amount));
        }
        public DataTable GetFixedCustomer(string customerCode)
        {
            string query = @"select FixedCustomer from tblOrder WHERE tblOrder.OrderId=@OrderId";

            return GetDataTable(query, Param("@OrderId", customerCode));
        }

        public DataTable GetFixedCustomerffff(string customerCode)
        {
            string query = @"select * from tblOrder ord
inner join tblCustMaster cus on ord.CustTypeId=cus.CustomerTypeId
   where cus.IsActive=1 and ord.CustTypeId not in(1,3) and ord.CustomerCode=@CustomerCode";

            return GetDataTable(query, Param("@CustomerCode", customerCode));
        }
        public DataTable GetFixedCustomerfromInvoiceTable(string invoiceid)
        {
            string query = @"select isnull(FixedCustomer,0)FixedCustomer from dbo.tblInvoice WHERE tblInvoice.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceid));
        }
        public DataTable SubDeportGetFixedCustomerfromInvoiceTable(string invoiceid)
        {
            string query = @"select FixedCustomer from dbo.tblSubInvoiceMaster WHERE tblSubInvoiceMaster.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceid));
        }
        public DataTable ProductVat(string productcode)
        {
            string query = @"SELECT * FROM dbo.tblUnitPrice WHERE ProductCode=@ProductCode";

            return GetDataTable(query, Param("@ProductCode", productcode));
        }
        public DataTable ProductDiscount(string productcode, string customerId, string invoicedate)
        {
            string query = @"SELECT * FROM dbo.tblProductDiscount WHERE CustomerMasterId=@CustomerMasterId AND ProductCode=@ProductCode AND @InvoiceDate BETWEEN ActiveDate AND InactiveDate";

            return GetDataTable(query, Param("@CustomerMasterId", customerId), Param("@ProductCode", productcode), Param("@InvoiceDate", invoicedate));
        }

       
        public void LoadSC(DropDownList ddl)
        {
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            BindDropDown(ddl, GetDataTable(queryStr), "ComUnitName", "ComUnitId");
        }
        public void LoadSC(DropDownList ddl,string userId)
        {
//            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit
//                                LEFT JOIN dbo.tblUserCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblUserCompanyUnit.CompanyUnitId
//                                WHERE UserId='"+userId+"'";


            string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                               " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId=@UserId)";


            BindDropDown(ddl, GetDataTable(queryStr, Param("@UserId", userId.Trim())), "ComUnitName", "ComUnitId");
        }
        public void LoadDZSM(DropDownList ddl, string userId)
        {
            string queryStr = "SELECT * FROM dbo.tblregion";
            BindDropDown(ddl, GetDataTable(queryStr), "RegionName", "RegionCode");
        }
        public void LoadDisRoute(DropDownList ddl)
        {
            string queryStr = @"SELECT * FROM dbo.tblRouteInformationMaster with (nolock) 
order by RouteName asc";
            BindDropDown(ddl, GetDataTable(queryStr), "RouteName", "RouteInformationMasterId");
        }
        public void LoadDisRouteforInvoice(DropDownList ddl, int dis)
        {

//            string query = @"              
//         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
//
//from tblOrder
//inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
//where IsInvoice=0 and ComUnitId=" + comunitId;




            string queryStr = @"select distinct ord.DistributionRouteId ,ord.DistributionRoute_Ord  DistributionRouteName

from tblOrder ord  with (nolock)
--inner join tblRouteInformationMaster  with (nolock) on tblRouteInformationMaster.RouteInformationMasterId=tblOrder.DistributionRouteId
where IsInvoice=0 and  ord.ActionStatus='2' and IsPrepareforInvoice=1 and ord.DistributionRoute_Ord is not null  and ComUnitId=@ComUnitId     order by ord.DistributionRoute_Ord asc";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", dis)), "DistributionRouteName", "DistributionRouteId");
        }

        public void SubDepoLoadDisRouteforInvoice(DropDownList ddl, int dis)
        {

            //            string query = @"              
            //         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
            //
            //from tblOrder
            //inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
            //where IsInvoice=0 and ComUnitId=" + comunitId;




            string queryStr = @"select distinct tblOrder.DistributionRouteId ,tblRouteInformationMaster.RouteName DistributionRouteName
           from tblOrder  with (nolock)
           inner join tblRouteInformationMaster  with (nolock) on tblRouteInformationMaster.RouteInformationMasterId=tblOrder.DistributionRouteId
           where IsInvoice=0 and  tblOrder.ActionStatus='2' and  tblRouteInformationMaster.IsSubDepo =1  and ComUnitId=@ComUnitId  order by tblRouteInformationMaster.RouteName asc";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", dis)), "DistributionRouteName", "DistributionRouteId");
        }
        public void LoadDeliveryDisRouteforInvoice(DropDownList ddl, int dis, string Date)
        {

            //            string query = @"              
            //         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
            //
            //from tblOrder
            //inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
            //where IsInvoice=0 and ComUnitId=" + comunitId;




            string queryStr = @"
select distinct ord.DistributionRouteId ,ord.DistributionRoute_Ord DistributionRouteName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
--inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
where DelivaryInvoiceNo  is null  and       Inv.ComUnitId=@ComUnitId  and convert(date, Inv.InvoiceDate)=@InvoiceDate   order by ord.DistributionRoute_Ord ";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", dis), Param("@InvoiceDate", Date)), "DistributionRouteName", "DistributionRouteId");
        }


        public void LoadDeliveryDisRouteforInvoice(DropDownList ddl, int dis)
        {

            //            string query = @"              
            //         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
            //
            //from tblOrder
            //inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
            //where IsInvoice=0 and ComUnitId=" + comunitId;




            string queryStr = @"
select distinct ord.DistributionRouteId ,Rote.RouteName DistributionRouteName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
where DelivaryInvoiceNo  is null  and Inv.ComUnitId=@ComUnitId";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", dis)), "DistributionRouteName", "DistributionRouteId");
        }

        public void LoadManufac(DropDownList ddl)
        {
            string queryStr = "SELECT * FROM dbo.tblManufacturer";
            BindDropDown(ddl, GetDataTable(queryStr), "ManufacName", "ManufacId");
        }
        //public bool UpdateInvoiceStatus(string id)
        //{
        //    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //    aSqlParameterlist.Add(new SqlParameter("@OrderId", id));

        //    return aDbManager.UpdateAction("sp_UD_InvoiceDetail", aSqlParameterlist);
        //}
        public bool UpdateInvoiceStatus(string id)
        {
            string query = @"UPDATE dbo.tblOrder SET IsInvoice='True' WHERE OrderId=@OrderId";
            return SInventorySql.Execute(query, new List<SqlParameter> { Param("@OrderId", id) });
        }
        public void LoadMarket(DropDownList ddl,string comunitId)
        {
            string queryStr = @"SELECT DISTINCT CM.MarketId,CM.MarketCode,CM.MarketName FROM dbo.tblCompanyUnit Cu
                inner JOIN dbo.View_CustomerMaster CM ON CM.ComUnitCode = Cu.ComUnitCode
                inner JOIN dbo.tblMarket ON tblMarket.MarketCode = CM.MarketCode
                WHERE CU.ComUnitId=@ComUnitId";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comunitId)), "MarketName", "MarketId");
        }
      
        public void LoadMarketOrderWise(DropDownList ddl, string comunitId)
        {
            string queryStr = @"SELECT DISTINCT tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            WHERE IsInvoice = 0 and   V.ComUnitId=@ComUnitId AND IsInvoice =0 ";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comunitId)), "MarketName", "MarketId");
        }
        public void LoadMarketOrderWiseALl(DropDownList ddl, string comunitId)
        {
            string queryStr = @"SELECT DISTINCT tblArea.AreaId,tblArea.AreaCode,tblArea.AreaName FROM dbo.tblArea
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblArea.AreaCode = V.AreaCode  
            WHERE  V.ComUnitId=@ComUnitId";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comunitId)), "AreaName", "AreaCode");
        }
        public void SubdeportLoadMarketOrderWise(DropDownList ddl, string comunitId, string SD)
        {
            string queryStr = @"SELECT DISTINCT tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            WHERE IsInvoice = 0 and   V.ComUnitId=@ComUnitId AND IsInvoice =0 AND (V.TerritoryCode='BL-141' or V.TerritoryCode='BL-142' or V.TerritoryCode='BL-144' or V.TerritoryCode='BL-145' or V.TerritoryCode='kL-137' or V.TerritoryCode = 'KL-131' OR V.TerritoryCode = 'KL-132' OR V.TerritoryCode = 'KL-133' OR V.TerritoryCode = 'KL-134' OR V.TerritoryCode = 'KL-135' OR V.TerritoryCode = 'KL-136' OR V.TerritoryCode = 'KL-171' OR V.TerritoryCode = 'KL-173' OR V.TerritoryCode = 'KL-174')";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comunitId)), "MarketName", "MarketId");
        }
        public void LoadSalesCenter(DropDownList ddl)
        {
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            BindDropDown(ddl, GetDataTable(queryStr), "ComUnitName", "ComUnitId");
        }
        public void LoadArea(DropDownList ddl, string comUnitId)
        {
            string queryStr = "SELECT * FROM dbo.tblArea WHERE AreaId IN (SELECT AreaId FROM dbo.View_CustomerMaster WHERE ComUnitId=@ComUnitId)";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", comUnitId)), "AreaName", "AreaId");
        }
        public void LoadMarketbyArea(DropDownList ddl, string areaId)
        {
            string queryStr = "SELECT * FROM dbo.tblMarket WHERE MarketId IN (SELECT DISTINCT MarketId FROM dbo.View_CustomerMaster WHERE AreaId=@AreaId)";
            BindDropDown(ddl, GetDataTable(queryStr, Param("@AreaId", areaId)), "MarketName", "MarketId");
        }
        public DataTable LoadInvoice(string invoiceId)
        {
            string query = @"SELECT tblOrderDetail.CampaignName, tblOrderDetail.CampaignType, tblOrderDetail.ISGiftProduct,(case when  tblOrderDetail.DiscountAmount>0 then 0  else 1 END)IsCampaignProduct,*,tblInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,tblInvoiceDetail.UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,tblInvoiceDetail.DiscountAmount,tblInvoiceDetail.NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
			 LEFT JOIN tblOrderDetail ON dbo.tblOrderDetail.OrderDetailId = dbo.tblInvoiceDetail.OrderDetailsId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblInvoice.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceId));
        }
        
        
        public DataTable LoadInvoicePartialPayment(string invoiceId)
        {
            string query = @"SELECT tblOrderDetail.CampaignName,  tblInvoiceDetail.PaymentQuantity AS DelTotalQty, tblOrderDetail.ISGiftProduct,(case when  tblOrderDetail.DiscountAmount>0 then 0  else 1 END)IsCampaignProduct,*,tblInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,tblInvoiceDetail.UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,tblInvoiceDetail.DiscountAmount,tblInvoiceDetail.NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
			 LEFT JOIN tblOrderDetail ON dbo.tblOrderDetail.OrderDetailId = dbo.tblInvoiceDetail.OrderDetailsId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblInvoice.InvoiceId=@InvoiceId";

            return GetDataTable(query, Param("@InvoiceId", invoiceId));
        }
        public DataTable LoadInvoice(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
               FROM tblInvoice I
                   INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode WHERE  ManufacId=@ManufacId AND UpdateDate=@InvoiceDate " +
            " ) as tblD ON I.InvoiceId = tblD.InvoiceId  " +
          " INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
             " where I.ComUnitId=@ComUnitId and tblD.ManufacId=@ManufacId and MarketId=@MarketId and I.UpdateDate=@InvoiceDate AND  I.DeliveryInvoiceStatus IN ('Full','Partial') order by OrderNo";

            return GetDataTable(query, Param("@ComUnitId", ComUnitId), Param("@ManufacId", ManufId), Param("@MarketId", marketid), Param("@InvoiceDate", invDate));
        }
        public DataTable LoadInvoiceSubdeport(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
               FROM tblSubInvoiceMaster I
                   INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
            INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode WHERE  ManufacId=@ManufacId AND UpdateDate=@InvoiceDate " +
            " ) as tblD ON I.InvoiceId = tblD.InvoiceId  " +
          " INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
             " where I.ComUnitId=@ComUnitId and tblD.ManufacId=@ManufacId and MarketId=@MarketId and UpdateDate=@InvoiceDate AND  I.DeliveryInvoiceStatus IN ('Full','Partial') order by OrderNo";

            return GetDataTable(query, Param("@ComUnitId", ComUnitId), Param("@ManufacId", ManufId), Param("@MarketId", marketid), Param("@InvoiceDate", invDate));
        }

        public DataTable LoadInvoiceSUbdeport(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
               FROM tblSubInvoiceMaster I
                   INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
            INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode WHERE  ManufacId=@ManufacId AND UpdateDate=@InvoiceDate " +
            " ) as tblD ON I.InvoiceId = tblD.InvoiceId  " +
          " INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
             " where I.ComUnitId=@ComUnitId and tblD.ManufacId=@ManufacId and MarketId=@MarketId and UpdateDate=@InvoiceDate AND  I.DeliveryInvoiceStatus IN ('Full','Partial') order by OrderNo";

            return GetDataTable(query, Param("@ComUnitId", ComUnitId), Param("@ManufacId", ManufId), Param("@MarketId", marketid), Param("@InvoiceDate", invDate));
        }





        public void LoadTerritory(DropDownList ddl, string userId)
        {
            string queryStr = "SELECT DISTINCT tblArea.AreaId,tblArea.AreaCode,tblArea.AreaName  FROM dbo.tblInvoice inner JOIN dbo. View_CustomerMaster V ON dbo.tblInvoice.CustomerMasterId = V.CustomerMasterId  inner JOIN dbo.tblArea ON dbo.tblInvoice.AreaCode=dbo.tblArea.AreaCode WHERE    V.ComUnitId=@ComUnitId";

            BindDropDown(ddl, GetDataTable(queryStr, Param("@ComUnitId", userId.Trim())), "AreaName", "AreaCode");
        }
        public void LoadZone(DropDownList ddl, string userId)
        {
            string queryStr = "select * from dbo.tblRegion";

            BindDropDown(ddl, GetDataTable(queryStr), "Region", "RegionCode");
        }
        public void LoadSCZoneWise(DropDownList ddl, string userId)
        {
            //            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit
            //                                LEFT JOIN dbo.tblUserCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblUserCompanyUnit.CompanyUnitId
            //                                WHERE UserId='"+userId+"'";


            string queryStr = "SELECT DISTINCT tblCompanyUnit.ComUnitId,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName  FROM dbo.tblInvoice inner JOIN dbo. View_CustomerMaster V ON dbo.tblInvoice.CustomerMasterId = V.CustomerMasterId inner JOIN dbo.tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId WHERE  V.RegionCode=@RegionCode";


            BindDropDown(ddl, GetDataTable(queryStr, Param("@RegionCode", userId.Trim())), "ComUnitName", "ComUnitId");
        }
        public void LoadSCZoneWise(DropDownList ddl)
        {
            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit";

            BindDropDown(ddl, GetDataTable(queryStr), "ComUnitName", "ComUnitId");
        }
        public DataTable LoadOrderWithDetailFrindsHospital(string orderid,string deid)
        {
            string query = @"SELECT DiscountAmount,tblOrderDetail.CampaignName,* FROM dbo.tblOrder
            LEFT JOIN dbo.tblCustMaster ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            LEFT JOIN dbo.tblMarket ON dbo.tblCustMaster.MarketId = dbo.tblMarket.MarketId
            LEFT JOIN dbo.tblOrderDetail ON dbo.tblOrder.OrderId=dbo.tblOrderDetail.OrderId
            inner JOIN dbo.tblProduct ON dbo.tblOrderDetail.ProductId = dbo.tblProduct.ProductId            
            WHERE tblOrder.OrderId=@OrderId and OrderDetailId=@OrderDetailId";

            return GetDataTable(query, Param("@OrderId", orderid), Param("@OrderDetailId", deid));
        }
        //public DataTable LoadOffer(string InvoiceNo)
        //{
        //    string query = @"select InvoiceId,InvoiceNo,ProductOffer,OldTradePolicy from tblInvoice WHERE tblInvoice.InvoiceNo='" + InvoiceNo + "'";

        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
    }
}
