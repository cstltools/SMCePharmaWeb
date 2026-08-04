using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using Library.BLL.SInventory_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_MIGOReportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    ExcelUpForMIGOBLL aUpForMigobll = new ExcelUpForMIGOBLL();
    ReportDocument rptdoc = new ReportDocument();
    protected void Page_Init(object sender, EventArgs e)
    {
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];
        string orderno = Request.QueryString["orderno"];
        string custcode = Request.QueryString["custcode"];
        string rpttype = Request.QueryString["rpttype"];

        DateTime FromDate = Convert.ToDateTime(fromDate);
        DateTime ToDate = Convert.ToDateTime(toDate);

        if (rpttype == "sto")
        {
            DataTable comDetailDataTable = aUpForMigobll.LoadMigoReport(fromDate, toDate).Copy();

            if (comDetailDataTable.Rows.Count > 0)
            {
                DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
                DataSet Ds = new DataSet();
                comDetailDataTable.TableName = "StoDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";


                Ds.Tables.Add(comDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);
                rptdoc.Load(ReportPath("crpMigoDetailsReport.rpt"));
                rptdoc.SetDataSource(Ds);
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                "STO_Report");
              //  crpMigoDetailsReport rptMigoDetail = new crpMigoDetailsReport();

              //  rptMigoDetail.SetDataSource(Ds);
              //  crvComSalesRpt.ReportSource = rptMigoDetail;
            }
            else
            {
                MessageLabel.Text = "No Data Found!!";
            }
        }
        if (rpttype=="OD")
        {
            DataTable comDetailDataTable = aUpForMigobll.LoadOrderDetail(fromDate, toDate,custcode,orderno).Copy();

            if (comDetailDataTable.Rows.Count > 0)
            {

                DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
                DataSet Ds = new DataSet();

                comDetailDataTable.TableName = "orderDetailsDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";

                Ds.Tables.Add(comDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);
                rptdoc.Load(ReportPath("crpOrderDetailsReport.rpt"));
                rptdoc.SetDataSource(Ds);
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "Order_Report");
                //crpOrderDetailsReport rptOrderDetails = new crpOrderDetailsReport();

                //rptOrderDetails.SetDataSource(Ds);
                //crvComSalesRpt.ReportSource = rptOrderDetails;
            }
            else
            {
                MessageLabel.Text = "No Data Found!!";
            }
        }
        if (rpttype == "MIGO")
        {
            DataTable comDetailDataTable = aUpForMigobll.LoadMainMigoReport(fromDate, toDate).Copy();

            if (comDetailDataTable.Rows.Count > 0)
            {
                DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();
                DataSet Ds = new DataSet();
                comDetailDataTable.TableName = "migoDataTable";
                companyInfoDataTable.TableName = "companyInfoDataTable";

                Ds.Tables.Add(comDetailDataTable);
                Ds.Tables.Add(companyInfoDataTable);
                rptdoc.Load(ReportPath("crpMainMigoReport.rpt"));
                rptdoc.SetDataSource(Ds);
                //crvComSalesRpt.ReportSource = rptdoc;
                //crvComSalesRpt.DataBind();
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                "MIGO_Report");
            
            }
            else
            {
                MessageLabel.Text = "No Data Found!!";
            }
        }
    }
    private string ReportPath(string rptName)
    {
        return Convert.ToString(Server.MapPath("~\\Reports\\CrystalReports\\" + rptName));
    }
    protected void closeButton_Click(object sender, EventArgs e)
    {
        ScriptManager.RegisterStartupScript(this, typeof(string), "Close", "window.close()", true);
    }
   
    protected void crvComSalesRpt_Unload(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComSalesRpt.Dispose();
        }
    }
    protected void crvComSalesRpt_Disposed(object sender, EventArgs e)
    {
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvComSalesRpt.Dispose();
        }
    }
}