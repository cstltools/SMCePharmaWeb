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

public partial class SInventory_RPTVIEW_ProformaandSalesreportViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CompanySalesReportBLL aCompanySalesReportBll = new CompanySalesReportBLL();
    ReportDocument rptdoc = new ReportDocument();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
        int NationalReport = Convert.ToInt32(Request.QueryString["NationalReport"]);
        string districtId = Request.QueryString["districtId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];

        int rpt = Convert.ToInt32(Session["SalesReport"]);

        if (NationalReport != 1 && rpt == 0)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aCompanySalesReportBll.GetInvoceLifecycleReport(Convert.ToInt32(districtId), FromDate, ToDate).Copy();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "AllsalesDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("ProformaandsalesReport.rpt"));
            rptdoc.SetDataSource(Ds);

            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "Sales_Report");
        }
        else 
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aCompanySalesReportBll.GetInvoceLifecycleReport(Convert.ToInt32(districtId), FromDate, ToDate).Copy();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "AllsalesDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("ProformaandsalesReport.rpt"));
            rptdoc.SetDataSource(Ds);

            //crvSalesRpt.ReportSource = rptdoc;
            //crvSalesRpt.DataBind();


            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "Sales_Report");


            //rptdoc.Load(ReportPath("rptInvoiceForCustomer.rpt"));
            //rptdoc.SetDataSource(Ds);

            //rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
            //    "ProformaInvoice-" + invNo);
        }

        //Report View

        if (NationalReport != 1 && rpt == 1)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aCompanySalesReportBll.SalesReportDAl(districtId, FromDate, ToDate).Copy();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "AllsalesDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("crpAllSalesReport.rpt"));
            rptdoc.SetDataSource(Ds);

            //crvSalesRpt.ReportSource = rptdoc;
            //crvSalesRpt.DataBind();

            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "Sales_Report");
        }
        else
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aCompanySalesReportBll.SalesReportDAl(FromDate, ToDate).Copy();

            DataSet Ds = new DataSet();

            mainDataTable.TableName = "AllsalesDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("crpAllSalesReport.rpt"));
            rptdoc.SetDataSource(Ds);


            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
               "Sales_Report");

            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //   "Sales_Report");


            //rptdoc.Load(ReportPath("rptInvoiceForCustomer.rpt"));
            //rptdoc.SetDataSource(Ds);

            //rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
            //    "ProformaInvoice-" + invNo);
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
    //protected void crViewer_Unload(object sender, EventArgs e)
    //{
       
    //}
    //protected void crViewer_Disposed(object sender, EventArgs e)
    //{
       
    //}
    protected void crvSalesRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
    protected void crvSalesRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
}