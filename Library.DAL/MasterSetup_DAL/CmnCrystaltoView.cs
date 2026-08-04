using Library.DAL.DataManager;
using Library.DAL.InternalCls;
using SalesSolution.Web.Models;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.UI.WebControls.WebParts;

namespace Library.DAL.MasterSetup_DAL
{
  public  class CmnCrystaltoView
    {
        private DataAccessManager  accessManager = new DataAccessManager ();

        public DataTable GetTerriTorryWiseSalesReportDataDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_TerritorryWiseSalesReportList", aSqlParameterlist);
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
        public DataTable GetMoneyReceiptDAL(string parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm", parm));


                DataTable dt = accessManager.GetDataTable("sp_Get_MoneyReceiptReportList", aSqlParameters);
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
        public DataTable GetMoneyReceiptAfterPaymentDAL(string parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm", parm));


                DataTable dt = accessManager.GetDataTable("sp_Get_MoneyReceiptReportAfterPaymentList", aSqlParameters);
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
        public DataTable GetDCReportListDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@comunit", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_DCStockReportListNew", aSqlParameterlist);
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



        public DataTable SalesRejecionReportDAl(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_alesReectionReportList", aSqlParameterlist);
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


        public DataTable BusinessSummaryReportDAl(DateTime fromdate, DateTime todate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@fromdate", fromdate));
                aSqlParameterlist.Add(new SqlParameter("@todate", todate));

                DataTable dt = accessManager.GetDataTable("sp_Get_BusinessSummaryReportList", aSqlParameterlist);
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

        public DataTable GetProformaInvoListDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_ProformaInvoiceReportList", aSqlParameterlist);
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
        
        public DataTable GetDynamicSalesReportListDAL(DateTime fromdate, DateTime todate, string Type, string grpId, string ZonId, string Area, string Terr)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterList = new List<SqlParameter>();
                aSqlParameterList.Add(new SqlParameter("@fromdate", fromdate));
                aSqlParameterList.Add(new SqlParameter("@todate", todate));
                aSqlParameterList.Add(new SqlParameter("@Type", Type));
                aSqlParameterList.Add(new SqlParameter("@Area", Area));
                aSqlParameterList.Add(new SqlParameter("@Terr", Terr));
                aSqlParameterList.Add(new SqlParameter("@ZonId", ZonId));
                aSqlParameterList.Add(new SqlParameter("@grpId", grpId));

                DataTable dt = accessManager.GetDataTable("GetDynamicSalesReportList", aSqlParameterList, true);
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

        
        public DataTable GetSalesRejectionReportDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

               // DataTable dt = accessManager.GetDataTable("sp_Get_SalesRejectionReportListLAtest", aSqlParameterlist);
                DataTable dt = accessManager.GetDataTable("sp_Get_SalesRejectionReportListLAtest", aSqlParameterlist);
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


        public DataTable GetLoadingReportDAL(string Parm, string dtRange)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@dtRange", dtRange));

                DataTable dt = accessManager.GetDataTable("sp_Get_LoadingReportList", aSqlParameterlist);
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

        public DataTable Get_MIOWiseReceiveableReport(string  FrmDate, string ToDate, string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@fromDate", FrmDate));
                aSqlParameterlist.Add(new SqlParameter("@toDate", ToDate));
                aSqlParameterlist.Add(new SqlParameter("@districtId", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_NewReceiveableList", aSqlParameterlist);/*DataTable dt = accessManager.GetDataTable("sp_Get_MIOWiseReceiveableReport", aSqlParameterlist);*/
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

        public DataTable GetDeliveryReturnReportListDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_DeliveryReturnReport", aSqlParameterlist);
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
        
        public DataTable GetSalesReturnReportListDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_SalesReturnReport", aSqlParameterlist);
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
        
        public DataTable GetDACollectionReportDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_DACollectionReport", aSqlParameterlist);
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
        
        public DataTable GetSalesConfirmStatusByDateReportDAL(string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", Month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));

                DataTable dt = accessManager.GetDataTable("sp_RPT_SalesConfirmStatusByDate", aSqlParameterlist);
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
        
        public DataTable GetSalesReturnReportDAL(string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", Month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));
                DataTable dt = accessManager.GetDataTable("sp_RPT_SalesReturnStatusByDate", aSqlParameterlist);
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
        
        public DataTable GetChallanStatusByDateDAL(string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Month", Month));
                aSqlParameterlist.Add(new SqlParameter("@Year", Year));
                DataTable dt = accessManager.GetDataTable("sp_RPT_ChallanStatusByDate", aSqlParameterlist);
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

        public DataTable GetReplaceNoteReportListDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_ReplaceNoteReport", aSqlParameterlist);
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

        public DataTable GetSalesConfirmationReport_newDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_AllSalesConfirmationReport_new", aSqlParameterlist);
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
           public DataTable GetDeliveryPaymentDAL( string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_AllSalesReportListParam2", aSqlParameterlist);
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



        public DataTable GetFullPaymentDAL(string NewParm, string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@NewParm", NewParm));
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_AllSalesReportListParam2", aSqlParameterlist);
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

        public DataTable GetSC_PaymentReportDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_RPT_PaymentSC_Param", aSqlParameterlist);
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
        
        public DataTable GetSC_CustomerFinalPaymentReportDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_RPT_SC_CustomerFinalPaymentReport", aSqlParameterlist);
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
        private ClsCommonInternalDAL aCommonInternalDal = new ClsCommonInternalDAL();
        public DataTable GetSC_CustomerFinalPaymentReportDAL_new(string Parm, string Parm2, string oldParam)
        {
            try
            {
                //accessManager.SqlConnectionOpen(DataBase.SalesDB);
                //List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                //aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                //aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));
                //aSqlParameterlist.Add(new SqlParameter("@oldParam",  oldParam));

                //DataTable dt = accessManager.GetDataTable("sp_Get_RPT_SC_CustomerFinalPaymentReport_new", aSqlParameterlist);
                //return dt;

                List<SqlParameter> parameters = new List<SqlParameter>();
                string paymentFilter = BuildPaymentFilter(Parm, parameters);
                string reportFilter = paymentFilter + BuildReportFilter(Parm2, parameters);

                string queryOld = @"   SET NOCOUNT ON;
SELECT  mas.paymenttype,  STUFF(( SELECT Distinct ', ' +    da.Name  FROM dbo.tblCustPayDetail custDtl    with (nolock)  
inner JOIN tblDAInfo da WITH (NOLOCK) ON da.DAId = custDtl.DANameId WHERE custDtl.InvoiceId = I.InvoiceId  " + paymentFilter + @"
FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS DAName,STUFF((   SELECT Distinct ', ' +   custDtl.CollectionBy FROM dbo.tblCustPayDetail custDtl    with (nolock)  
WHERE custDtl.InvoiceId = I.InvoiceId  " + paymentFilter + @" FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS CollectionBy,  STUFF((SELECT ', ' +   FORMAT(custDtl.custPaymentDate,'dd-MMM-yyyy') FROM dbo.tblCustPayDetail custDtl     with (nolock)   WHERE custDtl.InvoiceId = I.InvoiceId
FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS custPaymentDates, '' 
AS InvPayNo,
case when isnull(sndRTN.sndReturnTotalPrice,0)>0 then isnull(sndRTN.sndReturnTotalPrice,0) else tblinvDetls.PaymentTotalPrice end Inv_TP , case when isnull(sndRTN.sndReturnTotalPriceVatAmount,0)>0 then isnull(sndRTN.sndReturnTotalPriceVatAmount,0) else  tblinvDetls.PaymentTotalPriceVatAmount end Inv_Vat,sum((isnull(custDtl.TPAmount,0))) +
sum((isnull(custDtl.VATAmount,0)))   TotalPay,
CASE WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)>0 THEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)
 WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)<0 THEN 0 ELSE 0
END as TP_Pay, CASE  WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)>0 THEN tblinvDetls.PaymentTotalPriceVatAmount 
ELSE 0 END as Vat_Pay,
 sum((isnull(custDtl.TPAmount,0))) PayTPAmount,sum((isnull(custDtl.VATAmount,0))) PayVATAmount,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer, 
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate, I.PaymentInvoiceNo PaymentInvoiceNo, CONVERT(VARCHAR,I.PaymentDate,103) PaymentDate, 
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.PaymentTpTotal DeliveryTpTotal,I. PaymentTpGrandTotal DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,ddd.AreaCode  AreaName,cc.TerritoryCode,cc.TerritoryName TerritoryName,
 mas.SubTerritoryCode_Ord+' : '+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName  as soldQty 
FROM tblCustPayDetail custDtl   with(nolock)
inner JOIN dbo.tblInvoice I   with (nolock)    ON I.InvoiceId = custDtl.InvoiceId
LEFT JOIN dbo.tblOrder mas  with (nolock)   ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt  with (nolock)   ON mas.ProgramTypeId = ptt.ProgramTypeId
 LEFT JOIN tblCustomertype ct  with (nolock)   ON mas.CusttypeId = ct.CustomerTypeId
inner JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail  with (nolock)   group by InvoiceId)tblinvDetls on tblinvDetls.InvoiceId=I.InvoiceId 
LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId 
LEFT JOIN dbo.tblCompanyUnit CU  with (nolock)   ON CU.ComUnitId = mas.ComUnitId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
LEFT JOIN tblSubTerritory bb with (nolock)  ON bb.SubTerritoryId=aa.SubTerritoryId  and bb.IsActive=1
LEFT JOIN tblTerritory cc with (nolock)  ON cc.TerritoryId=bb.TerritoryId and cc.IsActive=1
LEFT JOIN tblarea ddd  with (nolock)  ON ddd.AreaId=cc.AreaId and ddd.IsActive=1
 LEFT JOIN tblRegion   with (nolock)  ON tblRegion.RegionId=ddd.RegionId and tblRegion.IsActive=1
left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
where   I.InvoiceId>0    " + reportFilter + @"
 group by  isnull(sndRTN.sndReturnTotalPrice,0),  isnull(sndRTN.sndReturnTotalPriceVatAmount,0), mas.paymenttype,   I.InvoiceId,tblinvDetls.PaymentTotalPrice,tblinvDetls.PaymentTotalPriceVatAmount,I.PaymentTpVat,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName, I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) ,I.InvoiceNo,I.FixedCustomer, CONVERT(VARCHAR,I.InvoiceDate,103)  ,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) , I.PaymentInvoiceNo , CONVERT(VARCHAR,I.PaymentDate,103) , ptt.ProgramTypeName  ,ct.CustomerType ,I.TpGrandTotal,TpTotal,I.PaymentTpTotal ,I. PaymentTpGrandTotal ,DZSM.EmpMasterCode , AM.EmpMasterCode , AM.EmpName   , MIO.EmpMasterCode  , MIO.EmpName   , mas.GroupCode_Ord ,mas.RegionCode_Ord ,ddd.AreaCode  ,cc.TerritoryCode,cc.TerritoryName ,mas.SubTerritoryCode_Ord+' : ' + mas.SubTerritoryName_Ord , mas.MarketCode_Ord ,  mas.MarketName_Ord ,rt.RouteName ";
                string query = @"   SET NOCOUNT ON;
SELECT  mas.paymenttype,  STUFF(( SELECT Distinct ', ' +    da.Name  FROM dbo.tblCustPayDetail custDtl    with (nolock)  
inner JOIN tblDAInfo da WITH (NOLOCK) ON da.DAId = custDtl.DANameId WHERE custDtl.InvoiceId = I.InvoiceId  " + paymentFilter + @"
FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS DAName,STUFF((   SELECT Distinct ', ' +   custDtl.CollectionBy FROM dbo.tblCustPayDetail custDtl    with (nolock)  
WHERE custDtl.InvoiceId = I.InvoiceId  " + paymentFilter + @" FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS CollectionBy,  STUFF((SELECT ', ' +   FORMAT(custDtl.custPaymentDate,'dd-MMM-yyyy') FROM dbo.tblCustPayDetail custDtl     with (nolock)   WHERE custDtl.InvoiceId = I.InvoiceId
FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 2, '') AS custPaymentDates, '' 
AS InvPayNo,
case when isnull(sndRTN.sndReturnTotalPrice,0)>0 then isnull(sndRTN.sndReturnTotalPrice,0) else tblinvDetls.PaymentTotalPrice end Inv_TP , case when isnull(sndRTN.sndReturnTotalPriceVatAmount,0)>0 then isnull(sndRTN.sndReturnTotalPriceVatAmount,0) else  tblinvDetls.PaymentTotalPriceVatAmount end Inv_Vat,sum((isnull(custDtl.TPAmount,0))) +
sum((isnull(custDtl.VATAmount,0)))   TotalPay,
CASE WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)>0 THEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)
 WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)<0 THEN 0 ELSE 0
END as TP_Pay, CASE  WHEN (sum((isnull(custDtl.PaymentAmount,0)))-tblinvDetls.PaymentTotalPriceVatAmount)>0 THEN tblinvDetls.PaymentTotalPriceVatAmount 
ELSE 0 END as Vat_Pay,
 sum((isnull(custDtl.TPAmount,0))) PayTPAmount,sum((isnull(custDtl.VATAmount,0))) PayVATAmount,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName,
I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) as OrderDate,I.InvoiceNo,I.FixedCustomer, 
CONVERT(VARCHAR,I.InvoiceDate,103)  InvoiceDate,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) UpdateDate, I.PaymentInvoiceNo PaymentInvoiceNo, CONVERT(VARCHAR,I.PaymentDate,103) PaymentDate, 
 ptt.ProgramTypeName  as Type,ct.CustomerType as NewType,I.TpGrandTotal,TpTotal,I.PaymentTpTotal DeliveryTpTotal,I. PaymentTpGrandTotal DeliveryTpGrandTotal,DZSM.EmpMasterCode DZSMEmpName, 
 AM.EmpMasterCode AMEmpCode, AM.EmpName AMEmpName  , MIO.EmpMasterCode  MIOEmpCode, MIO.EmpName MIOEmpName  , mas.GroupCode_Ord GroupName,
 mas.RegionCode_Ord RegionName,mas.AreaCode_Ord  AreaName,mas.TerritoryCode,mas.TerritoryName_Ord TerritoryName,
 mas.SubTerritoryCode_Ord+' : '+  mas.SubTerritoryName_Ord SubTerritoryName, mas.MarketCode_Ord MarketCode,  mas.MarketName_Ord MarketName,rt.RouteName  as soldQty 
FROM tblCustPayDetail custDtl   with(nolock)
inner JOIN dbo.tblInvoice I   with (nolock)    ON I.InvoiceId = custDtl.InvoiceId
LEFT JOIN dbo.tblOrder mas  with (nolock)   ON I.OrderId = mas.OrderId
 LEFT JOIN tblProgramType ptt  with (nolock)   ON mas.ProgramTypeId = ptt.ProgramTypeId
 LEFT JOIN tblCustomertype ct  with (nolock)   ON mas.CusttypeId = ct.CustomerTypeId
inner JOIN tblCustMaster C ON C.CustomerMasterId = mas.CustomerMasterId
LEFT join (select InvoiceId,SUM(PaymentTotalPriceVatAmount)PaymentTotalPriceVatAmount,sum(PaymentTotalPrice)PaymentTotalPrice from tblInvoiceDetail  with (nolock)   group by InvoiceId)tblinvDetls on tblinvDetls.InvoiceId=I.InvoiceId 
LEFT JOIN (SELECT InvoiceId,sum(sndReturnTotalPrice) sndReturnTotalPrice,sum(sndReturnTotalPriceVatAmount) sndReturnTotalPriceVatAmount,  sum(sndReturnNetAmount) sndReturnNetAmount  from  tblInvoiceDetailReturn  GROUP BY InvoiceId) AS SndRTN ON I.InvoiceId= SndRTN.InvoiceId 
LEFT JOIN dbo.tblCompanyUnit CU  with (nolock)   ON CU.ComUnitId = mas.ComUnitId
LEFT JOIN dbo.tblEmpGeneralInfo DZSM  with (nolock)   ON mas.RSMId=DZSM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo AM  with (nolock)  ON mas.ASMId=AM.EmpInfoId
LEFT JOIN dbo.tblEmpGeneralInfo MIO  with (nolock)  ON mas.MIOId=MIO.EmpInfoId
LEFT JOIN tblMarket aa with (nolock)  ON aa.MarketId=C.MarketId
 
left join dbo.tblRouteInformationMaster rt  with (nolock) on mas.DistributionRouteId=rt.RouteInformationMasterId
where   I.InvoiceId>0    " + reportFilter + @"
 group by  isnull(sndRTN.sndReturnTotalPrice,0),  isnull(sndRTN.sndReturnTotalPriceVatAmount,0), mas.paymenttype,   I.InvoiceId,tblinvDetls.PaymentTotalPrice,tblinvDetls.PaymentTotalPriceVatAmount,I.PaymentTpVat,I.FinalPaymentNo,  mas.SMCType_Ord ,  CU.ComUnitCode,CU.ComUnitName,C.CustomerCode,C.CustomerName, I.OrderNo,CONVERT(VARCHAR,I.OrderDate,103) ,I.InvoiceNo,I.FixedCustomer, CONVERT(VARCHAR,I.InvoiceDate,103)  ,I.DelivaryInvoiceNo, CONVERT(VARCHAR,I.UpdateDate,103) , I.PaymentInvoiceNo , CONVERT(VARCHAR,I.PaymentDate,103) , ptt.ProgramTypeName  ,ct.CustomerType ,I.TpGrandTotal,TpTotal,I.PaymentTpTotal ,I. PaymentTpGrandTotal ,DZSM.EmpMasterCode , AM.EmpMasterCode , AM.EmpName   , MIO.EmpMasterCode  , MIO.EmpName   , mas.GroupCode_Ord ,mas.RegionCode_Ord ,mas.AreaCode_Ord  ,mas.TerritoryCode,mas.TerritoryName_Ord ,mas.SubTerritoryCode_Ord+' : ' + mas.SubTerritoryName_Ord , mas.MarketCode_Ord ,  mas.MarketName_Ord ,rt.RouteName  ";

                return aCommonInternalDal.DataContainerDataTable(query, parameters, "SSIDB");
            }
            catch (Exception e)
            {
                throw;
            }
            finally
            {
                //accessManager.SqlConnectionClose();
            }
        }

        private static string BuildPaymentFilter(string parameterText, List<SqlParameter> parameters)
        {
            StringBuilder filter = new StringBuilder();

            Match dateRange = Regex.Match(parameterText ?? string.Empty,
                @"CONVERT\s*\(\s*date\s*,\s*custDtl\.CustPaymentDate\s*\)\s*BETWEEN\s*'([^']*)'\s*AND\s*'([^']*)'",
                RegexOptions.IgnoreCase);
            if (dateRange.Success)
            {
                AddDateParameter(parameters, "@CustPaymentFromDate", dateRange.Groups[1].Value);
                AddDateParameter(parameters, "@CustPaymentToDate", dateRange.Groups[2].Value);
                filter.Append(" AND CONVERT(date,custDtl.CustPaymentDate) BETWEEN @CustPaymentFromDate AND @CustPaymentToDate ");
            }

            Match collectionBy = Regex.Match(parameterText ?? string.Empty,
                @"custDtl\.CollectionBy\s*=\s*'([^']*)'",
                RegexOptions.IgnoreCase);
            if (collectionBy.Success)
            {
                parameters.Add(new SqlParameter("@CollectionBy", collectionBy.Groups[1].Value));
                filter.Append(" AND custDtl.CollectionBy = @CollectionBy ");
            }

            return filter.ToString();
        }

        private static string BuildReportFilter(string parameterText, List<SqlParameter> parameters)
        {
            StringBuilder filter = new StringBuilder();

            AppendIntFilter(filter, parameters, parameterText, "CU.ComUnitId", "@ComUnitId");
            AppendIntFilter(filter, parameters, parameterText, "mas.ProgramTypeId", "@ProgramTypeId");
            AppendIntFilter(filter, parameters, parameterText, "mas.CusttypeId", "@CusttypeId");
            AppendIntFilter(filter, parameters, parameterText, "mas.MarketId", "@MarketId");
            AppendIntFilter(filter, parameters, parameterText, "mas.SubTerritoryId", "@SubTerritoryId");
            AppendIntFilter(filter, parameters, parameterText, "mas.TerritoryId", "@TerritoryId");
            AppendIntFilter(filter, parameters, parameterText, "mas.AreaId", "@AreaId");
            AppendIntFilter(filter, parameters, parameterText, "mas.RegionId", "@RegionId");
            AppendIntFilter(filter, parameters, parameterText, "mas.GroupId", "@GroupId");

            return filter.ToString();
        }

        private static void AppendIntFilter(StringBuilder filter, List<SqlParameter> parameters, string parameterText, string columnName, string parameterName)
        {
            Match match = Regex.Match(parameterText ?? string.Empty,
                Regex.Escape(columnName) + @"\s*=\s*'?(\d+)'?",
                RegexOptions.IgnoreCase);
            if (!match.Success)
                return;

            filter.Append(" AND ").Append(columnName).Append(" = ").Append(parameterName).Append(" ");
            parameters.Add(new SqlParameter(parameterName, Convert.ToInt32(match.Groups[1].Value)));
        }

        private static void AddDateParameter(List<SqlParameter> parameters, string parameterName, string value)
        {
            DateTime dateValue;
            if (DateTime.TryParse(value, out dateValue))
                parameters.Add(new SqlParameter(parameterName, SqlDbType.Date) { Value = dateValue.Date });
            else
                parameters.Add(new SqlParameter(parameterName, value));
        }

        public DataTable GetDeliveryPaymentDALNew(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                DataTable dt = accessManager.GetDataTable("sp_Get_AllSalesReportListParamNew", aSqlParameterlist);
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

        public DataTable GetDBH_DeliveryPaymentDAL(string Parm, string Parm2)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm2", Parm2));

                //DataTable dt = accessManager.GetDataTable("sp_Get_AllSalesReportListDHB", aSqlParameterlist);
                //
               DataTable dt = accessManager.GetDataTable("sp_Get_AllCollectionReportListDHB", aSqlParameterlist);
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

        public DataTable GetAllSalesListDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));
                
                DataTable dt = accessManager.GetDataTable("sp_Get_AllSalesReportList", aSqlParameterlist);
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


        public DataTable GetAllPaymentReportListDAL(string Parm)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameterlist = new List<SqlParameter>();
                aSqlParameterlist.Add(new SqlParameter("@Parm", Parm));

                DataTable dt = accessManager.GetDataTable("sp_Get_AllPaymentReportList", aSqlParameterlist);
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

        public DataTable GetMonthlyExpenseList(string EmpId, string From, string To)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@EmpId", EmpId));
                aSqlParameters.Add(new SqlParameter("@frmDate", From));
                aSqlParameters.Add(new SqlParameter("@ToDate", To));
                DataTable dt = accessManager.GetDataTable("sp_Get_EmployyeMonthlyExpense", aSqlParameters);
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


        public DataTable GetDoctorWiseDayList(string Type, string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                //aSqlParameters.Add(new SqlParameter("@Month", Month));
                //aSqlParameters.Add(new SqlParameter("@Year", Year));
                //aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                //aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));

                //DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCR", aSqlParameters);


                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@Type", Type));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("sp_GetDCRRXDoctorWiseRptView", aSqlParameters);

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

        public DataTable GetRXDoctorWiseDayListNew( string MonthValue, string Year, string ApprovalStatus)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                //aSqlParameters.Add(new SqlParameter("@Month", Month));
                //aSqlParameters.Add(new SqlParameter("@Year", Year));
                //aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                //aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));

                //DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCR", aSqlParameters);


                aSqlParameters.Add(new SqlParameter("@Month", MonthValue));
                aSqlParameters.Add(new SqlParameter("@MonthValue", MonthValue));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                DataTable dt = new DataTable();

                //sp_GetDCRRXDoctorWiseRptView

                dt = accessManager.GetDataTable("sp_GetRXDoctorWiseRpt", aSqlParameters);

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


        public DataTable GetDCRDoctorWiseDayListNew(string MonthValue, string Year, string ApprovalStatus)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                //aSqlParameters.Add(new SqlParameter("@Month", Month));
                //aSqlParameters.Add(new SqlParameter("@Year", Year));
                //aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                //aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));

                //DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCR", aSqlParameters);


                aSqlParameters.Add(new SqlParameter("@Month", MonthValue));
                aSqlParameters.Add(new SqlParameter("@MonthValue", MonthValue));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                DataTable dt = new DataTable();

                //sp_GetDCRRXDoctorWiseRptView

                dt = accessManager.GetDataTable("sp_GetRXDoctorWiseRpt", aSqlParameters);

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

        public DataTable GetRXDoctorWiseDayList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string DoctorTypeSelect, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();
                     
                dt = accessManager.GetDataTable("DynamicPivotDoctorWiseRX_New", aSqlParameters);


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

        public DataTable GetDCRDoctorWiseDayList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));


                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCR_New_ForSearch", aSqlParameters);


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

        public DataTable GetCVRDoctorWiseDayList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));


                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotDoctorWiseCVR_New_ForSearch", aSqlParameters);


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


        public DataTable GetDynamicVisitStatusReport(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect, string EmpID, string DCType)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));


                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                aSqlParameters.Add(new SqlParameter("@EmpID", EmpID));
                aSqlParameters.Add(new SqlParameter("@DCType", DCType));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicVisitStatusReport", aSqlParameters);


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

        //public DataTable _GetDCPDoctorWiseDayList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform)
        //{
        //    try
        //    {
        //        accessManager.SqlConnectionOpen(DataBase.SalesDB);
        //        List<SqlParameter> aSqlParameters = new List<SqlParameter>();

        //        aSqlParameters.Add(new SqlParameter("@Month", Month));
        //        aSqlParameters.Add(new SqlParameter("@Year", Year));
        //        aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
        //        aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
        //        aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
        //        aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
        //        aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));

        //        DataTable dt = new DataTable();

        //        dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCR_New_ForSearch", aSqlParameters);


        //        return dt;
        //    }
        //    catch (Exception e)
        //    {
        //        throw;
        //    }
        //    finally
        //    {
        //        accessManager.SqlConnectionClose();
        //    }
        //}



        public DataTable GetDCPDoctorWiseDayList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));


                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCP", aSqlParameters);


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



        public DataTable GetCusDCPDoctorWiseDayList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform));


                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotDoctorWiseDCPCustomerWise", aSqlParameters);


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


