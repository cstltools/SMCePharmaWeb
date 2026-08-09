using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Web.UI.WebControls;
using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using Library.DAL.MAIN_FUNCTION;
using Library.DAO.SInventory_Entities;
using Dapper;

namespace Library.DAL.SInventory_DAL
{
    public class OrderInfoDAL_daaw
    {
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        DB_Manager aDbManager = new DB_Manager();
        private DataAccessManager_daaw  accessManager = new DataAccessManager_daaw ();

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

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
         
        public DataTable getEsomiumCampaignCheckSeacoral(string OrderDetailId)
        {
            string query = @"
 select invdt.* from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId 

inner join tblInvoiceDetail invdt on dtl.OrderDetailId=invdt.OrderDetailsId 
WHERE invdt.InvoiceDetailId= '" + OrderDetailId + "' and dtl.CampaignName='Seacoral D Flat Rate Campaign | Apr-26'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadInvoiceReturn(string invoiceId)
        {
            string query = @"SELECT '0' as SubDCStoreId,*,tblInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,tblInvoiceDetail.UnitPrice,tblInvoiceDetail.UnitVatAmount,tblInvoiceDetail.TotalQuantity AS Quantity,tblInvoiceDetail.TotalPrice,tblInvoiceDetail.TotalPriceVatAmount AS VAT
,tblInvoiceDetail.DiscountPercentage,tblInvoiceDetail.DiscountAmount,tblInvoiceDetail.NetAmount AS NetPrice,
'0'BonusQty,tblInvoiceDetail.TotalQuantity AS TotalQty,ISNULL(tblReturnInvoiceDetail.TotalQuantity,0) AS TQty FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
			LEFT JOIN dbo.tblReturnInvoiceDetail ON dbo.tblReturnInvoiceDetail.InvoiceDetailId=dbo.tblInvoiceDetail.InvoiceDetailId WHERE dbo.tblInvoice.InvoiceId='" + invoiceId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
           
            WHERE tblOrder_Doctorrequirement.ComUnitId='" + comunitId + "' AND IsInvoice =0  ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        // Returns whether sp_Process_ProformaInvoiceByOrderId actually committed an invoice.
        // Reads the proc's @Success OUTPUT parameter rather than RunStoreProcedure's rows-affected
        // count, which is meaningless for this proc's multi-statement transaction.
        public bool GenerateInvoiceByOrderId(int orderId, int userId, string batchno, string DANameId, int? saForSelectedSick = null)
        {
            List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
            aSqlParameterList.Add(new SqlParameter("@OrderId", orderId));
            aSqlParameterList.Add(new SqlParameter("@UserId", userId));
            aSqlParameterList.Add(new SqlParameter("@BatchNo1", batchno));
            aSqlParameterList.Add(new SqlParameter("@DANameId", DANameId));
            aSqlParameterList.Add(new SqlParameter("@SAforSelectedSick", (object)saForSelectedSick ?? DBNull.Value));
            aSqlParameterList.Add(new SqlParameter("@Success", SqlDbType.Bit) { Direction = ParameterDirection.Output });
            return aCommonInternalDal.RunStoreProcedureWithSuccessOutput("sp_Process_ProformaInvoiceByOrderId", aSqlParameterList, "@Success", "SSIDB");
        }
        public DataTable LoadSubInvoiceReturn(string invoiceId)
        {
            string query = @"SELECT SubDCStoreId AS DCStoreId,*,tblSubInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,tblSubInvoiceDetail.UnitPrice,tblSubInvoiceDetail.UnitVatAmount,tblSubInvoiceDetail.TotalQuantity AS Quantity,tblSubInvoiceDetail.TotalPrice,tblSubInvoiceDetail.TotalPriceVatAmount AS VAT
,tblSubInvoiceDetail.DiscountPercentage,tblSubInvoiceDetail.DiscountAmount,tblSubInvoiceDetail.NetAmount AS NetPrice,
'0'BonusQty,tblSubInvoiceDetail.TotalQuantity AS TotalQty,ISNULL(tblReturnInvoiceDetail.TotalQuantity,0) AS TQty FROM dbo.tblSubInvoiceMaster
            LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblSubInvoiceDetail.InvoiceId
            LEFT JOIN dbo.tblProduct ON dbo.tblSubInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId
			LEFT JOIN dbo.tblReturnInvoiceDetail ON dbo.tblReturnInvoiceDetail.InvoiceDetailId=dbo.tblSubInvoiceDetail.InvoiceDetailId WHERE dbo.tblSubInvoiceMaster.InvoiceId='" + invoiceId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
            LEFT JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  WHERE V.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND IsInvoice =0 ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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

            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT Distinct tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
          WHERE  TpGrandTotal>0 AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='') and tblOrder.ComUnitId='" + comunitId + "'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }
        public void SubdeportLoadMarketByInvoice(DropDownList ddl, string comunitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT Distinct tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN View_CustomerMaster C ON dbo.tblOrder.CustomerCode = C.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON C.MarketId = dbo.tblMarket.MarketId
            inner JOIN dbo.tblSubInvoiceMaster ON dbo.tblOrder.OrderId=dbo.tblSubInvoiceMaster.OrderId 
          WHERE  TpGrandTotal>0 AND (DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo='') and tblOrder.ComUnitId='" + comunitId + "'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }
        public DataTable LoadOrderForOrderCreation(string comunitId, string manufacId, string marketId,   string TerritoryId)
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
                aSqlParameters.Add(new SqlParameter("@TerritoryId", TerritoryId));


                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_LoadOrderListForOrderCreationbyTerri", aSqlParameters);



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

        public DataTable LoadOrderListForOrderRouteDayWise(int comunitId, DateTime routeDate, int routeId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@comunitId", comunitId));
                aSqlParameters.Add(new SqlParameter("@RouteDate", routeDate.Date));
                aSqlParameters.Add(new SqlParameter("@routeId", routeId));

                return accessManager.GetDataTable("sp_LoadOrderListForOrderRouteDayWise", aSqlParameters);
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetInvoiceCreationRouteWiseSalesAssistantList(int dcId, DateTime inputDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@InputDate", inputDate.Date));
                aSqlParameters.Add(new SqlParameter("@DCId", dcId));

                return accessManager.GetDataTable("sp_Get_InvoiceCreationRouteWiseSalesAssistantList", aSqlParameters);
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetInvoiceCreationRouteWiseSalesAssistantListForSick(int dcId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@DCId", dcId));

                return accessManager.GetDataTable("sp_Get_InvoiceCreationRouteWiseSalesAssistantListforSick", aSqlParameters);
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }

        public DataTable GetInvoiceCreationRouteWiseRouteTerritoryList(int dcId, DateTime inputDate, int daId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@InputDate", inputDate.Date));
                aSqlParameters.Add(new SqlParameter("@DCId", dcId));
                aSqlParameters.Add(new SqlParameter("@DAId", daId));

                return accessManager.GetDataTable("sp_Get_InvoiceCreationRouteWiseRouteTerritoryList", aSqlParameters);
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                accessManager.SqlConnectionClose();
            }
        }
        public DataTable subDepoOrderLoad(string comunitId, string manufacId, string root)
        {
            string query = @"SELECT * FROM dbo.tblOrder
            inner JOIN dbo. tblCustMaster V ON dbo.tblOrder.CustomerMasterId = V.CustomerMasterId
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitId=dbo.tblCompanyUnit.ComUnitId
            inner JOIN dbo.tblMarket ON tblOrder.MarketId = dbo.tblMarket.MarketId  
            WHERE IsInvoice = 0 and  tblOrder.IsSubDepo =1 and  tblOrder.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "'  AND tblOrder.DistributionRouteId='" + root + "'  ";

            //  )


            //AND(TerritoryCode = 'BL-141' or TerritoryCode = 'BL-142' or TerritoryCode = 'BL-144' or TerritoryCode = 'BL-145' or TerritoryCode = 'kL-137' or TerritoryCode = 'KL-131' OR TerritoryCode = 'KL-132' OR TerritoryCode = 'KL-133' OR TerritoryCode = 'KL-134' OR TerritoryCode = 'KL-135' OR TerritoryCode = 'KL-136' OR TerritoryCode = 'KL-171' OR TerritoryCode = 'KL-173' OR TerritoryCode = 'KL-174')

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadOrderWithInvoice(string comunitId, string manufacId, string marketId)
        {
            string query = @"              
            SELECT tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder
            
            inner JOIN dbo.tblInvoice ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId='" + comunitId + "' AND tblOrder.DistributionRouteId='" + manufacId + "'  AND DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo=''  order by InvoiceDate asc";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
            string query = @"            
            SELECT case when  MONTH(CONVERT(date,tblInvoice.InvoiceDate))=  MONTH(CONVERT(date,GETDATE())) then 'True' else 'False' end chkStatus ,tblInvoice.CustomerMasterId,tblMarket.MarketId,* FROM dbo.tblOrder With (nolock)
            
            inner JOIN dbo.tblInvoice  With (nolock) ON dbo.tblOrder.OrderId=dbo.tblInvoice.OrderId 
            inner JOIN dbo. tblCustMaster  V   With (nolock)  ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit  With (nolock) ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
                       inner JOIN dbo.tblMarket  With (nolock) ON tblOrder.MarketId = dbo.tblMarket.MarketId  
            WHERE  TpGrandTotal>0     " + param+ "  ";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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

                dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList_DA", aSqlParameters);



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

           public DataTable LoadDAPaymentInvSP(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);

                DataTable dt = new DataTable();
                //if (CustPayDetailHasDaCollectionColumns())
                //{
                    List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                    aSqlParameters.Add(new SqlParameter("@param", param));
                    dt = accessManager.GetDataTable("sp_GET_DA_PaymentInvSP", aSqlParameters);
                //}
                //else
                //{
                //    dt = accessManager.GetDataTableByText(BuildLegacyDaPaymentInvoiceQuery(param), null, true);
                //}

                //EnsurePayableAmountDaColumn(dt);
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

        private void EnsurePayableAmountDaColumn(DataTable dt)
        {
            if (dt == null || dt.Columns.Contains("PayableAmount_DA"))
            {
                return;
            }

            dt.Columns.Add("PayableAmount_DA", typeof(decimal));

            foreach (DataRow row in dt.Rows)
            {
                row["PayableAmount_DA"] = dt.Columns.Contains("Due") && row["Due"] != DBNull.Value
                    ? row["Due"]
                    : 0m;
            }
        }

        private bool CustPayDetailHasDaCollectionColumns()
        {
            DataTable dt = accessManager.GetDataTableByText(@"
SELECT COUNT(*) AS ColumnCount
FROM sys.columns
WHERE object_id = OBJECT_ID('dbo.tblCustPayDetail')
  AND name IN ('DAId', 'BankId', 'CollectionReceptNo', 'fromDACollection')", null, true);

            return dt.Rows.Count > 0 && Convert.ToInt32(dt.Rows[0]["ColumnCount"]) == 4;
        }

        private string BuildLegacyDaPaymentInvoiceQuery(string param)
        {
            return @"
SELECT INV.CustomerMasterId,
       CUST.MarketId,
       ORD.DistributionRouteId,
       INV.InvoiceId,
       CUST.CustomerCode,
       CUST.CustomerName,
       ORD.TerritoryName_Ord,
       ORD.DistributionRoute_Ord,
       INV.InvoiceNo,
       INV.InvoiceDate,
       LASTPAY.DANameId AS DAId,
       CAST(NULL AS INT) AS BankId,
       DA.Name AS PaymentCollectedBy,
       LASTPAY.custPaymentDate AS CollectedDate,
       CAST(NULL AS NVARCHAR(200)) AS BankName,
       CAST(CALC.TotalDelivery AS DECIMAL(18, 2)) AS TotalDelivery,
       CAST(CALC.PreviousPay AS DECIMAL(18, 2)) AS PaymentAmount,
       CAST(CALC.DueAmount AS DECIMAL(18, 2)) AS Due,
       CAST(CASE
                WHEN CALC.DueAmount <= 0 THEN 0
                WHEN CALC.DueAmount <= CALC.VatDue THEN 0
                ELSE CALC.DueAmount - CALC.VatDue
            END AS DECIMAL(18, 2)) AS TP_Pay,
       CAST(CASE
                WHEN CALC.DueAmount <= 0 THEN 0
                WHEN CALC.DueAmount <= CALC.VatDue THEN CALC.DueAmount
                ELSE CALC.VatDue
            END AS DECIMAL(18, 2)) AS Vat_Pay,
       CAST(CALC.AdjustAmount AS DECIMAL(18, 2)) AS AdjustableAmount
FROM dbo.tblInvoice INV WITH (NOLOCK)
INNER JOIN dbo.tblOrder ORD WITH (NOLOCK)
        ON ORD.OrderId = INV.OrderId
INNER JOIN dbo.View_CustomerMaster CUST WITH (NOLOCK)
        ON CUST.CustomerMasterId = INV.CustomerMasterId
OUTER APPLY (
    SELECT TOP (1) CPD.DANameId,
           CPD.custPaymentDate
    FROM dbo.tblCustPayDetail CPD WITH (NOLOCK)
    WHERE CPD.InvoiceId = INV.InvoiceId
    ORDER BY CPD.custPaymentDate DESC, CPD.CustPayDetailId DESC
) LASTPAY
LEFT JOIN dbo.tblDAInfo DA WITH (NOLOCK)
       ON DA.DAId = LASTPAY.DANameId
LEFT JOIN (
    SELECT InvoiceId,
           SUM(ISNULL(PaymentAmount, 0)) AS DetailPaymentAmount,
           SUM(ISNULL(TPAmount, 0)) AS DetailTPAmount,
           SUM(ISNULL(VATAmount, 0)) AS DetailVATAmount
    FROM dbo.tblCustPayDetail WITH (NOLOCK)
    GROUP BY InvoiceId
) PAY
       ON PAY.InvoiceId = INV.InvoiceId
CROSS APPLY (
    SELECT ISNULL(INV.DeliveryTpGrandTotal, 0) AS TotalDelivery,
           ISNULL(INV.AdjustAmount, 0) AS AdjustAmount,
           ISNULL(INV.PaymentAmount, ISNULL(PAY.DetailPaymentAmount, 0)) AS PreviousPay,
           CASE
               WHEN ISNULL(INV.DeliveryTpGrandTotal, 0)
                    - ISNULL(INV.PaymentAmount, ISNULL(PAY.DetailPaymentAmount, 0))
                    - ISNULL(INV.AdjustAmount, 0) < 0 THEN 0
               ELSE ISNULL(INV.DeliveryTpGrandTotal, 0)
                    - ISNULL(INV.PaymentAmount, ISNULL(PAY.DetailPaymentAmount, 0))
                    - ISNULL(INV.AdjustAmount, 0)
           END AS DueAmount,
           CASE
               WHEN ISNULL(INV.DeliveryTpVat, 0) - ISNULL(PAY.DetailVATAmount, 0) < 0 THEN 0
               ELSE ISNULL(INV.DeliveryTpVat, 0) - ISNULL(PAY.DetailVATAmount, 0)
           END AS VatDue
) CALC
WHERE ISNULL(INV.DeliveryTpGrandTotal, 0) > 0
  AND CALC.DueAmount > 0
  AND ISNULL(INV.DeliveryInvoiceStatus, '') IN ('Full', 'Partial') " + (param ?? String.Empty) + @"
ORDER BY INV.InvoiceDate, INV.InvoiceNo;";
        }
        
           public DataTable SndTimeReturnLoadPaymentInvSP(string param)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@param", param));
                

                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
                //dt = accessManager.GetDataTable("sp_DeliveryInvoiceCreationList", aSqlParameters);

                dt = accessManager.GetDataTable("sp_GET_PaymentInvSPSndReturn", aSqlParameters);



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
                dt = accessManager.GetDataTable("sp_LoadingSummary_da", aSqlParameters);


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
where IsInvoice=0 and ComUnitId=" + comunitId;
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

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
            WHERE  TpGrandTotal>0 and dbo.tblCompanyUnit.ComUnitId='" + comunitId + "' AND ManufacId='" + manufacId + "' AND dbo.tblMarket.MarketId='" + marketId + "' AND DelivaryInvoiceNo IS NULL OR DelivaryInvoiceNo=''";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
       
        public DataTable SubLoadInvoice(string invoiceId)
        {
            string query = @"
			SELECT tblSubInvoiceDetail.DiscountAmount,tblOrderDetail.ISGiftProduct,tblOrderDetail.IsCampaignProduct,*,tblSubInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,tblSubInvoiceDetail.UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,tblSubInvoiceDetail.NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty 
            FROM dbo.tblSubInvoiceMaster
            LEFT JOIN dbo.tblSubInvoiceDetail ON dbo.tblSubInvoiceMaster.InvoiceId = dbo.tblSubInvoiceDetail.InvoiceId
			 LEFT JOIN tblOrderDetail ON dbo.tblOrderDetail.OrderDetailId = dbo.tblSubInvoiceDetail.OrderDetailsId
            LEFT JOIN dbo.tblProduct ON dbo.tblSubInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblSubInvoiceMaster.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblSubInvoiceDetail.InvoiceId='" + invoiceId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadDelivaryInvoice(string invoiceno,string comunitId)
        {
            string query = @"SELECT UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,UnitVatAmount,DeliveryQuantity AS Quantity,DeliveryTotalPrice AS TotalPrice,DeliveryTotalPriceVatAmount AS VAT,DiscountPercentage,DeliveryDiscountAmount AS DiscountAmount,DeliveryNetAmount AS NetPrice,'0'BonusQty,DeliveryTotalQuantity AS TotalQty,tblInvoiceDetail.DelivarySpecialAmount as SpecialAmount,* FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE DelivaryInvoiceNo='" +invoiceno+"' AND ComUnitId='"+comunitId+"'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetQty(string invoicedetailId)
        {
            string query = @"SELECT SUM(TotalQuantity) AS Qty FROM dbo.tblReturnInvoiceDetail WHERE InvoiceDetailId='"+invoicedetailId+"'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadOrderWithDetail()
        {
            string query = @"SELECT * FROM dbo.tblOrder
            LEFT JOIN dbo.tblCustMaster ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            
			where IsInvoice='0'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadOrderWithDetail(string orderid)
        {
            string query = @"SELECT (case when  tblOrderDetail.DiscountAmount>0 then 0  else 1 END)IsCampaignProduct,tblOrderDetail.IsSpDis,tblOrderDetail.CampaignName,* FROM dbo.tblOrder
            LEFT JOIN dbo.tblCustMaster ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            LEFT JOIN dbo.tblMarket ON dbo.tblCustMaster.MarketId = dbo.tblMarket.MarketId
            LEFT JOIN dbo.tblOrderDetail ON dbo.tblOrder.OrderId=dbo.tblOrderDetail.OrderId
            inner JOIN dbo.tblProduct ON dbo.tblOrderDetail.ProductId = dbo.tblProduct.ProductId            
            WHERE tblOrder.OrderId='" + orderid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable LoadOrderWithDetailIDCheck(string orderid, string DetailsId)
        {
            string query = @"SELECT  * FROM dbo.tblOrderDetail dtl
           WHERE dtl.OrderId='" + orderid + "' and dtl.OrderDetailId='" + DetailsId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadInvoiceWithDetailIDCheck(string orderid, int DetailsId)
        {
            string query = @"	   SELECT  dtl.OrderDetailId FROM dbo.tblOrderDetail dtl 
           WHERE dtl.OrderId='" + orderid + "' and dtl.OrderDetailId='" + DetailsId + "'  order by dtl.OrderDetailId asc";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable LoadDetalIdByMasCheck(string orderid)
        {
            string query = @"select   InvDtl.OrderDetailsId from tblInvoiceDetail InvDtl
		   inner join tblInvoice Inv on InvDtl.InvoiceId=Inv.InvoiceId

           WHERE Inv.OrderId='" + orderid + "'    order by InvDtl.OrderDetailsId asc";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetInvoNOGetByInvoID(string orderid)
        {
            string query = @"select Inv.InvoiceNo, Inv.InvoiceId  from tblInvoice Inv where Inv.OrderId='" + orderid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetInvoNOGetByInvoNo(string InvoNo)
        {
            string query = @"select Inv.InvoiceNo, Inv.InvoiceId , Inv.OrderId   from tblInvoice Inv where Inv.InvoiceNo='" + InvoNo + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable GetInvoNOGetByBatchNo(string batchNO)
        {
            string query = @"select IV.InvoiceNo, IV.InvoiceId , IV.OrderId   from tblInvoice IV  with (nolock) "+ batchNO;

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetCustomerCredit(string cid)
        {
            string query = @"SELECT ISNULL(SUM(Amount),0)Amount FROM [dbo].[tblReturnAmount] WHERE CustomerId='" + cid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadOffer(string InvoiceNo)
        {
            string query = @"select InvoiceId,InvoiceNo,ProductOffer,OldTradePolicy from tblInvoice WHERE tblInvoice.InvoiceNo='" + InvoiceNo + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadCampaign(string InvoiceNo)
        {
            string query = @"select Campaign from tblInvoice INNER JOIN dbo.tblInvoiceDetail ON tblInvoiceDetail.InvoiceId = tblInvoice.InvoiceId WHERE tblInvoice.InvoiceNo='" + InvoiceNo + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadCampaignDtls(string InvoiceNo)
        {
            string query = @"select distinct DiscountPercentage from tbl_BonusCampaignNewDetail dtl
inner join tbl_BonusCampaignNewMaster mas on mas.CampgainMasterId=dtl.CampaignMasterId
where LTRIM(RTRIM(mas.CampaignName))='" + InvoiceNo + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadCampaignsub(string InvoiceNo)
        {
            string query = @"select Campaign from tblSubInvoiceMaster INNER JOIN dbo.tblSubInvoiceDetail ON tblSubInvoiceDetail.InvoiceId = tblSubInvoiceMaster.InvoiceId WHERE tblSubInvoiceMaster.InvoiceNo='" + InvoiceNo + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable subLoadOffer(string InvoiceNo)
        {
            string query = @"select InvoiceId,InvoiceNo,ProductOffer,OldTradePolicy from tblSubInvoiceMaster WHERE tblSubInvoiceMaster.InvoiceNo='" + InvoiceNo + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadOrderExistsDal(string orderid)
        {
            string query = @"SELECT * FROM dbo.tblInvoice
            WHERE tblInvoice.OrderId='" + orderid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
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
                query = @"SELECT * FROM dbo.tblTradePolicyNew WHERE '" + amount + "' BETWEEN MinAmount AND MaxAmount";
            }
            else
            {
                // Use the second query
                query = @"SELECT * FROM dbo.tblTradePolicyNew2 WHERE '" + amount + "' BETWEEN MinAmount AND MaxAmount   and PaymentType='" + PaymentType + "' and CustomerType=" + CustTypeId + "";
            }
           
           
               

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }


        public DataTable GetParcentFromOrderDetails(string amount)
        {
            string query = @"select * from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId  WHERE dtl.OrderDetailId= '" + amount + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetParcentFromOrderDetailsMasterID(string OrderId)
        {
            string query = @"select * from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId  WHERE mas.OrderId= '" + OrderId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable getEzeventCampaignCheck(string OrderDetailId)
        {
            string query = @"
 select invdt.* from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId 

inner join tblInvoiceDetail invdt on dtl.OrderDetailId=invdt.OrderDetailsId 
WHERE invdt.InvoiceDetailId= '" + OrderDetailId + "' and dtl.CampaignName='Ezevent Flat Rate Campaign | Dec-25'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable getEsomiumCampaignCheck(string OrderDetailId)
        {
            string query = @"
 select invdt.* from tblOrderDetail dtl
inner join tblOrder mas on dtl.OrderId=mas.OrderId 

inner join tblInvoiceDetail invdt on dtl.OrderDetailId=invdt.OrderDetailsId 
WHERE invdt.InvoiceDetailId= '" + OrderDetailId + "' and dtl.CampaignName='Esomium 20 Flat Rate Campaign | Mar-26'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetTradeTermOld(string amount)
        {
            string query = @"SELECT * FROM dbo.tblTradePolicy WHERE '" + amount + "' BETWEEN MinAmount AND MaxAmount";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetFixedCustomer(string customerCode)
        {
            string query = @"select FixedCustomer from tblOrder WHERE tblOrder.OrderId='" + customerCode + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable GetFixedCustomerffff(string customerCode)
        {
            string query = @"select * from tblOrder ord
inner join tblCustMaster cus on ord.CustTypeId=cus.CustomerTypeId
   where cus.IsActive=1 and ord.CustTypeId not in(1,3) and ord.CustomerCode='" + customerCode + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable GetFixedCustomerfromInvoiceTable(string invoiceid)
        {
            string query = @"select isnull(FixedCustomer,0)FixedCustomer from dbo.tblInvoice WHERE tblInvoice.InvoiceId='" + invoiceid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable SubDeportGetFixedCustomerfromInvoiceTable(string invoiceid)
        {
            string query = @"select FixedCustomer from dbo.tblSubInvoiceMaster WHERE tblSubInvoiceMaster.InvoiceId='" + invoiceid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ProductVat(string productcode)
        {
            string query = @"SELECT * FROM dbo.tblUnitPrice WHERE ProductCode='"+productcode+"'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable ProductDiscount(string productcode, string customerId, string invoicedate)
        {
            string query = @"SELECT * FROM dbo.tblProductDiscount WHERE CustomerMasterId='" + customerId + "' AND ProductCode='" + productcode + "' AND '" + invoicedate + "' BETWEEN ActiveDate AND InactiveDate";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

       
        public void LoadSC(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public void LoadSC(DropDownList ddl,string userId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
//            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit
//                                LEFT JOIN dbo.tblUserCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblUserCompanyUnit.CompanyUnitId
//                                WHERE UserId='"+userId+"'";


            string queryStr = "select ComUnitId, ComUnitName  from tblCompanyUnit WHERE " +
                               " ComUnitId IN (SELECT CompanyUnitId FROM dbo.tblUserCompanyUnit WHERE UserId='" + userId.Trim() + "')";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public void LoadDZSM(DropDownList ddl, string userId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblregion";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RegionName", "RegionCode", queryStr);
        }
        public void LoadDisRoute(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT * FROM dbo.tblRouteInformationMaster with (nolock) 
order by RouteName asc";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "RouteName", "RouteInformationMasterId", queryStr);
        }
        public void LoadDisRouteforInvoice(DropDownList ddl, int dis)
        {

//            string query = @"              
//         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
//
//from tblOrder
//inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
//where IsInvoice=0 and ComUnitId=" + comunitId;




            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"select distinct ord.DistributionRouteId ,ord.DistributionRoute_Ord  DistributionRouteName

from tblOrder ord  with (nolock)
--inner join tblRouteInformationMaster  with (nolock) on tblRouteInformationMaster.RouteInformationMasterId=tblOrder.DistributionRouteId
where IsInvoice=0 and  ord.ActionStatus='2' and IsPrepareforInvoice=1 and ord.DistributionRoute_Ord is not null  and ComUnitId="+ dis + @"     order by ord.DistributionRoute_Ord asc";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistributionRouteName", "DistributionRouteId", queryStr);
        }

        public void SubDepoLoadDisRouteforInvoice(DropDownList ddl, int dis)
        {

            //            string query = @"              
            //         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
            //
            //from tblOrder
            //inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
            //where IsInvoice=0 and ComUnitId=" + comunitId;




            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"select distinct tblOrder.DistributionRouteId ,tblRouteInformationMaster.RouteName DistributionRouteName
           from tblOrder  with (nolock)
           inner join tblRouteInformationMaster  with (nolock) on tblRouteInformationMaster.RouteInformationMasterId=tblOrder.DistributionRouteId
           where IsInvoice=0 and  tblOrder.ActionStatus='2' and  tblRouteInformationMaster.IsSubDepo =1  and ComUnitId=" + dis + "  order by tblRouteInformationMaster.RouteName asc";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistributionRouteName", "DistributionRouteId", queryStr);
        }
        public void LoadDeliveryDisRouteforInvoice(DropDownList ddl, int dis, string Date)
        {

            //            string query = @"              
            //         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
            //
            //from tblOrder
            //inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
            //where IsInvoice=0 and ComUnitId=" + comunitId;




            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"
select distinct ord.DistributionRouteId ,ord.DistributionRoute_Ord DistributionRouteName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
--inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
where DelivaryInvoiceNo  is null  and       Inv.ComUnitId=" + dis + "  and convert(date, Inv.InvoiceDate)='" + Date + "'   order by ord.DistributionRoute_Ord ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistributionRouteName", "DistributionRouteId", queryStr);
        }


        public void LoadDeliveryDisRouteforInvoice(DropDownList ddl, int dis)
        {

            //            string query = @"              
            //         select distinct tblOrder.DistributionRouteId ,tblDistributionRoute.DistributionRouteName
            //
            //from tblOrder
            //inner join tblDistributionRoute on tblDistributionRoute.DistributionRouteId=tblOrder.DistributionRouteId
            //where IsInvoice=0 and ComUnitId=" + comunitId;




            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"
select distinct ord.DistributionRouteId ,Rote.RouteName DistributionRouteName

from tblInvoice Inv
inner join tblOrder ord on ord.OrderId=Inv.OrderId
inner join tblRouteInformationMaster Rote on ord.DistributionRouteId=Rote.RouteInformationMasterId 
  
where DelivaryInvoiceNo  is null  and Inv.ComUnitId=" + dis;
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "DistributionRouteName", "DistributionRouteId", queryStr);
        }

        public void LoadManufac(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblManufacturer";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ManufacName", "ManufacId", queryStr);
        }
        //public bool UpdateInvoiceStatus(string id)
        //{
        //    List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
        //    aSqlParameterlist.Add(new SqlParameter("@OrderId", id));

        //    return aDbManager.UpdateAction("sp_UD_InvoiceDetail", aSqlParameterlist);
        //}
        public bool UpdateInvoiceStatus(string id)
        {
            string query = @"UPDATE dbo.tblOrder SET IsInvoice='True' WHERE OrderId='" + id + "'";
            return aCommonInternalDal.UpdateDataByUpdateCommand(query, "SSIDB");
        }
        public void LoadMarket(DropDownList ddl,string comunitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT DISTINCT CM.MarketId,CM.MarketCode,CM.MarketName FROM dbo.tblCompanyUnit Cu
                inner JOIN dbo.View_CustomerMaster CM ON CM.ComUnitCode = Cu.ComUnitCode
                inner JOIN dbo.tblMarket ON tblMarket.MarketCode = CM.MarketCode
                WHERE CU.ComUnitId='" + comunitId + "'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }
      
        public void LoadMarketOrderWise(DropDownList ddl, string comunitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT DISTINCT tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            WHERE IsInvoice = 0 and   V.ComUnitId='" + comunitId + "' AND IsInvoice =0 ";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }
        public void LoadMarketOrderWiseALl(DropDownList ddl, string comunitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT DISTINCT tblArea.AreaId,tblArea.AreaCode,tblArea.AreaName FROM dbo.tblArea
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblArea.AreaCode = V.AreaCode  
            WHERE  V.ComUnitId='" + comunitId + "'";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaCode", queryStr);
        }
        public void SubdeportLoadMarketOrderWise(DropDownList ddl, string comunitId, string SD)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT DISTINCT tblMarket.MarketId,tblMarket.MarketCode,tblMarket.MarketName FROM dbo.tblOrder
            inner JOIN dbo. View_CustomerMaster V ON dbo.tblOrder.CustomerCode = V.CustomerCode
            inner JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            inner JOIN dbo.tblMarket ON V.MarketCode = dbo.tblMarket.MarketCode  
            WHERE IsInvoice = 0 and   V.ComUnitId='" + comunitId + "' AND IsInvoice =0 AND (V.TerritoryCode='BL-141' or V.TerritoryCode='BL-142' or V.TerritoryCode='BL-144' or V.TerritoryCode='BL-145' or V.TerritoryCode='kL-137' or V.TerritoryCode = 'KL-131' OR V.TerritoryCode = 'KL-132' OR V.TerritoryCode = 'KL-133' OR V.TerritoryCode = 'KL-134' OR V.TerritoryCode = 'KL-135' OR V.TerritoryCode = 'KL-136' OR V.TerritoryCode = 'KL-171' OR V.TerritoryCode = 'KL-173' OR V.TerritoryCode = 'KL-174')";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }
        public void LoadSalesCenter(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblCompanyUnit";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public void LoadArea(DropDownList ddl, string comUnitId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblArea WHERE AreaId IN (SELECT AreaId FROM dbo.View_CustomerMaster WHERE ComUnitId='" + comUnitId + "')";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaId", queryStr);
        }
        public void LoadMarketbyArea(DropDownList ddl, string areaId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = "SELECT * FROM dbo.tblMarket WHERE MarketId IN (SELECT DISTINCT MarketId FROM dbo.View_CustomerMaster WHERE AreaId='" + areaId + "')";
            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "MarketName", "MarketId", queryStr);
        }
        public DataTable LoadInvoice(string invoiceId)
        {
            string query = @"SELECT tblInvoice.DA_SalesConfirmBy DeliveryPersonName, tblOrderDetail.CampaignName, tblOrderDetail.CampaignType, tblOrderDetail.ISGiftProduct,(case when  tblOrderDetail.DiscountAmount>0 then 0  else 1 END)IsCampaignProduct,*,tblInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,tblInvoiceDetail.UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,tblInvoiceDetail.DiscountAmount,tblInvoiceDetail.NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
			 LEFT JOIN tblOrderDetail ON dbo.tblOrderDetail.OrderDetailId = dbo.tblInvoiceDetail.OrderDetailsId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblInvoice.InvoiceId='" + invoiceId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadSalesConfirmationAppLogDetail(string invoiceId)
        {
            DataTable table = new DataTable();
            var connectionString = System.Configuration.ConfigurationManager.ConnectionStrings["SolutionConnectionStringSSIDB"].ConnectionString;

            using (var connection = new SqlConnection(connectionString))
            {
                connection.Open();
                using (var reader = (DbDataReader)connection.ExecuteReader(
                    @"select InvoiceDetailId, DeliveredQty, DeliveryStatus, DeliveryReason
            from tblSalesConfirmation_appLogDetail
            where InvoiceId=@InvoiceId",
                    new { InvoiceId = invoiceId }, commandTimeout: 90, commandType: CommandType.Text))
                {
                    table.Load(reader);
                }
            }

            return table;
        }
        
        
        public DataTable LoadInvoicePartialPayment(string invoiceId)
        {
            string query = @"SELECT ISNULL(tblOrderDetail.CampaignType, '') AS CampaignType, tblOrderDetail.CampaignName,  tblInvoiceDetail.DeliveryQuantity AS DelTotalQty, tblOrderDetail.ISGiftProduct,(case when  tblOrderDetail.DiscountAmount>0 then 0  else 1 END)IsCampaignProduct,*,tblInvoiceDetail.UnitVatAmount AS UnitVAT,'0'SL,'0'StockQty,UnitPrice,tblInvoiceDetail.UnitVatAmount,TotalQuantity AS Quantity,TotalPrice,TotalPriceVatAmount AS VAT,DiscountPercentage,tblInvoiceDetail.DiscountAmount,tblInvoiceDetail.NetAmount AS NetPrice,'0'BonusQty,TotalQuantity AS TotalQty FROM dbo.tblInvoice
            LEFT JOIN dbo.tblInvoiceDetail ON dbo.tblInvoice.InvoiceId = dbo.tblInvoiceDetail.InvoiceId
 			 LEFT JOIN tblOrderDetail ON dbo.tblOrderDetail.OrderDetailId = dbo.tblInvoiceDetail.OrderDetailsId
            LEFT JOIN dbo.tblProduct ON dbo.tblInvoiceDetail.ProductCode = dbo.tblProduct.ProductCode
            LEFT JOIN dbo.tblCustMaster ON dbo.tblInvoice.CustomerMasterId=dbo.tblCustMaster.CustomerMasterId WHERE dbo.tblInvoice.InvoiceId='" + invoiceId + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadInvoice(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
               FROM tblInvoice I
                   INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblInvoice I
            INNER JOIN dbo.tblInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode WHERE  ManufacId='" + ManufId + "' AND UpdateDate='" + invDate + "' " +
            " ) as tblD ON I.InvoiceId = tblD.InvoiceId  " +
          " INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
             " where I.ComUnitId= '" + ComUnitId + "' and tblD.ManufacId='" + ManufId + "' and MarketId='" + marketid + "' and I.UpdateDate='" + invDate + "' AND  I.DeliveryInvoiceStatus IN ('Full','Partial') order by OrderNo";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        public DataTable LoadInvoiceSubdeport(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
               FROM tblSubInvoiceMaster I
                   INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
            INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode WHERE  ManufacId='" + ManufId + "' AND UpdateDate='" + invDate + "' " +
            " ) as tblD ON I.InvoiceId = tblD.InvoiceId  " +
          " INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
             " where I.ComUnitId= '" + ComUnitId + "' and tblD.ManufacId='" + ManufId + "' and MarketId='" + marketid + "' and UpdateDate='" + invDate + "' AND  I.DeliveryInvoiceStatus IN ('Full','Partial') order by OrderNo";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }

        public DataTable LoadInvoiceSUbdeport(string ComUnitId, string ManufId, string marketid, DateTime invDate)
        {
            string query = @"SELECT  * 				
               FROM tblSubInvoiceMaster I
                   INNER JOIN (SELECT DISTINCT D.InvoiceId, ManufacId FROM dbo.tblSubInvoiceMaster I
            INNER JOIN dbo.tblSubInvoiceDetail D ON I.InvoiceId = D.InvoiceId
            INNER JOIN dbo.tblProduct P ON D.ProductCode = P.ProductCode WHERE  ManufacId='" + ManufId + "' AND UpdateDate='" + invDate + "' " +
            " ) as tblD ON I.InvoiceId = tblD.InvoiceId  " +
          " INNER JOIN dbo.View_CustomerMaster C ON I.CustomerMasterId = C.CustomerMasterId " +
             " where I.ComUnitId= '" + ComUnitId + "' and tblD.ManufacId='" + ManufId + "' and MarketId='" + marketid + "' and UpdateDate='" + invDate + "' AND  I.DeliveryInvoiceStatus IN ('Full','Partial') order by OrderNo";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }





        public void LoadTerritory(DropDownList ddl, string userId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

            string queryStr = "SELECT DISTINCT tblArea.AreaId,tblArea.AreaCode,tblArea.AreaName  FROM dbo.tblInvoice inner JOIN dbo. View_CustomerMaster V ON dbo.tblInvoice.CustomerMasterId = V.CustomerMasterId  inner JOIN dbo.tblArea ON dbo.tblInvoice.AreaCode=dbo.tblArea.AreaCode WHERE    V.ComUnitId='" + userId.Trim() + "'";

            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "AreaName", "AreaCode", queryStr);
        }
        public void LoadZone(DropDownList ddl, string userId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();

            string queryStr = "select * from dbo.tblRegion";

            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "Region", "RegionCode", queryStr);
        }
        public void LoadSCZoneWise(DropDownList ddl, string userId)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            //            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit
            //                                LEFT JOIN dbo.tblUserCompanyUnit ON dbo.tblCompanyUnit.ComUnitId=dbo.tblUserCompanyUnit.CompanyUnitId
            //                                WHERE UserId='"+userId+"'";


            string queryStr = "SELECT DISTINCT tblCompanyUnit.ComUnitId,tblCompanyUnit.ComUnitCode,tblCompanyUnit.ComUnitName  FROM dbo.tblInvoice inner JOIN dbo. View_CustomerMaster V ON dbo.tblInvoice.CustomerMasterId = V.CustomerMasterId inner JOIN dbo.tblCompanyUnit ON dbo.tblInvoice.ComUnitId=dbo.tblCompanyUnit.ComUnitId WHERE  V.RegionCode='" + userId.Trim() + "'";


            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public void LoadSCZoneWise(DropDownList ddl)
        {
            ClsCommonInternalDAL aInternalDal = new ClsCommonInternalDAL();
            string queryStr = @"SELECT * FROM dbo.tblCompanyUnit";

            aInternalDal.LoadDropDownValueWithoutDataBase(ddl, "ComUnitName", "ComUnitId", queryStr);
        }
        public DataTable LoadOrderWithDetailFrindsHospital(string orderid,string deid)
        {
            string query = @"SELECT DiscountAmount,tblOrderDetail.CampaignName,* FROM dbo.tblOrder
            LEFT JOIN dbo.tblCustMaster ON dbo.tblOrder.CustomerCode = dbo.tblCustMaster.CustomerCode
            LEFT JOIN dbo.tblCompanyUnit ON dbo.tblOrder.ComUnitCode=dbo.tblCompanyUnit.ComUnitCode
            LEFT JOIN dbo.tblMarket ON dbo.tblCustMaster.MarketId = dbo.tblMarket.MarketId
            LEFT JOIN dbo.tblOrderDetail ON dbo.tblOrder.OrderId=dbo.tblOrderDetail.OrderId
            inner JOIN dbo.tblProduct ON dbo.tblOrderDetail.ProductId = dbo.tblProduct.ProductId            
            WHERE tblOrder.OrderId='" + orderid + "' and OrderDetailId='" + deid + "'";

            return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        }
        //public DataTable LoadOffer(string InvoiceNo)
        //{
        //    string query = @"select InvoiceId,InvoiceNo,ProductOffer,OldTradePolicy from tblInvoice WHERE tblInvoice.InvoiceNo='" + InvoiceNo + "'";

        //    return aCommonInternalDal.DataContainerDataTable(query, "SSIDB");
        //}
    }
}
