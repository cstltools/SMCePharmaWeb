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

public partial class SInventory_RPTVIEW_InvoicewiseDetailssalesReport : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    
    protected void Page_Init(object sender, EventArgs e)
    {

        int National = Convert.ToInt32(Request.QueryString["NationalReport"]);
        string districtId = Request.QueryString["districtId"];
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];
        
        int rpt = Convert.ToInt32(Session["ProformaReport"]);

        if (National != 1 && rpt == 0)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aInvoiceBll.ProformaReportBLL(districtId, FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "proformaDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("rptProformaReport.rpt"));
            rptdoc.SetDataSource(Ds);

            //crvInvoiceReport.ReportSource = rptdoc;
            //crvInvoiceReport.DataBind();

            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
              "Proforma_Report");
        }
        if (National == 1 && rpt == 0)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aInvoiceBll.ProformaReportBLL(FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "proformaDataTable";
            Ds.Tables.Add(mainDataTable);
            rptdoc.Load(ReportPath("rptProformaReport.rpt"));
            rptdoc.SetDataSource(Ds);

            //crvInvoiceReport.ReportSource = rptdoc;
            //crvInvoiceReport.DataBind();

            rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
              "Proforma_Report");
        }


        // Report View

        if (National != 1 && rpt == 1)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aInvoiceBll.ProformaReportBLL(districtId, FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "proformaDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("rptProformaReport.rpt"));
            rptdoc.SetDataSource(Ds);

            crvInvoiceReport.ReportSource = rptdoc;
            crvInvoiceReport.DataBind();

            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //  "Proforma_Report");
        }
        if (National == 1 && rpt == 1)
        {
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aInvoiceBll.ProformaReportBLL(FromDate, ToDate).Copy();
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "proformaDataTable";
            Ds.Tables.Add(mainDataTable);

            rptdoc.Load(ReportPath("rptProformaReport.rpt"));
            rptdoc.SetDataSource(Ds);

            crvInvoiceReport.ReportSource = rptdoc;
            crvInvoiceReport.DataBind();

            //rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
            //  "Proforma_Report");
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
 
    protected void crvInvoiceReport_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();

        }
     
    }
    protected void crvInvoiceReport_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvInvoiceReport.Dispose();
        }
    
    }
}