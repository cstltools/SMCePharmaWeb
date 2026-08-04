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
using Library.DAL.MasterSetup_DAL;

public partial class SInventory_RPTVIEW_MIOwiseInTransitReportViewer : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    CmnCrystaltoView aDal = new CmnCrystaltoView();
    protected void Page_Init(object sender, EventArgs e)
    {
        string MArket = (Request.QueryString["MArket"]);
        int National = Convert.ToInt32(Request.QueryString["NationalReport"]);
        string Parm = Session["Param"].ToString();
        string fromDate = Request.QueryString["fromDate"];
        string toDate = Request.QueryString["toDate"];
        string mio = Request.QueryString["MIO"];

        string excel = Session["Excel"].ToString();

        //if (National != 1)
        {

            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);

            DataTable mainDataTable = aDal.Get_MIOWiseReceiveableReport(fromDate, toDate, Parm).Copy();
            DataSet Ds = new DataSet();

            mainDataTable.TableName = "proformaDataTable";
            Ds.Tables.Add(mainDataTable);


            if (excel == "Y")
            {
                rptdoc.Load(ReportPath("INTransitReport.rpt"));
                rptdoc.SetDataSource(Ds);
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true, "Receivable_Report");
            }
            else
            {//  crpINTransitReport
                rptdoc.Load(ReportPath("MIOWIseReceivable.rpt"));
                rptdoc.SetDataSource(Ds);

                crvInvoiceReport.ReportSource = rptdoc;
                crvInvoiceReport.DataBind();
            }

        }
        //if (National == 1)
        //{
        //    DateTime FromDate = Convert.ToDateTime(fromDate);
        //    DateTime ToDate = Convert.ToDateTime(toDate);

        //    DataTable mainDataTable = aInvoiceBll.IntransitBll(FromDate, ToDate).Copy();
        //    DataSet Ds = new DataSet();

        //    mainDataTable.TableName = "proformaDataTable";
        //    Ds.Tables.Add(mainDataTable);

        //    if (excel == "Y")
        //    {
        //        rptdoc.Load(ReportPath("INTransitReport.rpt"));
        //        rptdoc.SetDataSource(Ds);
        //        rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true, "Receivable_Report");
        //    }
        //    else
        //    {
        //        rptdoc.Load(ReportPath("crpINTransitReport.rpt"));
        //        rptdoc.SetDataSource(Ds);

        //        crvInvoiceReport.ReportSource = rptdoc;
        //        crvInvoiceReport.DataBind();
        //    }
        //}

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