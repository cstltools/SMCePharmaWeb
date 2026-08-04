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

public partial class SInventory_RPTVIEW_CustomerPaymentViewer : System.Web.UI.Page
{
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    CompanySalesReportBLL aCompanySalesReportBll = new CompanySalesReportBLL();
    ReportDocument rptdoc = new ReportDocument();
    InvoiceBLL aInvoiceBll = new InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
            string paymentStatus = (Request.QueryString["payment"]);
            string fromDate = Request.QueryString["fromDate"];
            string toDate = Request.QueryString["toDate"];
          //  string market = Request.QueryString["fromDate"];
            string salesCenter = Request.QueryString["salesCenter"];
            DateTime FromDate = Convert.ToDateTime(fromDate);
            DateTime ToDate = Convert.ToDateTime(toDate);
            string rptType = Session["PaymentReport"].ToString();

        if (rptType == "SC")
        {

            if (paymentStatus == "0")
            {
                DataTable mainDataTable =
                    aCompanySalesReportBll.CustomerPaymentBLL(paymentStatus, FromDate, ToDate, salesCenter).Copy();

                DataSet Ds = new DataSet();

                mainDataTable.TableName = "custPaymentDataTable";
                Ds.Tables.Add(mainDataTable);
                rptdoc.Load(ReportPath("rptCustomerPaymentDue.rpt"));
                rptdoc.SetDataSource(Ds);

                //crvSalesRpt.ReportSource = rptdoc;
                //crvSalesRpt.DataBind();
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "CustomerPayment_Report");
            }
            if (paymentStatus == "1")
            {
                DataTable mainDataTable =
                    aCompanySalesReportBll.CustomerPaymentBLL(paymentStatus, FromDate, ToDate, salesCenter).Copy();

                DataSet Ds = new DataSet();

                mainDataTable.TableName = "custPaymentDataTable";
                Ds.Tables.Add(mainDataTable);
                rptdoc.Load(ReportPath("rptCustomerPayment.rpt"));
                rptdoc.SetDataSource(Ds);

                //crvSalesRpt.ReportSource = rptdoc;
                //crvSalesRpt.DataBind();
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "CustomerPayment_Report");
            }

        }
        else
        {


            if (paymentStatus == "0")
            {
                DataTable mainDataTable =
                    aCompanySalesReportBll.CustomerPaymentBLL(paymentStatus, FromDate, ToDate).Copy();

                DataSet Ds = new DataSet();

                mainDataTable.TableName = "custPaymentDataTable";
                Ds.Tables.Add(mainDataTable);
                rptdoc.Load(ReportPath("rptCustomerPaymentDue.rpt"));
                rptdoc.SetDataSource(Ds);

                //crvSalesRpt.ReportSource = rptdoc;
                //crvSalesRpt.DataBind();
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "CustomerPayment_Report");
            }
            if (paymentStatus == "1")
            {
                DataTable mainDataTable =
                    aCompanySalesReportBll.CustomerPaymentBLL(paymentStatus, FromDate, ToDate).Copy();

                DataSet Ds = new DataSet();

                mainDataTable.TableName = "custPaymentDataTable";
                Ds.Tables.Add(mainDataTable);
                rptdoc.Load(ReportPath("rptCustomerPayment.rpt"));
                rptdoc.SetDataSource(Ds);

                //crvSalesRpt.ReportSource = rptdoc;
                //crvSalesRpt.DataBind();
                rptdoc.ExportToHttpResponse(ExportFormatType.ExcelRecord, Response, true,
                    "CustomerPayment_Report");
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
    
    protected void crvCustMasterRpt_Unload(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
    protected void crvCustMasterRpt_Disposed(object sender, EventArgs e)
    {
        if (this.rptdoc != null)
        {
            rptdoc.Close();
            rptdoc.Dispose();
            crvSalesRpt.Dispose();
        }
    }
}