        public DataTable GetDoctorProductWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotProductdWiseDCR", aSqlParameters);


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

        public DataTable GetDCRUserWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotUserWiseDCR", aSqlParameters);


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



        public DataTable GetDCPUserWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));


                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotUserWiseDCP", aSqlParameters);


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

        public DataTable GetRXUserWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string DoctorTypeSelect, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotUserWiseRX_New", aSqlParameters);


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



        public DataTable GetRXUserProductWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string DoctorTypeSelect, string ProID, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
                aSqlParameters.Add(new SqlParameter("@ProID", ProID));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotUserandProductdWiseRX_New", aSqlParameters);


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


      

        public DataTable GetDynamicVisitStatusReport(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform,  string ZoneSelect, string AreaSelect, string TeritorySelect, string EmpID,string DoctorTypeSelect, string Brand)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
              
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                aSqlParameters.Add(new SqlParameter("@EmpID",  EmpID));
                aSqlParameters.Add(new SqlParameter("@Brand", Brand));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicVisitStatusReport", aSqlParameters);


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

        public DataTable GetDynamicRXStatusReport(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string DoctorTypeSelect, string ProID, string ZoneSelect, string AreaSelect, string TeritorySelect, string EmpID, string Brand)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
                aSqlParameters.Add(new SqlParameter("@ProID", ProID));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                aSqlParameters.Add(new SqlParameter("@EmpID", EmpID));
                aSqlParameters.Add(new SqlParameter("@Brand", Brand));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("GetDynamicVisitStatusReportRX", aSqlParameters);


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

        public DataTable GetRXDoctorProductWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string DoctorTypeSelect, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotProductdWiseRX_New", aSqlParameters);


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


        public DataTable GetDWSPMonthlyList(string mainDate, string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DWSPDate"));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotDWSP", aSqlParameters);


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


        public DataTable GetDWSPMonthlyList_Mew(int MonthValue, string Month, string Year, string ApprovalStatus, string RegionId,string AreaId, string TrId)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@MonthValue", MonthValue)); 
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus)); 
                aSqlParameters.Add(new SqlParameter("@RegionId", RegionId));
                aSqlParameters.Add(new SqlParameter("@AreaId", AreaId));
                aSqlParameters.Add(new SqlParameter("@TrId", TrId));

                DataTable dt = new DataTable();

                //dt = accessManager.GetDataTable("sp_Process_DWSPReport", aSqlParameters);
               dt = accessManager.GetDataTable("sp_Process_DWSPReport_Territory", aSqlParameters);


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

        public DataTable GetDoctorBrandWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotBrandWiseDCR", aSqlParameters);


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


        public DataTable GetRXDoctorBrandWiseList(string mainDate, string Month, string Year, string ApprovalStatus, string ProviderType, string PharmaPlatform, string DoctorTypeSelect, string ZoneSelect, string AreaSelect, string TeritorySelect)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));
                aSqlParameters.Add(new SqlParameter("@ListToPivot", mainDate));
                aSqlParameters.Add(new SqlParameter("@ColumnToPivot", "DcrDate"));
                aSqlParameters.Add(new SqlParameter("@ApprovalStatus", ApprovalStatus));
                aSqlParameters.Add(new SqlParameter("@ProviderType", ProviderType ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@PharmaPlatform", PharmaPlatform ?? (object)DBNull.Value));
                aSqlParameters.Add(new SqlParameter("@DoctorTypeSelect", DoctorTypeSelect));
                aSqlParameters.Add(new SqlParameter("@ZoneSelect", ZoneSelect));
                aSqlParameters.Add(new SqlParameter("@AreaSelect", AreaSelect));
                aSqlParameters.Add(new SqlParameter("@TeritorySelect", TeritorySelect));
                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicPivotBrandWiseRX_new", aSqlParameters);


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

        public DataTable GetDatefromMonthYear(string Type, string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicDatebyMonthYear", aSqlParameters);


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
        public DataTable GetDynamicDateByDateRange( string frmDate, string toDate)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@frmDate", frmDate));
                aSqlParameters.Add(new SqlParameter("@toDate", toDate));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicDateByDateRange", aSqlParameters);


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

        public DataTable GetDatefromMonthYearStuff(string Type, string Month, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();

                aSqlParameters.Add(new SqlParameter("@Month", Month));
                aSqlParameters.Add(new SqlParameter("@Year", Year));

                DataTable dt = new DataTable();

                dt = accessManager.GetDataTable("DynamicDatebyMonthYearForStuff", aSqlParameters);


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

        public DataTable GetSampleStockRptList(string EmpId, string From, string To)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@EmpId", EmpId));
                aSqlParameters.Add(new SqlParameter("@Month", To ));
                aSqlParameters.Add(new SqlParameter("@Year", From));
                DataTable dt = accessManager.GetDataTable("sp_Get_SampleStockReport", aSqlParameters);
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


        public DataTable GetEmployee_YearlyLeaveBalanceRptList(string Parm, string Parm2, string _year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm", Parm2));
                aSqlParameters.Add(new SqlParameter("@Parm2", Parm));
                aSqlParameters.Add(new SqlParameter("@Year", _year));


                //DataTable dt = accessManager.GetDataTable("sp_Webapi_LeaveReport_New", aSqlParameters);
                DataTable dt = accessManager.GetDataTable("sp_Webapi_LeaveReport_Details", aSqlParameters);

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


        public DataTable GetEmployee_YearlySummaryList(string Parm, string Parm2, string Year)
        {
            try
            {
                accessManager.SqlConnectionOpen(DataBase.SalesDB);
                List<SqlParameter> aSqlParameters = new List<SqlParameter>();
                aSqlParameters.Add(new SqlParameter("@Parm",  Parm2));
                aSqlParameters.Add(new SqlParameter("@Parm2", Parm));
                aSqlParameters.Add(new SqlParameter("@Year", Year));


                DataTable dt = accessManager.GetDataTable("sp_Webapi_LeaveReport_Summary", aSqlParameters);
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
    }
}
