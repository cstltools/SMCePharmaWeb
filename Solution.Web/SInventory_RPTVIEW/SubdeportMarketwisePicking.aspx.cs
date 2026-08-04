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
using Library.BLL.SubDepot_BLL;
using Library.CrystalReports.SInventory_RPT;

public partial class SInventory_RPTVIEW_SubdeportMarketwisePicking : System.Web.UI.Page
{
    ReportDocument rptdoc = new ReportDocument();
    StockTransportOrderReportBLL aOrderReportBll = new StockTransportOrderReportBLL();
    Sub_InvoiceBLL aInvoiceBll = new Sub_InvoiceBLL();
    protected void Page_Init(object sender, EventArgs e)
    {
       int MarketID = Convert.ToInt32(Session["Market"]) ;
       int ManufacID = Convert.ToInt32(Session["Manufac"]) ;
       DateTime InvDate = Convert.ToDateTime(Session["invoicedate"]) ;
       string SC = Server.UrlDecode(Request.QueryString["SC"]);
        string parameter = string.IsNullOrEmpty(Session["MrktRptParameter"].ToString())
            ? ""
            : Session["MrktRptParameter"].ToString();
     
       // string invColl = aInvoiceBll.InvoiceNoCollectionFormate(SC, MarketID, ManufacID, InvDate);
       DataTable mainDataTable = aInvoiceBll.MarketPickinReport(SC, MarketID, ManufacID, InvDate,parameter).Copy();
       // DataTable detailDataTable = aInvoiceBll.InvoiceDetailDataForReportBLL(invColl).Copy();


        DataTable companyInfoDataTable = aOrderReportBll.CompanyInfoBLL().Copy();

       // rptMarketwisePicking aRptInvoiceForCustomer = new rptMarketwisePicking();

        DataSet Ds = new DataSet();

        mainDataTable.TableName = "marketwisepickingDataTable";
       // detailDataTable.TableName = "detailDataTable";
        companyInfoDataTable.TableName = "companyInfoDataTable";
        Ds.Tables.Add(mainDataTable);
       // Ds.Tables.Add(detailDataTable);
        Ds.Tables.Add(companyInfoDataTable);
       // aRptInvoiceForCustomer.SetDataSource(Ds);
       // crvInvoiceReport.ReportSource = aRptInvoiceForCustomer;
        //aRptInvoiceForCustomer.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
        //       "Picking");

        rptdoc.Load(ReportPath("rptMarketwisePicking.rpt"));
        rptdoc.SetDataSource(Ds);
        rptdoc.ExportToHttpResponse(ExportFormatType.PortableDocFormat, Response, true,
               "Picking");

        //crvInvoiceReport.ReportSource = rptdoc;
        //crvInvoiceReport.DataBind();
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