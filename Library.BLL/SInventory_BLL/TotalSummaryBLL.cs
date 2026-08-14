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
    public class TotalSummaryBLL
    {
        TotalSummaryDAL aTotalSummaryDAL = new TotalSummaryDAL();


        public DataTable LoadSummaryBLL(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryDAL(fromdate, todate);
        }
        public DataTable LoadSummary2BLL(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewise(fromdate, todate);
        }
        public DataTable LoadSummaryProductcodewise(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewiseNew(fromdate, todate, Type, ZonId, Area, Terr);
        }

        public DataTable LoadBusinessSummaryProductwise(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadBusinessSummaryProductwise(fromdate, todate);
        }
        public DataTable OrderMonitoring_Bizmo(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.OrderMonitoring_Bizmo(fromdate, todate);
        }
        public DataTable LoadSummaryzonewiseBLL(DateTime fromdate, DateTime todate, string zone)
        {
            return aTotalSummaryDAL.LoadSummaryzonewiseDAL(fromdate, todate, zone);
        }
        public DataTable LoadSummaryzoneBranchwiseBLL(DateTime fromdate, DateTime todate, string zone, string Branch)
        {
            return aTotalSummaryDAL.LoadSummaryzoneBranchwiseBLL(fromdate, todate, zone, Branch);
        }

        public DataTable LoadSummaryzoneBranchTerritorywiseBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            return aTotalSummaryDAL.LoadSummaryzoneBranchTerritorywiseBLL(fromdate, todate, Branch);
        }

        public DataTable CustomerWiseSale(string fromdate, string todate)
        {
            DateTime fromdatedt = Convert.ToDateTime(fromdate);
            DateTime todatedt = Convert.ToDateTime(todate);

            DataTable aDataTable = new DataTable();
            aDataTable.Columns.Add("CustomerMasterId");
            aDataTable.Columns.Add("CustomerCode");
            aDataTable.Columns.Add("CustomerName");
            aDataTable.Columns.Add("Depocode");
            aDataTable.Columns.Add("deponame");
            aDataTable.Columns.Add("SumOfNetSalesAmount");
            while (fromdatedt <= todatedt)
            {
                aDataTable.Columns.Add(fromdatedt.ToString("MMM-yyyy"));

                fromdatedt = fromdatedt.AddMonths(1);
            }
            aDataTable.Columns.Add("Total");
            DataRow dataRow = null;
            fromdatedt = Convert.ToDateTime(fromdate);
            while (fromdatedt <= todatedt)
            {
                DataTable dtdata = aTotalSummaryDAL.GetMonthYearWiseSale(fromdatedt,
                    fromdatedt.AddDays(DateTime.DaysInMonth(fromdatedt.Year, fromdatedt.Month) - 1));
                if (aDataTable.Rows.Count < 1)
                {
                    for (int i = 0; i < dtdata.Rows.Count; i++)
                    {

                        dataRow = aDataTable.NewRow();
                        dataRow["CustomerMasterId"] = dtdata.Rows[i]["CustomerMasterId"].ToString();
                        dataRow["CustomerCode"] = dtdata.Rows[i]["CustomerCode"].ToString();
                        dataRow["CustomerName"] = dtdata.Rows[i]["CustomerName"].ToString();
                        //dataRow["Depocode"] = dtdata.Rows[i]["Depocode"].ToString();
                        //dataRow["deponame"] = dtdata.Rows[i]["deponame"].ToString();
                        //dataRow["SumOfNetSalesAmount"] = dtdata.Rows[i]["deponame"].ToString();
                        dataRow[fromdatedt.ToString("MMM-yyyy")] = dtdata.Rows[i]["SumofNetSalesAmount"].ToString();
                        dataRow["Total"] = dtdata.Rows[i]["SumofNetSalesAmount"].ToString();
                        aDataTable.Rows.Add(dataRow);

                    }
                }
                else
                {
                    for (int i = 0; i < dtdata.Rows.Count; i++)
                    {
                        aDataTable.Rows[i][fromdatedt.ToString("MMM-yyyy")] = dtdata.Rows[i]["SumofNetSalesAmount"].ToString();
                        decimal total = 0;
                        total = Convert.ToDecimal(aDataTable.Rows[i]["Total"].ToString());
                        aDataTable.Rows[i]["Total"] =
                            Convert.ToDecimal(dtdata.Rows[i]["SumofNetSalesAmount"].ToString()) + total;
                    }
                }


                fromdatedt = fromdatedt.AddMonths(1);
            }

            //fromdatedt = Convert.ToDateTime(fromdate);
            for (int i = 0; i < aDataTable.Rows.Count; i++)
            {
                decimal total = 0;

                total = Convert.ToDecimal(aDataTable.Rows[i]["Total"].ToString());
                if (total > 0)
                {

                }
                else
                {
                    aDataTable.Rows[i].Delete();
                    aDataTable.AcceptChanges();
                }

            }
            return aDataTable;

        }




        public int LoadDepositSlipSummaryProcess(DateTime fromdate, DateTime todate, string comUnitId = null)
        {
            return aTotalSummaryDAL.LoadDepositSlipSummaryProcess(fromdate, todate, comUnitId);
        }
        public DataTable LoadDepositSlipSummary(DateTime fromdate, DateTime todate, string comUnitId = null)
        {
            return aTotalSummaryDAL.LoadDepositSlipSummary(fromdate, todate, comUnitId);
        }

        public DataTable LoadMonthlyInventoryReportBatchWise(DateTime fromDate, DateTime toDate, string comUnitId)
        {
            return aTotalSummaryDAL.LoadMonthlyInventoryReportBatchWise(fromDate, toDate, comUnitId);
        }

        public DataTable GetDistributionCenterListDAL()
        {
            return aTotalSummaryDAL.GetDistributionCenterListDAL();
        }

        public DataTable LoadRptDuplicateOrderCodeDAL()
        {
            return aTotalSummaryDAL.LoadRptDuplicateOrderCodeDAL();
        }

        public DataTable LoadRptDuplicateOrderNoInInvoiceDAL()
        {
            return aTotalSummaryDAL.LoadRptDuplicateOrderNoInInvoiceDAL();
        }

        public DataTable LoadRptDuplicateInvoiceNoDAL()
        {
            return aTotalSummaryDAL.LoadRptDuplicateInvoiceNoDAL();
        }

        public DataTable LoadRptDuplicateCustomerCodeDAL()
        {
            return aTotalSummaryDAL.LoadRptDuplicateCustomerCodeDAL();
        }

        public DataTable LoadRptInvoicePaymentVatTpMismatchDAL()
        {
            return aTotalSummaryDAL.LoadRptInvoicePaymentVatTpMismatchDAL();
        }

        public DataTable LoadRptTourPlanMissingSerialDAL()
        {
            return aTotalSummaryDAL.LoadRptTourPlanMissingSerialDAL();
        }

        public int FixTourPlanMissingSerialDAL()
        {
            return aTotalSummaryDAL.FixTourPlanMissingSerialDAL();
        }

        public DataTable LoadSalesReturnReportSAP(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSalesReturnReportSAP(fromdate, todate);
        }

      
        public DataTable LoadBankDepositSAP(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.BankDepositPosting_SAP(fromdate, todate);
        }

        public DataTable LoadSummaryProductcodewiseGyash(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewiseGyash(fromdate, todate);
        }

        public DataTable LoadSummaryProductcodewiseGyash(DateTime fromdate, DateTime todate, string Type, string Area, string Terr, string ZoneId)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewiseGyash(fromdate, todate, Type, Area, Terr,ZoneId);
        }

        public DataTable LoadSummaryProductcodewiseGyash__New(DateTime fromdate, DateTime todate, string Type, string Area, string Terr, string ZoneId)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewiseGyash__New(fromdate, todate, Type, Area, Terr, ZoneId);
        }

        public DataTable LoadMIOWiseBusinessSummaryDAL(string Depid, DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadMIOWiseBusinessSummaryDAL(Depid, fromdate, todate);
        }
        public DataTable rptMonitoringReport(DateTime fromdate, DateTime todate, string Type)
        {
            return aTotalSummaryDAL.rptMonitoringReport(fromdate, todate, Type);
        }

        public DataTable LoadSummaryProductcodewiseGyashNew(int DistricId, DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.LoadSummaryProductcodewiseGyashNew(DistricId,fromdate, todate);
        }

        public DataTable BranchwiseLoadSummaryBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            return aTotalSummaryDAL.BranchwiseLoadSummaryBLL(fromdate, todate, Branch);
        }
        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate, string Branch)
        {
            return aTotalSummaryDAL.DZSMwiseLoadSummaryBLL(fromdate, todate, Branch);
        }
        public DataTable DZSMwiseLoadSummaryBLL(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.DZSMwiseLoadSummaryBLL(fromdate, todate);
        }




        public DataTable FinalSales(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.FinalSales(fromdate, todate);
        }
        public DataTable FinalSales2(DateTime fromdate, DateTime todate)
        {
            return aTotalSummaryDAL.FinalSales2(fromdate, todate);
        }

       

        public DataTable LoadRptBussinessSummary_LoadingDAL(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {
            return aTotalSummaryDAL.LoadRptBussinessSummary_LoadingDAL(fromdate, todate, Type, ZonId, Area, Terr);
        }

        public DataTable LoadRptBussinessSummary_DayWiseDAL(int comUnitId, int year, int month)
        {
            return aTotalSummaryDAL.LoadRptBussinessSummary_DayWiseDAL(comUnitId, year, month);
        }

        public DataTable LoadRptNegativeClosingStockDAL(int comUnitId, DateTime fromDate)
        {
            return aTotalSummaryDAL.LoadRptNegativeClosingStockDAL(comUnitId, fromDate);
        }

        public DataTable LoadRptNegativeClosingStock_DCWiseDAL()
        {
            return aTotalSummaryDAL.LoadRptNegativeClosingStock_DCWiseDAL();
        }


        public DataTable RptMIOWiseReceiveableReport(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {
            return aTotalSummaryDAL.RptMIOWiseReceiveableReport(fromdate, todate, Type, ZonId, Area, Terr);
        }

        public DataTable Sales_Collection_Reports_AccDAL(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {
            return aTotalSummaryDAL.Sales_Collection_Reports_AccDAL(fromdate, todate, Type, ZonId, Area, Terr);
        }
        public DataTable ProductWiseSalesReportDAL(DateTime fromdate, DateTime todate, string Type, string ZonId, string Area, string Terr)
        {
            return aTotalSummaryDAL.ProductWiseSalesReportDAL(fromdate, todate, Type, ZonId, Area, Terr);
        }
    }
}
